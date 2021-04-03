/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names

import 'package:serverpod_serialization/serverpod_serialization.dart';
// ignore: unused_import
import 'protocol.dart';

class SimpleDataList extends SerializableEntity {
  String get className => 'SimpleDataList';

  int? id;
  List<SimpleData>? rows;

  SimpleDataList({
    this.id,
    this.rows,
});

  SimpleDataList.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    rows = _data['rows']?.map<SimpleData>((a) => SimpleData.fromSerialization(a))?.toList();
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'rows': rows?.map((SimpleData a) => a.serialize()).toList(),
    });
  }
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'rows': rows?.map((SimpleData a) => a.serialize()).toList(),
    });
  }

  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'rows': rows?.map((SimpleData a) => a.serialize()).toList(),
    });
  }
}

