/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'protocol.dart' as _i2;

/// Bindings to a log entry in the database.
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
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      sessionLogId: serializationManager
          .deserialize<int>(jsonSerialization['sessionLogId']),
      messageId: serializationManager
          .deserialize<int?>(jsonSerialization['messageId']),
      reference: serializationManager
          .deserialize<String?>(jsonSerialization['reference']),
      serverId: serializationManager
          .deserialize<String>(jsonSerialization['serverId']),
      time:
          serializationManager.deserialize<DateTime>(jsonSerialization['time']),
      logLevel: serializationManager
          .deserialize<_i2.LogLevel>(jsonSerialization['logLevel']),
      message: serializationManager
          .deserialize<String>(jsonSerialization['message']),
      error:
          serializationManager.deserialize<String?>(jsonSerialization['error']),
      stackTrace: serializationManager
          .deserialize<String?>(jsonSerialization['stackTrace']),
      order: serializationManager.deserialize<int>(jsonSerialization['order']),
    );
  }

  int? id;

  /// The id of the session this log entry is associated with.
  int sessionLogId;

  /// The message id this entry is associated with, if in a streaming session.
  int? messageId;

  /// Currently unused.
  String? reference;

  /// The id of the server which created this log entry.
  String serverId;

  /// Timpstamp of this log entry.
  DateTime time;

  /// The log level of this entry.
  _i2.LogLevel logLevel;

  /// The logging message.
  String message;

  /// Optional error associated with this log entry.
  String? error;

  /// Optional stack trace associated with this log entry.
  String? stackTrace;

  /// The order of this log entry, used for sorting.
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
