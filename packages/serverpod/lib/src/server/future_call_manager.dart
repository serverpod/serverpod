import 'dart:async';
import 'dart:io';

import 'package:serverpod/src/server/command_line_args.dart';
import 'package:serverpod_client/serverpod_client.dart';

import '../generated/protocol.dart';
import 'future_call.dart';
import 'server.dart';
import 'session.dart';

/// Manages [FutureCall]s in the [Server]. A [FutureCall] is a method that will
/// be called at a certain time in the future. The call request and its
/// arguments are stored in the database, so it is persistent even if the
/// [Serverpod] is restarted.
class FutureCallManager {
  final Server _server;

  /// Called when pending future calls have been completed, if the server is
  /// running in [ServerpodRole.maintenance] mode.
  final VoidCallback onCompleted;

  final SerializationManager _serializationManager;
  final _futureCalls = <String, FutureCall>{};
  Timer? _timer;

  /// Creates a new [FutureCallManager]. Typically, this is done internally by
  /// the [Serverpod].
  FutureCallManager(this._server, this._serializationManager, this.onCompleted);

  /// Schedules a [FutureCall] by its [name]. A [SerializableEntity] can be
  /// passed as an argument. The `invoke` method of the [FutureCall] will
  /// be called at or after the specified [time]. Set the identifier if you need
  /// to be able to cancel the call.
  Future<void> scheduleFutureCall(
    String name,
    SerializableEntity? object,
    DateTime time,
    String serverId,
    String? identifier,
  ) async {
    String? serialization;
    if (object != null) {
      serialization = SerializationManager.encode(object.allToJson());
    }

    var entry = FutureCallEntry(
      name: name,
      serializedObject: serialization,
      time: time,
      serverId: serverId,
      identifier: identifier,
    );

    var session = await _server.serverpod.createSession(enableLogging: false);
    await FutureCallEntry.db.insertRow(session, entry);
    await session.close();
  }

  /// Cancels a [FutureCall] with the specified identifier. If no future call
  /// with the specified identifier is found, this call will have no effect.
  Future<void> cancelFutureCall(String identifier) async {
    var session = await _server.serverpod.createSession(enableLogging: false);

    await FutureCallEntry.db.deleteWhere(
      session,
      where: (t) => t.identifier.equals(identifier),
    );

    await session.close();
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
    _run();
  }

  /// Stops the manager.
  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void _run() async {
    unawaited(_checkQueue());
  }

  Future<void> _checkQueue() async {
    if (_server.serverpod.commandLineArgs.role == ServerpodRole.maintenance) {
      stdout.writeln('Processing future calls.');
    }

    try {
      // Get calls
      var now = DateTime.now().toUtc();

      var tempSession = await _server.serverpod.createSession(
        enableLogging: false,
      );

      // TODO: replace when we got batch ops.
      // ignore: deprecated_member_use_from_same_package
      var rows = await tempSession.db.deleteAndReturn<FutureCallEntry>(
        where: (FutureCallEntry.t.time <= now),
      );
      await tempSession.close();

      for (var entry in rows.cast<FutureCallEntry>()) {
        var call = _futureCalls[entry.name];
        if (call == null) {
          continue;
        }

        dynamic object;
        if (entry.serializedObject != null) {
          object = _serializationManager.decode(
              entry.serializedObject!, call.dataType);
        }

        var futureCallSession = FutureCallSession(
          server: _server,
          futureCallName: entry.name,
        );

        try {
          await call.invoke(futureCallSession, object);
          await futureCallSession.close();
        } catch (e, stackTrace) {
          await futureCallSession.close(error: e, stackTrace: stackTrace);
        }
      }
    } catch (e, stackTrace) {
      // Most likely we lost connection to the database
      stderr.writeln(
          '${DateTime.now().toUtc()} Internal server error. Failed to connect to database in future call manager.');
      stderr.writeln('$e');
      stderr.writeln('$stackTrace');
      stderr.writeln('Local stacktrace:');
      stderr.writeln('${StackTrace.current}');
    }

    // If we are running as a maintenance task, we shouldn't check the queue
    // again.
    if (_server.serverpod.commandLineArgs.role == ServerpodRole.monolith) {
      // Check the queue again in 5 seconds
      _timer = Timer(const Duration(seconds: 5), _checkQueue);
    } else if (_server.serverpod.commandLineArgs.role ==
        ServerpodRole.maintenance) {
      onCompleted();
    }
  }
}
