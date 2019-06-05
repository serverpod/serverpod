/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

import 'package:serverpod/database.dart';
// ignore: unused_import
import 'protocol.dart';

class LogEntry extends TableRow {
  String get className => 'LogEntry';
  String get tableName => 'serverpod_log';

  int id;
  int serverId;
  int logLevel;
  DateTime time;
  String stackTrace;
  String message;

  LogEntry({
    this.id,
    this.serverId,
    this.logLevel,
    this.time,
    this.stackTrace,
    this.message,
});

  LogEntry.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    serverId = _data['serverId'];
    logLevel = _data['logLevel'];
    time = _data['time'] != null ? DateTime.tryParse(_data['time']) : null;
    stackTrace = _data['stackTrace'];
    message = _data['message'];
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'serverId': serverId,
      'logLevel': logLevel,
      'time': time?.toUtc()?.toIso8601String(),
      'stackTrace': stackTrace,
      'message': message,
    });
  }
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'serverId': serverId,
      'logLevel': logLevel,
      'time': time?.toUtc()?.toIso8601String(),
      'stackTrace': stackTrace,
      'message': message,
    });
  }

  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'serverId': serverId,
      'logLevel': logLevel,
      'time': time?.toUtc()?.toIso8601String(),
      'stackTrace': stackTrace,
      'message': message,
    });
  }
}

class LogEntryTable extends Table {
  LogEntryTable() : super(tableName: 'serverpod_log');

  String tableName = 'serverpod_log';
  final id = ColumnInt('id');
  final serverId = ColumnInt('serverId');
  final logLevel = ColumnInt('logLevel');
  final time = ColumnDateTime('time');
  final stackTrace = ColumnString('stackTrace');
  final message = ColumnString('message');

  List<Column> get columns => [
    id,
    serverId,
    logLevel,
    time,
    stackTrace,
    message,
  ];
}

LogEntryTable tLogEntry = LogEntryTable();
