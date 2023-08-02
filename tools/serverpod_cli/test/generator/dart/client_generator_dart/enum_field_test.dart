import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:serverpod_cli/src/test_util/builders/enum_definition_builder.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;

import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartClientCodeGenerator();

void main() {
  var expectedFileName = path.join(
    '..',
    'example_project_client',
    'lib',
    'src',
    'protocol',
    'example.dart',
  );
  group('Given enum named Example when generating code', () {
    var entities = [
      EnumDefinitionBuilder()
          .withClassName('Example')
          .withFileName('example')
          .build()
    ];

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );

    test('then generated enum name is Example', () {
      expect(codeMap[expectedFileName], contains('enum Example'));
    });

    test('then generated enum inherits from SerializableEntity', () {
      expect(codeMap[expectedFileName],
          contains('enum Example with _i1.SerializableEntity {'));
    });

    test('then generated enum has static fromJson method', () {
      expect(codeMap[expectedFileName],
          contains('static Example? fromJson(int index)'));
    });

    test('then generated enum has toJson method', () {
      expect(codeMap[expectedFileName], contains('int toJson() => index;'));
    });
  });

  group('Given enum with documentation when generating code', () {
    var documentation = [
      '// This is an example documentation',
      '// This is another example'
    ];
    var entities = [
      EnumDefinitionBuilder()
          .withFileName('example')
          .withDocumentation(documentation)
          .build()
    ];

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );

    test('then documentation is included in code', () {
      for (var comment in documentation) {
        expect(codeMap[expectedFileName], contains(comment));
      }
    });
  });

  group('Given enum with two values with documentation when generating code',
      () {
    var entities = [
      EnumDefinitionBuilder()
          .withClassName('Example')
          .withFileName('example')
          .withValues([
        ProtocolEnumValueDefinition(
            'one', ['// This is a comment for the first value']),
        ProtocolEnumValueDefinition(
            'two', ['// This is a comment for the second value'])
      ]).build()
    ];

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );

    test('then generated enum includes first value', () {
      expect(codeMap[expectedFileName], contains('one'));
    });

    test('then generated enum includes first value comment', () {
      expect(codeMap[expectedFileName],
          contains('// This is a comment for the first value'));
    });

    test('then generated enum includes second value', () {
      expect(codeMap[expectedFileName],
          contains('// This is a comment for the second value'));
    });
  });
}
