/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: unnecessary_import
// ignore_for_file: overridden_fields

import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'dart:typed_data';
import 'protocol.dart';

class SimpleDataList extends SerializableEntity {
  @override
  String get className => 'SimpleDataList';

  int? id;
  late List<SimpleData> rows;

  SimpleDataList({
    this.id,
    required this.rows,
  });

  SimpleDataList.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    rows = _data['rows']!
        .map<SimpleData>((a) => SimpleData.fromSerialization(a))
        ?.toList();
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'rows': rows.map((SimpleData a) => a.serialize()).toList(),
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'rows': rows.map((SimpleData a) => a.serialize()).toList(),
    });
  }
}
