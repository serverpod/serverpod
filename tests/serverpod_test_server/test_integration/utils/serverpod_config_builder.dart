import 'package:serverpod_shared/serverpod_shared.dart';

class ServerpodConfigBuilder {
  String _runMode = 'development';
  String _serverId = 'test-server';
  ServerpodRole _role = ServerpodRole.monolith;
  ServerpodLoggingMode _loggingMode = ServerpodLoggingMode.normal;
  bool _applyMigrations = false;
  bool _applyRepairMigration = false;
  int _maxRequestSize = 524288;
  ServerConfig? _apiServer;
  ServerConfig? _insightsServer;
  ServerConfig? _webServer;

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
      apiServer: _apiServer ??
          ServerConfig(
            port: 8080,
            publicHost: 'localhost',
            publicPort: 8080,
            publicScheme: 'http',
          ),
      insightsServer: _insightsServer,
      webServer: _webServer,
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

  ServerpodConfigBuilder withInsightsServer(ServerConfig? insightsServer) {
    _insightsServer = insightsServer;
    return this;
  }

  ServerpodConfigBuilder withWebServer(ServerConfig? webServer) {
    _webServer = webServer;
    return this;
  }
}