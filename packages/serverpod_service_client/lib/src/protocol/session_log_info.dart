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

/// Compounded information about a session log.
abstract class SessionLogInfo extends _i1.SerializableEntity {
  SessionLogInfo._({
    required this.sessionLogEntry,
    required this.queries,
    required this.logs,
    required this.messages,
  });

  factory SessionLogInfo({
    required _i2.SessionLogEntry sessionLogEntry,
    required List<_i2.QueryLogEntry> queries,
    required List<_i2.LogEntry> logs,
    required List<_i2.MessageLogEntry> messages,
  }) = _SessionLogInfoImpl;

  factory SessionLogInfo.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return SessionLogInfo(
      sessionLogEntry: serializationManager.deserialize<_i2.SessionLogEntry>(
          jsonSerialization['sessionLogEntry']),
      queries: serializationManager
          .deserialize<List<_i2.QueryLogEntry>>(jsonSerialization['queries']),
      logs: serializationManager
          .deserialize<List<_i2.LogEntry>>(jsonSerialization['logs']),
      messages: serializationManager.deserialize<List<_i2.MessageLogEntry>>(
          jsonSerialization['messages']),
    );
  }

  /// The main session log entry.
  _i2.SessionLogEntry sessionLogEntry;

  /// List of queries made during the session.
  List<_i2.QueryLogEntry> queries;

  /// List of log entries made during the session.
  List<_i2.LogEntry> logs;

  /// List of messages sent during the session.
  List<_i2.MessageLogEntry> messages;

  SessionLogInfo copyWith({
    _i2.SessionLogEntry? sessionLogEntry,
    List<_i2.QueryLogEntry>? queries,
    List<_i2.LogEntry>? logs,
    List<_i2.MessageLogEntry>? messages,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'sessionLogEntry': sessionLogEntry.toJson(),
      'queries': queries.toJson(valueToJson: (v) => v.toJson()),
      'logs': logs.toJson(valueToJson: (v) => v.toJson()),
      'messages': messages.toJson(valueToJson: (v) => v.toJson()),
    };
  }
}

class _SessionLogInfoImpl extends SessionLogInfo {
  _SessionLogInfoImpl({
    required _i2.SessionLogEntry sessionLogEntry,
    required List<_i2.QueryLogEntry> queries,
    required List<_i2.LogEntry> logs,
    required List<_i2.MessageLogEntry> messages,
  }) : super._(
          sessionLogEntry: sessionLogEntry,
          queries: queries,
          logs: logs,
          messages: messages,
        );

  @override
  SessionLogInfo copyWith({
    _i2.SessionLogEntry? sessionLogEntry,
    List<_i2.QueryLogEntry>? queries,
    List<_i2.LogEntry>? logs,
    List<_i2.MessageLogEntry>? messages,
  }) {
    return SessionLogInfo(
      sessionLogEntry: sessionLogEntry ?? this.sessionLogEntry.copyWith(),
      queries: queries ?? this.queries.clone(),
      logs: logs ?? this.logs.clone(),
      messages: messages ?? this.messages.clone(),
    );
  }
}
