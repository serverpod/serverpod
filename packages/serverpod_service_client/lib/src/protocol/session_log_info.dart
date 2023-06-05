/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'protocol.dart' as _i2;
import 'package:collection/collection.dart' as _i3;

/// Compounded information about a session log.
abstract class SessionLogInfo extends _i1.SerializableEntity {
  const SessionLogInfo._();

  const factory SessionLogInfo({
    required _i2.SessionLogEntry sessionLogEntry,
    required List<_i2.QueryLogEntry> queries,
    required List<_i2.LogEntry> logs,
    required List<_i2.MessageLogEntry> messages,
  }) = _SessionLogInfo;

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

  SessionLogInfo copyWith({
    _i2.SessionLogEntry? sessionLogEntry,
    List<_i2.QueryLogEntry>? queries,
    List<_i2.LogEntry>? logs,
    List<_i2.MessageLogEntry>? messages,
  });

  /// The main session log entry.
  _i2.SessionLogEntry get sessionLogEntry;

  /// List of queries made during the session.
  List<_i2.QueryLogEntry> get queries;

  /// List of log entries made during the session.
  List<_i2.LogEntry> get logs;

  /// List of messages sent during the session.
  List<_i2.MessageLogEntry> get messages;
}

/// Compounded information about a session log.
class _SessionLogInfo extends SessionLogInfo {
  const _SessionLogInfo({
    required this.sessionLogEntry,
    required this.queries,
    required this.logs,
    required this.messages,
  }) : super._();

  /// The main session log entry.
  @override
  final _i2.SessionLogEntry sessionLogEntry;

  /// List of queries made during the session.
  @override
  final List<_i2.QueryLogEntry> queries;

  /// List of log entries made during the session.
  @override
  final List<_i2.LogEntry> logs;

  /// List of messages sent during the session.
  @override
  final List<_i2.MessageLogEntry> messages;

  @override
  Map<String, dynamic> toJson() {
    return {
      'sessionLogEntry': sessionLogEntry,
      'queries': queries,
      'logs': logs,
      'messages': messages,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is SessionLogInfo &&
            (identical(
                  other.sessionLogEntry,
                  sessionLogEntry,
                ) ||
                other.sessionLogEntry == sessionLogEntry) &&
            const _i3.DeepCollectionEquality().equals(
              queries,
              other.queries,
            ) &&
            const _i3.DeepCollectionEquality().equals(
              logs,
              other.logs,
            ) &&
            const _i3.DeepCollectionEquality().equals(
              messages,
              other.messages,
            ));
  }

  @override
  int get hashCode => Object.hash(
        sessionLogEntry,
        const _i3.DeepCollectionEquality().hash(queries),
        const _i3.DeepCollectionEquality().hash(logs),
        const _i3.DeepCollectionEquality().hash(messages),
      );

  @override
  SessionLogInfo copyWith({
    _i2.SessionLogEntry? sessionLogEntry,
    List<_i2.QueryLogEntry>? queries,
    List<_i2.LogEntry>? logs,
    List<_i2.MessageLogEntry>? messages,
  }) {
    return SessionLogInfo(
      sessionLogEntry: sessionLogEntry ?? this.sessionLogEntry,
      queries: queries ?? this.queries,
      logs: logs ?? this.logs,
      messages: messages ?? this.messages,
    );
  }
}
