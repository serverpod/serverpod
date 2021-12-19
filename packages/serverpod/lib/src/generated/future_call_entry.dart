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

class FutureCallEntry extends TableRow {
  @override
  String get className => 'FutureCallEntry';
  @override
  String get tableName => 'serverpod_future_call';

  @override
  int? id;
  late String name;
  late DateTime time;
  String? serializedObject;
  late int serverId;

  FutureCallEntry({
    this.id,
    required this.name,
    required this.time,
    this.serializedObject,
    required this.serverId,
  });

  FutureCallEntry.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    name = _data['name']!;
    time = DateTime.tryParse(_data['time'])!;
    serializedObject = _data['serializedObject'];
    serverId = _data['serverId']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'name': name,
      'time': time.toUtc().toIso8601String(),
      'serializedObject': serializedObject,
      'serverId': serverId,
    });
  }

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'name': name,
      'time': time.toUtc().toIso8601String(),
      'serializedObject': serializedObject,
      'serverId': serverId,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'name': name,
      'time': time.toUtc().toIso8601String(),
      'serializedObject': serializedObject,
      'serverId': serverId,
    });
  }
}

class FutureCallEntryTable extends Table {
  FutureCallEntryTable() : super(tableName: 'serverpod_future_call');

  @override
  String tableName = 'serverpod_future_call';
  final id = ColumnInt('id');
  final name = ColumnString('name');
  final time = ColumnDateTime('time');
  final serializedObject = ColumnString('serializedObject');
  final serverId = ColumnInt('serverId');

  @override
  List<Column> get columns => [
        id,
        name,
        time,
        serializedObject,
        serverId,
      ];
}

FutureCallEntryTable tFutureCallEntry = FutureCallEntryTable();
