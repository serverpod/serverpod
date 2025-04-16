import 'dart:async';
import 'dart:io';

import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/diagnostic_events/diagnostic_events.dart';
import 'package:serverpod/src/server/serverpod.dart';

import 'future_call_scanner.dart';
import 'serverpod_task_scheduler.dart';

/// Manages [FutureCall]s in the [Server]. A [FutureCall] is a method that will
/// be called at a certain time in the future. The call request and its
/// arguments are stored in the database, so it is persistent even if the
/// [Serverpod] is restarted.
class FutureCallManager {
  final Server _server;

  final FutureCallConfig _config;

  final SerializationManager _serializationManager;

  final _futureCalls = <String, FutureCall>{};

  late final ServerpodTaskScheduler _scheduler;
  late final FutureCallScanner _scanner;

  /// Creates a new [FutureCallManager]. Typically, this is done internally by
  /// the [Serverpod].
  FutureCallManager(
    this._server,
    this._config,
    this._serializationManager,
  ) {
    _scheduler = ServerpodTaskScheduler(
      concurrencyLimit: _config.concurrencyLimit,
    );

    _scanner = FutureCallScanner(
      server: _server,
      scanInterval: _config.scanInterval,
      shouldSkipScan: _scheduler.isConcurrentLimitReached,
      dispatchEntries: (entries) => _dispatchEntries(entries),
    );
  }

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
  void registerFutureCall(FutureCall futureCall, String name) {
    if (_futureCalls.containsKey(name)) {
      throw Exception('Added future call with duplicate name ($name)');
    }

    futureCall.initialize(_server, name);

    _futureCalls[name] = futureCall;
  }

  /// Runs all scheduled future calls that are past their due date.
  Future<void> runScheduledFutureCalls() async {
    stdout.writeln('Processing future calls.');

    await _scanner.scanFutureCallEntries();

    await _scheduler.stop();
  }

  /// Starts the future call manager to monitor the database for overdue future
  /// calls and execute them.
  void start() {
    _scanner.start();
  }

  /// Stops the future call manager from monitoring overdue future calls for
  /// execution.
  Future<void> stop() async {
    await _scanner.stop();
    await _scheduler.stop();
  }

  void _dispatchEntries(List<FutureCallEntry> entries) {
    final callbacks = entries.map<TaskCallback?>((entry) {
      final futureCall = _futureCalls[entry.name];

      if (futureCall == null) {
        // TODO(inf0rmatix): this should be logged or caught otherwise.
        return null;
      }

      return () => _runFutureCall(
            session: _server.serverpod.internalSession,
            futureCallEntry: entry,
            futureCall: futureCall,
          );
    });

    _scheduler.addTaskCallbacks(callbacks.nonNulls.toList());
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
