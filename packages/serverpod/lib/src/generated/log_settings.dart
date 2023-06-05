/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'protocol.dart' as _i2;

class _Undefined {}

/// Log settings for the server.
class LogSettings extends _i1.SerializableEntity {
  LogSettings({
    required this.logLevel,
    required this.logAllSessions,
    required this.logAllQueries,
    required this.logSlowSessions,
    required this.logStreamingSessionsContinuously,
    required this.logSlowQueries,
    required this.logFailedSessions,
    required this.logFailedQueries,
    required this.slowSessionDuration,
    required this.slowQueryDuration,
  });

  factory LogSettings.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return LogSettings(
      logLevel: serializationManager
          .deserialize<_i2.LogLevel>(jsonSerialization['logLevel']),
      logAllSessions: serializationManager
          .deserialize<bool>(jsonSerialization['logAllSessions']),
      logAllQueries: serializationManager
          .deserialize<bool>(jsonSerialization['logAllQueries']),
      logSlowSessions: serializationManager
          .deserialize<bool>(jsonSerialization['logSlowSessions']),
      logStreamingSessionsContinuously: serializationManager.deserialize<bool>(
          jsonSerialization['logStreamingSessionsContinuously']),
      logSlowQueries: serializationManager
          .deserialize<bool>(jsonSerialization['logSlowQueries']),
      logFailedSessions: serializationManager
          .deserialize<bool>(jsonSerialization['logFailedSessions']),
      logFailedQueries: serializationManager
          .deserialize<bool>(jsonSerialization['logFailedQueries']),
      slowSessionDuration: serializationManager
          .deserialize<double>(jsonSerialization['slowSessionDuration']),
      slowQueryDuration: serializationManager
          .deserialize<double>(jsonSerialization['slowQueryDuration']),
    );
  }

  /// Log level. Everything above this level will be logged.
  final _i2.LogLevel logLevel;

  /// True if all sessions should be logged.
  final bool logAllSessions;

  /// True if all queries should be logged.
  final bool logAllQueries;

  /// True if all slow sessions should be logged.
  final bool logSlowSessions;

  /// True if streaming sessions should be logged continuously. If set to false,
  /// the logging will take place when the session is closed.
  final bool logStreamingSessionsContinuously;

  /// True if all slow queries should be logged.
  final bool logSlowQueries;

  /// True if all failed sessions should be logged.
  final bool logFailedSessions;

  /// True if all failed queries should be logged.
  final bool logFailedQueries;

  /// The duration in seconds for a session to be considered slow.
  final double slowSessionDuration;

  /// The duration in seconds for a query to be considered slow.
  final double slowQueryDuration;

  late Function({
    _i2.LogLevel? logLevel,
    bool? logAllSessions,
    bool? logAllQueries,
    bool? logSlowSessions,
    bool? logStreamingSessionsContinuously,
    bool? logSlowQueries,
    bool? logFailedSessions,
    bool? logFailedQueries,
    double? slowSessionDuration,
    double? slowQueryDuration,
  }) copyWith = _copyWith;

  @override
  Map<String, dynamic> toJson() {
    return {
      'logLevel': logLevel,
      'logAllSessions': logAllSessions,
      'logAllQueries': logAllQueries,
      'logSlowSessions': logSlowSessions,
      'logStreamingSessionsContinuously': logStreamingSessionsContinuously,
      'logSlowQueries': logSlowQueries,
      'logFailedSessions': logFailedSessions,
      'logFailedQueries': logFailedQueries,
      'slowSessionDuration': slowSessionDuration,
      'slowQueryDuration': slowQueryDuration,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is LogSettings &&
            (identical(
                  other.logLevel,
                  logLevel,
                ) ||
                other.logLevel == logLevel) &&
            (identical(
                  other.logAllSessions,
                  logAllSessions,
                ) ||
                other.logAllSessions == logAllSessions) &&
            (identical(
                  other.logAllQueries,
                  logAllQueries,
                ) ||
                other.logAllQueries == logAllQueries) &&
            (identical(
                  other.logSlowSessions,
                  logSlowSessions,
                ) ||
                other.logSlowSessions == logSlowSessions) &&
            (identical(
                  other.logStreamingSessionsContinuously,
                  logStreamingSessionsContinuously,
                ) ||
                other.logStreamingSessionsContinuously ==
                    logStreamingSessionsContinuously) &&
            (identical(
                  other.logSlowQueries,
                  logSlowQueries,
                ) ||
                other.logSlowQueries == logSlowQueries) &&
            (identical(
                  other.logFailedSessions,
                  logFailedSessions,
                ) ||
                other.logFailedSessions == logFailedSessions) &&
            (identical(
                  other.logFailedQueries,
                  logFailedQueries,
                ) ||
                other.logFailedQueries == logFailedQueries) &&
            (identical(
                  other.slowSessionDuration,
                  slowSessionDuration,
                ) ||
                other.slowSessionDuration == slowSessionDuration) &&
            (identical(
                  other.slowQueryDuration,
                  slowQueryDuration,
                ) ||
                other.slowQueryDuration == slowQueryDuration));
  }

  @override
  int get hashCode => Object.hash(
        logLevel,
        logAllSessions,
        logAllQueries,
        logSlowSessions,
        logStreamingSessionsContinuously,
        logSlowQueries,
        logFailedSessions,
        logFailedQueries,
        slowSessionDuration,
        slowQueryDuration,
      );

  LogSettings _copyWith({
    _i2.LogLevel? logLevel,
    bool? logAllSessions,
    bool? logAllQueries,
    bool? logSlowSessions,
    bool? logStreamingSessionsContinuously,
    bool? logSlowQueries,
    bool? logFailedSessions,
    bool? logFailedQueries,
    double? slowSessionDuration,
    double? slowQueryDuration,
  }) {
    return LogSettings(
      logLevel: logLevel ?? this.logLevel,
      logAllSessions: logAllSessions ?? this.logAllSessions,
      logAllQueries: logAllQueries ?? this.logAllQueries,
      logSlowSessions: logSlowSessions ?? this.logSlowSessions,
      logStreamingSessionsContinuously: logStreamingSessionsContinuously ??
          this.logStreamingSessionsContinuously,
      logSlowQueries: logSlowQueries ?? this.logSlowQueries,
      logFailedSessions: logFailedSessions ?? this.logFailedSessions,
      logFailedQueries: logFailedQueries ?? this.logFailedQueries,
      slowSessionDuration: slowSessionDuration ?? this.slowSessionDuration,
      slowQueryDuration: slowQueryDuration ?? this.slowQueryDuration,
    );
  }
}
