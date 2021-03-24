/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names

import 'package:serverpod/database.dart';
// ignore: unused_import
import 'protocol.dart';

class FutureCallEntry extends TableRow {
  String get className => 'FutureCallEntry';
  String get tableName => 'serverpod_future_call';

  int id;
  String name;
  DateTime time;
  String serializedObject;
  int serverId;

  FutureCallEntry({
    this.id,
    this.name,
    this.time,
    this.serializedObject,
    this.serverId,
});

  FutureCallEntry.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    name = _data['name'];
    time = _data['time'] != null ? DateTime.tryParse(_data['time']) : null;
    serializedObject = _data['serializedObject'];
    serverId = _data['serverId'];
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'name': name,
      'time': time?.toUtc()?.toIso8601String(),
      'serializedObject': serializedObject,
      'serverId': serverId,
    });
  }
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'name': name,
      'time': time?.toUtc()?.toIso8601String(),
      'serializedObject': serializedObject,
      'serverId': serverId,
    });
  }

  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'name': name,
      'time': time?.toUtc()?.toIso8601String(),
      'serializedObject': serializedObject,
      'serverId': serverId,
    });
  }
}

class FutureCallEntryTable extends Table {
  FutureCallEntryTable() : super(tableName: 'serverpod_future_call');

  String tableName = 'serverpod_future_call';
  final id = ColumnInt('id');
  final name = ColumnString('name');
  final time = ColumnDateTime('time');
  final serializedObject = ColumnString('serializedObject');
  final serverId = ColumnInt('serverId');

  List<Column> get columns => [
    id,
    name,
    time,
    serializedObject,
    serverId,
  ];
}

FutureCallEntryTable tFutureCallEntry = FutureCallEntryTable();
