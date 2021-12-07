/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import

import 'package:serverpod/database.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'dart:typed_data';
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
  ByteData? aByteData;

  Types({
    this.id,
    this.anInt,
    this.aBool,
    this.aDouble,
    this.aDateTime,
    this.aString,
    this.aByteData,
  });

  Types.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    anInt = _data['anInt'];
    aBool = _data['aBool'];
    aDouble = _data['aDouble'];
    aDateTime = _data['aDateTime'] != null
        ? DateTime.tryParse(_data['aDateTime'])
        : null;
    aString = _data['aString'];
    aByteData = _data['aByteData'] == null
        ? null
        : (_data['aByteData'] is String
            ? (_data['aByteData'] as String).base64DecodedByteData()
            : ByteData.view((_data['aByteData'] as Uint8List).buffer));
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
      'aByteData': aByteData?.base64encodedString(),
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
      'aByteData': aByteData?.base64encodedString(),
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
      'aByteData': aByteData?.base64encodedString(),
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
  final aByteData = ColumnByteData('aByteData');

  @override
  List<Column> get columns => [
        id,
        anInt,
        aBool,
        aDouble,
        aDateTime,
        aString,
        aByteData,
      ];
}

TypesTable tTypes = TypesTable();
