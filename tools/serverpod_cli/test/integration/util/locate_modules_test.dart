import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/util/locate_modules.dart';
import 'package:test/test.dart';

import '../../test_util/builders/project_dependency_factory.dart';

void main() {
  test(
    'Given serverpod module dependency when loading modules then module configuration is loaded',
    () async {
      const moduleName = 'module_server';

      var ProjectDependencyContext(
        :packageConfig,
        :projectPubspec,
      ) = await ProjectDependencyStructureFactory()
          .addProjectDependency(moduleName)
          .addModuleProject(ModuleProjectBuilder().withName(moduleName).build())
          .addPackageToPackageConfig(moduleName)
          .construct();

      var moduleConfigs = loadModuleConfigs(
        projectPubspec: projectPubspec,
        packageConfig: packageConfig,
      );

      expect(moduleConfigs, hasLength(1));
      expect(moduleConfigs.first.serverPackage, moduleName);
    },
  );

  test(
    'Given serverpod module dependency with transitive serverpod module dependency when loading modules then module configuration for both modules are loaded',
    () async {
      const moduleName = 'module_server';
      const transitiveModuleName = 'transitive_module_server';

      var ProjectDependencyContext(
        :packageConfig,
        :projectPubspec,
      ) = await ProjectDependencyStructureFactory()
          .addProjectDependency(moduleName)
          .withModuleProjects([
            ModuleProjectBuilder().withName(moduleName).withPubspecDependencies(
              [transitiveModuleName],
            ).build(),
            ModuleProjectBuilder().withName(transitiveModuleName).build(),
          ])
          .addPackageToPackageConfig(moduleName)
          .addPackageToPackageConfig(transitiveModuleName)
          .construct();

      var moduleConfigs = loadModuleConfigs(
        projectPubspec: projectPubspec,
        packageConfig: packageConfig,
      );

      expect(moduleConfigs, hasLength(2));
      expect(moduleConfigs.first.serverPackage, moduleName);
      expect(moduleConfigs.last.serverPackage, transitiveModuleName);
    },
  );

  test(
    'Given serverpod module dependency with deeply nested transitive serverpod module dependency when loading modules then module configuration for all modules are loaded',
    () async {
      const moduleName = 'module_server';
      const firstTransitiveModuleName = 'first_transitive_module_server';
      const secondTransitiveModuleName = 'second_transitive_module_server';

      var ProjectDependencyContext(
        :packageConfig,
        :projectPubspec,
      ) = await ProjectDependencyStructureFactory()
          .addProjectDependency(moduleName)
          .withModuleProjects([
            ModuleProjectBuilder().withName(moduleName).withPubspecDependencies(
              [firstTransitiveModuleName],
            ).build(),
            ModuleProjectBuilder()
                .withName(firstTransitiveModuleName)
                .withPubspecDependencies([secondTransitiveModuleName])
                .build(),
            ModuleProjectBuilder().withName(secondTransitiveModuleName).build(),
          ])
          .addPackageToPackageConfig(moduleName)
          .addPackageToPackageConfig(firstTransitiveModuleName)
          .addPackageToPackageConfig(secondTransitiveModuleName)
          .construct();

      var moduleConfigs = loadModuleConfigs(
        projectPubspec: projectPubspec,
        packageConfig: packageConfig,
      );

      expect(moduleConfigs, hasLength(3));
      var moduleConfigServerPackageNames = moduleConfigs
          .map((config) => config.serverPackage)
          .toList();
      expect(
        moduleConfigServerPackageNames,
        containsAll([
          moduleName,
          firstTransitiveModuleName,
          secondTransitiveModuleName,
        ]),
      );
    },
  );

  test(
    'Given multiple serverpod module dependencies when loading modules then module configurations are loaded',
    () async {
      const firstModule = 'first_module_server';
      const secondModule = 'second_module_server';

      var ProjectDependencyContext(
        :packageConfig,
        :projectPubspec,
      ) = await ProjectDependencyStructureFactory()
          .addProjectDependency(firstModule)
          .addProjectDependency(secondModule)
          .withModuleProjects([
            ModuleProjectBuilder().withName(firstModule).build(),
            ModuleProjectBuilder().withName(secondModule).build(),
          ])
          .addPackageToPackageConfig(firstModule)
          .addPackageToPackageConfig(secondModule)
          .construct();

      var moduleConfigs = loadModuleConfigs(
        projectPubspec: projectPubspec,
        packageConfig: packageConfig,
      );

      expect(moduleConfigs, hasLength(2));
      expect(moduleConfigs.first.serverPackage, firstModule);
      expect(moduleConfigs.last.serverPackage, secondModule);
    },
  );

  test(
    'Given no serverpod module dependencies when loading modules then no module configuration is loaded',
    () async {
      var ProjectDependencyContext(:packageConfig, :projectPubspec) =
          await ProjectDependencyStructureFactory().construct();

      var moduleConfigs = loadModuleConfigs(
        projectPubspec: projectPubspec,
        packageConfig: packageConfig,
      );

      expect(moduleConfigs, isEmpty);
    },
  );

  test(
    'Given serverpod module dependency that does not exist in package config when loading modules then exception is thrown',
    () async {
      const module = 'module_server';

      var ProjectDependencyContext(
        :packageConfig,
        :projectPubspec,
      ) = await ProjectDependencyStructureFactory()
          .addProjectDependency(module)
          .addModuleProject(ModuleProjectBuilder().withName(module).build())
          .construct();

      expect(
        () => loadModuleConfigs(
          projectPubspec: projectPubspec,
          packageConfig: packageConfig,
        ),
        throwsA(
          isA<ServerpodModulesNotFoundException>().having(
            (e) => e.message,
            'message',
            equals(
              'Failed to locate module dependency path in package config for '
              'dependency: module_server',
            ),
          ),
        ),
      );
    },
  );

  test(
    'Given serverpod module dependency with transitive module dependency that does not exist in package config when loading modules then exception is thrown',
    () async {
      const moduleName = 'module_server';
      const transitiveModuleName = 'transitive_module_server';

      var ProjectDependencyContext(
        :packageConfig,
        :projectPubspec,
      ) = await ProjectDependencyStructureFactory()
          .addProjectDependency(moduleName)
          .withModuleProjects([
            ModuleProjectBuilder().withName(moduleName).withPubspecDependencies(
              [transitiveModuleName],
            ).build(),
            ModuleProjectBuilder().withName(transitiveModuleName).build(),
          ])
          .addPackageToPackageConfig(moduleName)
          .construct();

      expect(
        () => loadModuleConfigs(
          projectPubspec: projectPubspec,
          packageConfig: packageConfig,
        ),
        throwsA(
          isA<ServerpodModulesNotFoundException>().having(
            (e) => e.message,
            'message',
            equals(
              'Failed to locate module dependency path in package config for '
              'dependency: transitive_module_server',
            ),
          ),
        ),
      );
    },
  );

  test(
    'Given serverpod module dependency that is missing generator config when loading modules then no module configuration is loaded',
    () async {
      const moduleName = 'module_server';

      var ProjectDependencyContext(
        :packageConfig,
        :projectPubspec,
      ) = await ProjectDependencyStructureFactory()
          .addProjectDependency(moduleName)
          .addModuleProject(
            ModuleProjectBuilder()
                .withName(moduleName)
                .withIncludeGeneratorConfig(false)
                .build(),
          )
          .addPackageToPackageConfig(moduleName)
          .construct();

      var moduleConfigs = loadModuleConfigs(
        projectPubspec: projectPubspec,
        packageConfig: packageConfig,
      );

      expect(moduleConfigs, isEmpty);
    },
  );

  test(
    'Given no serverpod module dependencies but one exists in package config when loading modules then no module configuration is loaded',
    () async {
      const moduleName = 'module_server';

      var ProjectDependencyContext(
        :packageConfig,
        :projectPubspec,
      ) = await ProjectDependencyStructureFactory()
          .addModuleProject(ModuleProjectBuilder().withName(moduleName).build())
          .addPackageToPackageConfig(moduleName)
          .construct();

      var moduleConfigs = loadModuleConfigs(
        projectPubspec: projectPubspec,
        packageConfig: packageConfig,
      );

      expect(moduleConfigs, isEmpty);
    },
  );
}
