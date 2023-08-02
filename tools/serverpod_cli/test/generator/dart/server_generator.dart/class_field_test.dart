import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;

import 'package:serverpod_cli/src/test_util/builders/class_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  group('Given a class with a none nullable field', () {
    var entities = [
      ClassDefinitionBuilder()
          .withClassName('Example')
          .withFileName('example')
          .withSimpleField('title', 'String')
          .build()
    ];

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );

    test('then a server-side class is generated with that class variable.', () {
      var expectedFileName =
          path.join('lib', 'src', 'generated', 'example.dart');

      expect(codeMap[expectedFileName], contains('String title;'));
    });
  });

  group('Given a class with a nullable field', () {
    var entities = [
      ClassDefinitionBuilder()
          .withClassName('Example')
          .withFileName('example')
          .withSimpleField('title', 'String', nullable: true)
          .build()
    ];

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );

    test('then a server-side class is generated with that class variable.', () {
      var expectedFileName =
          path.join('lib', 'src', 'generated', 'example.dart');

      expect(codeMap[expectedFileName], contains('String? title;'));
    });
  });
}
