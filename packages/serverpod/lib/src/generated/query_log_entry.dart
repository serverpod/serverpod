/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// A log entry for a database query.
abstract class QueryLogEntry extends _i1.TableRow {
  QueryLogEntry._({
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

  factory QueryLogEntry({
    int? id,
    required String serverId,
    required int sessionLogId,
    int? messageId,
    required String query,
    required double duration,
    int? numRows,
    String? error,
    String? stackTrace,
    required bool slow,
    required int order,
  }) = _QueryLogEntryImpl;

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

  static final db = QueryLogEntryRepository._();

  /// The id of the server that handled the query.
  String serverId;

  /// Id of the session this entry is associated with.
  int sessionLogId;

  /// The id of the message this entry is associated with, if the query was
  /// executed in a streaming session.
  int? messageId;

  /// The query that was executed.
  String query;

  /// The time it took to execute the query, in seconds.
  double duration;

  /// Number of rows returned by this query. This can be null if the number is
  /// not relevant.
  int? numRows;

  /// Set if an exception was thrown during the execution of this query.
  String? error;

  /// The stack trace of this query.
  String? stackTrace;

  /// True if the execution of this query was considered slow.
  bool slow;

  /// used for sorting the query log.
  int order;

  @override
  String get tableName => 'serverpod_query_log';
  QueryLogEntry copyWith({
    int? id,
    String? serverId,
    int? sessionLogId,
    int? messageId,
    String? query,
    double? duration,
    int? numRows,
    String? error,
    String? stackTrace,
    bool? slow,
    int? order,
  });
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

  static QueryLogEntryInclude include() {
    return QueryLogEntryInclude._();
  }
}

class _Undefined {}

class _QueryLogEntryImpl extends QueryLogEntry {
  _QueryLogEntryImpl({
    int? id,
    required String serverId,
    required int sessionLogId,
    int? messageId,
    required String query,
    required double duration,
    int? numRows,
    String? error,
    String? stackTrace,
    required bool slow,
    required int order,
  }) : super._(
          id: id,
          serverId: serverId,
          sessionLogId: sessionLogId,
          messageId: messageId,
          query: query,
          duration: duration,
          numRows: numRows,
          error: error,
          stackTrace: stackTrace,
          slow: slow,
          order: order,
        );

  @override
  QueryLogEntry copyWith({
    Object? id = _Undefined,
    String? serverId,
    int? sessionLogId,
    Object? messageId = _Undefined,
    String? query,
    double? duration,
    Object? numRows = _Undefined,
    Object? error = _Undefined,
    Object? stackTrace = _Undefined,
    bool? slow,
    int? order,
  }) {
    return QueryLogEntry(
      id: id is int? ? id : this.id,
      serverId: serverId ?? this.serverId,
      sessionLogId: sessionLogId ?? this.sessionLogId,
      messageId: messageId is int? ? messageId : this.messageId,
      query: query ?? this.query,
      duration: duration ?? this.duration,
      numRows: numRows is int? ? numRows : this.numRows,
      error: error is String? ? error : this.error,
      stackTrace: stackTrace is String? ? stackTrace : this.stackTrace,
      slow: slow ?? this.slow,
      order: order ?? this.order,
    );
  }
}

typedef QueryLogEntryExpressionBuilder = _i1.Expression Function(
    QueryLogEntryTable);

class QueryLogEntryTable extends _i1.Table {
  QueryLogEntryTable({
    super.queryPrefix,
    super.tableRelations,
  }) : super(tableName: 'serverpod_query_log') {
    serverId = _i1.ColumnString(
      'serverId',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    sessionLogId = _i1.ColumnInt(
      'sessionLogId',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    messageId = _i1.ColumnInt(
      'messageId',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    query = _i1.ColumnString(
      'query',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    duration = _i1.ColumnDouble(
      'duration',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    numRows = _i1.ColumnInt(
      'numRows',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    error = _i1.ColumnString(
      'error',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    stackTrace = _i1.ColumnString(
      'stackTrace',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    slow = _i1.ColumnBool(
      'slow',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    order = _i1.ColumnInt(
      'order',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
  }

  /// The id of the server that handled the query.
  late final _i1.ColumnString serverId;

  /// Id of the session this entry is associated with.
  late final _i1.ColumnInt sessionLogId;

  /// The id of the message this entry is associated with, if the query was
  /// executed in a streaming session.
  late final _i1.ColumnInt messageId;

  /// The query that was executed.
  late final _i1.ColumnString query;

  /// The time it took to execute the query, in seconds.
  late final _i1.ColumnDouble duration;

  /// Number of rows returned by this query. This can be null if the number is
  /// not relevant.
  late final _i1.ColumnInt numRows;

  /// Set if an exception was thrown during the execution of this query.
  late final _i1.ColumnString error;

  /// The stack trace of this query.
  late final _i1.ColumnString stackTrace;

  /// True if the execution of this query was considered slow.
  late final _i1.ColumnBool slow;

  /// used for sorting the query log.
  late final _i1.ColumnInt order;

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

class QueryLogEntryInclude extends _i1.Include {
  QueryLogEntryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};
  @override
  _i1.Table get table => QueryLogEntry.t;
}

class QueryLogEntryRepository {
  QueryLogEntryRepository._();
}
