/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

import 'package:serverpod/database.dart';
// ignore: unused_import
import 'protocol.dart';

class QueryLogEntry extends TableRow {
  String get className => 'QueryLogEntry';
  String get tableName => 'serverpod_query_log';

  int id;
  int numRows;
  String query;
  double duration;
  int callLogId;

  QueryLogEntry({
    this.id,
    this.numRows,
    this.query,
    this.duration,
    this.callLogId,
});

  QueryLogEntry.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    numRows = _data['numRows'];
    query = _data['query'];
    duration = _data['duration'];
    callLogId = _data['callLogId'];
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'numRows': numRows,
      'query': query,
      'duration': duration,
      'callLogId': callLogId,
    });
  }
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'numRows': numRows,
      'query': query,
      'duration': duration,
      'callLogId': callLogId,
    });
  }

  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'numRows': numRows,
      'query': query,
      'duration': duration,
      'callLogId': callLogId,
    });
  }
}

class QueryLogEntryTable extends Table {
  QueryLogEntryTable() : super(tableName: 'serverpod_query_log');

  String tableName = 'serverpod_query_log';
  final id = ColumnInt('id');
  final numRows = ColumnInt('numRows');
  final query = ColumnString('query');
  final duration = ColumnDouble('duration');
  final callLogId = ColumnInt('callLogId');

  List<Column> get columns => [
    id,
    numRows,
    query,
    duration,
    callLogId,
  ];
}

QueryLogEntryTable tQueryLogEntry = QueryLogEntryTable();
