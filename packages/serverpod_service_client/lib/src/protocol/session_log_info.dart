/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'session_log_entry.dart' as _i2;
import 'query_log_entry.dart' as _i3;
import 'log_entry.dart' as _i4;
import 'message_log_entry.dart' as _i5;

/// Compounded information about a session log.
abstract class SessionLogInfo implements _i1.SerializableModel {
  SessionLogInfo._({
    required this.sessionLogEntry,
    required this.queries,
    required this.logs,
    required this.messages,
  });

  factory SessionLogInfo({
    required _i2.SessionLogEntry sessionLogEntry,
    required List<_i3.QueryLogEntry> queries,
    required List<_i4.LogEntry> logs,
    required List<_i5.MessageLogEntry> messages,
  }) = _SessionLogInfoImpl;

  factory SessionLogInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return SessionLogInfo(
      sessionLogEntry: _i2.SessionLogEntry.fromJson(
          (jsonSerialization['sessionLogEntry'] as Map<String, dynamic>)),
      queries: (jsonSerialization['queries'] as List)
          .map((e) => _i3.QueryLogEntry.fromJson((e as Map<String, dynamic>)))
          .toList(),
      logs: (jsonSerialization['logs'] as List)
          .map((e) => _i4.LogEntry.fromJson((e as Map<String, dynamic>)))
          .toList(),
      messages: (jsonSerialization['messages'] as List)
          .map((e) => _i5.MessageLogEntry.fromJson((e as Map<String, dynamic>)))
          .toList(),
    );
  }

  /// The main session log entry.
  _i2.SessionLogEntry sessionLogEntry;

  /// List of queries made during the session.
  List<_i3.QueryLogEntry> queries;

  /// List of log entries made during the session.
  List<_i4.LogEntry> logs;

  /// List of messages sent during the session.
  List<_i5.MessageLogEntry> messages;

  /// Returns a shallow copy of this [SessionLogInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SessionLogInfo copyWith({
    _i2.SessionLogEntry? sessionLogEntry,
    List<_i3.QueryLogEntry>? queries,
    List<_i4.LogEntry>? logs,
    List<_i5.MessageLogEntry>? messages,
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

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _SessionLogInfoImpl extends SessionLogInfo {
  _SessionLogInfoImpl({
    required _i2.SessionLogEntry sessionLogEntry,
    required List<_i3.QueryLogEntry> queries,
    required List<_i4.LogEntry> logs,
    required List<_i5.MessageLogEntry> messages,
  }) : super._(
          sessionLogEntry: sessionLogEntry,
          queries: queries,
          logs: logs,
          messages: messages,
        );

  /// Returns a shallow copy of this [SessionLogInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SessionLogInfo copyWith({
    _i2.SessionLogEntry? sessionLogEntry,
    List<_i3.QueryLogEntry>? queries,
    List<_i4.LogEntry>? logs,
    List<_i5.MessageLogEntry>? messages,
  }) {
    return SessionLogInfo(
      sessionLogEntry: sessionLogEntry ?? this.sessionLogEntry.copyWith(),
      queries: queries ?? this.queries.map((e0) => e0.copyWith()).toList(),
      logs: logs ?? this.logs.map((e0) => e0.copyWith()).toList(),
      messages: messages ?? this.messages.map((e0) => e0.copyWith()).toList(),
    );
  }
}
