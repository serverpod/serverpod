/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: unnecessary_import
// ignore_for_file: overridden_fields

import 'package:serverpod/serverpod.dart';
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
  late String serverId;
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

  @override
  void setColumn(String columnName, value) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'serverId':
        serverId = value;
        return;
      case 'sessionLogId':
        sessionLogId = value;
        return;
      case 'query':
        query = value;
        return;
      case 'duration':
        duration = value;
        return;
      case 'numRows':
        numRows = value;
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

  static Future<List<QueryLogEntry>> find(
    Session session, {
    QueryLogEntryExpressionBuilder? where,
    int? limit,
    int? offset,
    Column? orderBy,
    List<Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.find<QueryLogEntry>(
      where: where != null ? where(QueryLogEntry.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<QueryLogEntry?> findSingleRow(
    Session session, {
    QueryLogEntryExpressionBuilder? where,
    int? offset,
    Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.findSingleRow<QueryLogEntry>(
      where: where != null ? where(QueryLogEntry.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static Future<QueryLogEntry?> findById(Session session, int id) async {
    return session.db.findById<QueryLogEntry>(id);
  }

  static Future<int> delete(
    Session session, {
    required QueryLogEntryExpressionBuilder where,
    Transaction? transaction,
  }) async {
    return session.db.delete<QueryLogEntry>(
      where: where(QueryLogEntry.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    Session session,
    QueryLogEntry row, {
    Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    Session session,
    QueryLogEntry row, {
    Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    Session session,
    QueryLogEntry row, {
    Transaction? transaction,
  }) async {
    return session.db.insert(row, transaction: transaction);
  }

  static Future<int> count(
    Session session, {
    QueryLogEntryExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    Transaction? transaction,
  }) async {
    return session.db.count<QueryLogEntry>(
      where: where != null ? where(QueryLogEntry.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef QueryLogEntryExpressionBuilder = Expression Function(
    QueryLogEntryTable t);

class QueryLogEntryTable extends Table {
  QueryLogEntryTable() : super(tableName: 'serverpod_query_log');

  @override
  String tableName = 'serverpod_query_log';
  final id = ColumnInt('id');
  final serverId = ColumnString('serverId');
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
