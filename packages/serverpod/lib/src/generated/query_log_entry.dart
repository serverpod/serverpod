/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

class QueryLogEntry extends _i1.TableRow {
  QueryLogEntry({
    int? id,
    required this.serverId,
    required this.sessionLogId,
    this.messageId,
    required this.query,
    required this.duration,
    this.numRows,
    this.error,
    this.stackTrace,
    required this.slow,
    required this.order,
  }) : super(id);

  factory QueryLogEntry.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return QueryLogEntry(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      serverId: serializationManager
          .deserialize<String>(jsonSerialization['serverId']),
      sessionLogId: serializationManager
          .deserialize<int>(jsonSerialization['sessionLogId']),
      messageId: serializationManager
          .deserialize<int?>(jsonSerialization['messageId']),
      query:
          serializationManager.deserialize<String>(jsonSerialization['query']),
      duration: serializationManager
          .deserialize<double>(jsonSerialization['duration']),
      numRows:
          serializationManager.deserialize<int?>(jsonSerialization['numRows']),
      error:
          serializationManager.deserialize<String?>(jsonSerialization['error']),
      stackTrace: serializationManager
          .deserialize<String?>(jsonSerialization['stackTrace']),
      slow: serializationManager.deserialize<bool>(jsonSerialization['slow']),
      order: serializationManager.deserialize<int>(jsonSerialization['order']),
    );
  }

  static final t = QueryLogEntryTable();

  String serverId;

  int sessionLogId;

  int? messageId;

  String query;

  double duration;

  int? numRows;

  String? error;

  String? stackTrace;

  bool slow;

  int order;

  @override
  String get tableName => 'serverpod_query_log';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serverId': serverId,
      'sessionLogId': sessionLogId,
      'messageId': messageId,
      'query': query,
      'duration': duration,
      'numRows': numRows,
      'error': error,
      'stackTrace': stackTrace,
      'slow': slow,
      'order': order,
    };
  }

  @override
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'serverId': serverId,
      'sessionLogId': sessionLogId,
      'messageId': messageId,
      'query': query,
      'duration': duration,
      'numRows': numRows,
      'error': error,
      'stackTrace': stackTrace,
      'slow': slow,
      'order': order,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'serverId': serverId,
      'sessionLogId': sessionLogId,
      'messageId': messageId,
      'query': query,
      'duration': duration,
      'numRows': numRows,
      'error': error,
      'stackTrace': stackTrace,
      'slow': slow,
      'order': order,
    };
  }

  @override
  void setColumn(
    String columnName,
    value,
  ) {
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
      case 'messageId':
        messageId = value;
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
      case 'slow':
        slow = value;
        return;
      case 'order':
        order = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<QueryLogEntry>> find(
    _i1.Session session, {
    QueryLogEntryExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
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
    _i1.Session session, {
    QueryLogEntryExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
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

  static Future<QueryLogEntry?> findById(
    _i1.Session session,
    int id,
  ) async {
    return session.db.findById<QueryLogEntry>(id);
  }

  static Future<int> delete(
    _i1.Session session, {
    required QueryLogEntryExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<QueryLogEntry>(
      where: where(QueryLogEntry.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    QueryLogEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    QueryLogEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    QueryLogEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    QueryLogEntryExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<QueryLogEntry>(
      where: where != null ? where(QueryLogEntry.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }
}

typedef QueryLogEntryExpressionBuilder = _i1.Expression Function(
    QueryLogEntryTable);

class QueryLogEntryTable extends _i1.Table {
  QueryLogEntryTable() : super(tableName: 'serverpod_query_log');

  final id = _i1.ColumnInt('id');

  final serverId = _i1.ColumnString('serverId');

  final sessionLogId = _i1.ColumnInt('sessionLogId');

  final messageId = _i1.ColumnInt('messageId');

  final query = _i1.ColumnString('query');

  final duration = _i1.ColumnDouble('duration');

  final numRows = _i1.ColumnInt('numRows');

  final error = _i1.ColumnString('error');

  final stackTrace = _i1.ColumnString('stackTrace');

  final slow = _i1.ColumnBool('slow');

  final order = _i1.ColumnInt('order');

  @override
  List<_i1.Column> get columns => [
        id,
        serverId,
        sessionLogId,
        messageId,
        query,
        duration,
        numRows,
        error,
        stackTrace,
        slow,
        order,
      ];
}

@Deprecated('Use QueryLogEntryTable.t instead.')
QueryLogEntryTable tQueryLogEntry = QueryLogEntryTable();
