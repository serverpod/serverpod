import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:serverpod_cli/src/test_util/builders/enum_definition_builder.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;

import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  var expectedFileName = path.join('lib', 'src', 'generated', 'example.dart');
  group('Given an enum named Example serialized by index when generating code',
      () {
    var models = [
      EnumDefinitionBuilder()
          .withClassName('Example')
          .withFileName('example')
          .withSerialized(EnumSerialization.byIndex)
          .build()
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    test('then generated enum name is Example', () {
      expect(codeMap[expectedFileName], contains('enum Example'));
    });

    test('then generated enum inherits from SerializableModel', () {
      expect(codeMap[expectedFileName],
          contains('enum Example with _i1.SerializableModel {'));
    });

    test('then generated enum imports server version of serverpod client', () {
      expect(codeMap[expectedFileName],
          contains("import 'package:serverpod/serverpod.dart' as"));
    });

    test('then generated enum has static fromJson method', () {
      expect(codeMap[expectedFileName],
          contains('static Example? fromJson(int index)'));
    });

    test('then generated enum has toJson method', () {
      expect(codeMap[expectedFileName], contains('int toJson() => index;'));
    });
  });

  group('Given an enum named Example serialized by name when generating code',
      () {
    var models = [
      EnumDefinitionBuilder()
          .withClassName('Example')
          .withFileName('example')
          .withSerialized(EnumSerialization.byName)
          .build()
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );
    test('then generated enum has static fromJson method', () {
      expect(codeMap[expectedFileName],
          contains('static Example? fromJson(String name)'));
    });

    test('then generated enum has toJson method', () {
      expect(codeMap[expectedFileName], contains('String toJson() => name;'));
    });

    test('then generated enum has toString method', () {
      expect(
        codeMap[expectedFileName],
        contains('String toString() => toJson();'),
      );
    });
  });

  group('Given enum with documentation when generating code', () {
    var documentation = [
      '// This is an example documentation',
      '// This is another example'
    ];
    var models = [
      EnumDefinitionBuilder()
          .withFileName('example')
          .withDocumentation(documentation)
          .build()
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
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
    var models = [
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

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
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
