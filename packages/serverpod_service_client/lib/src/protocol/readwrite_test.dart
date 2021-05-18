/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs

import 'package:serverpod_client/serverpod_client.dart';
// ignore: unused_import
import 'protocol.dart';

class ReadWriteTestEntry extends SerializableEntity {
  @override
  String get className => 'ReadWriteTestEntry';

  int? id;
  late int number;

  ReadWriteTestEntry({
    this.id,
    required this.number,
});

  ReadWriteTestEntry.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    number = _data['number']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'number': number,
    });
  }
}

