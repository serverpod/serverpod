import 'dart:async';
import 'dart:io';

import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/command_line_args.dart';
import 'package:serverpod/src/server/diagnostic_events/diagnostic_events.dart';
import 'package:serverpod/src/server/serverpod.dart';
import 'package:synchronized/synchronized.dart';

enum _FutureCallInvocationResult {
  success,
  postponed;
}

/// Manages [FutureCall]s in the [Server]. A [FutureCall] is a method that will
/// be called at a certain time in the future. The call request and its
/// arguments are stored in the database, so it is persistent even if the
/// [Serverpod] is restarted.
class FutureCallManager {
  final Server _server;

  /// Called when pending future calls have been completed, if the server is
  /// running in [ServerpodRole.maintenance] mode.
  final void Function() onCompleted;

  final SerializationManager _serializationManager;
  final _futureCalls = <String, FutureCall>{};
  Timer? _timer;
  final Map<String, int> _runningFutureCalls = {};
  final _runningFutureCallFutures = <Future>[];
  final _runningFutureCallsLock = Lock();
  bool _shuttingDown = false;

  /// Creates a new [FutureCallManager]. Typically, this is done internally by
  /// the [Serverpod].
  FutureCallManager(
    this._server,
    this._serializationManager,
    this.onCompleted,
  );

  /// Schedules a [FutureCall] by its [name]. A [SerializableModel] can be
  /// passed as an argument. The `invoke` method of the [FutureCall] will
  /// be called at or after the specified [time]. Set the identifier if you need
  /// to be able to cancel the call.
  Future<void> scheduleFutureCall(
    String name,
    SerializableModel? object,
    DateTime time,
    String serverId,
    String? identifier,
  ) async {
    String? serialization;
    if (object != null) {
      serialization = SerializationManager.encode(object.toJson());
    }

    var entry = FutureCallEntry(
      name: name,
      serializedObject: serialization,
      time: time,
      serverId: serverId,
      identifier: identifier,
    );

    var session = _server.serverpod.internalSession;
    await FutureCallEntry.db.insertRow(session, entry);
  }

  /// Cancels a [FutureCall] with the specified identifier. If no future call
  /// with the specified identifier is found, this call will have no effect.
  Future<void> cancelFutureCall(String identifier) async {
    var session = _server.serverpod.internalSession;

    await FutureCallEntry.db.deleteWhere(
      session,
      where: (t) => t.identifier.equals(identifier),
    );
  }

  /// Registers a [FutureCall] with the manager.
  void registerFutureCall(FutureCall call, String name) {
    if (_futureCalls.containsKey(name)) {
      throw Exception('Added future call with duplicate name ($name)');
    }

    call.initialize(_server, name);
    _futureCalls[name] = call;
  }

  /// Starts the manager.
  void start() {
    unawaited(_checkQueue());
  }

  /// Stops the manager.
  Future<void> stop() async {
    _timer?.cancel();
    _timer = null;
    _shuttingDown = true;

    await _waitForRunningFutureCalls();
  }

  Future<void> _checkQueue() async {
    if (_shuttingDown) {
      return;
    }

    final serverpodRole = _server.serverpod.commandLineArgs.role;
    final isMaintenance = serverpodRole == ServerpodRole.maintenance;
    final isMonolith = serverpodRole == ServerpodRole.monolith;

    if (isMaintenance) {
      stdout.writeln('Processing future calls.');
    }

    try {
      var now = DateTime.now().toUtc();
      var postponedFutureCalls = await _invokeFutureCalls(due: now);

      // Ensure all future calls that were overdue are run before proceeding.
      // If there are postponed future calls, wait for one to complete.
      while (postponedFutureCalls.isNotEmpty && !_shuttingDown) {
        if (_runningFutureCallFutures.isNotEmpty) {
          await Future.any(_runningFutureCallFutures);
        }

        // If we are shutting down, stop processing future calls.
        if (_shuttingDown) {
          break;
        }

        // Keep the same due time to run all overdue future calls.
        postponedFutureCalls = await _invokeFutureCalls(
          due: now,
          futureCallEntries: postponedFutureCalls,
        );
      }
    } catch (error, stackTrace) {
      // Most likely we lost connection to the database
      var message =
          'Internal server error. Failed to connect to database in future call manager.';

      _server.serverpod.internalSubmitEvent(
        ExceptionEvent(error, stackTrace, message: message),
        space: OriginSpace.framework,
        context: contextFromServer(_server),
      );

      stderr.writeln('${DateTime.now().toUtc()} $message');
      stderr.writeln('$error');
      stderr.writeln('$stackTrace');
      stderr.writeln('Local stacktrace:');
      stderr.writeln('${StackTrace.current}');
    }

    // If we are running as a maintenance task, we shouldn't check the queue
    // again.
    if (isMonolith && !_shuttingDown) {
      final scanInterval = _server.serverpod.config.futureCall.scanInterval;

      _timer = Timer(scanInterval, _checkQueue);
    } else if (isMaintenance) {
      await _waitForRunningFutureCalls();

      onCompleted();
    }
  }

  Future<void> _waitForRunningFutureCalls() async {
    await Future.wait(_runningFutureCallFutures);
  }

  /// Starts all overdue future calls.
  /// Returns a list of future call entries which are due but have not been
  /// started due to concurrency limits.
  Future<List<FutureCallEntry>> _invokeFutureCalls({
    required DateTime due,
    List<FutureCallEntry>? futureCallEntries,
  }) async {
    var internalSession = _server.serverpod.internalSession;

    var overdueFutureCalls = List<FutureCallEntry>.from(
      futureCallEntries ??
          await FutureCallEntry.db.deleteWhere(
            internalSession,
            where: (row) => row.time <= due,
          ),
    )..sort((a, b) => a.time.compareTo(b.time));
    // Ensure earliest scheduled future call is first

    for (final futureCallEntry in overdueFutureCalls) {
      if (_shuttingDown) {
        break;
      }

      final futureCall = _futureCalls[futureCallEntry.name];

      if (futureCall == null) {
        // TODO this should be logged and not fail silently
        continue;
      }

      final result = await _tryRunFutureCallEntry(
        session: internalSession,
        futureCallEntry: futureCallEntry,
        futureCall: futureCall,
      );

      if (result == _FutureCallInvocationResult.postponed) {
        // Return the remaining future calls to be invoked
        return overdueFutureCalls
            .sublist(overdueFutureCalls.indexOf(futureCallEntry));
      }
    }

    // Reaching this point means that all future calls were started
    return [];
  }

  /// Tries to start a [FutureCall] as configured by the [FutureCallEntry].
  /// If the concurrency limit allows it, the [FutureCall] is invoked, the
  /// [FutureCallEntry] is deleted from the database and
  /// `_FutureCallInvocationResult.success` is returned.
  /// If the concurrency limit is reached, the future call is not invoked and
  /// `_FutureCallInvocationResult.postponed` is returned.
  Future<_FutureCallInvocationResult> _tryRunFutureCallEntry({
    required Session session,
    required FutureCallEntry futureCallEntry,
    required FutureCall<SerializableModel> futureCall,
  }) async {
    // Run in a synchronized block to avoid race conditions
    return _runningFutureCallsLock.synchronized(() async {
      final futureCallName = futureCall.name;

      final isConcurrentLimitReached = _isFutureCallConcurrentLimitReached();

      if (isConcurrentLimitReached) {
        return _FutureCallInvocationResult.postponed;
      }

      // TODO: Later on, here would be the place to check if the future call entry is still in the database and delete it.
      //  The FutureCallEntry should not be deleted prior, because the server process might exit before it is even started.
      //  When implementing this, keep in mind to ensure no race conditions with other server instances occur.

      // Increment the number of running future calls.
      // We are in a synchronized block, no race conditions here.
      _runningFutureCalls.update(
        futureCallName,
        (value) => value + 1,
        ifAbsent: () => 1,
      );

      final futureCallCompleter = Completer<void>();

      _runningFutureCallFutures.add(futureCallCompleter.future);

      unawaited(
        _runFutureCall(
          session: session,
          futureCallEntry: futureCallEntry,
          futureCall: futureCall,
        ).whenComplete(
          () async {
            await _runningFutureCallsLock.synchronized(
              () async => _runningFutureCalls.update(
                futureCallName,
                (value) => value - 1,
                ifAbsent: () => 0,
              ),
            );

            futureCallCompleter.complete();
          },
        ),
      );

      unawaited(
        futureCallCompleter.future.then(
          (_) => _runningFutureCallFutures.remove(futureCallCompleter.future),
        ),
      );

      return _FutureCallInvocationResult.success;
    });
  }

  /// Returns `true` if the concurrent limit for FutureCalls is reached.
  /// Returns `false` otherwise.
  /// Should be called in a synchronized block.
  bool _isFutureCallConcurrentLimitReached() {
    final concurrencyLimit =
        _server.serverpod.config.futureCall.concurrencyLimit;

    if (concurrencyLimit <= 0) {
      return false;
    }

    final totalRunningFutureCalls =
        _runningFutureCalls.values.fold(0, (sum, value) => sum + value);

    final isLimitReached = totalRunningFutureCalls >= concurrencyLimit;

    return isLimitReached;
  }

  /// Runs a [FutureCallEntry] and completes when the future call is completed.
  Future<void> _runFutureCall({
    required Session session,
    required FutureCallEntry futureCallEntry,
    required FutureCall<SerializableModel> futureCall,
  }) async {
    final futureCallName = futureCallEntry.name;

    final futureCallSession = FutureCallSession(
      server: _server,
      futureCallName: futureCallName,
    );

    try {
      dynamic object;
      if (futureCallEntry.serializedObject != null) {
        object = _serializationManager.decode(
          futureCallEntry.serializedObject!,
          futureCall.dataType,
        );
      }

      await futureCall.invoke(futureCallSession, object);
      await futureCallSession.close();
    } catch (error, stackTrace) {
      _server.serverpod.internalSubmitEvent(
        ExceptionEvent(error, stackTrace),
        space: OriginSpace.application,
        context: contextFromSession(futureCallSession),
      );

      await futureCallSession.close(error: error, stackTrace: stackTrace);
    }
  }
}
