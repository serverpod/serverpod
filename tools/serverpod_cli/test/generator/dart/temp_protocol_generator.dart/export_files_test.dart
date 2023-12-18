import 'package:serverpod_cli/src/generator/dart/temp_protocol_generator.dart';
import 'package:test/test.dart';

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
      models: entities,
      config: config,
    );

    test('then the protocol file exports the class', () {
      expect(
        codeMap.values.first,
        contains("export 'example.dart';"),
        reason: 'Expected class to be exported',
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
      models: entities,
      config: config,
    );

    test('then the protocol file exports the first class', () {
      expect(
        codeMap.values.first,
        contains("export 'example.dart';"),
        reason: 'Expected example class to be exported',
      );
    });

    test('then the protocol file exports the second class', () {
      expect(
        codeMap.values.first,
        contains("export 'example.dart';"),
        reason: 'Expected user class to be exported',
      );
    });
  });

  test(
      'Given a server-side only class when generating the code then the protocol exports the class',
      () {
    var entities = [
      ClassDefinitionBuilder()
          .withClassName('Example')
          .withFileName('example')
          .withServerOnly(true)
          .build()
    ];

    var codeMap = generator.generateSerializableEntitiesCode(
      models: entities,
      config: config,
    );

    expect(
      codeMap.values.first,
      contains("export 'example.dart';"),
      reason: 'Expected example class to be exported',
    );
  });
}
