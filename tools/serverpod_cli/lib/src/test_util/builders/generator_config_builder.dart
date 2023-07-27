import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/generator/types.dart';

class GeneratorConfigBuilder {
  GeneratorConfig _config;

  GeneratorConfigBuilder()
      : _config = const GeneratorConfig(
          name: 'example',
          type: PackageType.server,
          serverPackage: 'example_server',
          dartClientPackage: 'example_client',
          dartClientDependsOnServiceClient: false,
          serverPackageDirectoryPathParts: [],
          relativeDartClientPackagePathParts: [
            '..',
            'example_client',
          ],
          modules: [],
          extraClasses: [],
        );

  GeneratorConfigBuilder withName(String name) {
    _config = _config.copyWith(
      name: name,
      serverPackage: '${name}_server',
      dartClientPackage: '${name}_client',
      relativeDartClientPackagePathParts: ['..', '${name}_client'],
    );
    return this;
  }

  GeneratorConfigBuilder withPackageType(PackageType type) {
    _config = _config.copyWith(type: type);
    return this;
  }

  GeneratorConfigBuilder withDartClientDependsOnServiceClient(
      bool dartClientDependsOnServiceClient) {
    _config = _config.copyWith(
        dartClientDependsOnServiceClient: dartClientDependsOnServiceClient);
    return this;
  }

  GeneratorConfigBuilder withServerPackageDirectoryPathParts(
      List<String> serverPackageDirectoryPathParts) {
    _config = _config.copyWith(
        serverPackageDirectoryPathParts: serverPackageDirectoryPathParts);
    return this;
  }

  GeneratorConfigBuilder withRelativeDartClientPackagePathParts(
      List<String> relativeDartClientPackagePathParts) {
    _config = _config.copyWith(
        relativeDartClientPackagePathParts: relativeDartClientPackagePathParts);
    return this;
  }

  GeneratorConfigBuilder withAuthModule() {
    _config = _config.copyWith(
      modules: _config.modules +
          [
            ModuleConfig(
              name: 'serverpod_auth',
              nickname: 'auth',
            ),
          ],
    );
    return this;
  }

  GeneratorConfigBuilder withModules(List<ModuleConfig> modules) {
    _config = _config.copyWith(modules: _config.modules + modules);
    return this;
  }

  GeneratorConfigBuilder withExtraClasses(List<TypeDefinition> extraClasses) {
    _config = _config.copyWith(
      extraClasses: _config.extraClasses + extraClasses,
    );
    return this;
  }

  GeneratorConfig build() {
    return _config;
  }
}
