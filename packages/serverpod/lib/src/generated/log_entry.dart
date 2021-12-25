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

class LogEntry extends TableRow {
  @override
  String get className => 'LogEntry';
  @override
  String get tableName => 'serverpod_log';

  static final t = LogEntryTable();

  @override
  int? id;
  late int sessionLogId;
  String? reference;
  late int serverId;
  late DateTime time;
  late int logLevel;
  late String message;
  String? error;
  String? stackTrace;

  LogEntry({
    this.id,
    required this.sessionLogId,
    this.reference,
    required this.serverId,
    required this.time,
    required this.logLevel,
    required this.message,
    this.error,
    this.stackTrace,
  });

  LogEntry.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    sessionLogId = _data['sessionLogId']!;
    reference = _data['reference'];
    serverId = _data['serverId']!;
    time = DateTime.tryParse(_data['time'])!;
    logLevel = _data['logLevel']!;
    message = _data['message']!;
    error = _data['error'];
    stackTrace = _data['stackTrace'];
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'sessionLogId': sessionLogId,
      'reference': reference,
      'serverId': serverId,
      'time': time.toUtc().toIso8601String(),
      'logLevel': logLevel,
      'message': message,
      'error': error,
      'stackTrace': stackTrace,
    });
  }

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'sessionLogId': sessionLogId,
      'reference': reference,
      'serverId': serverId,
      'time': time.toUtc().toIso8601String(),
      'logLevel': logLevel,
      'message': message,
      'error': error,
      'stackTrace': stackTrace,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'sessionLogId': sessionLogId,
      'reference': reference,
      'serverId': serverId,
      'time': time.toUtc().toIso8601String(),
      'logLevel': logLevel,
      'message': message,
      'error': error,
      'stackTrace': stackTrace,
    });
  }

  @override
  void setColumn(String columnName, value) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'sessionLogId':
        sessionLogId = value;
        return;
      case 'reference':
        reference = value;
        return;
      case 'serverId':
        serverId = value;
        return;
      case 'time':
        time = value;
        return;
      case 'logLevel':
        logLevel = value;
        return;
      case 'message':
        message = value;
        return;
      case 'error':
        error = value;
        return;
      case 'stackTrace':
        stackTrace = value;
        return;
      default:
        throw UnimplementedError();
    }
  }
}

class LogEntryTable extends Table {
  LogEntryTable() : super(tableName: 'serverpod_log');

  @override
  String tableName = 'serverpod_log';
  final id = ColumnInt('id');
  final sessionLogId = ColumnInt('sessionLogId');
  final reference = ColumnString('reference');
  final serverId = ColumnInt('serverId');
  final time = ColumnDateTime('time');
  final logLevel = ColumnInt('logLevel');
  final message = ColumnString('message');
  final error = ColumnString('error');
  final stackTrace = ColumnString('stackTrace');

  @override
  List<Column> get columns => [
        id,
        sessionLogId,
        reference,
        serverId,
        time,
        logLevel,
        message,
        error,
        stackTrace,
      ];
}

@Deprecated('Use LogEntryTable.t instead.')
LogEntryTable tLogEntry = LogEntryTable();
