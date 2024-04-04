/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'protocol.dart' as _i2;

/// Bindings to a log entry in the database.
abstract class LogEntry extends _i1.SerializableEntity {
  LogEntry._({
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

  factory LogEntry({
    int? id,
    required int sessionLogId,
    int? messageId,
    String? reference,
    required String serverId,
    required DateTime time,
    required _i2.LogLevel logLevel,
    required String message,
    String? error,
    String? stackTrace,
    required int order,
  }) = _LogEntryImpl;

  factory LogEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return LogEntry(
      id: jsonSerialization['id'] as int?,
      sessionLogId: jsonSerialization['sessionLogId'] as int,
      messageId: jsonSerialization['messageId'] as int?,
      reference: jsonSerialization['reference'] as String?,
      serverId: jsonSerialization['serverId'] as String,
      time: DateTime.parse(jsonSerialization['time']),
      logLevel: _i2.LogLevel.fromJson((jsonSerialization['logLevel'] as int)),
      message: jsonSerialization['message'] as String,
      error: jsonSerialization['error'] as String?,
      stackTrace: jsonSerialization['stackTrace'] as String?,
      order: jsonSerialization['order'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
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
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'sessionLogId': sessionLogId,
      if (messageId != null) 'messageId': messageId,
      if (reference != null) 'reference': reference,
      'serverId': serverId,
      'time': time.toJson(),
      'logLevel': logLevel.toJson(),
      'message': message,
      if (error != null) 'error': error,
      if (stackTrace != null) 'stackTrace': stackTrace,
      'order': order,
    };
  }
}

class _Undefined {}

class _LogEntryImpl extends LogEntry {
  _LogEntryImpl({
    int? id,
    required int sessionLogId,
    int? messageId,
    String? reference,
    required String serverId,
    required DateTime time,
    required _i2.LogLevel logLevel,
    required String message,
    String? error,
    String? stackTrace,
    required int order,
  }) : super._(
          id: id,
          sessionLogId: sessionLogId,
          messageId: messageId,
          reference: reference,
          serverId: serverId,
          time: time,
          logLevel: logLevel,
          message: message,
          error: error,
          stackTrace: stackTrace,
          order: order,
        );

  @override
  LogEntry copyWith({
    Object? id = _Undefined,
    int? sessionLogId,
    Object? messageId = _Undefined,
    Object? reference = _Undefined,
    String? serverId,
    DateTime? time,
    _i2.LogLevel? logLevel,
    String? message,
    Object? error = _Undefined,
    Object? stackTrace = _Undefined,
    int? order,
  }) {
    return LogEntry(
      id: id is int? ? id : this.id,
      sessionLogId: sessionLogId ?? this.sessionLogId,
      messageId: messageId is int? ? messageId : this.messageId,
      reference: reference is String? ? reference : this.reference,
      serverId: serverId ?? this.serverId,
      time: time ?? this.time,
      logLevel: logLevel ?? this.logLevel,
      message: message ?? this.message,
      error: error is String? ? error : this.error,
      stackTrace: stackTrace is String? ? stackTrace : this.stackTrace,
      order: order ?? this.order,
    );
  }
}
