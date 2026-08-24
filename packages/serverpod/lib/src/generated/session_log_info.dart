/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod/src/generated/protocol.dart' as _ic00rqxb;
import 'log_entry.dart' as _iv7ld46g;
import 'message_log_entry.dart' as _iky1nb92;
import 'query_log_entry.dart' as _inqjskye;
import 'session_log_entry.dart' as _i3jtimpl;

/// Compounded information about a session log.
abstract class SessionLogInfo
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SessionLogInfo._({
    required this.sessionLogEntry,
    required this.queries,
    required this.logs,
    required this.messages,
  });

  factory SessionLogInfo({
    required _i3jtimpl.SessionLogEntry sessionLogEntry,
    required List<_inqjskye.QueryLogEntry> queries,
    required List<_iv7ld46g.LogEntry> logs,
    required List<_iky1nb92.MessageLogEntry> messages,
  }) = _SessionLogInfoImpl;

  factory SessionLogInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return SessionLogInfo(
      sessionLogEntry: _ic00rqxb.Protocol()
          .deserialize<_i3jtimpl.SessionLogEntry>(
            jsonSerialization['sessionLogEntry'],
          ),
      queries: _ic00rqxb.Protocol().deserialize<List<_inqjskye.QueryLogEntry>>(
        jsonSerialization['queries'],
      ),
      logs: _ic00rqxb.Protocol().deserialize<List<_iv7ld46g.LogEntry>>(
        jsonSerialization['logs'],
      ),
      messages: _ic00rqxb.Protocol()
          .deserialize<List<_iky1nb92.MessageLogEntry>>(
            jsonSerialization['messages'],
          ),
    );
  }

  /// The main session log entry.
  _i3jtimpl.SessionLogEntry sessionLogEntry;

  /// List of queries made during the session.
  List<_inqjskye.QueryLogEntry> queries;

  /// List of log entries made during the session.
  List<_iv7ld46g.LogEntry> logs;

  /// List of messages sent during the session.
  List<_iky1nb92.MessageLogEntry> messages;

  /// Returns a shallow copy of this [SessionLogInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SessionLogInfo copyWith({
    _i3jtimpl.SessionLogEntry? sessionLogEntry,
    List<_inqjskye.QueryLogEntry>? queries,
    List<_iv7ld46g.LogEntry>? logs,
    List<_iky1nb92.MessageLogEntry>? messages,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.SessionLogInfo',
      'sessionLogEntry': sessionLogEntry.toJson(),
      'queries': queries.toJson(valueToJson: (v) => v.toJson()),
      'logs': logs.toJson(valueToJson: (v) => v.toJson()),
      'messages': messages.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod.SessionLogInfo',
      'sessionLogEntry': sessionLogEntry.toJsonForProtocol(),
      'queries': queries.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'logs': logs.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'messages': messages.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _SessionLogInfoImpl extends SessionLogInfo {
  _SessionLogInfoImpl({
    required _i3jtimpl.SessionLogEntry sessionLogEntry,
    required List<_inqjskye.QueryLogEntry> queries,
    required List<_iv7ld46g.LogEntry> logs,
    required List<_iky1nb92.MessageLogEntry> messages,
  }) : super._(
         sessionLogEntry: sessionLogEntry,
         queries: queries,
         logs: logs,
         messages: messages,
       );

  /// Returns a shallow copy of this [SessionLogInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SessionLogInfo copyWith({
    _i3jtimpl.SessionLogEntry? sessionLogEntry,
    List<_inqjskye.QueryLogEntry>? queries,
    List<_iv7ld46g.LogEntry>? logs,
    List<_iky1nb92.MessageLogEntry>? messages,
  }) {
    return SessionLogInfo(
      sessionLogEntry: sessionLogEntry ?? this.sessionLogEntry.copyWith(),
      queries: queries ?? this.queries.map((e0) => e0.copyWith()).toList(),
      logs: logs ?? this.logs.map((e0) => e0.copyWith()).toList(),
      messages: messages ?? this.messages.map((e0) => e0.copyWith()).toList(),
    );
  }
}
