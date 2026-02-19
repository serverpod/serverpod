import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/generator/dart/shared_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/enum_definition_builder.dart';
import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/model_class_definition_builder.dart';

const sharedPackageName = 'shared_pkg';
const projectName = 'example_project';
const serverPathParts = ['server_root'];
final config = GeneratorConfigBuilder()
    .withServerPackageDirectoryPathParts(serverPathParts)
    .withSharedModelsSourcePathsParts({
      sharedPackageName: ['packages', 'shared'],
    })
    .withModules([])
    .build();
const generator = DartSharedCodeGenerator();

void main() {
  group('Given a single class when generating the code', () {
    var models = [
      ModelClassDefinitionBuilder()
          .withClassName('Example')
          .withFileName('example')
          .withSharedPackageName(sharedPackageName)
          .build(),
    ];

    late var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    test('then the shared-side file is created', () {
      expect(
        codeMap.keys,
        contains(
          path.joinAll([
            ...serverPathParts,
            'packages',
            'shared',
            'lib',
            'src',
            'generated',
            'example.dart',
          ]),
        ),
        reason: 'Expected shared-side file to be present, found none.',
      );
    });
  });

  group('Given a single enum when generating the code', () {
    var models = [
      EnumDefinitionBuilder()
          .withClassName('Example')
          .withFileName('example')
          .withSharedPackageName(sharedPackageName)
          .build(),
    ];

    late var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    test('then the shared-side file is created', () {
      expect(
        codeMap.keys,
        contains(
          path.joinAll([
            ...serverPathParts,
            'packages',
            'shared',
            'lib',
            'src',
            'generated',
            'example.dart',
          ]),
        ),
        reason: 'Expected shared-side file to be present, found none.',
      );
    });
  });

  group('Given a multiple classes when generating the code', () {
    var models = [
      ModelClassDefinitionBuilder()
          .withClassName('Example')
          .withFileName('example')
          .withSharedPackageName(sharedPackageName)
          .build(),
      ModelClassDefinitionBuilder()
          .withClassName('User')
          .withFileName('user')
          .withSharedPackageName(sharedPackageName)
          .build(),
      EnumDefinitionBuilder()
          .withClassName('Animal')
          .withFileName('animal')
          .withSharedPackageName(sharedPackageName)
          .build(),
      EnumDefinitionBuilder()
          .withClassName('Color')
          .withFileName('color')
          .withSharedPackageName(sharedPackageName)
          .build(),
    ];

    late var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    test('then the shared-side files are created', () {
      expect(
        codeMap.keys,
        contains(
          path.joinAll([
            ...serverPathParts,
            'packages',
            'shared',
            'lib',
            'src',
            'generated',
            'example.dart',
          ]),
        ),
        reason: 'Expected shared-side file to be present, found none.',
      );

      expect(
        codeMap.keys,
        contains(
          path.joinAll([
            ...serverPathParts,
            'packages',
            'shared',
            'lib',
            'src',
            'generated',
            'user.dart',
          ]),
        ),
        reason: 'Expected shared-side file to be present, found none.',
      );

      expect(
        codeMap.keys,
        contains(
          path.joinAll([
            ...serverPathParts,
            'packages',
            'shared',
            'lib',
            'src',
            'generated',
            'animal.dart',
          ]),
        ),
        reason: 'Expected shared-side file to be present, found none.',
      );

      expect(
        codeMap.keys,
        contains(
          path.joinAll([
            ...serverPathParts,
            'packages',
            'shared',
            'lib',
            'src',
            'generated',
            'color.dart',
          ]),
        ),
        reason: 'Expected shared-side file to be present, found none.',
      );
    });
  });

  test(
    'Given a server-side only enum when generating the code then the shared-side file is NOT created',
    () {
      var models = [
        EnumDefinitionBuilder()
            .withClassName('Example')
            .withFileName('example')
            .withServerOnly(true)
            .withSharedPackageName(sharedPackageName)
            .build(),
      ];

      late var codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      expect(
        codeMap.keys,
        isNot(
          contains(
            path.joinAll([
              '..',
              'packages',
              'shared',
              'lib',
              'src',
              'generated',
              'example.dart',
            ]),
          ),
        ),
        reason: 'Expected shared-side file to NOT be present, found one.',
      );
    },
  );
}
