/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names

import 'package:serverpod/database.dart';
// ignore: unused_import
import 'protocol.dart';

class SimpleData extends TableRow {
  @override
  String get className => 'SimpleData';
  @override
  String get tableName => 'simple_data';

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

  String tableName = 'simple_data';
  final id = ColumnInt('id');
  final num = ColumnInt('num');

  List<Column> get columns => [
    id,
    num,
  ];
}

SimpleDataTable tSimpleData = SimpleDataTable();
