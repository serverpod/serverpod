/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// A log entry for a message sent in a streaming session.
abstract class MessageLogEntry extends _i1.SerializableEntity {
  MessageLogEntry._({
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

  factory MessageLogEntry({
    int? id,
    required int sessionLogId,
    required String serverId,
    required int messageId,
    required String endpoint,
    required String messageName,
    required double duration,
    String? error,
    String? stackTrace,
    required bool slow,
    required int order,
  }) = _MessageLogEntryImpl;

  factory MessageLogEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return MessageLogEntry(
      id: jsonSerialization['id'] as int?,
      sessionLogId: jsonSerialization['sessionLogId'] as int,
      serverId: jsonSerialization['serverId'] as String,
      messageId: jsonSerialization['messageId'] as int,
      endpoint: jsonSerialization['endpoint'] as String,
      messageName: jsonSerialization['messageName'] as String,
      duration: jsonSerialization['duration'] as double,
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

  /// Id of the session this entry is associated with.
  int sessionLogId;

  /// The id of the server that handled the message.
  String serverId;

  /// The id of the message this entry is associated with.
  int messageId;

  /// The entpoint this message is associated with.
  String endpoint;

  /// The class name of the message this entry is associated with.
  String messageName;

  /// The duration of handling of this message.
  double duration;

  /// Error is set if an error or exception was thrown during the handling of
  /// this message.
  String? error;

  /// The stack trace of an error that was thrown during the handling of this
  /// message.
  String? stackTrace;

  /// The handling of this message was slow.
  bool slow;

  /// Used for sorting the message log.
  int order;

  MessageLogEntry copyWith({
    int? id,
    int? sessionLogId,
    String? serverId,
    int? messageId,
    String? endpoint,
    String? messageName,
    double? duration,
    String? error,
    String? stackTrace,
    bool? slow,
    int? order,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'sessionLogId': sessionLogId,
      'serverId': serverId,
      'messageId': messageId,
      'endpoint': endpoint,
      'messageName': messageName,
      'duration': duration,
      if (error != null) 'error': error,
      if (stackTrace != null) 'stackTrace': stackTrace,
      'slow': slow,
      'order': order,
    };
  }
}

class _Undefined {}

class _MessageLogEntryImpl extends MessageLogEntry {
  _MessageLogEntryImpl({
    int? id,
    required int sessionLogId,
    required String serverId,
    required int messageId,
    required String endpoint,
    required String messageName,
    required double duration,
    String? error,
    String? stackTrace,
    required bool slow,
    required int order,
  }) : super._(
          id: id,
          sessionLogId: sessionLogId,
          serverId: serverId,
          messageId: messageId,
          endpoint: endpoint,
          messageName: messageName,
          duration: duration,
          error: error,
          stackTrace: stackTrace,
          slow: slow,
          order: order,
        );

  @override
  MessageLogEntry copyWith({
    Object? id = _Undefined,
    int? sessionLogId,
    String? serverId,
    int? messageId,
    String? endpoint,
    String? messageName,
    double? duration,
    Object? error = _Undefined,
    Object? stackTrace = _Undefined,
    bool? slow,
    int? order,
  }) {
    return MessageLogEntry(
      id: id is int? ? id : this.id,
      sessionLogId: sessionLogId ?? this.sessionLogId,
      serverId: serverId ?? this.serverId,
      messageId: messageId ?? this.messageId,
      endpoint: endpoint ?? this.endpoint,
      messageName: messageName ?? this.messageName,
      duration: duration ?? this.duration,
      error: error is String? ? error : this.error,
      stackTrace: stackTrace is String? ? stackTrace : this.stackTrace,
      slow: slow ?? this.slow,
      order: order ?? this.order,
    );
  }
}
