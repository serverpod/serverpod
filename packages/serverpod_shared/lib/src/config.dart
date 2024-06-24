import 'dart:io';

import 'package:serverpod_shared/src/environment_variables.dart';
import 'package:yaml/yaml.dart';
import 'package:path/path.dart' as path;

/// The configuration sections for the serverpod configuration file.
typedef Convert<T> = T Function(String value);

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

  /// Creates a new [ServerpodConfig].
  ServerpodConfig({
    required this.apiServer,
    this.runMode = 'development',
    this.serverId = 'default',
    this.maxRequestSize = 524288,
    this.insightsServer,
    this.webServer,
    this.database,
    this.redis,
    this.serviceSecret,
  }) {
    apiServer._name = 'api';
    insightsServer?._name = 'insights';
    webServer?._name = 'web';
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
    Map configMap,
    Map<String, String> environment,
  ) {
    /// Get api server setup. This field cannot be null, so if the
    /// configuration is missing an exception is thrown.
    var apiConfig = _apiConfigMap(configMap, environment);
    if (apiConfig == null) {
      throw Exception('${ServerpodConfigMap.apiServer} is missing in config');
    }

    var apiServer = ServerConfig._fromJson(
      apiConfig,
      ServerpodConfigMap.apiServer,
    );

    /// Get insights server setup
    var insightsConfig = _insightsConfigMap(configMap, environment);
    var insightsServer = insightsConfig != null
        ? ServerConfig._fromJson(
            insightsConfig,
            ServerpodConfigMap.insightsServer,
          )
        : null;

    /// Get web server setup
    var webConfig = _webConfigMap(configMap, environment);
    var webServer = webConfig != null
        ? ServerConfig._fromJson(
            webConfig,
            ServerpodConfigMap.webServer,
          )
        : null;

    // Get max request size (default to 512kb)
    var maxRequestSize = configMap[ServerpodEnv.maxRequestSize.key] ?? 524288;

    var serviceSecret = passwords[ServerpodPassword.serviceSecret.key];

    // Get database setup
    var dbSetup = configMap[ServerpodConfigMap.database];
    var database = dbSetup != null
        ? DatabaseConfig._fromJson(
            dbSetup,
            passwords,
            ServerpodConfigMap.database,
          )
        : null;

    // Get Redis setup
    var redisSetup = configMap[ServerpodConfigMap.redis];
    var redis = redisSetup != null
        ? RedisConfig._fromJson(
            redisSetup,
            passwords,
            ServerpodConfigMap.redis,
          )
        : null;

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
    );
  }

  /// Loads and parses a server configuration file. Picks config file depending
  /// on run mode.
  factory ServerpodConfig.load(
    String runMode,
    String serverId,
    Map<String, String> passwords,
  ) {
    String data;

    data = File(_createConfigPath(runMode)).readAsStringSync();

    var doc = loadYaml(data);
    return ServerpodConfig.loadFromMap(
      runMode,
      serverId,
      passwords,
      doc,
      Platform.environment,
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

  /// Creates a new [DatabaseConfig].
  DatabaseConfig({
    required this.host,
    required this.port,
    required this.user,
    required this.password,
    required this.name,
    this.requireSsl = false,
    this.isUnixSocket = false,
  });

  factory DatabaseConfig._fromJson(Map dbSetup, Map passwords, String name) {
    _validateJsonConfig(
      {
        ServerpodEnv.databaseHost.key: String,
        ServerpodEnv.databasePort.key: int,
        ServerpodEnv.databaseName.key: String,
        ServerpodEnv.databaseUser.key: String,
      },
      dbSetup,
      name,
    );

    var password = passwords[ServerpodPassword.databasePassword.key];
    if (password == null) {
      throw Exception('Missing database password.');
    }

    return DatabaseConfig(
      host: dbSetup[ServerpodEnv.databaseHost.key],
      port: dbSetup[ServerpodEnv.databasePort.key],
      name: dbSetup[ServerpodEnv.databaseName.key],
      user: dbSetup[ServerpodEnv.databaseUser.key],
      requireSsl: dbSetup[ServerpodEnv.databaseRequireSsl.key] ?? false,
      isUnixSocket: dbSetup[ServerpodEnv.databaseIsUnixSocket.key] ?? false,
      password: password,
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

  /// Creates a new [RedisConfig].
  RedisConfig({
    required this.enabled,
    required this.host,
    required this.port,
    this.user,
    this.password,
  });

  factory RedisConfig._fromJson(Map redisSetup, Map passwords, String name) {
    _validateJsonConfig(
      {
        ServerpodEnv.redisHost.key: String,
        ServerpodEnv.redisPort.key: int,
      },
      redisSetup,
      name,
    );

    return RedisConfig(
      enabled: redisSetup[ServerpodEnv.redisEnabled.key] ?? false,
      host: redisSetup[ServerpodEnv.redisHost.key],
      port: redisSetup[ServerpodEnv.redisPort.key],
      user: redisSetup[ServerpodEnv.redisUser.key],
      password: passwords[ServerpodPassword.redisPassword.key],
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
    return str;
  }
}

Map? _insightsConfigMap(
  Map<dynamic, dynamic> configMap,
  Map<String, String> environment,
) {
  var serverConfig = configMap[ServerpodConfigMap.insightsServer] ?? {};

  Map config = {
    ...serverConfig,
    ..._extractMapEntry(environment, ServerpodEnv.insightsPort, int.parse),
    ..._extractMapEntry(environment, ServerpodEnv.insightsPublicHost),
    ..._extractMapEntry(
      environment,
      ServerpodEnv.insightsPublicPort,
      int.parse,
    ),
    ..._extractMapEntry(environment, ServerpodEnv.insightsPublicScheme),
  };

  if (config.isEmpty) return null;

  return config;
}

Map? _webConfigMap(
  Map<dynamic, dynamic> configMap,
  Map<String, String> environment,
) {
  var serverConfig = configMap[ServerpodConfigMap.webServer] ?? {};

  Map config = {
    ...serverConfig,
    ..._extractMapEntry(environment, ServerpodEnv.webPort, int.parse),
    ..._extractMapEntry(environment, ServerpodEnv.webPublicHost),
    ..._extractMapEntry(environment, ServerpodEnv.webPublicPort, int.parse),
    ..._extractMapEntry(environment, ServerpodEnv.webPublicScheme),
  };

  if (config.isEmpty) return null;

  return config;
}

Map? _apiConfigMap(Map configMap, Map<String, String> environment) {
  var serverConfig = configMap[ServerpodConfigMap.apiServer] ?? {};

  Map config = {
    ...serverConfig,
    ..._extractMapEntry(environment, ServerpodEnv.apiPort, int.parse),
    ..._extractMapEntry(environment, ServerpodEnv.apiPublicHost),
    ..._extractMapEntry(environment, ServerpodEnv.apiPublicPort, int.parse),
    ..._extractMapEntry(environment, ServerpodEnv.apiPublicScheme),
  };

  if (config.isEmpty) return null;

  return config;
}

Map<String, dynamic> _extractMapEntry(
  Map<String, String> env,
  ServerpodEnv serverpodEnv, [
  Convert? convert,
]) {
  var content = env[serverpodEnv.variable];

  if (content == null) return {};

  return {serverpodEnv.key: convert?.call(content) ?? content};
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

    if (jsonConfig[key].runtimeType != value) {
      throw Exception(
        '$name configuration has invalid type for $key. Expected $value, got ${jsonConfig[key].runtimeType}.',
      );
    }
  }
}
