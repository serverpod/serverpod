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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final int? id;

  /// The id of the session this log entry is associated with.
  final int sessionLogId;

  /// The message id this entry is associated with, if in a streaming session.
  final int? messageId;

  /// Currently unused.
  final String? reference;

  /// The id of the server which created this log entry.
  final String serverId;

  /// Timpstamp of this log entry.
  final DateTime time;

  /// The log level of this entry.
  final _i2.LogLevel logLevel;

  /// The logging message.
  final String message;

  /// Optional error associated with this log entry.
  final String? error;

  /// Optional stack trace associated with this log entry.
  final String? stackTrace;

  /// The order of this log entry, used for sorting.
  final int order;

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

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is LogEntry &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
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
                  other.reference,
                  reference,
                ) ||
                other.reference == reference) &&
            (identical(
                  other.serverId,
                  serverId,
                ) ||
                other.serverId == serverId) &&
            (identical(
                  other.time,
                  time,
                ) ||
                other.time == time) &&
            (identical(
                  other.logLevel,
                  logLevel,
                ) ||
                other.logLevel == logLevel) &&
            (identical(
                  other.message,
                  message,
                ) ||
                other.message == message) &&
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
                  other.order,
                  order,
                ) ||
                other.order == order));
  }

  @override
  int get hashCode => Object.hash(
        id,
        sessionLogId,
        messageId,
        reference,
        serverId,
        time,
        logLevel,
        message,
        error,
        stackTrace,
        order,
      );

  LogEntry copyWith({
    int? id,
    int? sessionLogId,
    int? messageId,
    String? reference,
    String? serverId,
    DateTime? time,
    _i2.LogLevel? logLevel,
    String? message,
    String? error,
    String? stackTrace,
    int? order,
  }) {
    return LogEntry(
      id: id ?? this.id,
      sessionLogId: sessionLogId ?? this.sessionLogId,
      messageId: messageId ?? this.messageId,
      reference: reference ?? this.reference,
      serverId: serverId ?? this.serverId,
      time: time ?? this.time,
      logLevel: logLevel ?? this.logLevel,
      message: message ?? this.message,
      error: error ?? this.error,
      stackTrace: stackTrace ?? this.stackTrace,
      order: order ?? this.order,
    );
  }
}
