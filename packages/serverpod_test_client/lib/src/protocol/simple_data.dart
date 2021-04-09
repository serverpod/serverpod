/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names

import 'package:serverpod_client/serverpod_client.dart';
// ignore: unused_import
import 'protocol.dart';

class SimpleData extends SerializableEntity {
  String get className => 'SimpleData';

  int? id;
  late int num;

  SimpleData({
    this.id,
    required this.num,
});

  SimpleData.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    num = _data['num']!;
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'num': num,
    });
  }
}

