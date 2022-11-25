/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'protocol.dart' as _i2;

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

  _i2.LogLevel logLevel;

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
}
