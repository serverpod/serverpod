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

class QueryLogEntry extends TableRow {
  @override
  String get className => 'QueryLogEntry';
  @override
  String get tableName => 'serverpod_query_log';

  static final t = QueryLogEntryTable();

  @override
  int? id;
  late int serverId;
  late int sessionLogId;
  late String query;
  late double duration;
  int? numRows;
  String? error;
  String? stackTrace;

  QueryLogEntry({
    this.id,
    required this.serverId,
    required this.sessionLogId,
    required this.query,
    required this.duration,
    this.numRows,
    this.error,
    this.stackTrace,
  });

  QueryLogEntry.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    serverId = _data['serverId']!;
    sessionLogId = _data['sessionLogId']!;
    query = _data['query']!;
    duration = _data['duration']!;
    numRows = _data['numRows'];
    error = _data['error'];
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
      'error': error,
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
      'error': error,
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
      'error': error,
      'stackTrace': stackTrace,
    });
  }
}

class QueryLogEntryTable extends Table {
  QueryLogEntryTable() : super(tableName: 'serverpod_query_log');

  @override
  String tableName = 'serverpod_query_log';
  final id = ColumnInt('id');
  final serverId = ColumnInt('serverId');
  final sessionLogId = ColumnInt('sessionLogId');
  final query = ColumnString('query');
  final duration = ColumnDouble('duration');
  final numRows = ColumnInt('numRows');
  final error = ColumnString('error');
  final stackTrace = ColumnString('stackTrace');

  @override
  List<Column> get columns => [
        id,
        serverId,
        sessionLogId,
        query,
        duration,
        numRows,
        error,
        stackTrace,
      ];
}

@Deprecated('Use QueryLogEntryTable.t instead.')
QueryLogEntryTable tQueryLogEntry = QueryLogEntryTable();
