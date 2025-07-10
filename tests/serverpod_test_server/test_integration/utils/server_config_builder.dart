import 'package:serverpod_shared/serverpod_shared.dart';

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
