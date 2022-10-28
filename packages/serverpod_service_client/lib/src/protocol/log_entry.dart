/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'protocol.dart' as _i2;

class LogEntry extends _i1.SerializableEntity {
  LogEntry({
    this.id,
    required this.sessionLogId,
    this.messageId,
    this.reference,
    required this.serverId,
    required this.time,
    required this.logLevel,
    required this.message,
    this.error,
    this.stackTrace,
    required this.order,
  });

  factory LogEntry.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return LogEntry(
      id: serializationManager.deserializeJson<int?>(jsonSerialization['id']),
      sessionLogId: serializationManager
          .deserializeJson<int>(jsonSerialization['sessionLogId']),
      messageId: serializationManager
          .deserializeJson<int?>(jsonSerialization['messageId']),
      reference: serializationManager
          .deserializeJson<String?>(jsonSerialization['reference']),
      serverId: serializationManager
          .deserializeJson<String>(jsonSerialization['serverId']),
      time: serializationManager
          .deserializeJson<DateTime>(jsonSerialization['time']),
      logLevel: serializationManager
          .deserializeJson<_i2.LogLevel>(jsonSerialization['logLevel']),
      message: serializationManager
          .deserializeJson<String>(jsonSerialization['message']),
      error: serializationManager
          .deserializeJson<String?>(jsonSerialization['error']),
      stackTrace: serializationManager
          .deserializeJson<String?>(jsonSerialization['stackTrace']),
      order:
          serializationManager.deserializeJson<int>(jsonSerialization['order']),
    );
  }

  int? id;

  int sessionLogId;

  int? messageId;

  String? reference;

  String serverId;

  DateTime time;

  _i2.LogLevel logLevel;

  String message;

  String? error;

  String? stackTrace;

  int order;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sessionLogId': sessionLogId,
      'messageId': messageId,
      'reference': reference,
      'serverId': serverId,
      'time': time,
      'logLevel': logLevel,
      'message': message,
      'error': error,
      'stackTrace': stackTrace,
      'order': order,
    };
  }
}
