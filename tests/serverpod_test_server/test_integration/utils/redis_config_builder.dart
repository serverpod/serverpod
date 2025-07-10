import 'package:serverpod_shared/serverpod_shared.dart';

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
