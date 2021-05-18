/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs

import 'package:serverpod/database.dart';
// ignore: unused_import
import 'protocol.dart';

class SessionLogEntry extends TableRow {
  @override
  String get className => 'SessionLogEntry';
  @override
  String get tableName => 'serverpod_session_log';

  @override
  int? id;
  late int serverId;
  late DateTime time;
  String? endpoint;
  String? method;
  String? futureCall;
  late double duration;
  late int numQueries;
  late bool slow;
  String? error;
  String? stackTrace;
  int? authenticatedUserId;

  SessionLogEntry({
    this.id,
    required this.serverId,
    required this.time,
    this.endpoint,
    this.method,
    this.futureCall,
    required this.duration,
    required this.numQueries,
    required this.slow,
    this.error,
    this.stackTrace,
    this.authenticatedUserId,
});

  SessionLogEntry.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    serverId = _data['serverId']!;
    time = DateTime.tryParse(_data['time'])!;
    endpoint = _data['endpoint'];
    method = _data['method'];
    futureCall = _data['futureCall'];
    duration = _data['duration']!;
    numQueries = _data['numQueries']!;
    slow = _data['slow']!;
    error = _data['error'];
    stackTrace = _data['stackTrace'];
    authenticatedUserId = _data['authenticatedUserId'];
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'serverId': serverId,
      'time': time.toUtc().toIso8601String(),
      'endpoint': endpoint,
      'method': method,
      'futureCall': futureCall,
      'duration': duration,
      'numQueries': numQueries,
      'slow': slow,
      'error': error,
      'stackTrace': stackTrace,
      'authenticatedUserId': authenticatedUserId,
    });
  }

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'serverId': serverId,
      'time': time.toUtc().toIso8601String(),
      'endpoint': endpoint,
      'method': method,
      'futureCall': futureCall,
      'duration': duration,
      'numQueries': numQueries,
      'slow': slow,
      'error': error,
      'stackTrace': stackTrace,
      'authenticatedUserId': authenticatedUserId,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'serverId': serverId,
      'time': time.toUtc().toIso8601String(),
      'endpoint': endpoint,
      'method': method,
      'futureCall': futureCall,
      'duration': duration,
      'numQueries': numQueries,
      'slow': slow,
      'error': error,
      'stackTrace': stackTrace,
      'authenticatedUserId': authenticatedUserId,
    });
  }
}

class SessionLogEntryTable extends Table {
  SessionLogEntryTable() : super(tableName: 'serverpod_session_log');

  @override
  String tableName = 'serverpod_session_log';
  final id = ColumnInt('id');
  final serverId = ColumnInt('serverId');
  final time = ColumnDateTime('time');
  final endpoint = ColumnString('endpoint');
  final method = ColumnString('method');
  final futureCall = ColumnString('futureCall');
  final duration = ColumnDouble('duration');
  final numQueries = ColumnInt('numQueries');
  final slow = ColumnBool('slow');
  final error = ColumnString('error');
  final stackTrace = ColumnString('stackTrace');
  final authenticatedUserId = ColumnInt('authenticatedUserId');

  @override
  List<Column> get columns => [
    id,
    serverId,
    time,
    endpoint,
    method,
    futureCall,
    duration,
    numQueries,
    slow,
    error,
    stackTrace,
    authenticatedUserId,
  ];
}

SessionLogEntryTable tSessionLogEntry = SessionLogEntryTable();
