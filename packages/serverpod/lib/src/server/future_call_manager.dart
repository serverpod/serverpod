import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:serverpod_serialization/serverpod_serialization.dart';

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
  final SerializationManager _serializationManager;
  final _futureCalls = <String, FutureCall>{};
  Timer? _timer;

  /// Creates a new [FutureCallManager]. Typically, this is done internally by
  /// the [Serverpod].
  FutureCallManager(this._server, this._serializationManager);

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
    if (object != null) serialization = jsonEncode(object.serializeAll());

    var entry = FutureCallEntry(
      name: name,
      serializedObject: serialization,
      time: time,
      serverId: serverId,
      identifier: identifier,
    );

    var session = await _server.serverpod.createSession();
    await session.db.insert(entry);
    await session.close(logSession: false);
  }

  /// Cancels a [FutureCall] with the specified identifier. If no future call
  /// with the specified identifier is found, this call will have no effect.
  Future<void> cancelFutureCall(String identifier) async {
    var session = await _server.serverpod.createSession();

    await FutureCallEntry.delete(
      session,
      where: (t) => t.identifier.equals(identifier),
    );

    await session.close(logSession: false);
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
    try {
      // Get calls
      var now = DateTime.now().toUtc();

      var tempSession = await _server.serverpod.createSession();
      var rows = await tempSession.db.find<FutureCallEntry>(
        where: (FutureCallEntry.t.time <= now) &
            FutureCallEntry.t.serverId.equals(_server.serverId),
      );
      await tempSession.close(logSession: false);

      for (var entry in rows.cast<FutureCallEntry>()) {
        var call = _futureCalls[entry.name];
        if (call == null) {
          continue;
        }

        SerializableEntity? object;
        if (entry.serializedObject != null) {
          Map? data = jsonDecode(entry.serializedObject!);
          object = _serializationManager
              .createEntityFromSerialization(data as Map<String, dynamic>?);
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

      // Remove the invoked calls
      if (rows.isNotEmpty) {
        var tempSession = await _server.serverpod.createSession();
        await tempSession.db.delete<FutureCallEntry>(
          where:
              FutureCallEntry.t.serverId.equals(tempSession.server.serverId) &
                  (FutureCallEntry.t.time <= now),
        );
        await tempSession.close(logSession: false);
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

    // Check the queue again in 5 seconds
    _timer = Timer(const Duration(seconds: 5), _checkQueue);
  }
}
