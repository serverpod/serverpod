/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names

import 'package:serverpod_client/serverpod_client.dart';
// ignore: unused_import
import 'protocol.dart';

class ModuleClass extends SerializableEntity {
  @override
  String get className => 'serverpod_test_module_server.ModuleClass';

  int? id;
  late String name;
  late int data;

  ModuleClass({
    this.id,
    required this.name,
    required this.data,
});

  ModuleClass.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    name = _data['name']!;
    data = _data['data']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'name': name,
      'data': data,
    });
  }
}

