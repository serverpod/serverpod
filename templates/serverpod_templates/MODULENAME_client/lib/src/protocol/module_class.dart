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

class ModuleClass extends SerializableEntity {
  @override
  String get className => 'MODULENAME_server.ModuleClass';

  int? id;
  late String name;
  late int data;

  ModuleClass({
    this.id,
    required this.name,
    required this.data,
  });

  ModuleClass.fromSerialization(Map<String, dynamic> serialization) {
    Map<String, dynamic> _data = unwrapSerializationData(serialization);
    id = _data['id'];
    name = _data['name']!;
    data = _data['data']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData(<String, dynamic>{
      'id': id,
      'name': name,
      'data': data,
    });
  }
}
