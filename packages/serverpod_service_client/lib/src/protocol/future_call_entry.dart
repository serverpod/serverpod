/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: unnecessary_import
// ignore_for_file: overridden_fields

import 'package:serverpod_client/serverpod_client.dart';
import 'dart:typed_data';
import 'protocol.dart';

class FutureCallEntry extends SerializableEntity {
  @override
  String get className => 'FutureCallEntry';

  int? id;
  late String name;
  late DateTime time;
  String? serializedObject;
  late String serverId;
  String? identifier;

  FutureCallEntry({
    this.id,
    required this.name,
    required this.time,
    this.serializedObject,
    required this.serverId,
    this.identifier,
  });

  FutureCallEntry.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    name = _data['name']!;
    time = DateTime.tryParse(_data['time'])!;
    serializedObject = _data['serializedObject'];
    serverId = _data['serverId']!;
    identifier = _data['identifier'];
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'name': name,
      'time': time.toUtc().toIso8601String(),
      'serializedObject': serializedObject,
      'serverId': serverId,
      'identifier': identifier,
    });
  }
}
