/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: unnecessary_import
// ignore_for_file: overridden_fields
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: depend_on_referenced_packages

import 'package:serverpod_client/serverpod_client.dart';
import 'dart:typed_data';
import 'protocol.dart';

class Example extends SerializableEntity {
  @override
  String get className => 'Example';

  late String name;
  late int data;

  Example({
    required this.name,
    required this.data,
  });

  Example.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    name = _data['name']!;
    data = _data['data']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'name': name,
      'data': data,
    });
  }
}
