/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// A log entry for a database query.
abstract class QueryLogEntry implements _i1.SerializableModel {
  QueryLogEntry._({
    this.id,
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
  });

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

  factory QueryLogEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return QueryLogEntry(
      id: jsonSerialization['id'] as int?,
      serverId: jsonSerialization['serverId'] as String,
      sessionLogId: jsonSerialization['sessionLogId'] as int,
      messageId: jsonSerialization['messageId'] as int?,
      query: jsonSerialization['query'] as String,
      duration: (jsonSerialization['duration'] as num).toDouble(),
      numRows: jsonSerialization['numRows'] as int?,
      error: jsonSerialization['error'] as String?,
      stackTrace: jsonSerialization['stackTrace'] as String?,
      slow: jsonSerialization['slow'] as bool,
      order: jsonSerialization['order'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

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
      if (id != null) 'id': id,
      'serverId': serverId,
      'sessionLogId': sessionLogId,
      if (messageId != null) 'messageId': messageId,
      'query': query,
      'duration': duration,
      if (numRows != null) 'numRows': numRows,
      if (error != null) 'error': error,
      if (stackTrace != null) 'stackTrace': stackTrace,
      'slow': slow,
      'order': order,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
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
