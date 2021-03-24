/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names

import 'package:serverpod/database.dart';
// ignore: unused_import
import 'protocol.dart';

class SessionLogEntry extends TableRow {
  String get className => 'SessionLogEntry';
  String get tableName => 'serverpod_session_log';

  int id;
  int serverId;
  DateTime time;
  String endpoint;
  String method;
  double duration;
  int numQueries;
  bool slow;
  String error;
  String stackTrace;
  String authenticatedUser;

  SessionLogEntry({
    this.id,
    this.serverId,
    this.time,
    this.endpoint,
    this.method,
    this.duration,
    this.numQueries,
    this.slow,
    this.error,
    this.stackTrace,
    this.authenticatedUser,
});

  SessionLogEntry.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    serverId = _data['serverId'];
    time = _data['time'] != null ? DateTime.tryParse(_data['time']) : null;
    endpoint = _data['endpoint'];
    method = _data['method'];
    duration = _data['duration'];
    numQueries = _data['numQueries'];
    slow = _data['slow'];
    error = _data['error'];
    stackTrace = _data['stackTrace'];
    authenticatedUser = _data['authenticatedUser'];
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'serverId': serverId,
      'time': time?.toUtc()?.toIso8601String(),
      'endpoint': endpoint,
      'method': method,
      'duration': duration,
      'numQueries': numQueries,
      'slow': slow,
      'error': error,
      'stackTrace': stackTrace,
      'authenticatedUser': authenticatedUser,
    });
  }
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'serverId': serverId,
      'time': time?.toUtc()?.toIso8601String(),
      'endpoint': endpoint,
      'method': method,
      'duration': duration,
      'numQueries': numQueries,
      'slow': slow,
      'error': error,
      'stackTrace': stackTrace,
      'authenticatedUser': authenticatedUser,
    });
  }

  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'serverId': serverId,
      'time': time?.toUtc()?.toIso8601String(),
      'endpoint': endpoint,
      'method': method,
      'duration': duration,
      'numQueries': numQueries,
      'slow': slow,
      'error': error,
      'stackTrace': stackTrace,
      'authenticatedUser': authenticatedUser,
    });
  }
}

class SessionLogEntryTable extends Table {
  SessionLogEntryTable() : super(tableName: 'serverpod_session_log');

  String tableName = 'serverpod_session_log';
  final id = ColumnInt('id');
  final serverId = ColumnInt('serverId');
  final time = ColumnDateTime('time');
  final endpoint = ColumnString('endpoint');
  final method = ColumnString('method');
  final duration = ColumnDouble('duration');
  final numQueries = ColumnInt('numQueries');
  final slow = ColumnBool('slow');
  final error = ColumnString('error');
  final stackTrace = ColumnString('stackTrace');
  final authenticatedUser = ColumnString('authenticatedUser');

  List<Column> get columns => [
    id,
    serverId,
    time,
    endpoint,
    method,
    duration,
    numQueries,
    slow,
    error,
    stackTrace,
    authenticatedUser,
  ];
}

SessionLogEntryTable tSessionLogEntry = SessionLogEntryTable();
