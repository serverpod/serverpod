/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

typedef QueryLogEntryExpressionBuilder = _i1.Expression Function(
    QueryLogEntryTable);

/// A log entry for a database query.
abstract class QueryLogEntry extends _i1.TableRow {
  const QueryLogEntry._();

  const factory QueryLogEntry({
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
  }) = _QueryLogEntry;

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

  static const t = QueryLogEntryTable();

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
  String get tableName => 'serverpod_query_log';
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

  /// Inserts a row into the database.
  /// Returns updated row with the id set.
  static Future<QueryLogEntry> insert(
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

  /// The id of the server that handled the query.
  String get serverId;

  /// Id of the session this entry is associated with.
  int get sessionLogId;

  /// The id of the message this entry is associcated with, if the query was
  /// executed in a streaming session.
  int? get messageId;

  /// The query that was executed.
  String get query;

  /// The time it took to execute the query, in seconds.
  double get duration;

  /// Number of rows returned by this query. This can be null if the number is
  /// not relevant.
  int? get numRows;

  /// Set if an exception was thrown during the execution of this query.
  String? get error;

  /// The stack trace of this query.
  String? get stackTrace;

  /// True if the execution of this query was considered slow.
  bool get slow;

  /// used for sorting the query log.
  int get order;
}

class _Undefined {}

/// A log entry for a database query.
class _QueryLogEntry extends QueryLogEntry {
  const _QueryLogEntry({
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
  }) : super._();

  /// The id of the server that handled the query.
  @override
  final String serverId;

  /// Id of the session this entry is associated with.
  @override
  final int sessionLogId;

  /// The id of the message this entry is associcated with, if the query was
  /// executed in a streaming session.
  @override
  final int? messageId;

  /// The query that was executed.
  @override
  final String query;

  /// The time it took to execute the query, in seconds.
  @override
  final double duration;

  /// Number of rows returned by this query. This can be null if the number is
  /// not relevant.
  @override
  final int? numRows;

  /// Set if an exception was thrown during the execution of this query.
  @override
  final String? error;

  /// The stack trace of this query.
  @override
  final String? stackTrace;

  /// True if the execution of this query was considered slow.
  @override
  final bool slow;

  /// used for sorting the query log.
  @override
  final int order;

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
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is QueryLogEntry &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.serverId,
                  serverId,
                ) ||
                other.serverId == serverId) &&
            (identical(
                  other.sessionLogId,
                  sessionLogId,
                ) ||
                other.sessionLogId == sessionLogId) &&
            (identical(
                  other.messageId,
                  messageId,
                ) ||
                other.messageId == messageId) &&
            (identical(
                  other.query,
                  query,
                ) ||
                other.query == query) &&
            (identical(
                  other.duration,
                  duration,
                ) ||
                other.duration == duration) &&
            (identical(
                  other.numRows,
                  numRows,
                ) ||
                other.numRows == numRows) &&
            (identical(
                  other.error,
                  error,
                ) ||
                other.error == error) &&
            (identical(
                  other.stackTrace,
                  stackTrace,
                ) ||
                other.stackTrace == stackTrace) &&
            (identical(
                  other.slow,
                  slow,
                ) ||
                other.slow == slow) &&
            (identical(
                  other.order,
                  order,
                ) ||
                other.order == order));
  }

  @override
  int get hashCode => Object.hash(
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
      id: id == _Undefined ? this.id : (id as int?),
      serverId: serverId ?? this.serverId,
      sessionLogId: sessionLogId ?? this.sessionLogId,
      messageId: messageId == _Undefined ? this.messageId : (messageId as int?),
      query: query ?? this.query,
      duration: duration ?? this.duration,
      numRows: numRows == _Undefined ? this.numRows : (numRows as int?),
      error: error == _Undefined ? this.error : (error as String?),
      stackTrace:
          stackTrace == _Undefined ? this.stackTrace : (stackTrace as String?),
      slow: slow ?? this.slow,
      order: order ?? this.order,
    );
  }
}

class QueryLogEntryTable extends _i1.Table {
  const QueryLogEntryTable() : super(tableName: 'serverpod_query_log');

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final id = const _i1.ColumnInt('id');

  /// The id of the server that handled the query.
  final serverId = const _i1.ColumnString('serverId');

  /// Id of the session this entry is associated with.
  final sessionLogId = const _i1.ColumnInt('sessionLogId');

  /// The id of the message this entry is associcated with, if the query was
  /// executed in a streaming session.
  final messageId = const _i1.ColumnInt('messageId');

  /// The query that was executed.
  final query = const _i1.ColumnString('query');

  /// The time it took to execute the query, in seconds.
  final duration = const _i1.ColumnDouble('duration');

  /// Number of rows returned by this query. This can be null if the number is
  /// not relevant.
  final numRows = const _i1.ColumnInt('numRows');

  /// Set if an exception was thrown during the execution of this query.
  final error = const _i1.ColumnString('error');

  /// The stack trace of this query.
  final stackTrace = const _i1.ColumnString('stackTrace');

  /// True if the execution of this query was considered slow.
  final slow = const _i1.ColumnBool('slow');

  /// used for sorting the query log.
  final order = const _i1.ColumnInt('order');

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
QueryLogEntryTable tQueryLogEntry = const QueryLogEntryTable();
