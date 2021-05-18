/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs

import 'package:serverpod/database.dart';
// ignore: unused_import
import 'protocol.dart';

class Types extends TableRow {
  @override
  String get className => 'Types';
  @override
  String get tableName => 'types';

  @override
  int? id;
  int? anInt;
  bool? aBool;
  double? aDouble;
  DateTime? aDateTime;
  String? aString;

  Types({
    this.id,
    this.anInt,
    this.aBool,
    this.aDouble,
    this.aDateTime,
    this.aString,
});

  Types.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    anInt = _data['anInt'];
    aBool = _data['aBool'];
    aDouble = _data['aDouble'];
    aDateTime = _data['aDateTime'] != null ? DateTime.tryParse(_data['aDateTime']) : null;
    aString = _data['aString'];
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'anInt': anInt,
      'aBool': aBool,
      'aDouble': aDouble,
      'aDateTime': aDateTime?.toUtc().toIso8601String(),
      'aString': aString,
    });
  }

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'anInt': anInt,
      'aBool': aBool,
      'aDouble': aDouble,
      'aDateTime': aDateTime?.toUtc().toIso8601String(),
      'aString': aString,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'anInt': anInt,
      'aBool': aBool,
      'aDouble': aDouble,
      'aDateTime': aDateTime?.toUtc().toIso8601String(),
      'aString': aString,
    });
  }
}

class TypesTable extends Table {
  TypesTable() : super(tableName: 'types');

  @override
  String tableName = 'types';
  final id = ColumnInt('id');
  final anInt = ColumnInt('anInt');
  final aBool = ColumnBool('aBool');
  final aDouble = ColumnDouble('aDouble');
  final aDateTime = ColumnDateTime('aDateTime');
  final aString = ColumnString('aString');

  @override
  List<Column> get columns => [
    id,
    anInt,
    aBool,
    aDouble,
    aDateTime,
    aString,
  ];
}

TypesTable tTypes = TypesTable();
