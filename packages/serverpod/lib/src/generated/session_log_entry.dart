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
  int numQueries;
  DateTime time;
  String authenticatedUser;
  double duration;
  int serverId;
  String error;
  String stackTrace;
  String method;
  String endpoint;
  bool slow;

  SessionLogEntry({
    this.id,
    this.numQueries,
    this.time,
    this.authenticatedUser,
    this.duration,
    this.serverId,
    this.error,
    this.stackTrace,
    this.method,
    this.endpoint,
    this.slow,
});

  SessionLogEntry.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    numQueries = _data['numQueries'];
    time = _data['time'] != null ? DateTime.tryParse(_data['time']) : null;
    authenticatedUser = _data['authenticatedUser'];
    duration = _data['duration'];
    serverId = _data['serverId'];
    error = _data['error'];
    stackTrace = _data['stackTrace'];
    method = _data['method'];
    endpoint = _data['endpoint'];
    slow = _data['slow'];
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'numQueries': numQueries,
      'time': time?.toUtc()?.toIso8601String(),
      'authenticatedUser': authenticatedUser,
      'duration': duration,
      'serverId': serverId,
      'error': error,
      'stackTrace': stackTrace,
      'method': method,
      'endpoint': endpoint,
      'slow': slow,
    });
  }
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'numQueries': numQueries,
      'time': time?.toUtc()?.toIso8601String(),
      'authenticatedUser': authenticatedUser,
      'duration': duration,
      'serverId': serverId,
      'error': error,
      'stackTrace': stackTrace,
      'method': method,
      'endpoint': endpoint,
      'slow': slow,
    });
  }

  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'numQueries': numQueries,
      'time': time?.toUtc()?.toIso8601String(),
      'authenticatedUser': authenticatedUser,
      'duration': duration,
      'serverId': serverId,
      'error': error,
      'stackTrace': stackTrace,
      'method': method,
      'endpoint': endpoint,
      'slow': slow,
    });
  }
}

class SessionLogEntryTable extends Table {
  SessionLogEntryTable() : super(tableName: 'serverpod_session_log');

  String tableName = 'serverpod_session_log';
  final id = ColumnInt('id');
  final numQueries = ColumnInt('numQueries');
  final time = ColumnDateTime('time');
  final authenticatedUser = ColumnString('authenticatedUser');
  final duration = ColumnDouble('duration');
  final serverId = ColumnInt('serverId');
  final error = ColumnString('error');
  final stackTrace = ColumnString('stackTrace');
  final method = ColumnString('method');
  final endpoint = ColumnString('endpoint');
  final slow = ColumnBool('slow');

  List<Column> get columns => [
    id,
    numQueries,
    time,
    authenticatedUser,
    duration,
    serverId,
    error,
    stackTrace,
    method,
    endpoint,
    slow,
  ];
}

SessionLogEntryTable tSessionLogEntry = SessionLogEntryTable();
