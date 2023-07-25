import 'package:serverpod_cli/src/config/config.dart';

class ModuleConfigBuilder {
  late ModuleConfig _config;

  ModuleConfigBuilder(String name, [String? nickname]) {
    _config = ModuleConfig(name: name, nickname: nickname ?? name);
  }

  ModuleConfigBuilder withNickname(String nickname) {
    _config = _config.copyWith(nickname: nickname);
    return this;
  }

  ModuleConfigBuilder withName(String name) {
    _config = _config.copyWith(name: name);
    return this;
  }

  ModuleConfig build() {
    return _config;
  }
}
