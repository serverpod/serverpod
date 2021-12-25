/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: overridden_fields

import 'package:serverpod/database.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'dart:typed_data';
import 'protocol.dart';

class ReadWriteTestEntry extends TableRow {
  @override
  String get className => 'ReadWriteTestEntry';
  @override
  String get tableName => 'serverpod_readwrite_test';

  static final t = ReadWriteTestEntryTable();

  @override
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

  @override
  void setColumn(String columnName, value) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'number':
        number = value;
        return;
      default:
        throw UnimplementedError();
    }
  }
}

class ReadWriteTestEntryTable extends Table {
  ReadWriteTestEntryTable() : super(tableName: 'serverpod_readwrite_test');

  @override
  String tableName = 'serverpod_readwrite_test';
  final id = ColumnInt('id');
  final number = ColumnInt('number');

  @override
  List<Column> get columns => [
        id,
        number,
      ];
}

@Deprecated('Use ReadWriteTestEntryTable.t instead.')
ReadWriteTestEntryTable tReadWriteTestEntry = ReadWriteTestEntryTable();
