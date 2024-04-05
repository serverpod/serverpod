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

/// Log settings for the server.
abstract class LogSettings extends _i1.SerializableEntity {
  LogSettings._({
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

  factory LogSettings({
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
  }) = _LogSettingsImpl;

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
  _i2.LogLevel logLevel;

  /// True if all sessions should be logged.
  bool logAllSessions;

  /// True if all queries should be logged.
  bool logAllQueries;

  /// True if all slow sessions should be logged.
  bool logSlowSessions;

  /// True if streaming sessions should be logged continuously. If set to false,
  /// the logging will take place when the session is closed.
  bool logStreamingSessionsContinuously;

  /// True if all slow queries should be logged.
  bool logSlowQueries;

  /// True if all failed sessions should be logged.
  bool logFailedSessions;

  /// True if all failed queries should be logged.
  bool logFailedQueries;

  /// The duration in seconds for a session to be considered slow.
  double slowSessionDuration;

  /// The duration in seconds for a query to be considered slow.
  double slowQueryDuration;

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
  @override
  Map<String, dynamic> toJson() {
    return {
      'logLevel': logLevel.toJson(),
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
}

class _LogSettingsImpl extends LogSettings {
  _LogSettingsImpl({
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
  }) : super._(
          logLevel: logLevel,
          logAllSessions: logAllSessions,
          logAllQueries: logAllQueries,
          logSlowSessions: logSlowSessions,
          logStreamingSessionsContinuously: logStreamingSessionsContinuously,
          logSlowQueries: logSlowQueries,
          logFailedSessions: logFailedSessions,
          logFailedQueries: logFailedQueries,
          slowSessionDuration: slowSessionDuration,
          slowQueryDuration: slowQueryDuration,
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
