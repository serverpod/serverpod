import 'package:serverpod/web_server.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

import 'run_mode.dart';

/// Toggles for enabling and disabling features in the server.
class Features {
  static late Features _instance;
  final ServerpodConfig _config;

  /// Creates a new [Features] and instantiates the singleton.
  Features(this._config) {
    _instance = this;
  }

  /// Returns true if the database is enabled.
  static bool get enableDatabase => _instance._config.database != null;

  /// Returns true if migrations are enabled.
  static bool get enableMigrations => enableDatabase;

  /// Returns true if Redis is enabled.
  static bool get enableRedis => _instance._config.redis?.enabled == true;

  /// Returns true if the Insights server is enabled.
  static bool get enableInsights {
    return _instance._config.insightsServer != null && enableDatabase;
  }

  /// Returns true if the web server is enabled.
  static bool enableWebServer([WebServer? server]) {
    if (server != null && !server.hasApp) return false;
    return _instance._config.webServer != null;
  }

  /// Returns true if the web server is enabled.
  static bool get enableFutureCalls => enableDatabase;

  /// Returns true if the web server is enabled and the health check interval is valid.
  static bool get enableScheduledHealthChecks =>
      enableDatabase && _instance._config.healthCheckInterval > Duration.zero;

  /// Returns true if runtime settings should be persisted to and loaded from
  /// the database.
  ///
  /// In test mode, runtime settings are only managed in-memory. This prevents
  /// test isolation issues caused by runtime settings (e.g. log settings)
  /// bleeding across tests. The store/reload mechanism is only needed by
  /// Serverpod Insights (which syncs [RuntimeSettings] changes via
  /// [HealthCheckManager]) and is never required in a test context.
  static bool get persistRuntimeSettings =>
      enableDatabase && _instance._config.runMode != ServerpodRunMode.test;
}
