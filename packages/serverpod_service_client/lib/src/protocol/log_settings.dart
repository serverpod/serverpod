/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'protocol.dart' as _i2;

/// Log settings for the server.
abstract class LogSettings extends _i1.SerializableEntity {
  const LogSettings._();

  const factory LogSettings({
    required _i2.LogLevel logLevel,
    required bool logAllSessions,
    required bool logAllQueries,
    required bool logSlowSessions,
    required bool logStreamingSessionsContinuously,
    required bool logSlowQueries,
    required bool logFailedSessions,
    required bool logFailedQueries,
    required double slowSessionDuration,
    required double slowQueryDuration,
  }) = _LogSettings;

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

  LogSettings copyWith({
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
  });

  /// Log level. Everything above this level will be logged.
  _i2.LogLevel get logLevel;

  /// True if all sessions should be logged.
  bool get logAllSessions;

  /// True if all queries should be logged.
  bool get logAllQueries;

  /// True if all slow sessions should be logged.
  bool get logSlowSessions;

  /// True if streaming sessions should be logged continuously. If set to false,
  /// the logging will take place when the session is closed.
  bool get logStreamingSessionsContinuously;

  /// True if all slow queries should be logged.
  bool get logSlowQueries;

  /// True if all failed sessions should be logged.
  bool get logFailedSessions;

  /// True if all failed queries should be logged.
  bool get logFailedQueries;

  /// The duration in seconds for a session to be considered slow.
  double get slowSessionDuration;

  /// The duration in seconds for a query to be considered slow.
  double get slowQueryDuration;
}

/// Log settings for the server.
class _LogSettings extends LogSettings {
  const _LogSettings({
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
  }) : super._();

  /// Log level. Everything above this level will be logged.
  @override
  final _i2.LogLevel logLevel;

  /// True if all sessions should be logged.
  @override
  final bool logAllSessions;

  /// True if all queries should be logged.
  @override
  final bool logAllQueries;

  /// True if all slow sessions should be logged.
  @override
  final bool logSlowSessions;

  /// True if streaming sessions should be logged continuously. If set to false,
  /// the logging will take place when the session is closed.
  @override
  final bool logStreamingSessionsContinuously;

  /// True if all slow queries should be logged.
  @override
  final bool logSlowQueries;

  /// True if all failed sessions should be logged.
  @override
  final bool logFailedSessions;

  /// True if all failed queries should be logged.
  @override
  final bool logFailedQueries;

  /// The duration in seconds for a session to be considered slow.
  @override
  final double slowSessionDuration;

  /// The duration in seconds for a query to be considered slow.
  @override
  final double slowQueryDuration;

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

  @override
  LogSettings copyWith({
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
