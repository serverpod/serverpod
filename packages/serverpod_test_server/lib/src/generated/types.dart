/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names

import 'package:serverpod/database.dart';
// ignore: unused_import
import 'protocol.dart';

class Types extends TableRow {
  String get className => 'Types';
  String get tableName => 'types';

  int? id;
  late int anInt;
  late bool aBool;
  late double aDouble;
  late DateTime aDateTime;
  late String aString;

  Types({
    this.id,
    required this.anInt,
    required this.aBool,
    required this.aDouble,
    required this.aDateTime,
    required this.aString,
});

  Types.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    anInt = _data['anInt']!;
    aBool = _data['aBool']!;
    aDouble = _data['aDouble']!;
    aDateTime = DateTime.tryParse(_data['aDateTime'])!;
    aString = _data['aString']!;
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'anInt': anInt,
      'aBool': aBool,
      'aDouble': aDouble,
      'aDateTime': aDateTime.toUtc().toIso8601String(),
      'aString': aString,
    });
  }
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'anInt': anInt,
      'aBool': aBool,
      'aDouble': aDouble,
      'aDateTime': aDateTime.toUtc().toIso8601String(),
      'aString': aString,
    });
  }

  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'anInt': anInt,
      'aBool': aBool,
      'aDouble': aDouble,
      'aDateTime': aDateTime.toUtc().toIso8601String(),
      'aString': aString,
    });
  }
}

class TypesTable extends Table {
  TypesTable() : super(tableName: 'types');

  String tableName = 'types';
  final id = ColumnInt('id');
  final anInt = ColumnInt('anInt');
  final aBool = ColumnBool('aBool');
  final aDouble = ColumnDouble('aDouble');
  final aDateTime = ColumnDateTime('aDateTime');
  final aString = ColumnString('aString');

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
