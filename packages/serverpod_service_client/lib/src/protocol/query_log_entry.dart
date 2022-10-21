/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

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
      id: serializationManager.deserializeJson<int?>(jsonSerialization['id']),
      serverId: serializationManager
          .deserializeJson<String>(jsonSerialization['serverId']),
      sessionLogId: serializationManager
          .deserializeJson<int>(jsonSerialization['sessionLogId']),
      messageId: serializationManager
          .deserializeJson<int?>(jsonSerialization['messageId']),
      query: serializationManager
          .deserializeJson<String>(jsonSerialization['query']),
      duration: serializationManager
          .deserializeJson<double>(jsonSerialization['duration']),
      numRows: serializationManager
          .deserializeJson<int?>(jsonSerialization['numRows']),
      error: serializationManager
          .deserializeJson<String?>(jsonSerialization['error']),
      stackTrace: serializationManager
          .deserializeJson<String?>(jsonSerialization['stackTrace']),
      slow:
          serializationManager.deserializeJson<bool>(jsonSerialization['slow']),
      order:
          serializationManager.deserializeJson<int>(jsonSerialization['order']),
    );
  }

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
  String get className => 'QueryLogEntry';
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
