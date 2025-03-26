import 'dart:async';
import 'dart:io';

import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/command_line_args.dart';
import 'package:serverpod/src/server/diagnostic_events/diagnostic_events.dart';
import 'package:serverpod/src/server/serverpod.dart';
import 'package:serverpod/src/util/mutex.dart';

/// Manages [FutureCall]s in the [Server]. A [FutureCall] is a method that will
/// be called at a certain time in the future. The call request and its
/// arguments are stored in the database, so it is persistent even if the
/// [Serverpod] is restarted.
class FutureCallManager {
  final Server _server;

  /// Called when pending future calls have been completed, if the server is
  /// running in [ServerpodRole.maintenance] mode.
  final void Function() onCompleted;

  /// The maximum number of concurrent running future calls.
  /// Takes precedence over the [FutureCall.concurrentLimit] setting.
  /// Even if a single FutureCall has a higher limit, the total number of
  /// concurrent future calls will not exceed this limit.
  final int _concurrencyLimit;

  final SerializationManager _serializationManager;
  final _futureCalls = <String, FutureCall>{};
  Timer? _timer;
  final Map<String, int> _runningFutureCalls = {};
  final _runningFutureCallFutures = <Future>[];
  final _runningFutureCallsMutex = Mutex();
  bool _shuttingDown = false;

  /// Creates a new [FutureCallManager]. Typically, this is done internally by
  /// the [Serverpod].
  FutureCallManager(
    this._server,
    this._serializationManager,
    this.onCompleted,
    this._concurrencyLimit,
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
      var hasPostponedFutureCalls = !(await _invokeFutureCalls(due: now));

      // Ensure all future calls that were overdue are run before proceeding.
      while (hasPostponedFutureCalls && !_shuttingDown) {
        // TODO To increase performance and make sure invoke is only called if
        // there is a future call that can be run, in a later iteration checking
        // the map of running future calls for any postponed future call that is
        // now allowed to run would be more efficient.

        if (_runningFutureCallFutures.isNotEmpty) {
          await Future.any(_runningFutureCallFutures);
        }

        // Keep the same due time to run all overdue future calls.
        hasPostponedFutureCalls = !(await _invokeFutureCalls(due: now));
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
      // Check the queue again in 5 seconds
      _timer = Timer(const Duration(seconds: 5), _checkQueue);
    } else if (isMaintenance) {
      await _waitForRunningFutureCalls();

      onCompleted();
    }
  }

  Future<void> _waitForRunningFutureCalls() async {
    await Future.wait(_runningFutureCallFutures);
  }

  /// Starts all overdue future calls.
  /// Returns `true` if all due future calls have been run.
  /// Returns `false` if there are future calls which are due but have not been
  /// run due to concurrency limits.
  Future<bool> _invokeFutureCalls({required DateTime due}) async {
    var internalSession = _server.serverpod.internalSession;

    var overdueFutureCalls = await FutureCallEntry.db.find(
      internalSession,
      where: (row) => row.time <= due,
      orderBy: (row) => row.time,
    );

    var hasPostponedFutureCalls = false;

    for (var futureCallEntry in overdueFutureCalls) {
      if (_shuttingDown) {
        break;
      }

      final futureCall = _futureCalls[futureCallEntry.name];

      if (futureCall == null) {
        overdueFutureCalls.remove(futureCallEntry);
        // Delete the entry from the database before invoking the future call.
        await FutureCallEntry.db.deleteRow(internalSession, futureCallEntry);
        // TODO this should be logged and not fail silently
        continue;
      }

      final isFutureCallInvoked = await _tryRunFutureCallEntry(
        session: internalSession,
        futureCallEntry: futureCallEntry,
        futureCall: futureCall,
      );

      if (!isFutureCallInvoked) {
        hasPostponedFutureCalls = true;
      }
    }

    return !hasPostponedFutureCalls;
  }

  /// Tries to start a [FutureCall] as configured by the [FutureCallEntry].
  /// If the concurrency limit allows it, the [FutureCall] is invoked, the
  /// [FutureCallEntry] is deleted from the database and `true` is returned.
  /// If the future call limit is reached, the future call is not invoked and
  /// `false` is returned.
  Future<bool> _tryRunFutureCallEntry({
    required Session session,
    required FutureCallEntry futureCallEntry,
    required FutureCall<SerializableModel> futureCall,
  }) async {
    // Run in a synchronized block to avoid race conditions
    return _runningFutureCallsMutex.synchronized(() async {
      final futureCallName = futureCall.name;

      final isConcurrentLimitReached =
          _isFutureCallConcurrentLimitReached(futureCall);

      if (isConcurrentLimitReached) {
        return false;
      }

      // Increment the number of running future calls.
      // We are in a synchronized block, no race conditions here.
      _runningFutureCalls.update(
        futureCallName,
        (value) => value + 1,
        ifAbsent: () => 1,
      );

      final futureCallFuture = _runFutureCall(
        session: session,
        futureCallEntry: futureCallEntry,
        futureCall: futureCall,
      ).whenComplete(
        () => _runningFutureCallsMutex.synchronized(
          () async => _runningFutureCalls.update(
            futureCallName,
            (value) => value - 1,
            ifAbsent: () => 0,
          ),
        ),
      );

      _runningFutureCallFutures.add(futureCallFuture);

      unawaited(
        futureCallFuture.whenComplete(
          () => _runningFutureCallFutures.remove(futureCallFuture),
        ),
      );

      return true;
    });
  }

  /// Returns `true` if the concurrent limit for the [FutureCall] is reached.
  /// Returns `false` otherwise.
  /// Should be called in a synchronized block.
  bool _isFutureCallConcurrentLimitReached(FutureCall futureCall) {
    final futureCallName = futureCall.name;

    final totalRunningFutureCalls =
        _runningFutureCalls.values.fold(0, (sum, value) => sum + value);

    final isGlobalLimitReached = totalRunningFutureCalls >= _concurrencyLimit;

    if (isGlobalLimitReached) {
      return true;
    }

    final runningInstances = _runningFutureCalls[futureCallName] ?? 0;

    final isFutureCallLimitReached =
        runningInstances >= futureCall.concurrentLimit;

    if (isFutureCallLimitReached) {
      return true;
    }

    return false;
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
      // Future call is now running, so we can delete it from the database.
      // This might fail if the session is closed.
      await FutureCallEntry.db.deleteRow(session, futureCallEntry);

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
