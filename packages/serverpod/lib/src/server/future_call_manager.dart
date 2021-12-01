import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'future_call.dart';
import 'session.dart';
import 'server.dart';
import '../database/database_connection.dart';
import '../generated/protocol.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'package:pedantic/pedantic.dart';

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
  /// be called at or after the specified [time].
  Future<void> scheduleFutureCall(String name, SerializableEntity? object, DateTime time, int serverId) async {
    String? serialization;
    if (object != null)
      serialization = jsonEncode(object.serializeAll());

    var entry = FutureCallEntry(
      name: name,
      serializedObject: serialization,
      time: time,
      serverId: serverId,
    );

    var dbConn = DatabaseConnection(_server.databaseConfig);
    var session = await _server.serverpod.createSession();
    await dbConn.insert(entry, session: session);
    await session.close();

  }

  /// Registers a [FutureCall] with the manager.
  void registerFutureCall(FutureCall call, String name) {
    if (_futureCalls.containsKey(name))
      throw Exception('Added future call with duplicate name ($name)');

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
    var dbConn = DatabaseConnection(_server.databaseConfig);

    try {
      // Get calls
      var now = DateTime.now();

      var session = await _server.serverpod.createSession();
      var rows = await dbConn.find(
        tFutureCallEntry,
        where: (tFutureCallEntry.time <= now) & tFutureCallEntry.serverId
            .equals(_server.serverId),
        session: session,
      );
      await session.close();

      for (var entry in rows.cast<FutureCallEntry>()) {
        var call = _futureCalls[entry.name];
        if (call == null)
          continue;

        SerializableEntity? object;
        if (entry.serializedObject != null) {
          Map? data = jsonDecode(entry.serializedObject!);
          object = _serializationManager.createEntityFromSerialization(data as Map<String, dynamic>?);
        }

        var futureCallSession = FutureCallSession(
          server: _server,
          futureCallName: entry.name,
        );

        try {
          await call.invoke(futureCallSession, object);
          unawaited(futureCallSession.close());
        }
        catch(e, stackTrace) {
          unawaited(futureCallSession.close(error: e, stackTrace: stackTrace));
        }
      }

      // Remove the invoked calls
      if (rows.isNotEmpty) {
        var session = await _server.serverpod.createSession();
        await dbConn.delete(
          tFutureCallEntry,
          where: tFutureCallEntry.serverId.equals(
              _server.serverId) & (tFutureCallEntry.time <= now),
          session: session,
        );
        await session.close();
      }
    }
    catch(e, stackTrace) {
      // Most likely we lost connection to the database
      stderr.writeln('${DateTime.now().toUtc()} Internal server error. Failed to connect to database in future call manager.');
      stderr.writeln('$e');
      stderr.writeln('$stackTrace');
      stderr.writeln('Local stacktrace:');
      stderr.writeln('${StackTrace.current}');
    }

    // Check the queue again in 5 seconds
    _timer = Timer(Duration(seconds: 5), _checkQueue);
  }
}