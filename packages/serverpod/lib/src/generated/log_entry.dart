/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs

import 'package:serverpod/database.dart';
// ignore: unused_import
import 'protocol.dart';

class LogEntry extends TableRow {
  @override
  String get className => 'LogEntry';
  @override
  String get tableName => 'serverpod_log';

  @override
  int? id;
  late int serverId;
  late DateTime time;
  late int logLevel;
  late String message;
  String? exception;
  String? stackTrace;
  int? sessionLogId;

  LogEntry({
    this.id,
    required this.serverId,
    required this.time,
    required this.logLevel,
    required this.message,
    this.exception,
    this.stackTrace,
    this.sessionLogId,
});

  LogEntry.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    serverId = _data['serverId']!;
    time = DateTime.tryParse(_data['time'])!;
    logLevel = _data['logLevel']!;
    message = _data['message']!;
    exception = _data['exception'];
    stackTrace = _data['stackTrace'];
    sessionLogId = _data['sessionLogId'];
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'serverId': serverId,
      'time': time.toUtc().toIso8601String(),
      'logLevel': logLevel,
      'message': message,
      'exception': exception,
      'stackTrace': stackTrace,
      'sessionLogId': sessionLogId,
    });
  }

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'serverId': serverId,
      'time': time.toUtc().toIso8601String(),
      'logLevel': logLevel,
      'message': message,
      'exception': exception,
      'stackTrace': stackTrace,
      'sessionLogId': sessionLogId,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'serverId': serverId,
      'time': time.toUtc().toIso8601String(),
      'logLevel': logLevel,
      'message': message,
      'exception': exception,
      'stackTrace': stackTrace,
      'sessionLogId': sessionLogId,
    });
  }
}

class LogEntryTable extends Table {
  LogEntryTable() : super(tableName: 'serverpod_log');

  @override
  String tableName = 'serverpod_log';
  final id = ColumnInt('id');
  final serverId = ColumnInt('serverId');
  final time = ColumnDateTime('time');
  final logLevel = ColumnInt('logLevel');
  final message = ColumnString('message');
  final exception = ColumnString('exception');
  final stackTrace = ColumnString('stackTrace');
  final sessionLogId = ColumnInt('sessionLogId');

  @override
  List<Column> get columns => [
    id,
    serverId,
    time,
    logLevel,
    message,
    exception,
    stackTrace,
    sessionLogId,
  ];
}

LogEntryTable tLogEntry = LogEntryTable();
