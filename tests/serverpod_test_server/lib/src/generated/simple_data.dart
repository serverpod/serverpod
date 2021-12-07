/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import

import 'package:serverpod/database.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'dart:typed_data';
import 'protocol.dart';

class SimpleData extends TableRow {
  @override
  String get className => 'SimpleData';
  @override
  String get tableName => 'simple_data';

  @override
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

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'num': num,
    });
  }

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'num': num,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'num': num,
    });
  }
}

class SimpleDataTable extends Table {
  SimpleDataTable() : super(tableName: 'simple_data');

  @override
  String tableName = 'simple_data';
  final id = ColumnInt('id');
  final num = ColumnInt('num');

  @override
  List<Column> get columns => [
        id,
        num,
      ];
}

SimpleDataTable tSimpleData = SimpleDataTable();
