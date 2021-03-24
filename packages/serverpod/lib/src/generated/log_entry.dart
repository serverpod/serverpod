/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names

import 'package:serverpod/database.dart';
// ignore: unused_import
import 'protocol.dart';

class LogEntry extends TableRow {
  String get className => 'LogEntry';
  String get tableName => 'serverpod_log';

  int id;
  int serverId;
  DateTime time;
  int logLevel;
  String message;
  String stackTrace;
  int sessionLogId;

  LogEntry({
    this.id,
    this.serverId,
    this.time,
    this.logLevel,
    this.message,
    this.stackTrace,
    this.sessionLogId,
});

  LogEntry.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    serverId = _data['serverId'];
    time = _data['time'] != null ? DateTime.tryParse(_data['time']) : null;
    logLevel = _data['logLevel'];
    message = _data['message'];
    stackTrace = _data['stackTrace'];
    sessionLogId = _data['sessionLogId'];
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'serverId': serverId,
      'time': time?.toUtc()?.toIso8601String(),
      'logLevel': logLevel,
      'message': message,
      'stackTrace': stackTrace,
      'sessionLogId': sessionLogId,
    });
  }
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'serverId': serverId,
      'time': time?.toUtc()?.toIso8601String(),
      'logLevel': logLevel,
      'message': message,
      'stackTrace': stackTrace,
      'sessionLogId': sessionLogId,
    });
  }

  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'serverId': serverId,
      'time': time?.toUtc()?.toIso8601String(),
      'logLevel': logLevel,
      'message': message,
      'stackTrace': stackTrace,
      'sessionLogId': sessionLogId,
    });
  }
}

class LogEntryTable extends Table {
  LogEntryTable() : super(tableName: 'serverpod_log');

  String tableName = 'serverpod_log';
  final id = ColumnInt('id');
  final serverId = ColumnInt('serverId');
  final time = ColumnDateTime('time');
  final logLevel = ColumnInt('logLevel');
  final message = ColumnString('message');
  final stackTrace = ColumnString('stackTrace');
  final sessionLogId = ColumnInt('sessionLogId');

  List<Column> get columns => [
    id,
    serverId,
    time,
    logLevel,
    message,
    stackTrace,
    sessionLogId,
  ];
}

LogEntryTable tLogEntry = LogEntryTable();
