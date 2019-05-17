import 'dart:async';
import 'dart:convert';
import 'future_call.dart';
import 'server.dart';
import '../generated/protocol.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';

class FutureCallManager {
  final Server _server;
  final SerializationManager _serializationManager;
  final _futureCalls = <String, FutureCall>{};
  Timer _timer;
  bool _lock = false;

  FutureCallManager(this._server, this._serializationManager);

  Future<Null> scheduleFutureCall(String name, SerializableEntity object, DateTime time, int serverId) async {
    String serialization;
    if (object != null)
      serialization = jsonEncode(object.serializeAll());

    var entry = FutureCallEntry(
      name: name,
      serializedObject: serialization,
      time: time,
      serverId: serverId,
    );
    await _server.database.insert(entry);
  }

  void addFutureCall(FutureCall call, String name) {
    if (_futureCalls.containsKey(name))
      _server.logWarning('Added future call with duplicate name ($name)');

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
    _timer = Timer.periodic(Duration(seconds: 5), (_) async {
      await _checkQueue();
    });
  }

  Future<Null> _checkQueue() async {
    if (_lock)
      return;

    _lock = true;

    DateTime now = DateTime.now();

    var rows = await _server.database.find(tFutureCallEntry, where: (tFutureCallEntry.time <= now));

    for(FutureCallEntry entry in rows) {
      FutureCall call = _futureCalls[entry.name];
      if (call == null)
        continue;

      SerializableEntity object;
      if (entry.serializedObject != null) {
        Map data = jsonDecode(entry.serializedObject);
        object = _serializationManager.createEntityFromSerialization(data);
      }
      call.invoke(object);
    }

    if (rows.length > 0)
      await _server.database.delete(tFutureCallEntry, where: (tFutureCallEntry.time <= now));

    _lock = false;
  }
}