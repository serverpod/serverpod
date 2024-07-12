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
    var localSession = session;
    if (localSession is MethodCallSession) {
      return _getLogSettingsForMethodCallSession(
        localSession.endpointName,
        localSession.methodName,
      );
    }

    if (localSession is StreamingSession) {
      return _getLogSettingsForStreamingSession(
        endpoint: localSession.endpointName,
      );
    }

    if (localSession is InternalSession) {
      return _getLogSettingsForInternalSession();
    }

    if (localSession is FutureCallSession) {
      return _getLogSettingsForFutureCallSession(
        localSession.futureCallName,
      );
    }

    if (localSession is MethodStreamSession) {
      return _getLogSettingsForMethodCallSession(
        localSession.endpointName,
        localSession.methodName,
      );
    }

    throw Exception('Unknown session type: $session');
  }
}
