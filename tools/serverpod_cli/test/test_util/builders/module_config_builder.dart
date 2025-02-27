import 'package:serverpod_cli/src/config/config.dart';

class ModuleConfigBuilder {
  PackageType _type;
  String _name;
  String _nickname;
  List<String> _migrationVersions;
  List<String> _serverPackageDirectoryPathParts;

  ModuleConfigBuilder(String name, [String? nickname])
      : _name = name,
        _nickname = nickname ?? name,
        _migrationVersions = [],
        _type = PackageType.module,
        _serverPackageDirectoryPathParts = [];

  ModuleConfigBuilder withType(PackageType type) {
    _type = type;
    return this;
  }

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

  ModuleConfigBuilder withServerPackageDirectoryPathParts(
      List<String> serverPackageDirectoryPathParts) {
    _serverPackageDirectoryPathParts = serverPackageDirectoryPathParts;
    return this;
  }

  ModuleConfig build() {
    return ModuleConfig(
      type: _type,
      name: _name,
      nickname: _nickname,
      migrationVersions: _migrationVersions,
      serverPackageDirectoryPathParts: _serverPackageDirectoryPathParts,
    );
  }
}
