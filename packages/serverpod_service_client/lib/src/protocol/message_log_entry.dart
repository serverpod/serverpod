/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

class MessageLogEntry extends _i1.SerializableEntity {
  MessageLogEntry({
    this.id,
    required this.sessionLogId,
    required this.serverId,
    required this.messageId,
    required this.endpoint,
    required this.messageName,
    required this.duration,
    this.error,
    this.stackTrace,
    required this.slow,
    required this.order,
  });

  factory MessageLogEntry.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return MessageLogEntry(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      sessionLogId: serializationManager
          .deserialize<int>(jsonSerialization['sessionLogId']),
      serverId: serializationManager
          .deserialize<String>(jsonSerialization['serverId']),
      messageId:
          serializationManager.deserialize<int>(jsonSerialization['messageId']),
      endpoint: serializationManager
          .deserialize<String>(jsonSerialization['endpoint']),
      messageName: serializationManager
          .deserialize<String>(jsonSerialization['messageName']),
      duration: serializationManager
          .deserialize<double>(jsonSerialization['duration']),
      error:
          serializationManager.deserialize<String?>(jsonSerialization['error']),
      stackTrace: serializationManager
          .deserialize<String?>(jsonSerialization['stackTrace']),
      slow: serializationManager.deserialize<bool>(jsonSerialization['slow']),
      order: serializationManager.deserialize<int>(jsonSerialization['order']),
    );
  }

  int? id;

  int sessionLogId;

  String serverId;

  int messageId;

  String endpoint;

  String messageName;

  double duration;

  String? error;

  String? stackTrace;

  bool slow;

  int order;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sessionLogId': sessionLogId,
      'serverId': serverId,
      'messageId': messageId,
      'endpoint': endpoint,
      'messageName': messageName,
      'duration': duration,
      'error': error,
      'stackTrace': stackTrace,
      'slow': slow,
      'order': order,
    };
  }
}
