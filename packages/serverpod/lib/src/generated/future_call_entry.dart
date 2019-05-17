/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

import 'package:serverpod/database.dart';
// ignore: unused_import
import 'protocol.dart';

class FutureCallEntry extends TableRow {
  String get className => 'FutureCallEntry';
  String get tableName => 'serverpod_future_call';

  int id;
  int serverId;
  DateTime time;
  String serializedObject;
  String name;

  FutureCallEntry({
    this.id,
    this.serverId,
    this.time,
    this.serializedObject,
    this.name,
});

  FutureCallEntry.fromSerialization(Map<String, dynamic> serialization) {
    var data = unwrapSerializationData(serialization);
    id = data['id'];
    serverId = data['serverId'];
    time = data['time'] != null ? DateTime.tryParse(data['time']) : null;
    serializedObject = data['serializedObject'];
    name = data['name'];
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'serverId': serverId,
      'time': time?.toUtc()?.toIso8601String(),
      'serializedObject': serializedObject,
      'name': name,
    });
  }
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'serverId': serverId,
      'time': time?.toUtc()?.toIso8601String(),
      'serializedObject': serializedObject,
      'name': name,
    });
  }

  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'serverId': serverId,
      'time': time?.toUtc()?.toIso8601String(),
      'serializedObject': serializedObject,
      'name': name,
    });
  }
}

class FutureCallEntryTable extends Table {
  FutureCallEntryTable() : super(tableName: 'serverpod_future_call');

  String tableName = 'serverpod_future_call';
  final id = ColumnInt('id');
  final serverId = ColumnInt('serverId');
  final time = ColumnDateTime('time');
  final serializedObject = ColumnString('serializedObject');
  final name = ColumnString('name');

  List<Column> get columns => [
    id,
    serverId,
    time,
    serializedObject,
    name,
  ];
}

FutureCallEntryTable tFutureCallEntry = FutureCallEntryTable();
