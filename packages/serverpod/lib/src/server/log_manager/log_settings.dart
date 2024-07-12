import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';

/// Retrieve the log settings for a session.
class LogSettingsManager {
  final RuntimeSettings _runtimeSettings;

  final Map<String, LogSettings> _endpointOverrides = {};
  final Map<String, LogSettings> _methodOverrides = {};

  /// Creates a new [LogSettingsManager].
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

  /// Returns the [LogSettings] for a specific session.
  LogSettings getLogSettingsForSession(Session session) {
    var endpoint = session.endpointName;
    var method = session.methodName;

    LogSettings? settings;
    if (method != null) {
      settings = _methodOverrides['$endpoint.$method'];
      if (settings != null) return settings;
    }

    settings = _endpointOverrides[endpoint];
    if (settings != null) return settings;

    return _runtimeSettings.logSettings;
  }
}
