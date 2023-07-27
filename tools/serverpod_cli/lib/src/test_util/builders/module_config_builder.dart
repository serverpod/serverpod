import 'package:serverpod_cli/src/config/config.dart';

class ModuleConfigBuilder {
  String _name;
  String _nickname;

  ModuleConfigBuilder(String name, [String? nickname])
      : _name = name,
        _nickname = nickname ?? name;

  ModuleConfigBuilder withNickname(String nickname) {
    _nickname = nickname;
    return this;
  }

  ModuleConfigBuilder withName(String name) {
    _name = name;
    return this;
  }

  ModuleConfig build() {
    return ModuleConfig(name: _name, nickname: _nickname);
  }
}
