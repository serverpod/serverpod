/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names

import 'package:serverpod_client/serverpod_client.dart';
// ignore: unused_import
import 'protocol.dart';

class FutureCallEntry extends SerializableEntity {
  String get className => 'FutureCallEntry';

  int? id;
  String? name;
  DateTime? time;
  String? serializedObject;
  int? serverId;

  FutureCallEntry({
    this.id,
    this.name,
    this.time,
    this.serializedObject,
    this.serverId,
});

  FutureCallEntry.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    name = _data['name'];
    time = _data['time'] != null ? DateTime.tryParse(_data['time']) : null;
    serializedObject = _data['serializedObject'];
    serverId = _data['serverId'];
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'name': name,
      'time': time?.toUtc().toIso8601String(),
      'serializedObject': serializedObject,
      'serverId': serverId,
    });
  }
}

