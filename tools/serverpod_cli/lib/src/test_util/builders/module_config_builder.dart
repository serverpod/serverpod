import 'package:serverpod_cli/src/config/config.dart';

class ModuleConfigBuilder {
  String _name;
  String _nickname;
  List<String> _migrationVersions;

  ModuleConfigBuilder(String name, [String? nickname])
      : _name = name,
        _nickname = nickname ?? name,
        _migrationVersions = [];

  ModuleConfigBuilder withNickname(String nickname) {
    _nickname = nickname;
    return this;
  }

  ModuleConfigBuilder withName(String name) {
    _name = name;
    return this;
  }

  ModuleConfigBuilder withMigrationVersions(List<String> migrationVersions) {
    _migrationVersions = migrationVersions;
    return this;
  }

  ModuleConfig build() {
    return ModuleConfig(
      name: _name,
      nickname: _nickname,
      migrationVersions: _migrationVersions,
    );
  }
}
