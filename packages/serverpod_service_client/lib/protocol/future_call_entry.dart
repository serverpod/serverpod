/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

import 'package:serverpod_client/serverpod_client.dart';
// ignore: unused_import
import 'protocol.dart';

class FutureCallEntry extends SerializableEntity {
  String get className => 'FutureCallEntry';

  int id;
  int serverId;
  DateTime time;
  String serializedObject;
  String name;

  FutureCallEntry({
    this.id,
    this.serverId,
    this.time,
    this.serializedObject,
    this.name,
});

  FutureCallEntry.fromSerialization(Map<String, dynamic> serialization) {
    var data = unwrapSerializationData(serialization);
    id = data['id'];
    serverId = data['serverId'];
    time = data['time'] != null ? DateTime.tryParse(data['time']) : null;
    serializedObject = data['serializedObject'];
    name = data['name'];
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'serverId': serverId,
      'time': time?.toUtc()?.toIso8601String(),
      'serializedObject': serializedObject,
      'name': name,
    });
  }
}

