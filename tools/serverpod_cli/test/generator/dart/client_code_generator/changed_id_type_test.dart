import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/model_class_definition_builder.dart';
import '../../../test_util/compilation_unit_helpers.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartClientCodeGenerator();

void main() {
  var testClassName = 'Example';
  var testClassFileName = 'example';
  var expectedFileName = path.join(
    '..',
    'example_project_client',
    'lib',
    'src',
    'protocol',
    '$testClassFileName.dart',
  );

  group('Given a table class with id type "int" when generating code', () {
    var models = [
      ModelClassDefinitionBuilder()
          .withFileName(testClassFileName)
          .withTableName('example_table')
          .withIdFieldType(SupportedIdType.int)
          .build(),
    ];

    late final codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    late final compilationUnit = parseString(
      content: codeMap[expectedFileName]!,
    ).unit;

    late final maybeClassNamedExample =
        CompilationUnitHelpers.tryFindClassDeclaration(
          compilationUnit,
          name: testClassName,
        );

    test('then the class has id in constructor with type "int".', () {
      var constructor = CompilationUnitHelpers.tryFindConstructorDeclaration(
        maybeClassNamedExample!,
        name: null,
      );

      expect(
        constructor?.parameters.parameters.first.toSource(),
        contains('int? id'),
        reason: 'Missing declaration for $testClassName constructor.',
      );
    });

    test('then the class id field has type "int".', () {
      var maybeIdField = CompilationUnitHelpers.tryFindFieldDeclaration(
        maybeClassNamedExample!,
        name: 'id',
      );

      expect(
        (maybeIdField?.fields.type as NamedType).name.toString(),
        'int',
        reason: 'Wrong type for the id field.',
      );
    });
  });

  group('Given a table class with id type "UUIDv4" when generating code', () {
    var models = [
      ModelClassDefinitionBuilder()
          .withFileName(testClassFileName)
          .withTableName('example_table')
          .withIdFieldType(SupportedIdType.uuidV4)
          .build(),
    ];

    late final codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    late final compilationUnit = parseString(
      content: codeMap[expectedFileName]!,
    ).unit;

    late final maybeClassNamedExample =
        CompilationUnitHelpers.tryFindClassDeclaration(
          compilationUnit,
          name: testClassName,
        );

    test('then the class has id in constructor with type "UuidValue".', () {
      var constructor = CompilationUnitHelpers.tryFindConstructorDeclaration(
        maybeClassNamedExample!,
        name: null,
      );

      expect(
        constructor?.parameters.parameters.first.toSource(),
        contains('UuidValue? id'),
        reason: 'Missing declaration for $testClassName constructor.',
      );
    });

    test('then the class id field has type "UuidValue".', () {
      var maybeIdField = CompilationUnitHelpers.tryFindFieldDeclaration(
        maybeClassNamedExample!,
        name: 'id',
      );

      expect(
        (maybeIdField?.fields.type as NamedType).name.toString(),
        'UuidValue',
        reason: 'Wrong type for the id field.',
      );
    });
  });
}
