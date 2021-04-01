import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'future_call.dart';
import 'session.dart';
import 'server.dart';
import '../database/database_connection.dart';
import '../generated/protocol.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';

class FutureCallManager {
  final Server _server;
  final SerializationManager _serializationManager;
  final _futureCalls = <String, FutureCall>{};
  Timer? _timer;

  FutureCallManager(this._server, this._serializationManager);

  Future<Null> scheduleFutureCall(String name, SerializableEntity? object, DateTime time, int serverId) async {
    String? serialization;
    if (object != null)
      serialization = jsonEncode(object.serializeAll());

    var entry = FutureCallEntry(
      name: name,
      serializedObject: serialization,
      time: time,
      serverId: serverId,
    );

    DatabaseConnection dbConn = DatabaseConnection(_server.databaseConnection);
    await dbConn.insert(entry);
  }

  void addFutureCall(FutureCall call, String name) {
    if (_futureCalls.containsKey(name))
      throw Exception('Added future call with duplicate name ($name)');

    call.initialize(_server, name);
    _futureCalls[name] = call;
  }

  void start() {
    _run();
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void _run() async {
    _checkQueue();
  }

  Future<Null> _checkQueue() async {
    DatabaseConnection dbConn = DatabaseConnection(_server.databaseConnection);

    try {
      // Get calls
      DateTime now = DateTime.now();

      var rows = await dbConn.find(
        tFutureCallEntry,
        where: (tFutureCallEntry.time <= now) & tFutureCallEntry.serverId
            .equals(_server.serverId),
      );

      for (FutureCallEntry entry in rows.cast<FutureCallEntry>()) {
        FutureCall? call = _futureCalls[entry.name!];
        if (call == null)
          continue;

        SerializableEntity? object;
        if (entry.serializedObject != null) {
          Map? data = jsonDecode(entry.serializedObject!);
          object = _serializationManager.createEntityFromSerialization(data as Map<String, dynamic>?);
        }
        try {
          Session session = Session(
            type: SessionType.futureCall,
            server: _server,
            futureCallName: entry.name,
          );

          await call.invoke(session, object);
        }
        catch(e, stackTrace) {
          // Log errors
          stderr.writeln('Internal server error.');
          stderr.writeln('$e');
          stderr.writeln('$stackTrace');
        }
      }

      // Remove the invoked calls
      if (rows.length > 0) {
        await dbConn.delete(
          tFutureCallEntry,
          where: tFutureCallEntry.serverId.equals(
              _server.serverId) & (tFutureCallEntry.time <= now),
        );
      }
    }
    catch(e, stackTrace) {
      // Most likely we lost connection to the database
      stderr.writeln('${DateTime.now()} Failed to connect to database in future call manager $e');
      stderr.writeln('$stackTrace');
      stderr.writeln('Local stacktrace:');
      stderr.writeln('${StackTrace.current}');
    }

    // Check the queue again in 5 seconds
    _timer = Timer(Duration(seconds: 5), _checkQueue);
  }
}