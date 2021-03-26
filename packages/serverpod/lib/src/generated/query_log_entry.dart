/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names

import 'package:serverpod/database.dart';
// ignore: unused_import
import 'protocol.dart';

class QueryLogEntry extends TableRow {
  String get className => 'QueryLogEntry';
  String get tableName => 'serverpod_query_log';

  int? id;
  int? sessionLogId;
  String? query;
  double? duration;
  int? numRows;

  QueryLogEntry({
    this.id,
    this.sessionLogId,
    this.query,
    this.duration,
    this.numRows,
});

  QueryLogEntry.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    sessionLogId = _data['sessionLogId'];
    query = _data['query'];
    duration = _data['duration'];
    numRows = _data['numRows'];
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'sessionLogId': sessionLogId,
      'query': query,
      'duration': duration,
      'numRows': numRows,
    });
  }
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'sessionLogId': sessionLogId,
      'query': query,
      'duration': duration,
      'numRows': numRows,
    });
  }

  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'sessionLogId': sessionLogId,
      'query': query,
      'duration': duration,
      'numRows': numRows,
    });
  }
}

class QueryLogEntryTable extends Table {
  QueryLogEntryTable() : super(tableName: 'serverpod_query_log');

  String tableName = 'serverpod_query_log';
  final id = ColumnInt('id');
  final sessionLogId = ColumnInt('sessionLogId');
  final query = ColumnString('query');
  final duration = ColumnDouble('duration');
  final numRows = ColumnInt('numRows');

  List<Column> get columns => [
    id,
    sessionLogId,
    query,
    duration,
    numRows,
  ];
}

QueryLogEntryTable tQueryLogEntry = QueryLogEntryTable();
