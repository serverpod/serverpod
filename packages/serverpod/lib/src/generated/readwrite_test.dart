/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names

import 'package:serverpod/database.dart';
// ignore: unused_import
import 'protocol.dart';

class ReadWriteTestEntry extends TableRow {
  @override
  String get className => 'ReadWriteTestEntry';
  @override
  String get tableName => 'serverpod_readwrite_test';

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

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'number': number,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'number': number,
    });
  }
}

class ReadWriteTestEntryTable extends Table {
  ReadWriteTestEntryTable() : super(tableName: 'serverpod_readwrite_test');

  String tableName = 'serverpod_readwrite_test';
  final id = ColumnInt('id');
  final number = ColumnInt('number');

  List<Column> get columns => [
    id,
    number,
  ];
}

ReadWriteTestEntryTable tReadWriteTestEntry = ReadWriteTestEntryTable();
