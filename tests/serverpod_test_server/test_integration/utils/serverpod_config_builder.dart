import 'package:serverpod_shared/serverpod_shared.dart';

import 'database_config_builder.dart';
import 'future_call_config_builder.dart';
import 'redis_config_builder.dart';
import 'server_config_builder.dart';
import 'session_log_config_builder.dart';

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
      apiServer: _apiServer ?? _createDefaultApiServer(),
      insightsServer: _insightsServer ?? _createDefaultInsightsServer(),
      webServer: _webServer ?? _createDefaultWebServer(),
      database: _database ?? DatabaseConfigBuilder().build(),
      redis: _redis ?? RedisConfigBuilder().build(),
      serviceSecret: _serviceSecret,
      sessionLogs:
          _sessionLogs ??
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

  ServerpodConfigBuilder withApiServerBuilder(
    ServerConfigBuilder Function(ServerConfigBuilder) builder,
  ) {
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

  ServerpodConfigBuilder withDatabaseBuilder(
    DatabaseConfigBuilder Function(DatabaseConfigBuilder) builder,
  ) {
    _database = builder(DatabaseConfigBuilder()).build();
    return this;
  }

  ServerpodConfigBuilder withRedis(RedisConfig? redis) {
    _redis = redis;
    return this;
  }

  ServerpodConfigBuilder withRedisBuilder(
    RedisConfigBuilder Function(RedisConfigBuilder) builder,
  ) {
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

  ServerpodConfigBuilder withSessionLogsBuilder(
    SessionLogConfigBuilder Function(SessionLogConfigBuilder) builder,
  ) {
    _sessionLogs = builder(SessionLogConfigBuilder()).build();
    return this;
  }

  ServerpodConfigBuilder withExperimentalDiagnosticHandlerTimeout(
    Duration? timeout,
  ) {
    _experimentalDiagnosticHandlerTimeout = timeout;
    return this;
  }

  ServerpodConfigBuilder withFutureCall(FutureCallConfig futureCall) {
    _futureCall = futureCall;
    return this;
  }

  ServerpodConfigBuilder withFutureCallBuilder(
    FutureCallConfigBuilder Function(FutureCallConfigBuilder) builder,
  ) {
    _futureCall = builder(FutureCallConfigBuilder()).build();
    return this;
  }

  ServerpodConfigBuilder withFutureCallExecutionEnabled(bool enabled) {
    _futureCallExecutionEnabled = enabled;
    return this;
  }

  ServerConfig _createDefaultApiServer() => ServerConfig(
    port: 8080,
    publicHost: 'localhost',
    publicPort: 8080,
    publicScheme: 'http',
  );

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
