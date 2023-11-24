import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/generator/types.dart';

const _defaultName = 'example';
const _defaultType = PackageType.server;

class GeneratorConfigBuilder {
  String _name;
  PackageType _type;
  String _serverPackage;
  String _dartClientPackage;
  bool _dartClientDependsOnServiceClient;
  List<String> _serverPackageDirectoryPathParts;
  List<String> _relativeDartClientPackagePathParts;
  List<ModuleConfig> _modules;
  List<TypeDefinition> _extraClasses;

  GeneratorConfigBuilder()
      : _name = _defaultName,
        _type = _defaultType,
        _serverPackage = 'example_server',
        _dartClientPackage = 'example_client',
        _dartClientDependsOnServiceClient = false,
        _serverPackageDirectoryPathParts = [],
        _relativeDartClientPackagePathParts = ['..', 'example_client'],
        _modules = [
          ModuleConfig(
            type: PackageType.internal,
            name: 'serverpod',
            nickname: 'serverpod',
            migrationVersions: ['0000000000000000000'],
          ),
          ModuleConfig(
            type: _defaultType,
            name: _defaultName,
            nickname: _defaultName,
            migrationVersions: ['0000000000000000000'],
          ),
        ],
        _extraClasses = [];

  GeneratorConfigBuilder withName(String name) {
    _name = name;
    _serverPackage = '${name}_server';
    _dartClientPackage = '${name}_client';
    _relativeDartClientPackagePathParts = ['..', '${name}_client'];
    return this;
  }

  GeneratorConfigBuilder withPackageType(PackageType type) {
    _type = type;
    return this;
  }

  GeneratorConfigBuilder withDartClientDependsOnServiceClient(
      bool dartClientDependsOnServiceClient) {
    _dartClientDependsOnServiceClient = dartClientDependsOnServiceClient;
    return this;
  }

  GeneratorConfigBuilder withServerPackageDirectoryPathParts(
      List<String> serverPackageDirectoryPathParts) {
    _serverPackageDirectoryPathParts = serverPackageDirectoryPathParts;
    return this;
  }

  GeneratorConfigBuilder withRelativeDartClientPackagePathParts(
      List<String> relativeDartClientPackagePathParts) {
    _relativeDartClientPackagePathParts = relativeDartClientPackagePathParts;
    return this;
  }

  GeneratorConfigBuilder withAuthModule() {
    _modules.add(
      ModuleConfig(
        type: PackageType.module,
        name: 'serverpod_auth',
        nickname: 'auth',
        migrationVersions: ['0000000000000000000'],
      ),
    );
    return this;
  }

  GeneratorConfigBuilder withModules(List<ModuleConfig> modules) {
    _modules = modules;
    return this;
  }

  GeneratorConfigBuilder withExtraClasses(List<TypeDefinition> extraClasses) {
    _extraClasses = extraClasses;
    return this;
  }

  GeneratorConfig build() {
    return GeneratorConfig(
      name: _name,
      type: _type,
      serverPackage: _serverPackage,
      dartClientPackage: _dartClientPackage,
      dartClientDependsOnServiceClient: _dartClientDependsOnServiceClient,
      serverPackageDirectoryPathParts: _serverPackageDirectoryPathParts,
      relativeDartClientPackagePathParts: _relativeDartClientPackagePathParts,
      modules: _modules,
      extraClasses: _extraClasses,
    );
  }
}
