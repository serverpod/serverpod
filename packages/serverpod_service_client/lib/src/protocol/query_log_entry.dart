/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

class QueryLogEntry extends _i1.SerializableEntity {
  QueryLogEntry({
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

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
}
