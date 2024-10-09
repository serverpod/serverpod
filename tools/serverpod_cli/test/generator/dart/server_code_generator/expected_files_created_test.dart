import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:serverpod_cli/src/test_util/builders/enum_definition_builder.dart';
import 'package:serverpod_cli/src/analyzer/protocol_definition.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;

import 'package:serverpod_cli/src/test_util/builders/class_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  group('Given a single class when generating the code', () {
    var models = [
      ClassDefinitionBuilder()
          .withClassName('Example')
          .withFileName('example')
          .build()
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    test('then the server-side file is created', () {
      expect(
        codeMap.keys,
        contains(path.join('lib', 'src', 'generated', 'example.dart')),
        reason: 'Expected server-side file to be present, found none.',
      );
    });
  });

  group('Given a single enum when generating the code', () {
    var models = [
      EnumDefinitionBuilder()
          .withClassName('Example')
          .withFileName('example')
          .build()
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    test('then the server-side file is created', () {
      expect(
        codeMap.keys,
        contains(path.join('lib', 'src', 'generated', 'example.dart')),
        reason: 'Expected server-side file to be present, found none.',
      );
    });
  });

  group('Given multiple classes when generating the code', () {
    var models = [
      ClassDefinitionBuilder()
          .withClassName('Example')
          .withFileName('example')
          .build(),
      ClassDefinitionBuilder()
          .withClassName('User')
          .withFileName('user')
          .build(),
      EnumDefinitionBuilder()
          .withClassName('Animal')
          .withFileName('animal')
          .build(),
      EnumDefinitionBuilder()
          .withClassName('Color')
          .withFileName('color')
          .build(),
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    test('then the server-side files are created', () {
      expect(
        codeMap.keys,
        contains(path.join('lib', 'src', 'generated', 'example.dart')),
        reason: 'Expected server-side file to be present, found none.',
      );

      expect(
        codeMap.keys,
        contains(path.join('lib', 'src', 'generated', 'user.dart')),
        reason: 'Expected server-side file to be present, found none.',
      );

      expect(
        codeMap.keys,
        contains(path.join('lib', 'src', 'generated', 'animal.dart')),
        reason: 'Expected server-side file to be present, found none.',
      );

      expect(
        codeMap.keys,
        contains(path.join('lib', 'src', 'generated', 'color.dart')),
        reason: 'Expected server-side file to be present, found none.',
      );
    });
  });

  test(
      'Given a server-side only class when generating the code then the server-side file is created',
      () {
    var models = [
      ClassDefinitionBuilder()
          .withClassName('Example')
          .withFileName('example')
          .withServerOnly(true)
          .build()
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    expect(
      codeMap.keys,
      contains(path.join('lib', 'src', 'generated', 'example.dart')),
      reason: 'Expected server-side file to be present, found none.',
    );
  });

  test(
      'Given a server-side only enum when generating the code then the server-side file is created',
      () {
    var models = [
      EnumDefinitionBuilder()
          .withClassName('Example')
          .withFileName('example')
          .withServerOnly(true)
          .build()
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    expect(
      codeMap.keys,
      contains(path.join('lib', 'src', 'generated', 'example.dart')),
      reason: 'Expected server-side file to be present, found none.',
    );
  });

  group(
      'Given relativeServerTestToolsPathParts is set when generating protocol code',
      () {
    var configWithTestToolsPath = GeneratorConfigBuilder()
        .withName(projectName)
        .withEnabledExperimentalFeatures(
      [
        ExperimentalFeature.testTools,
      ],
    ).withRelativeServerTestToolsPathParts(
      [
        'integration_test',
        'serverpod_test_tools',
      ],
    ).build();

    var codeMap = generator.generateProtocolCode(
      protocolDefinition: const ProtocolDefinition(
        endpoints: [],
        models: [],
      ),
      config: configWithTestToolsPath,
    );

    test('then the serverpod test tools file is created', () {
      expect(
        codeMap.keys,
        contains(path.join(
          'integration_test',
          'serverpod_test_tools',
          'serverpod_test_tools.dart',
        )),
        reason:
            'Expected serverpod_test_tools.dart file to be present, found none.',
      );
    });
  });

  group(
      'Given relativeServerTestToolsPathParts is not set when generating protocol code',
      () {
    var configWithTestToolsPath = GeneratorConfigBuilder()
        .withName(projectName)
        .withRelativeServerTestToolsPathParts(null)
        .build();

    var codeMap = generator.generateProtocolCode(
      protocolDefinition: const ProtocolDefinition(
        endpoints: [],
        models: [],
      ),
      config: configWithTestToolsPath,
    );
    var serverpodTestToolsFileName = 'serverpod_test_tools.dart';

    test('then the serverpod test tools file is not created', () {
      var listContainsTestToolsFilename = codeMap.keys.any(
        (filePath) => filePath.endsWith(serverpodTestToolsFileName),
      );

      expect(
        listContainsTestToolsFilename,
        false,
        reason:
            'Expected serverpod_test_tools.dart file to not be present, but it was found.',
      );
    });
  });
}
