import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_shared/src/environment_variables.dart';
import 'package:yaml/yaml.dart';

/// The configuration sections for the serverpod configuration file.
typedef Convert<T> = T Function(String value);

const int _defaultMaxRequestSize = 524288;

const String _developmentRunMode = 'development';

/// Parser for the Serverpod configuration file.
class ServerpodConfig {
  /// The servers run mode.
  final String runMode;

  /// Id of the current server.
  final String serverId;

  /// Max limit in bytes of requests to the server.
  final int maxRequestSize;

  /// Configuration for the main API server.
  final ServerConfig apiServer;

  /// Configuration for the Insights server.
  final ServerConfig? insightsServer;

  /// Configuration for the web server (optional).
  final ServerConfig? webServer;

  /// Configuration for the Postgres database.
  final DatabaseConfig? database;

  /// Configuration for Redis.
  final RedisConfig? redis;

  /// Authentication key for service protocol.
  late final String? serviceSecret;

  /// Configuration for Session logs.
  final SessionLogConfig sessionLogs;

  /// The timeout for the diagnostic event handlers.
  /// Default is 30 seconds.
  final Duration? experimentalDiagnosticHandlerTimeout;

  /// Configuration for future call handling.
  final FutureCallConfig futureCall;

  /// True if future call execution should be disabled.
  final bool futureCallExecutionEnabled;

  /// Creates a new [ServerpodConfig].
  ServerpodConfig({
    required this.apiServer,
    this.runMode = _developmentRunMode,
    this.serverId = 'default',
    this.maxRequestSize = 524288,
    this.insightsServer,
    this.webServer,
    this.database,
    this.redis,
    this.serviceSecret,
    SessionLogConfig? sessionLogs,
    this.experimentalDiagnosticHandlerTimeout = const Duration(seconds: 30),
    this.futureCall = const FutureCallConfig(),
    this.futureCallExecutionEnabled = true,
  }) : sessionLogs = sessionLogs ??
            SessionLogConfig.buildDefault(
              databaseEnabled: database != null,
              runMode: runMode,
            ) {
    apiServer._name = 'api';
    insightsServer?._name = 'insights';
    webServer?._name = 'web';
    sessionLogs?._validate(
      databaseEnabled: database != null,
    );
  }

  /// Creates a default bare bone configuration.
  factory ServerpodConfig.defaultConfig() {
    return ServerpodConfig(
      apiServer: ServerConfig(
        port: 8080,
        publicHost: 'localhost',
        publicPort: 8080,
        publicScheme: 'http',
      ),
    );
  }

  /// Creates a new [ServerpodConfig] from a configuration Map.
  /// Expects the Map to match the specified run mode.
  ///
  /// Throws an exception if the configuration is missing required fields.
  factory ServerpodConfig.loadFromMap(
    String runMode,
    String serverId,
    Map<String, String> passwords,
    Map configMap, {
    Map<String, String> environment = const {},
  }) {
    serverId = _readServerId(configMap, environment, serverId);

    var apiConfig = _apiConfigMap(configMap, environment);
    if (apiConfig == null) {
      throw _ServerpodApiServerConfigMissing();
    }

    var apiServer = ServerConfig._fromJson(
      apiConfig,
      ServerpodConfigMap.apiServer,
    );

    var insightsConfig = _insightsConfigMap(configMap, environment);
    var insightsServer = insightsConfig != null
        ? ServerConfig._fromJson(
            insightsConfig,
            ServerpodConfigMap.insightsServer,
          )
        : null;

    var webConfig = _webConfigMap(configMap, environment);
    var webServer = webConfig != null
        ? ServerConfig._fromJson(
            webConfig,
            ServerpodConfigMap.webServer,
          )
        : null;

    var maxRequestSize = _readMaxRequestSize(configMap, environment);

    var serviceSecret = passwords[ServerpodPassword.serviceSecret.configKey];

    var databaseConfig = _databaseConfigMap(configMap, environment);
    var database = databaseConfig != null
        ? DatabaseConfig._fromJson(
            databaseConfig,
            passwords,
            ServerpodConfigMap.database,
          )
        : null;

    var redisConfig = _redisConfigMap(configMap, environment);
    var redis = redisConfig != null
        ? RedisConfig._fromJson(
            redisConfig,
            passwords,
            ServerpodConfigMap.redis,
          )
        : null;

    var sessionLogsConfigJson =
        _buildSessionLogsConfigMap(configMap, environment);
    var sessionLogsConfig = sessionLogsConfigJson != null
        ? SessionLogConfig._fromJson(
            sessionLogsConfigJson,
            ServerpodConfigMap.sessionLogs,
            databaseEnabled: database != null,
          )
        : null;

    var futureCallConfigJson =
        _buildFutureCallConfigMap(configMap, environment);
    var futureCallConfig = futureCallConfigJson != null
        ? FutureCallConfig._fromJson(
            futureCallConfigJson,
            ServerpodConfigMap.futureCall,
          )
        : const FutureCallConfig(
            concurrencyLimit:
                FutureCallConfig.defaultFutureCallConcurrencyLimit,
          );

    var futureCallExecutionEnabled =
        _readIsFutureCallExecutionEnabled(configMap, environment);

    return ServerpodConfig(
      runMode: runMode,
      serverId: serverId,
      apiServer: apiServer,
      maxRequestSize: maxRequestSize,
      insightsServer: insightsServer,
      webServer: webServer,
      database: database,
      redis: redis,
      serviceSecret: serviceSecret,
      sessionLogs: sessionLogsConfig,
      futureCall: futureCallConfig,
      futureCallExecutionEnabled: futureCallExecutionEnabled,
    );
  }

  /// Loads and parses a server configuration file. Picks config file depending
  /// on run mode.
  factory ServerpodConfig.load(
    String runMode,
    String serverId,
    Map<String, String> passwords,
  ) {
    dynamic doc = {};

    if (isConfigAvailable(runMode)) {
      String data = File(_createConfigPath(runMode)).readAsStringSync();
      doc = loadYaml(data);
    }

    try {
      return ServerpodConfig.loadFromMap(
        runMode,
        serverId,
        passwords,
        doc,
        environment: Platform.environment,
      );
    } catch (e) {
      if (e is _ServerpodApiServerConfigMissing) {
        return ServerpodConfig.defaultConfig();
      }
      rethrow;
    }
  }

  /// Checks if a configuration file is available on disk for the given run mode.
  static bool isConfigAvailable(String runMode) {
    return File(_createConfigPath(runMode)).existsSync();
  }

  static String _createConfigPath(String runMode) {
    return path.joinAll(['config', '$runMode.yaml']);
  }

  @override
  String toString() {
    var str = '';

    str += apiServer.toString();
    if (insightsServer != null) str += insightsServer.toString();
    if (webServer != null) str += webServer.toString();

    if (database != null) str += database.toString();
    if (redis != null) str += redis.toString();
    str += sessionLogs.toString();
    str += futureCall.toString();
    str += 'future call execution enabled: $futureCallExecutionEnabled\n';

    return str;
  }
}

/// Configuration for a server.
class ServerConfig {
  String? _name;

  /// The port the server will be running on.
  final int port;

  /// Public facing host name.
  final String publicHost;

  /// Public facing port.
  final int publicPort;

  /// Public facing scheme, i.e. http or https.
  final String publicScheme;

  /// Creates a new [ServerConfig].
  ServerConfig({
    required this.port,
    required this.publicScheme,
    required this.publicHost,
    required this.publicPort,
  });

  factory ServerConfig._fromJson(Map serverSetup, String name) {
    _validateJsonConfig(
      const {
        ServerpodServerConfigMap.port: int,
        ServerpodServerConfigMap.publicHost: String,
        ServerpodServerConfigMap.publicPort: int,
        ServerpodServerConfigMap.publicScheme: String,
      },
      serverSetup,
      name,
    );

    return ServerConfig(
      port: serverSetup[ServerpodServerConfigMap.port],
      publicHost: serverSetup[ServerpodServerConfigMap.publicHost],
      publicPort: serverSetup[ServerpodServerConfigMap.publicPort],
      publicScheme: serverSetup[ServerpodServerConfigMap.publicScheme],
    );
  }

  @override
  String toString() {
    var str = '';
    str += '$_name port: $port\n';
    str += '$_name public host: $publicHost\n';
    str += '$_name public port: $publicPort\n';
    str += '$_name public scheme: $publicScheme\n';

    return str;
  }
}

/// Configuration for a Postgres database,
class DatabaseConfig {
  /// Database host.
  final String host;

  /// Database port.
  final int port;

  /// Database user name.
  final String user;

  /// Database password.
  final String password;

  /// Database name.
  final String name;

  /// True if the database requires an SSL connection.
  final bool requireSsl;

  /// True if the database is running on a unix socket.
  final bool isUnixSocket;

  /// Override the search path all connections to the database.
  final List<String>? searchPaths;

  /// Creates a new [DatabaseConfig].
  DatabaseConfig({
    required this.host,
    required this.port,
    required this.user,
    required this.password,
    required this.name,
    this.requireSsl = false,
    this.isUnixSocket = false,
    this.searchPaths,
  });

  factory DatabaseConfig._fromJson(Map dbSetup, Map passwords, String name) {
    _validateJsonConfig(
      {
        ServerpodEnv.databaseHost.configKey: String,
        ServerpodEnv.databasePort.configKey: int,
        ServerpodEnv.databaseName.configKey: String,
        ServerpodEnv.databaseUser.configKey: String,
      },
      dbSetup,
      name,
    );

    var password = passwords[ServerpodPassword.databasePassword.configKey];
    if (password == null) {
      throw Exception('Missing database password.');
    }

    return DatabaseConfig(
      host: dbSetup[ServerpodEnv.databaseHost.configKey],
      port: dbSetup[ServerpodEnv.databasePort.configKey],
      name: dbSetup[ServerpodEnv.databaseName.configKey],
      user: dbSetup[ServerpodEnv.databaseUser.configKey],
      requireSsl: dbSetup[ServerpodEnv.databaseRequireSsl.configKey] ?? false,
      isUnixSocket:
          dbSetup[ServerpodEnv.databaseIsUnixSocket.configKey] ?? false,
      password: password,
      searchPaths:
          _parseList(dbSetup[ServerpodEnv.databaseSearchPaths.configKey]),
    );
  }

  @override
  String toString() {
    var str = '';
    str += 'database host: $host\n';
    str += 'database port: $port\n';
    str += 'database name: $name\n';
    str += 'database user: $user\n';
    str += 'database require SSL: $requireSsl\n';
    str += 'database unix socket: $isUnixSocket\n';
    str += 'database pass: ********\n';
    if (searchPaths != null) {
      str += 'database search path overrides: $searchPaths\n';
    }
    return str;
  }
}

/// Configuration for Redis.
class RedisConfig {
  /// True if Redis should be enabled.
  final bool enabled;

  /// Redis host.
  final String host;

  /// Redis port.
  final int port;

  /// Redis user name (optional).
  final String? user;

  /// Redis password (optional, but recommended).
  final String? password;

  /// True if Redis requires an SSL connection.
  final bool requireSsl;

  /// Creates a new [RedisConfig].
  RedisConfig({
    required this.enabled,
    required this.host,
    required this.port,
    this.user,
    this.password,
    this.requireSsl = false,
  });

  factory RedisConfig._fromJson(Map redisSetup, Map passwords, String name) {
    _validateJsonConfig(
      {
        ServerpodEnv.redisHost.configKey: String,
        ServerpodEnv.redisPort.configKey: int,
      },
      redisSetup,
      name,
    );

    return RedisConfig(
      enabled: redisSetup[ServerpodEnv.redisEnabled.configKey] ?? false,
      host: redisSetup[ServerpodEnv.redisHost.configKey],
      port: redisSetup[ServerpodEnv.redisPort.configKey],
      user: redisSetup[ServerpodEnv.redisUser.configKey],
      password: passwords[ServerpodPassword.redisPassword.configKey],
      requireSsl: redisSetup[ServerpodEnv.redisRequireSsl.configKey] ?? false,
    );
  }

  @override
  String toString() {
    var str = '';
    str += 'redis host: $host\n';
    str += 'redis port: $port\n';
    if (user != null) {
      str += 'redis user: $user\n';
    }
    if (password != null) {
      str += 'redis pass: ********\n';
    }
    str += 'redis require SSL: $requireSsl\n';
    return str;
  }
}

/// Configuration for future call handling.
class FutureCallConfig {
  /// The maximum number of concurrent running future calls. If the limit is
  /// reached, future calls will be postponed until a slot is available.
  ///
  /// If the limit is `null`, the amount of concurrent future calls will be
  /// unlimited.
  final int? concurrencyLimit;

  /// How long to wait before checking the queue again.
  final Duration scanInterval;

  /// Creates a new [FutureCallConfig].
  const FutureCallConfig({
    this.concurrencyLimit,
    this.scanInterval =
        const Duration(milliseconds: defaultFutureCallScanIntervalMs),
  });

  /// The default concurrency limit for future calls.
  static const int defaultFutureCallConcurrencyLimit = 1;

  /// The default scan interval for future calls.
  static const int defaultFutureCallScanIntervalMs = 5000;

  factory FutureCallConfig._fromJson(Map futureCallConfigJson, String name) {
    final scanInterval =
        futureCallConfigJson[ServerpodEnv.futureCallScanInterval.configKey];

    final hasConcurrencyLimitKey = futureCallConfigJson.containsKey(
      ServerpodEnv.futureCallConcurrencyLimit.configKey,
    );

    int? concurrencyLimit = hasConcurrencyLimitKey
        ? futureCallConfigJson[
            ServerpodEnv.futureCallConcurrencyLimit.configKey]
        : null;

    // If the user sets the concurrency limit to 0 or a negative number, this
    // means to want to enable unlimited concurrency
    if (concurrencyLimit != null && concurrencyLimit < 1) {
      concurrencyLimit = null;
    }

    return FutureCallConfig(
      // If the user did not configure the concurrency limit, use the default
      concurrencyLimit: hasConcurrencyLimitKey
          ? concurrencyLimit
          : defaultFutureCallConcurrencyLimit,
      scanInterval: Duration(
        milliseconds: scanInterval ?? defaultFutureCallScanIntervalMs,
      ),
    );
  }

  @override
  String toString() {
    var output = StringBuffer();
    output.writeln('future call concurrency limit: $concurrencyLimit');
    output
        .writeln('future call scan interval: ${scanInterval.inMilliseconds}ms');
    return output.toString();
  }
}

/// Valid values for console log format.
enum ConsoleLogFormat {
  /// JSON format.
  json,

  /// Human-readable text format.
  text;

  /// Returns a list of all enum names.
  static final List<String> allEnumNames =
      ConsoleLogFormat.values.map((e) => e.name).toList();

  /// Default format for console logging.
  static const defaultFormat = ConsoleLogFormat.json;

  /// Parses a string into a [ConsoleLogFormat].
  static ConsoleLogFormat parse(String value) {
    return ConsoleLogFormat.values.firstWhere(
      (e) => e.name == value,
      orElse: () => throw ArgumentError(
        'Invalid console log format: "$value". Valid values are: ${allEnumNames.join(', ')}',
      ),
    );
  }
}

/// Configuration for session logging.
class SessionLogConfig {
  /// True if persistent logging (e.g., to Redis) should be enabled.
  final bool persistentEnabled;

  /// True if console logging should be enabled.
  final bool consoleEnabled;

  /// The format for the console log.
  final ConsoleLogFormat consoleLogFormat;

  /// Creates a new [SessionLogConfig].
  SessionLogConfig({
    required this.persistentEnabled,
    required this.consoleEnabled,
    ConsoleLogFormat? consoleLogFormat,
  }) : consoleLogFormat = consoleLogFormat ?? ConsoleLogFormat.defaultFormat;

  /// Creates a new default [SessionLogConfig] based on the run mode and
  /// whether the database is enabled.
  factory SessionLogConfig.buildDefault({
    required bool databaseEnabled,
    required String runMode,
  }) {
    return SessionLogConfig(
      persistentEnabled: databaseEnabled,
      consoleEnabled: !databaseEnabled || runMode == _developmentRunMode,
      consoleLogFormat: runMode == _developmentRunMode
          ? ConsoleLogFormat.text
          : ConsoleLogFormat.defaultFormat,
    );
  }

  factory SessionLogConfig._fromJson(
    Map sessionLogConfigJson,
    String name, {
    required bool databaseEnabled,
  }) {
    var configuredLogFormat =
        sessionLogConfigJson[ServerpodEnv.sessionConsoleLogFormat.configKey];

    ConsoleLogFormat logFormat = ConsoleLogFormat.defaultFormat;
    if (configuredLogFormat != null) {
      logFormat = ConsoleLogFormat.parse(configuredLogFormat);
    }

    return SessionLogConfig(
      persistentEnabled: sessionLogConfigJson[
              ServerpodEnv.sessionPersistentLogEnabled.configKey] ??
          false,
      consoleEnabled: sessionLogConfigJson[
              ServerpodEnv.sessionConsoleLogEnabled.configKey] ??
          false,
      consoleLogFormat: logFormat,
    );
  }

  void _validate({
    required bool databaseEnabled,
  }) {
    if (persistentEnabled && !databaseEnabled) {
      throw StateError(
        'The `persistentEnabled` setting was enabled in the configuration, but this project was created without database support. '
        'Persistent logging is only available when the database is enabled.',
      );
    }
  }

  @override
  String toString() {
    return 'session persistent log enabled: $persistentEnabled\n'
        'session console log enabled: $consoleEnabled\n';
  }
}

Map? _insightsConfigMap(
  Map<dynamic, dynamic> configMap,
  Map<String, String> environment,
) {
  var serverConfig = configMap[ServerpodConfigMap.insightsServer] ?? {};

  return _buildConfigMap(serverConfig, environment, [
    (ServerpodEnv.insightsPort, int.parse),
    (ServerpodEnv.insightsPublicHost, null),
    (ServerpodEnv.insightsPublicPort, int.parse),
    (ServerpodEnv.insightsPublicScheme, null),
  ]);
}

Map? _webConfigMap(
  Map<dynamic, dynamic> configMap,
  Map<String, String> environment,
) {
  var serverConfig = configMap[ServerpodConfigMap.webServer] ?? {};

  return _buildConfigMap(serverConfig, environment, [
    (ServerpodEnv.webPort, int.parse),
    (ServerpodEnv.webPublicHost, null),
    (ServerpodEnv.webPublicPort, int.parse),
    (ServerpodEnv.webPublicScheme, null),
  ]);
}

Map? _apiConfigMap(Map configMap, Map<String, String> environment) {
  var serverConfig = configMap[ServerpodConfigMap.apiServer] ?? {};

  return _buildConfigMap(serverConfig, environment, [
    (ServerpodEnv.apiPort, int.parse),
    (ServerpodEnv.apiPublicHost, null),
    (ServerpodEnv.apiPublicPort, int.parse),
    (ServerpodEnv.apiPublicScheme, null),
  ]);
}

Map? _databaseConfigMap(Map configMap, Map<String, String> environment) {
  var databaseConfig = configMap[ServerpodConfigMap.database] ?? {};

  return _buildConfigMap(databaseConfig, environment, [
    (ServerpodEnv.databaseHost, null),
    (ServerpodEnv.databasePort, int.parse),
    (ServerpodEnv.databaseName, null),
    (ServerpodEnv.databaseUser, null),
    (ServerpodEnv.databaseRequireSsl, bool.parse),
    (ServerpodEnv.databaseIsUnixSocket, bool.parse),
    (ServerpodEnv.databaseSearchPaths, null),
  ]);
}

Map? _redisConfigMap(Map configMap, Map<String, String> environment) {
  var redisConfig = configMap[ServerpodConfigMap.redis] ?? {};

  return _buildConfigMap(redisConfig, environment, [
    (ServerpodEnv.redisHost, null),
    (ServerpodEnv.redisPort, int.parse),
    (ServerpodEnv.redisUser, null),
    (ServerpodEnv.redisEnabled, bool.parse),
    (ServerpodEnv.redisRequireSsl, bool.parse),
  ]);
}

Map? _buildSessionLogsConfigMap(
    Map configMap, Map<String, String> environment) {
  var logsConfig = configMap[ServerpodConfigMap.sessionLogs] ?? {};

  return _buildConfigMap(logsConfig, environment, [
    (ServerpodEnv.sessionPersistentLogEnabled, bool.parse),
    (ServerpodEnv.sessionConsoleLogEnabled, bool.parse),
    (ServerpodEnv.sessionConsoleLogFormat, null),
  ]);
}

Map? _buildFutureCallConfigMap(Map configMap, Map<String, String> environment) {
  var futureCallConfig = configMap[ServerpodConfigMap.futureCall] ?? {};

  return _buildConfigMap(futureCallConfig, environment, [
    (ServerpodEnv.futureCallConcurrencyLimit, int.parse),
    (ServerpodEnv.futureCallScanInterval, int.parse),
  ]);
}

Map? _buildConfigMap(
  Map<dynamic, dynamic> serverConfig,
  Map<String, String> environment,
  List<(ServerpodEnv, Convert?)> envEntries,
) {
  Map config = {
    ...serverConfig,
    for (var entry in envEntries)
      ..._extractMapEntry(environment, entry.$1, entry.$2),
  };

  if (config.isEmpty) return null;

  return config;
}

Map<String, dynamic> _extractMapEntry(
  Map<String, String> env,
  ServerpodEnv serverpodEnv, [
  Convert? convert,
]) {
  var content = env[serverpodEnv.envVariable];

  if (content == null) return {};
  if (convert == null) return {serverpodEnv.configKey: content};

  try {
    return {serverpodEnv.configKey: convert.call(content)};
  } catch (e) {
    throw Exception(
      'Invalid value ($content) for ${serverpodEnv.envVariable}.',
    );
  }
}

int _readMaxRequestSize(
  Map<dynamic, dynamic> configMap,
  Map<String, String> environment,
) {
  var maxRequestSize = configMap[ServerpodEnv.maxRequestSize.configKey];
  maxRequestSize =
      environment[ServerpodEnv.maxRequestSize.envVariable] ?? maxRequestSize;

  if (maxRequestSize is String) {
    maxRequestSize = int.tryParse(maxRequestSize);
  }

  maxRequestSize ??= _defaultMaxRequestSize;
  return maxRequestSize;
}

String _readServerId(
  Map<dynamic, dynamic> configMap,
  Map<String, String> environment,
  String serverIdFromCommandLineArg,
) {
  if (serverIdFromCommandLineArg != 'default') {
    return serverIdFromCommandLineArg;
  }
  var serverId = environment[ServerpodEnv.serverId.envVariable] ??
      configMap[ServerpodEnv.serverId.configKey] ??
      'default';
  return serverId;
}

bool _readIsFutureCallExecutionEnabled(
  Map<dynamic, dynamic> configMap,
  Map<String, String> environment,
) {
  var futureCallsExecutionEnabled =
      configMap[ServerpodEnv.futureCallExecutionEnabled.configKey];
  futureCallsExecutionEnabled =
      environment[ServerpodEnv.futureCallExecutionEnabled.envVariable] ??
          futureCallsExecutionEnabled;

  if (futureCallsExecutionEnabled is String) {
    futureCallsExecutionEnabled = bool.tryParse(futureCallsExecutionEnabled);
  }

  futureCallsExecutionEnabled ??= true;
  return futureCallsExecutionEnabled;
}

/// Validates that a JSON configuration contains all required keys, and that
/// the values have the correct types.
///
/// Throws an exception if a key is missing or if the value has the wrong type.
void _validateJsonConfig(
  Map<String, Type> expectedConfiguration,
  Map jsonConfig,
  String name,
) {
  for (var MapEntry(key: key, value: value) in expectedConfiguration.entries) {
    if (!jsonConfig.containsKey(key)) {
      throw Exception('$name is missing required configuration for $key.');
    }

    Object? jsonValue = jsonConfig[key];
    if (jsonValue.runtimeType != value) {
      throw Exception(
        '$name configuration has invalid type for $key. Expected $value, got ${jsonValue.runtimeType}.',
      );
    }
  }
}

/// Parses a comma-separated string into a list of strings.
List<String>? _parseList(String? value) {
  if (value == null) return null;
  return value.split(',').map((e) => e.trim()).toList();
}

/// The configuration keys for the serverpod configuration file.
class _ServerpodApiServerConfigMissing implements Exception {
  @override
  String toString() {
    return 'Serverpod API server configuration is missing.';
  }
}
