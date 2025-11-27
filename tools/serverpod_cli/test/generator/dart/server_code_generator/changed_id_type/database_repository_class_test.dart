import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_class_definition_builder.dart';
import '../../../../test_util/compilation_unit_helpers.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  var expectedFilePath = path.join('lib', 'src', 'generated', 'example.dart');

  group('Given a table class with id type "int" when generating code', () {
    var models = [
      ModelClassDefinitionBuilder()
          .withFileName('example')
          .withTableName('example_table')
          .withIdFieldType(SupportedIdType.int)
          .build(),
    ];

    late final codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    late final compilationUnit = parseString(
      content: codeMap[expectedFilePath]!,
    ).unit;

    late final repositoryClass = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: 'ExampleRepository',
    );

    test('then the class name "ExampleRepository" is generated', () {
      expect(
        repositoryClass,
        isNotNull,
        reason: 'Missing class named ExampleRepository.',
      );
    });

    test(
      'then the "ExampleRepository" class has a findById method that takes an "int" as a required param',
      () {
        var findByIdMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          repositoryClass!,
          name: 'findById',
        );

        expect(
          findByIdMethod?.parameters?.toSource(),
          contains('int id, '),
        );
      },
    );
  });

  group('Given a table class with id type "UUIDv4" when generating code', () {
    var models = [
      ModelClassDefinitionBuilder()
          .withFileName('example')
          .withTableName('example_table')
          .withIdFieldType(SupportedIdType.uuidV4)
          .build(),
    ];

    late final codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    late final compilationUnit = parseString(
      content: codeMap[expectedFilePath]!,
    ).unit;

    late final repositoryClass = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: 'ExampleRepository',
    );

    test('then the class name "ExampleRepository" is generated', () {
      expect(
        repositoryClass,
        isNotNull,
        reason: 'Missing class named ExampleRepository.',
      );
    });

    test(
      'then the "ExampleRepository" class has a findById method that takes an "UuidValue" as a required param',
      () {
        var findByIdMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          repositoryClass!,
          name: 'findById',
        );

        expect(
          findByIdMethod?.parameters?.toSource(),
          contains('UuidValue id, '),
        );
      },
    );
  });
}
