import 'dart:async';
import 'dart:io';

import 'package:meta/meta.dart';
import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/command_line_args.dart';
import 'package:serverpod/src/server/serverpod.dart';

import 'future_call_scanner.dart';
import 'future_call_scheduler.dart';

/// Manages [FutureCall]s in the [Server]. A [FutureCall] is a method that will
/// be called at a certain time in the future. The call request and its
/// arguments are stored in the database, so it is persistent even if the
/// [Serverpod] is restarted.
class FutureCallManager {
  final Server _server;

  final FutureCallConfig _config;

  final SerializationManager _serializationManager;

  late final FutureCallScheduler _scheduler;
  late final FutureCallScanner _scanner;

  /// Called when pending future calls have been completed, if the server is
  /// running in [ServerpodRole.maintenance] mode.
  final void Function() onCompleted;

  /// Creates a new [FutureCallManager]. Typically, this is done internally by
  /// the [Serverpod].
  FutureCallManager(
    this._server,
    this._config,
    this._serializationManager,
    this.onCompleted,
  ) {
    _scheduler = FutureCallScheduler(
      server: _server,
      serializationManager: _serializationManager,
      concurrencyLimit: _config.concurrencyLimit,
    );

    _scanner = FutureCallScanner(
      server: _server,
      scanInterval: _config.scanInterval,
      isConcurrentLimitReached: _scheduler.shouldSkipScan,
      queueFutureCallEntries: _scheduler.addFutureCallEntries,
    );
  }

  /// Creates a [FutureCallManager] with custom scheduler and scanner for testing.
  @visibleForTesting
  FutureCallManager.forTesting(
    this._server,
    this._config,
    this._serializationManager,
    this.onCompleted, {
    required FutureCallScheduler scheduler,
    required FutureCallScanner scanner,
  }) {
    _scheduler = scheduler;
    _scanner = scanner;
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
  void registerFutureCall(FutureCall call, String name) {
    _scheduler.registerFutureCall(call, name);
  }

  /// Starts the manager.
  void start() {
    final serverpodRole = _server.serverpod.commandLineArgs.role;

    switch (serverpodRole) {
      case ServerpodRole.maintenance:
        unawaited(_runFutureCallsForMaintenance());
        break;
      case ServerpodRole.monolith:
        _runFutureCallsForMonolith();
        break;
      case ServerpodRole.serverless:
        // Serverless does not support future calls.
        break;
    }
  }

  /// Stops the manager.
  Future<void> stop() async {
    _scanner.stop();
    await _scheduler.stop();
  }

  Future<void> _runFutureCallsForMaintenance() async {
    stdout.writeln('Processing future calls.');

    await _scanner.scanFutureCalls();

    await _scheduler.stop();

    onCompleted();
  }

  void _runFutureCallsForMonolith() {
    _scanner.start();
  }
}
