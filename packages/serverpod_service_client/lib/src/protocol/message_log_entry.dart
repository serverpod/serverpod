/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_serialization/serverpod_serialization.dart' as _i1;

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
      id: serializationManager.deserializeJson<int?>(jsonSerialization['id']),
      sessionLogId: serializationManager
          .deserializeJson<int>(jsonSerialization['sessionLogId']),
      serverId: serializationManager
          .deserializeJson<String>(jsonSerialization['serverId']),
      messageId: serializationManager
          .deserializeJson<int>(jsonSerialization['messageId']),
      endpoint: serializationManager
          .deserializeJson<String>(jsonSerialization['endpoint']),
      messageName: serializationManager
          .deserializeJson<String>(jsonSerialization['messageName']),
      duration: serializationManager
          .deserializeJson<double>(jsonSerialization['duration']),
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
  String get className => 'MessageLogEntry';
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
