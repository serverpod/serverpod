import 'package:serverpod_shared/serverpod_shared.dart';

class SessionLogConfigBuilder {
  bool _persistentEnabled = true;
  Duration _cleanupInterval = const Duration(days: 1);
  Duration _retentionPeriod = const Duration(days: 90);
  int _retentionCount = 100_000;
  bool _consoleEnabled = true;
  ConsoleLogFormat _consoleLogFormat = ConsoleLogFormat.text;

  SessionLogConfigBuilder();

  SessionLogConfig build() {
    return SessionLogConfig(
      persistentEnabled: _persistentEnabled,
      consoleEnabled: _consoleEnabled,
      consoleLogFormat: _consoleLogFormat,
      cleanupInterval: _cleanupInterval,
      retentionPeriod: _retentionPeriod,
      retentionCount: _retentionCount,
    );
  }

  SessionLogConfigBuilder withPersistentEnabled(bool persistentEnabled) {
    _persistentEnabled = persistentEnabled;
    return this;
  }

  SessionLogConfigBuilder withCleanupInterval(Duration cleanupInterval) {
    _cleanupInterval = cleanupInterval;
    return this;
  }

  SessionLogConfigBuilder withRetentionPeriod(Duration retentionPeriod) {
    _retentionPeriod = retentionPeriod;
    return this;
  }

  SessionLogConfigBuilder withRetentionCount(int retentionCount) {
    _retentionCount = retentionCount;
    return this;
  }

  SessionLogConfigBuilder withConsoleEnabled(bool consoleEnabled) {
    _consoleEnabled = consoleEnabled;
    return this;
  }

  SessionLogConfigBuilder withConsoleLogFormat(
    ConsoleLogFormat consoleLogFormat,
  ) {
    _consoleLogFormat = consoleLogFormat;
    return this;
  }
}
