import 'package:serverpod_cli/src/generator/dart/temp_protocol_generator.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;

import 'package:serverpod_cli/src/test_util/builders/class_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartTemporaryProtocolGenerator();

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

    test('then the protocol file is created', () {
      expect(
        codeMap.keys,
        contains(path.join('lib', 'src', 'generated', 'protocol.dart')),
        reason: 'Expected protocol file to be present, found none.',
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

    test('then the protocol file is created', () {
      expect(
        codeMap.keys,
        contains(path.join('lib', 'src', 'generated', 'protocol.dart')),
        reason: 'Expected protocol file to be present, found none.',
      );
    });
  });

  test(
      'Given a server-side only class when generating the code then the protocol file is created',
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
      contains(path.join('lib', 'src', 'generated', 'protocol.dart')),
      reason: 'Expected protocol file to be present, found none.',
    );
  });
}
