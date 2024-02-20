import 'package:serverpod/relic.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

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
    if (server != null && server.routes.isEmpty) return false;
    return _instance._config.webServer != null;
  }

  /// Returns true if the web server is enabled.
  static bool get enableFutureCalls => enableDatabase;

  /// Returns true if the web server is enabled.
  static bool get enableScheduledHealthChecks => enableDatabase;

  /// Returns true if the web server is enabled.
  static bool get enablePersistentLogging => enableDatabase;

  /// Returns true if the web server is enabled.
  static bool get enableDefaultAuthenticationHandler => enableDatabase;
}
