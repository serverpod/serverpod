import 'package:serverpod_shared/serverpod_shared.dart';

class DatabaseConfigBuilder {
  String _host = 'localhost';
  int _port = 8090;
  String _name = 'serverpod_test';
  String _user = 'postgres';
  String _password = 'password';
  bool _requireSsl = false;
  bool _isUnixSocket = false;
  List<String>? _searchPaths;

  DatabaseConfigBuilder();

  DatabaseConfig build() {
    return DatabaseConfig(
      host: _host,
      port: _port,
      name: _name,
      user: _user,
      password: _password,
      requireSsl: _requireSsl,
      isUnixSocket: _isUnixSocket,
      searchPaths: _searchPaths,
    );
  }

  DatabaseConfigBuilder withHost(String host) {
    _host = host;
    return this;
  }

  DatabaseConfigBuilder withPort(int port) {
    _port = port;
    return this;
  }

  DatabaseConfigBuilder withName(String name) {
    _name = name;
    return this;
  }

  DatabaseConfigBuilder withUser(String user) {
    _user = user;
    return this;
  }

  DatabaseConfigBuilder withPassword(String password) {
    _password = password;
    return this;
  }

  DatabaseConfigBuilder withRequireSsl(bool requireSsl) {
    _requireSsl = requireSsl;
    return this;
  }

  DatabaseConfigBuilder withIsUnixSocket(bool isUnixSocket) {
    _isUnixSocket = isUnixSocket;
    return this;
  }

  DatabaseConfigBuilder withSearchPaths(List<String>? searchPaths) {
    _searchPaths = searchPaths;
    return this;
  }
}

class RedisConfigBuilder {
  bool _enabled = false;
  String _host = 'localhost';
  int _port = 8091;
  String? _user;
  String? _password = 'password';
  bool _requireSsl = false;

  RedisConfigBuilder();

  RedisConfig build() {
    return RedisConfig(
      enabled: _enabled,
      host: _host,
      port: _port,
      user: _user,
      password: _password,
      requireSsl: _requireSsl,
    );
  }

  RedisConfigBuilder withEnabled(bool enabled) {
    _enabled = enabled;
    return this;
  }

  RedisConfigBuilder withHost(String host) {
    _host = host;
    return this;
  }

  RedisConfigBuilder withPort(int port) {
    _port = port;
    return this;
  }

  RedisConfigBuilder withUser(String? user) {
    _user = user;
    return this;
  }

  RedisConfigBuilder withPassword(String? password) {
    _password = password;
    return this;
  }

  RedisConfigBuilder withRequireSsl(bool requireSsl) {
    _requireSsl = requireSsl;
    return this;
  }
}

class ServerConfigBuilder {
  int _port = 8080;
  String _publicHost = 'localhost';
  int _publicPort = 8080;
  String _publicScheme = 'http';

  ServerConfigBuilder();

  ServerConfig build() {
    return ServerConfig(
      port: _port,
      publicHost: _publicHost,
      publicPort: _publicPort,
      publicScheme: _publicScheme,
    );
  }

  ServerConfigBuilder withPort(int port) {
    _port = port;
    return this;
  }

  ServerConfigBuilder withPublicHost(String publicHost) {
    _publicHost = publicHost;
    return this;
  }

  ServerConfigBuilder withPublicPort(int publicPort) {
    _publicPort = publicPort;
    return this;
  }

  ServerConfigBuilder withPublicScheme(String publicScheme) {
    _publicScheme = publicScheme;
    return this;
  }
}

class SessionLogConfigBuilder {
  bool _persistentEnabled = true;
  bool _consoleEnabled = true;
  ConsoleLogFormat _consoleLogFormat = ConsoleLogFormat.text;

  SessionLogConfigBuilder();

  SessionLogConfig build() {
    return SessionLogConfig(
      persistentEnabled: _persistentEnabled,
      consoleEnabled: _consoleEnabled,
      consoleLogFormat: _consoleLogFormat,
    );
  }

  SessionLogConfigBuilder withPersistentEnabled(bool persistentEnabled) {
    _persistentEnabled = persistentEnabled;
    return this;
  }

  SessionLogConfigBuilder withConsoleEnabled(bool consoleEnabled) {
    _consoleEnabled = consoleEnabled;
    return this;
  }

  SessionLogConfigBuilder withConsoleLogFormat(ConsoleLogFormat consoleLogFormat) {
    _consoleLogFormat = consoleLogFormat;
    return this;
  }
}

class FutureCallConfigBuilder {
  int? _concurrencyLimit = 1;
  Duration _scanInterval = const Duration(milliseconds: 5000);

  FutureCallConfigBuilder();

  FutureCallConfig build() {
    return FutureCallConfig(
      concurrencyLimit: _concurrencyLimit,
      scanInterval: _scanInterval,
    );
  }

  FutureCallConfigBuilder withConcurrencyLimit(int? concurrencyLimit) {
    _concurrencyLimit = concurrencyLimit;
    return this;
  }

  FutureCallConfigBuilder withScanInterval(Duration scanInterval) {
    _scanInterval = scanInterval;
    return this;
  }
}

class ServerpodConfigBuilder {
  String _runMode = 'development';
  String _serverId = 'default';
  ServerpodRole _role = ServerpodRole.monolith;
  ServerpodLoggingMode _loggingMode = ServerpodLoggingMode.normal;
  bool _applyMigrations = false;
  bool _applyRepairMigration = false;
  int _maxRequestSize = 524288;
  ServerConfig? _apiServer;
  ServerConfig? _insightsServer;
  ServerConfig? _webServer;
  DatabaseConfig? _database;
  RedisConfig? _redis;
  String? _serviceSecret = 'test_service_secret';
  SessionLogConfig? _sessionLogs;
  Duration? _experimentalDiagnosticHandlerTimeout = const Duration(seconds: 30);
  FutureCallConfig _futureCall = const FutureCallConfig();
  bool _futureCallExecutionEnabled = true;

  ServerpodConfigBuilder();

  ServerpodConfig build() {
    return ServerpodConfig(
      runMode: _runMode,
      serverId: _serverId,
      role: _role,
      loggingMode: _loggingMode,
      applyMigrations: _applyMigrations,
      applyRepairMigration: _applyRepairMigration,
      maxRequestSize: _maxRequestSize,
      apiServer: _apiServer ?? ServerpodConfig.createDefaultApiServer(),
      insightsServer: _insightsServer ?? _createDefaultInsightsServer(),
      webServer: _webServer ?? _createDefaultWebServer(),
      database: _database ?? DatabaseConfigBuilder().build(),
      redis: _redis ?? RedisConfigBuilder().build(),
      serviceSecret: _serviceSecret,
      sessionLogs: _sessionLogs ??
          SessionLogConfig.buildDefault(
            databaseEnabled: true,
            runMode: _runMode,
          ),
      experimentalDiagnosticHandlerTimeout:
          _experimentalDiagnosticHandlerTimeout,
      futureCall: _futureCall,
      futureCallExecutionEnabled: _futureCallExecutionEnabled,
    );
  }

  ServerpodConfigBuilder withRunMode(String runMode) {
    _runMode = runMode;
    return this;
  }

  ServerpodConfigBuilder withServerId(String serverId) {
    _serverId = serverId;
    return this;
  }

  ServerpodConfigBuilder withRole(ServerpodRole role) {
    _role = role;
    return this;
  }

  ServerpodConfigBuilder withLoggingMode(ServerpodLoggingMode loggingMode) {
    _loggingMode = loggingMode;
    return this;
  }

  ServerpodConfigBuilder withApplyMigrations(bool applyMigrations) {
    _applyMigrations = applyMigrations;
    return this;
  }

  ServerpodConfigBuilder withApplyRepairMigration(bool applyRepairMigration) {
    _applyRepairMigration = applyRepairMigration;
    return this;
  }

  ServerpodConfigBuilder withMaxRequestSize(int maxRequestSize) {
    _maxRequestSize = maxRequestSize;
    return this;
  }

  ServerpodConfigBuilder withApiServer(ServerConfig apiServer) {
    _apiServer = apiServer;
    return this;
  }

  ServerpodConfigBuilder withApiServerBuilder(ServerConfigBuilder Function(ServerConfigBuilder) builder) {
    _apiServer = builder(ServerConfigBuilder()).build();
    return this;
  }

  ServerpodConfigBuilder withInsightsServer(ServerConfig? insightsServer) {
    _insightsServer = insightsServer;
    return this;
  }

  ServerpodConfigBuilder withWebServer(ServerConfig? webServer) {
    _webServer = webServer;
    return this;
  }

  ServerpodConfigBuilder withDatabase(DatabaseConfig? database) {
    _database = database;
    return this;
  }

  ServerpodConfigBuilder withDatabaseBuilder(DatabaseConfigBuilder Function(DatabaseConfigBuilder) builder) {
    _database = builder(DatabaseConfigBuilder()).build();
    return this;
  }

  ServerpodConfigBuilder withRedis(RedisConfig? redis) {
    _redis = redis;
    return this;
  }

  ServerpodConfigBuilder withRedisBuilder(RedisConfigBuilder Function(RedisConfigBuilder) builder) {
    _redis = builder(RedisConfigBuilder()).build();
    return this;
  }

  ServerpodConfigBuilder withServiceSecret(String? serviceSecret) {
    _serviceSecret = serviceSecret;
    return this;
  }

  ServerpodConfigBuilder withSessionLogs(SessionLogConfig? sessionLogs) {
    _sessionLogs = sessionLogs;
    return this;
  }

  ServerpodConfigBuilder withSessionLogsBuilder(SessionLogConfigBuilder Function(SessionLogConfigBuilder) builder) {
    _sessionLogs = builder(SessionLogConfigBuilder()).build();
    return this;
  }

  ServerpodConfigBuilder withExperimentalDiagnosticHandlerTimeout(
      Duration? timeout) {
    _experimentalDiagnosticHandlerTimeout = timeout;
    return this;
  }

  ServerpodConfigBuilder withFutureCall(FutureCallConfig futureCall) {
    _futureCall = futureCall;
    return this;
  }

  ServerpodConfigBuilder withFutureCallBuilder(FutureCallConfigBuilder Function(FutureCallConfigBuilder) builder) {
    _futureCall = builder(FutureCallConfigBuilder()).build();
    return this;
  }

  ServerpodConfigBuilder withFutureCallExecutionEnabled(bool enabled) {
    _futureCallExecutionEnabled = enabled;
    return this;
  }

  ServerConfig _createDefaultInsightsServer() => ServerConfig(
        port: 8081,
        publicHost: 'localhost',
        publicPort: 8081,
        publicScheme: 'http',
      );

  ServerConfig _createDefaultWebServer() => ServerConfig(
        port: 8082,
        publicHost: 'localhost',
        publicPort: 8082,
        publicScheme: 'http',
      );
}
