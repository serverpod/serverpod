import 'package:serverpod_cli/analyzer.dart';

class ModuleConfigEntry {
  final String _moduleName;
  final String _nickname;

  ModuleConfigEntry(this._moduleName, this._nickname);
}

class GeneratorConfigFileBuilder {
  PackageType _type;
  String? _nickname;
  String _clientPackagePath;
  String? _serverTestToolsPath;
  List<ModuleConfigEntry> _modules;

  GeneratorConfigFileBuilder()
    : _type = PackageType.server,
      _nickname = null,
      _clientPackagePath = '../example_client',
      _serverTestToolsPath = '../server_test_tools',
      _modules = [];

  GeneratorConfigFileBuilder withType(PackageType type) {
    _type = type;
    return this;
  }

  GeneratorConfigFileBuilder withNickname(String nickname) {
    _nickname = nickname;
    return this;
  }

  GeneratorConfigFileBuilder withClientPackagePath(String clientPackagePath) {
    _clientPackagePath = clientPackagePath;
    return this;
  }

  GeneratorConfigFileBuilder withServerTestToolsPath(
    String? serverTestToolsPath,
  ) {
    _serverTestToolsPath = serverTestToolsPath;
    return this;
  }

  GeneratorConfigFileBuilder addModule(ModuleConfigEntry module) {
    _modules.add(module);
    return this;
  }

  GeneratorConfigFileBuilder withModules(List<ModuleConfigEntry> modules) {
    _modules = modules;
    return this;
  }

  String build() {
    var buffer = StringBuffer();
    buffer.writeln('type: ${_type.name}');
    if (_nickname != null) {
      buffer.writeln('nickname: $_nickname');
    }

    buffer.writeln();
    buffer.writeln('client_package_path: $_clientPackagePath');

    if (_serverTestToolsPath != null) {
      buffer.writeln('server_test_tools_path: $_serverTestToolsPath');
    }

    if (_modules.isNotEmpty) {
      buffer.writeln();
      buffer.writeln('modules:');
      for (var module in _modules) {
        buffer.writeln('  ${module._moduleName}');
        buffer.writeln('    nickname: ${module._nickname}');
      }
    }

    return buffer.toString();
  }
}
