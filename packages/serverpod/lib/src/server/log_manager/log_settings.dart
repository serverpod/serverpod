import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';

class LogSettingsManager {
  final RuntimeSettings _runtimeSettings;

  final Map<String, LogSettings> _endpointOverrides = {};
  final Map<String, LogSettings> _methodOverrides = {};

  LogSettingsManager(
    this._runtimeSettings,
  ) {
    for (var override in _runtimeSettings.logSettingsOverrides) {
      if (override.method != null && override.endpoint != null) {
        _methodOverrides['${override.endpoint}.${override.method}'] =
            override.logSettings;
      } else if (override.endpoint != null) {
        _endpointOverrides['${override.endpoint}'] = override.logSettings;
      }
    }
  }

  /// Gets the log settings for a [MethodCallSession].
  LogSettings _getLogSettingsForMethodCallSession(
    String endpoint,
    String method,
  ) {
    var settings = _methodOverrides['$endpoint.$method'];
    if (settings != null) return settings;

    settings = _endpointOverrides[endpoint];
    if (settings != null) return settings;

    return _runtimeSettings.logSettings;
  }

  /// Gets the log settings for a [InternalSession].
  LogSettings _getLogSettingsForInternalSession() {
    return _runtimeSettings.logSettings;
  }

  /// Gets the log settings for a [StreamingSession].
  LogSettings _getLogSettingsForStreamingSession({required String endpoint}) {
    var settings = _endpointOverrides[endpoint];
    if (settings != null) return settings;

    return _runtimeSettings.logSettings;
  }

  /// Gets the log settings for a [FutureCallSession].
  LogSettings _getLogSettingsForFutureCallSession(String call) {
    return _runtimeSettings.logSettings;
  }

  /// Returns the [LogSettings] for a specific session.
  LogSettings getLogSettingsForSession(Session session) {
    return switch (session) {
      MethodCallSession session => _getLogSettingsForMethodCallSession(
          session.endpointName,
          session.methodName,
        ),
      StreamingSession session => _getLogSettingsForStreamingSession(
          // TODO: fix type cast error
          endpoint: session.sessionLogs.currentEndpoint!,
        ),
      InternalSession _ => _getLogSettingsForInternalSession(),
      FutureCallSession session => _getLogSettingsForFutureCallSession(
          session.futureCallName,
        ),
      MethodStreamSession session => _getLogSettingsForMethodCallSession(
          session.endpointName,
          session.methodName,
        ),
    };
  }
}
