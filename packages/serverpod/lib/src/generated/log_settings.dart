/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

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
          .deserializeJson<int>(jsonSerialization['logLevel']),
      logAllSessions: serializationManager
          .deserializeJson<bool>(jsonSerialization['logAllSessions']),
      logAllQueries: serializationManager
          .deserializeJson<bool>(jsonSerialization['logAllQueries']),
      logSlowSessions: serializationManager
          .deserializeJson<bool>(jsonSerialization['logSlowSessions']),
      logStreamingSessionsContinuously:
          serializationManager.deserializeJson<bool>(
              jsonSerialization['logStreamingSessionsContinuously']),
      logSlowQueries: serializationManager
          .deserializeJson<bool>(jsonSerialization['logSlowQueries']),
      logFailedSessions: serializationManager
          .deserializeJson<bool>(jsonSerialization['logFailedSessions']),
      logFailedQueries: serializationManager
          .deserializeJson<bool>(jsonSerialization['logFailedQueries']),
      slowSessionDuration: serializationManager
          .deserializeJson<double>(jsonSerialization['slowSessionDuration']),
      slowQueryDuration: serializationManager
          .deserializeJson<double>(jsonSerialization['slowQueryDuration']),
    );
  }

  int logLevel;

  bool logAllSessions;

  bool logAllQueries;

  bool logSlowSessions;

  bool logStreamingSessionsContinuously;

  bool logSlowQueries;

  bool logFailedSessions;

  bool logFailedQueries;

  double slowSessionDuration;

  double slowQueryDuration;

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
  Map<String, dynamic> allToJson() {
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
}
