/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names

import 'package:serverpod/database.dart';
// ignore: unused_import
import 'protocol.dart';

class QueryLogEntry extends TableRow {
  @override
  String get className => 'QueryLogEntry';
  @override
  String get tableName => 'serverpod_query_log';

  int? id;
  int? serverId;
  int? sessionLogId;
  late String query;
  late double duration;
  int? numRows;
  String? exception;
  String? stackTrace;

  QueryLogEntry({
    this.id,
    this.serverId,
    this.sessionLogId,
    required this.query,
    required this.duration,
    this.numRows,
    this.exception,
    this.stackTrace,
});

  QueryLogEntry.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    serverId = _data['serverId'];
    sessionLogId = _data['sessionLogId'];
    query = _data['query']!;
    duration = _data['duration']!;
    numRows = _data['numRows'];
    exception = _data['exception'];
    stackTrace = _data['stackTrace'];
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'serverId': serverId,
      'sessionLogId': sessionLogId,
      'query': query,
      'duration': duration,
      'numRows': numRows,
      'exception': exception,
      'stackTrace': stackTrace,
    });
  }

  @override
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'serverId': serverId,
      'sessionLogId': sessionLogId,
      'query': query,
      'duration': duration,
      'numRows': numRows,
      'exception': exception,
      'stackTrace': stackTrace,
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'serverId': serverId,
      'sessionLogId': sessionLogId,
      'query': query,
      'duration': duration,
      'numRows': numRows,
      'exception': exception,
      'stackTrace': stackTrace,
    });
  }
}

class QueryLogEntryTable extends Table {
  QueryLogEntryTable() : super(tableName: 'serverpod_query_log');

  String tableName = 'serverpod_query_log';
  final id = ColumnInt('id');
  final serverId = ColumnInt('serverId');
  final sessionLogId = ColumnInt('sessionLogId');
  final query = ColumnString('query');
  final duration = ColumnDouble('duration');
  final numRows = ColumnInt('numRows');
  final exception = ColumnString('exception');
  final stackTrace = ColumnString('stackTrace');

  List<Column> get columns => [
    id,
    serverId,
    sessionLogId,
    query,
    duration,
    numRows,
    exception,
    stackTrace,
  ];
}

QueryLogEntryTable tQueryLogEntry = QueryLogEntryTable();
