import 'package:serverpod/protocol.dart';

class LogSettingsBuilder {
  LogLevel _logLevel = LogLevel.debug;
  bool _logAllSessions = true;
  bool _logAllQueries = true;
  bool _logSlowSessions = true;
  bool _logStreamingSessionsContinuously = true;
  bool _logSlowQueries = true;
  bool _logFailedSessions = true;
  bool _logFailedQueries = true;
  double _slowSessionDuration = 1.0;
  double _slowQueryDuration = 1.0;

  LogSettingsBuilder withLoggingTurnedDown() {
    _logLevel = LogLevel.fatal;
    _logAllSessions = false;
    _logAllQueries = false;
    _logSlowSessions = false;
    _logStreamingSessionsContinuously = false;
    _logSlowQueries = false;
    _logFailedSessions = false;
    _logFailedQueries = false;
    return this;
  }

  LogSettingsBuilder withLogLevel(LogLevel logLevel) {
    _logLevel = logLevel;
    return this;
  }

  LogSettingsBuilder withLogAllSessions(bool logAllSessions) {
    _logAllSessions = logAllSessions;
    return this;
  }

  LogSettingsBuilder withLogAllQueries(bool logAllQueries) {
    _logAllQueries = logAllQueries;
    return this;
  }

  LogSettingsBuilder withLogSlowSessions(bool logSlowSessions) {
    _logSlowSessions = logSlowSessions;
    return this;
  }

  LogSettingsBuilder withLogStreamingSessionsContinuously(
    bool logStreamingSessionsContinuously,
  ) {
    _logStreamingSessionsContinuously = logStreamingSessionsContinuously;
    return this;
  }

  LogSettingsBuilder withLogSlowQueries(bool logSlowQueries) {
    _logSlowQueries = logSlowQueries;
    return this;
  }

  LogSettingsBuilder withLogFailedSessions(bool logFailedSessions) {
    _logFailedSessions = logFailedSessions;
    return this;
  }

  LogSettingsBuilder withLogFailedQueries(bool logFailedQueries) {
    _logFailedQueries = logFailedQueries;
    return this;
  }

  LogSettingsBuilder withSlowSessionDuration(double slowSessionDuration) {
    _slowSessionDuration = slowSessionDuration;
    return this;
  }

  LogSettingsBuilder withSlowQueryDuration(double slowQueryDuration) {
    _slowQueryDuration = slowQueryDuration;
    return this;
  }

  LogSettings build() {
    return LogSettings(
      logLevel: _logLevel,
      logAllSessions: _logAllSessions,
      logAllQueries: _logAllQueries,
      logSlowSessions: _logSlowSessions,
      logStreamingSessionsContinuously: _logStreamingSessionsContinuously,
      logSlowQueries: _logSlowQueries,
      logFailedSessions: _logFailedSessions,
      logFailedQueries: _logFailedQueries,
      slowSessionDuration: _slowSessionDuration,
      slowQueryDuration: _slowQueryDuration,
    );
  }
}
