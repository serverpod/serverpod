import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;

import 'package:serverpod_cli/src/test_util/builders/class_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = ClientCodeGenerator();

void main() {
  group('Given a single class when generating the code', () {
    var entities = [
      ClassDefinitionBuilder()
          .withClassName('Example')
          .withFileName('example')
          .build()
    ];

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );

    test('then the client-side file is created', () {
      expect(
        codeMap.keys,
        contains(path.join(
          '..',
          'example_project_client',
          'lib',
          'src',
          'protocol',
          'example.dart',
        )),
        reason: 'Expected client-side file to be present, found none.',
      );
    });
  });

  group('Given a multiple classes when generating the code', () {
    var entities = [
      ClassDefinitionBuilder()
          .withClassName('Example')
          .withFileName('example')
          .build(),
      ClassDefinitionBuilder()
          .withClassName('User')
          .withFileName('user')
          .build()
    ];

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );

    test('then the client-side files are created', () {
      expect(
        codeMap.keys,
        contains(path.join(
          '..',
          'example_project_client',
          'lib',
          'src',
          'protocol',
          'example.dart',
        )),
        reason: 'Expected client-side file to be present, found none.',
      );

      expect(
        codeMap.keys,
        contains(path.join(
          '..',
          'example_project_client',
          'lib',
          'src',
          'protocol',
          'user.dart',
        )),
        reason: 'Expected client-side file to be present, found none.',
      );
    });
  });

  test(
      'Given a server-side only class when generating the code then the client-side file is NOT created',
      () {
    var entities = [
      ClassDefinitionBuilder()
          .withClassName('Example')
          .withFileName('example')
          .withServerOnly(true)
          .build()
    ];

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );

    expect(
      codeMap.keys,
      isNot(
        contains(path.join(
          '..',
          'example_project_client',
          'lib',
          'src',
          'protocol',
          'example.dart',
        )),
      ),
      reason: 'Expected client-side file to NOT be present, found one.',
    );
  });
}
