import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:yaml/yaml.dart';

/// The configuration sections for the serverpod configuration file.
typedef Convert<T> = T Function(String value);

const int _defaultMaxRequestSize = 524288;

const String _developmentRunMode = 'development';

ServerConfig _createDefaultApiServer() => ServerConfig(
      port: 8080,
      publicHost: 'localhost',
      publicPort: 8080,
      publicScheme: 'http',
    );

/// Parser for the Serverpod configuration file.
class ServerpodConfig {
  /// The servers run mode.
  final String runMode;

  /// The servers role.
  final ServerpodRole role;

  /// Id of the current server.
  final String serverId;

  /// The servers logging mode.
  final ServerpodLoggingMode loggingMode;

  /// Whether to apply database migrations.
  final bool applyMigrations;

  /// Whether to apply database repair migration.
  late final bool applyRepairMigration;

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
    this.role = ServerpodRole.monolith,
    this.loggingMode = ServerpodLoggingMode.normal,
    this.applyMigrations = false,
    this.applyRepairMigration = false,
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
      apiServer: _createDefaultApiServer(),
    );
  }

  /// Creates a new [ServerpodConfig] from a configuration Map.
  /// Expects the Map to match the specified run mode.
  ///
  /// Throws an exception if the configuration is missing required fields.
  factory ServerpodConfig.loadFromMap(
    String runMode,
    String? serverId,
    Map<String, String> passwords,
    Map configMap, {
    Map<String, String> environment = const {},
    Map<String, dynamic>? commandLineArgs,
  }) {
    serverId = _readServerId(configMap, environment, serverId);
    final role = _readRole(configMap, environment, commandLineArgs);
    final loggingMode =
        _readLoggingMode(configMap, environment, commandLineArgs);
    final applyMigrations = _readApplyMigrations(
      configMap,
      environment,
      commandLineArgs,
    );
    final applyRepairMigration = _readApplyRepairMigration(
      configMap,
      environment,
      commandLineArgs,
    );

    var apiConfig = _apiConfigMap(configMap, environment);

    var apiServer = apiConfig != null
        ? ServerConfig._fromJson(
            apiConfig,
            ServerpodConfigMap.apiServer,
          )
        : _createDefaultApiServer();

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
        : const FutureCallConfig();

    var futureCallExecutionEnabled =
        _readIsFutureCallExecutionEnabled(configMap, environment);

    return ServerpodConfig(
      runMode: runMode,
      serverId: serverId,
      role: role,
      loggingMode: loggingMode,
      applyMigrations: applyMigrations,
      applyRepairMigration: applyRepairMigration,
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
    String? serverId,
    Map<String, String> passwords, {
    Map<String, dynamic>? commandLineArgs,
  }) {
    dynamic doc = {};

    if (isConfigAvailable(runMode)) {
      String data = File(_createConfigPath(runMode)).readAsStringSync();
      doc = loadYaml(data);
    }

    return ServerpodConfig.loadFromMap(
      runMode,
      serverId,
      passwords,
      doc,
      environment: Platform.environment,
      commandLineArgs: commandLineArgs,
    );
  }

  /// Creates a copy of this [ServerpodConfig] with the given fields replaced.
  /// All fields that are not specified will keep their original values.
  ///
  /// Note that passing null for a field will not remove/nullify that field -
  /// the original value will be retained. To explicitly set a field to null,
  /// create a new [ServerpodConfig] instance instead of using copyWith.
  ServerpodConfig copyWith({
    ServerConfig? apiServer,
    String? runMode,
    String? serverId,
    ServerpodRole? role,
    ServerpodLoggingMode? loggingMode,
    bool? applyMigrations,
    bool? applyRepairMigration,
    int? maxRequestSize,
    ServerConfig? insightsServer,
    ServerConfig? webServer,
    DatabaseConfig? database,
    RedisConfig? redis,
    String? serviceSecret,
    SessionLogConfig? sessionLogs,
    Duration? experimentalDiagnosticHandlerTimeout,
    FutureCallConfig? futureCall,
    bool? futureCallExecutionEnabled,
  }) {
    return ServerpodConfig(
      apiServer: apiServer ?? this.apiServer,
      runMode: runMode ?? this.runMode,
      serverId: serverId ?? this.serverId,
      role: role ?? this.role,
      loggingMode: loggingMode ?? this.loggingMode,
      applyMigrations: applyMigrations ?? this.applyMigrations,
      applyRepairMigration: applyRepairMigration ?? this.applyRepairMigration,
      maxRequestSize: maxRequestSize ?? this.maxRequestSize,
      insightsServer: insightsServer ?? this.insightsServer,
      webServer: webServer ?? this.webServer,
      database: database ?? this.database,
      redis: redis ?? this.redis,
      serviceSecret: serviceSecret ?? this.serviceSecret,
      sessionLogs: sessionLogs ?? this.sessionLogs,
      experimentalDiagnosticHandlerTimeout:
          experimentalDiagnosticHandlerTimeout ??
              this.experimentalDiagnosticHandlerTimeout,
      futureCall: futureCall ?? this.futureCall,
      futureCallExecutionEnabled:
          futureCallExecutionEnabled ?? this.futureCallExecutionEnabled,
    );
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
    this.concurrencyLimit = defaultFutureCallConcurrencyLimit,
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
  String? serverIdFromCommandLineArg,
) {
  if (serverIdFromCommandLineArg != null) {
    return serverIdFromCommandLineArg;
  }

  final serverId = environment[ServerpodEnv.serverId.envVariable] ??
      configMap[ServerpodEnv.serverId.configKey] ??
      'default';
  return serverId;
}

ServerpodRole _readRole(
  Map<dynamic, dynamic> configMap,
  Map<String, String> environment,
  Map<String, dynamic>? commandLineArgs,
) {
  final commandLineArg = commandLineArgs?[CliArgsConstants.role];
  if (commandLineArg != null) {
    if (commandLineArg is! ServerpodRole) {
      throw ArgumentError(
        'Invalid type for ${CliArgsConstants.role} from command line argument: ${commandLineArg.runtimeType}. '
        'Expected ServerpodRole.',
      );
    }
    return commandLineArg;
  }

  final envVariable = ServerpodEnv.role.envVariable;
  final roleFromEnv = environment[envVariable];
  if (roleFromEnv != null) {
    return ServerpodRole.values.firstWhere(
      (e) => e.name == roleFromEnv,
      orElse: () => throw ArgumentError(
        'Invalid $envVariable from environment variable: $roleFromEnv. '
        'Valid values are: ${ServerpodRole.values.map((e) => e.name).join(', ')}',
      ),
    );
  }

  final configKey = ServerpodEnv.role.configKey;
  final roleFromConfig = configMap[configKey];
  if (roleFromConfig != null) {
    return ServerpodRole.values.firstWhere(
      (e) => e.name == roleFromConfig,
      orElse: () => throw ArgumentError(
        'Invalid $configKey from configuration: $roleFromConfig. '
        'Valid values are: ${ServerpodRole.values.map((e) => e.name).join(', ')}',
      ),
    );
  }

  return ServerpodRole.monolith;
}

ServerpodLoggingMode _readLoggingMode(
  Map<dynamic, dynamic> configMap,
  Map<String, String> environment,
  Map<String, dynamic>? commandLineArgs,
) {
  final commandLineArg = commandLineArgs?[CliArgsConstants.loggingMode];
  if (commandLineArg != null) {
    if (commandLineArg is! ServerpodLoggingMode) {
      throw ArgumentError(
        'Invalid type for ${CliArgsConstants.loggingMode} '
        'from command line argument: ${commandLineArg.runtimeType}. '
        'Expected ServerpodLoggingMode.',
      );
    }
    return commandLineArg;
  }

  final envVariable = ServerpodEnv.loggingMode.envVariable;
  final loggingModeFromEnv = environment[envVariable];
  if (loggingModeFromEnv != null) {
    return ServerpodLoggingMode.values.firstWhere(
      (e) => e.name == loggingModeFromEnv,
      orElse: () => throw ArgumentError(
        'Invalid $envVariable from environment variable: $loggingModeFromEnv. '
        'Valid values are: ${ServerpodLoggingMode.values.map((e) => e.name).join(', ')}',
      ),
    );
  }

  final configKey = ServerpodEnv.loggingMode.configKey;
  final loggingModeFromConfig = configMap[configKey];
  if (loggingModeFromConfig != null) {
    return ServerpodLoggingMode.values.firstWhere(
      (e) => e.name == loggingModeFromConfig,
      orElse: () => throw ArgumentError(
        'Invalid $configKey from configuration: $loggingModeFromConfig. '
        'Valid values are: ${ServerpodLoggingMode.values.map((e) => e.name).join(', ')}',
      ),
    );
  }

  return ServerpodLoggingMode.normal;
}

bool _readApplyMigrations(
  Map<dynamic, dynamic> configMap,
  Map<String, String> environment,
  Map<String, dynamic>? commandLineArgs,
) {
  final commandLineArg = commandLineArgs?[CliArgsConstants.applyMigrations];
  if (commandLineArg != null) {
    if (commandLineArg is! bool) {
      throw ArgumentError(
        'Invalid type for ${CliArgsConstants.applyMigrations} '
        'from command line argument: ${commandLineArg.runtimeType}. '
        'Expected bool.',
      );
    }
    return commandLineArg;
  }

  final envVariable = ServerpodEnv.applyMigrations.envVariable;
  final applyMigrationsFromEnv = environment[envVariable];
  if (applyMigrationsFromEnv != null) {
    return switch (applyMigrationsFromEnv) {
      'true' || 'false' => bool.parse(applyMigrationsFromEnv),
      _ => throw ArgumentError(
          'Invalid $envVariable from environment variable: $applyMigrationsFromEnv. '
          'Valid values are: true, false',
        ),
    };
  }

  final configKey = ServerpodEnv.applyMigrations.configKey;
  final applyMigrationsFromConfig = configMap[configKey];
  if (applyMigrationsFromConfig != null) {
    if (applyMigrationsFromConfig is bool) {
      return applyMigrationsFromConfig;
    }
    return switch (applyMigrationsFromConfig.toString()) {
      'true' || 'false' => bool.parse(applyMigrationsFromConfig.toString()),
      _ => throw ArgumentError(
          'Invalid $configKey from configuration: $applyMigrationsFromConfig. '
          'Valid values are: true, false',
        ),
    };
  }

  return false;
}

bool _readApplyRepairMigration(
  Map<dynamic, dynamic> configMap,
  Map<String, String> environment,
  Map<String, dynamic>? commandLineArgs,
) {
  final commandLineArg =
      commandLineArgs?[CliArgsConstants.applyRepairMigration];
  if (commandLineArg != null) {
    if (commandLineArg is! bool) {
      throw ArgumentError(
        'Invalid type for ${CliArgsConstants.applyRepairMigration} '
        'from command line argument: ${commandLineArg.runtimeType}. '
        'Expected bool.',
      );
    }
    return commandLineArg;
  }

  final envVariable = ServerpodEnv.applyRepairMigration.envVariable;
  final applyRepairMigrationFromEnv = environment[envVariable];
  if (applyRepairMigrationFromEnv != null) {
    return switch (applyRepairMigrationFromEnv) {
      'true' || 'false' => bool.parse(applyRepairMigrationFromEnv),
      _ => throw ArgumentError(
          'Invalid $envVariable from environment variable: $applyRepairMigrationFromEnv. '
          'Valid values are: true, false',
        ),
    };
  }

  final configKey = ServerpodEnv.applyRepairMigration.configKey;
  final applyRepairMigrationFromConfig = configMap[configKey];
  if (applyRepairMigrationFromConfig != null) {
    if (applyRepairMigrationFromConfig is bool) {
      return applyRepairMigrationFromConfig;
    }
    return switch (applyRepairMigrationFromConfig.toString()) {
      'true' ||
      'false' =>
        bool.parse(applyRepairMigrationFromConfig.toString()),
      _ => throw ArgumentError(
          'Invalid $configKey from configuration: $applyRepairMigrationFromConfig. '
          'Valid values are: true, false',
        ),
    };
  }

  return false;
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
