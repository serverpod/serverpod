/// The configuration sections for the serverpod configuration file.
class ServerpodConfigMap {
  /// The api server configuration.
  static const String apiServer = 'apiServer';

  /// The insights server configuration.
  static const String insightsServer = 'insightsServer';

  /// The web server configuration.
  static const String webServer = 'webServer';

  /// The database configuration.
  static const String database = 'database';

  /// The redis configuration.
  static const String redis = 'redis';

  /// The logs configuration.
  static const String sessionLogs = 'sessionLogs';

  /// The future call configuration.
  static const String futureCall = 'futureCall';
}

/// The configuration sections for the serverpod server configuration file.
class ServerpodServerConfigMap {
  /// The port for the server.
  static const String port = 'port';

  /// The public address for the server.
  static const String publicHost = 'publicHost';

  /// The public port for the server.
  static const String publicPort = 'publicPort';

  /// The public scheme for the server.
  static const String publicScheme = 'publicScheme';
}

/// The configuration sections for the future call configuration.
class ServerpodFutureCallConfigMap {
  /// The maximum number of concurrent running future calls.
  static const String concurrencyLimit = 'concurrencyLimit';

  /// The delay for the future call queue.
  static const String scanInterval = 'scanInterval';
}

/// The default environment variables used by the server.
enum ServerpodEnv {
  /// The address for the database.
  databaseHost,

  /// The port for the database.
  databasePort,

  /// The name of the database.
  databaseName,

  /// The user for the database.
  databaseUser,

  /// The default schema for the database.
  databaseSearchPaths,

  /// Toggle to require SSL for the database.
  databaseRequireSsl,

  /// Toggle to use a Unix socket for the database.
  databaseIsUnixSocket,

  /// The address to the redis broker.
  redisHost,

  /// The port for the redis broker.
  redisPort,

  /// The user for the redis broker.
  redisUser,

  /// Toggle to enable the redis broker.
  redisEnabled,

  /// Toggle to require SSL for the redis broker.
  redisRequireSsl,

  /// The local port for the api server.
  apiPort,

  /// The public address to the api server.
  apiPublicHost,

  /// The public port for the api server.
  apiPublicPort,

  /// The public scheme for the api server.
  apiPublicScheme,

  /// The local port for the insights server.
  insightsPort,

  /// The public address to the insights server.
  insightsPublicHost,

  /// The public port for the insights server.
  insightsPublicPort,

  /// The public scheme for the insights server.
  insightsPublicScheme,

  /// The local port for the web server.
  webPort,

  /// The public address to the web server.
  webPublicHost,

  /// The public port for the web server.
  webPublicPort,

  /// The public scheme for the web server.
  webPublicScheme,

  /// The maximum request size for the server.
  maxRequestSize,

  /// The maximum number of concurrent running future calls.
  futureCallConcurrencyLimit,

  /// How long to wait before checking the queue again in milliseconds.
  futureCallScanInterval,

  /// Toggle to disable future call execution.
  futureCallExecutionEnabled,

  /// True if session persistent logging is enabled.
  sessionPersistentLogEnabled,

  /// True if session console logging is enabled.
  sessionConsoleLogEnabled,

  /// The format for the console log.
  sessionConsoleLogFormat,

  /// The run mode of the server.
  runMode,

  /// The role of the server.
  role,

  /// The logging mode of the server.
  loggingMode,

  /// The id of the server.
  serverId,

  /// If true, the server will apply database migrations on startup.
  applyMigrations,

  /// If true, the server will apply database repair migration on startup.
  applyRepairMigration;

  /// The key used in the environment configuration file.
  String get configKey {
    return switch (this) {
      (ServerpodEnv.databaseHost) => 'host',
      (ServerpodEnv.databasePort) => 'port',
      (ServerpodEnv.databaseName) => 'name',
      (ServerpodEnv.databaseUser) => 'user',
      (ServerpodEnv.databaseSearchPaths) => 'searchPaths',
      (ServerpodEnv.databaseRequireSsl) => 'requireSsl',
      (ServerpodEnv.databaseIsUnixSocket) => 'isUnixSocket',
      (ServerpodEnv.redisHost) => 'host',
      (ServerpodEnv.redisPort) => 'port',
      (ServerpodEnv.redisUser) => 'user',
      (ServerpodEnv.redisEnabled) => 'enabled',
      (ServerpodEnv.redisRequireSsl) => 'requireSsl',
      (ServerpodEnv.apiPort) => ServerpodServerConfigMap.port,
      (ServerpodEnv.apiPublicHost) => ServerpodServerConfigMap.publicHost,
      (ServerpodEnv.apiPublicPort) => ServerpodServerConfigMap.publicPort,
      (ServerpodEnv.apiPublicScheme) => ServerpodServerConfigMap.publicScheme,
      (ServerpodEnv.insightsPort) => ServerpodServerConfigMap.port,
      (ServerpodEnv.insightsPublicHost) => ServerpodServerConfigMap.publicHost,
      (ServerpodEnv.insightsPublicPort) => ServerpodServerConfigMap.publicPort,
      (ServerpodEnv.insightsPublicScheme) =>
        ServerpodServerConfigMap.publicScheme,
      (ServerpodEnv.webPort) => ServerpodServerConfigMap.port,
      (ServerpodEnv.webPublicHost) => ServerpodServerConfigMap.publicHost,
      (ServerpodEnv.webPublicPort) => ServerpodServerConfigMap.publicPort,
      (ServerpodEnv.webPublicScheme) => ServerpodServerConfigMap.publicScheme,
      (ServerpodEnv.maxRequestSize) => 'maxRequestSize',
      (ServerpodEnv.futureCallConcurrencyLimit) =>
        ServerpodFutureCallConfigMap.concurrencyLimit,
      (ServerpodEnv.futureCallScanInterval) =>
        ServerpodFutureCallConfigMap.scanInterval,
      (ServerpodEnv.futureCallExecutionEnabled) => 'futureCallExecutionEnabled',
      (ServerpodEnv.sessionPersistentLogEnabled) => 'persistentEnabled',
      (ServerpodEnv.sessionConsoleLogEnabled) => 'consoleEnabled',
      (ServerpodEnv.sessionConsoleLogFormat) => 'consoleLogFormat',
      (ServerpodEnv.runMode) => 'mode',
      (ServerpodEnv.role) => 'role',
      (ServerpodEnv.loggingMode) => 'logging',
      (ServerpodEnv.serverId) => 'serverId',
      (ServerpodEnv.applyMigrations) => 'applyMigrations',
      (ServerpodEnv.applyRepairMigration) => 'applyRepairMigration',
    };
  }

  /// The environment variable name for the key.
  String get envVariable {
    return switch (this) {
      (ServerpodEnv.databaseHost) => 'SERVERPOD_DATABASE_HOST',
      (ServerpodEnv.databasePort) => 'SERVERPOD_DATABASE_PORT',
      (ServerpodEnv.databaseName) => 'SERVERPOD_DATABASE_NAME',
      (ServerpodEnv.databaseUser) => 'SERVERPOD_DATABASE_USER',
      (ServerpodEnv.databaseSearchPaths) => 'SERVERPOD_DATABASE_SEARCH_PATHS',
      (ServerpodEnv.databaseRequireSsl) => 'SERVERPOD_DATABASE_REQUIRE_SSL',
      (ServerpodEnv.databaseIsUnixSocket) =>
        'SERVERPOD_DATABASE_IS_UNIX_SOCKET',
      (ServerpodEnv.redisHost) => 'SERVERPOD_REDIS_HOST',
      (ServerpodEnv.redisPort) => 'SERVERPOD_REDIS_PORT',
      (ServerpodEnv.redisUser) => 'SERVERPOD_REDIS_USER',
      (ServerpodEnv.redisEnabled) => 'SERVERPOD_REDIS_ENABLED',
      (ServerpodEnv.redisRequireSsl) => 'SERVERPOD_REDIS_REQUIRE_SSL',
      (ServerpodEnv.apiPort) => 'SERVERPOD_API_SERVER_PORT',
      (ServerpodEnv.apiPublicHost) => 'SERVERPOD_API_SERVER_PUBLIC_HOST',
      (ServerpodEnv.apiPublicPort) => 'SERVERPOD_API_SERVER_PUBLIC_PORT',
      (ServerpodEnv.apiPublicScheme) => 'SERVERPOD_API_SERVER_PUBLIC_SCHEME',
      (ServerpodEnv.insightsPort) => 'SERVERPOD_INSIGHTS_SERVER_PORT',
      (ServerpodEnv.insightsPublicHost) =>
        'SERVERPOD_INSIGHTS_SERVER_PUBLIC_HOST',
      (ServerpodEnv.insightsPublicPort) =>
        'SERVERPOD_INSIGHTS_SERVER_PUBLIC_PORT',
      (ServerpodEnv.insightsPublicScheme) =>
        'SERVERPOD_INSIGHTS_SERVER_PUBLIC_SCHEME',
      (ServerpodEnv.webPort) => 'SERVERPOD_WEB_SERVER_PORT',
      (ServerpodEnv.webPublicHost) => 'SERVERPOD_WEB_SERVER_PUBLIC_HOST',
      (ServerpodEnv.webPublicPort) => 'SERVERPOD_WEB_SERVER_PUBLIC_PORT',
      (ServerpodEnv.webPublicScheme) => 'SERVERPOD_WEB_SERVER_PUBLIC_SCHEME',
      (ServerpodEnv.maxRequestSize) => 'SERVERPOD_MAX_REQUEST_SIZE',
      (ServerpodEnv.futureCallConcurrencyLimit) =>
        'SERVERPOD_FUTURE_CALL_CONCURRENCY_LIMIT',
      (ServerpodEnv.futureCallScanInterval) =>
        'SERVERPOD_FUTURE_CALL_SCAN_INTERVAL',
      (ServerpodEnv.futureCallExecutionEnabled) =>
        'SERVERPOD_FUTURE_CALL_EXECUTION_ENABLED',
      (ServerpodEnv.sessionPersistentLogEnabled) =>
        'SERVERPOD_SESSION_PERSISTENT_LOG_ENABLED',
      (ServerpodEnv.sessionConsoleLogEnabled) =>
        'SERVERPOD_SESSION_CONSOLE_LOG_ENABLED',
      (ServerpodEnv.sessionConsoleLogFormat) =>
        'SERVERPOD_SESSION_CONSOLE_LOG_FORMAT',
      (ServerpodEnv.runMode) => 'SERVERPOD_RUN_MODE',
      (ServerpodEnv.role) => 'SERVERPOD_SERVER_ROLE',
      (ServerpodEnv.loggingMode) => 'SERVERPOD_LOGGING_MODE',
      (ServerpodEnv.serverId) => 'SERVERPOD_SERVER_ID',
      (ServerpodEnv.applyMigrations) => 'SERVERPOD_APPLY_MIGRATIONS',
      (ServerpodEnv.applyRepairMigration) => 'SERVERPOD_APPLY_REPAIR_MIGRATION',
    };
  }
}

/// The default passwords used by the server.
enum ServerpodPassword {
  /// The password for the database.
  databasePassword,

  /// The secret used by insights to authenticate the client.
  serviceSecret,

  /// The password for the redis broker.
  redisPassword;

  /// The key used in the password configuration file.
  String get configKey {
    return switch (this) {
      (ServerpodPassword.databasePassword) => 'database',
      (ServerpodPassword.serviceSecret) => 'serviceSecret',
      (ServerpodPassword.redisPassword) => 'redis',
    };
  }

  /// The environment variable name for the password.
  String get envVariable {
    return switch (this) {
      (ServerpodPassword.databasePassword) => 'SERVERPOD_DATABASE_PASSWORD',
      (ServerpodPassword.serviceSecret) => 'SERVERPOD_SERVICE_SECRET',
      (ServerpodPassword.redisPassword) => 'SERVERPOD_REDIS_PASSWORD',
    };
  }
}
