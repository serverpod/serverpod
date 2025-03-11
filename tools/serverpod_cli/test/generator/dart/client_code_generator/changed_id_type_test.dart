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

  for (var idType in SupportedIdType.all) {
    var idClassName = idType.className;
    var idTypeAlias = idType.aliases.first;

    group('Given the default id type is $idTypeAlias', () {
      group('Given a class with table name when generating code', () {
        var models = [
          ModelClassDefinitionBuilder()
              .withFileName(testClassFileName)
              .withTableName('example_table')
              .withIdFieldType(idType)
              .build()
        ];

        var codeMap = generator.generateSerializableModelsCode(
          models: models,
          config: config,
        );

        var compilationUnit =
            parseString(content: codeMap[expectedFileName]!).unit;
        var maybeClassNamedExample =
            CompilationUnitHelpers.tryFindClassDeclaration(
          compilationUnit,
          name: testClassName,
        );

        group('then the class named $testClassName', () {
          test('has id in constructor with type $idClassName.', () {
            var constructor =
                CompilationUnitHelpers.tryFindConstructorDeclaration(
              maybeClassNamedExample!,
              name: null,
            );

            expect(
              constructor?.parameters.parameters.first.toSource(),
              contains('$idClassName? id'),
              reason: 'Missing declaration for $testClassName constructor.',
            );
          });

          test('has type of the id field $idClassName.', () {
            var maybeIdField = CompilationUnitHelpers.tryFindFieldDeclaration(
              maybeClassNamedExample!,
              name: 'id',
            );

            expect(
              (maybeIdField?.fields.type as NamedType).name2.toString(),
              idClassName,
              reason: 'Wrong type for the id field.',
            );
          });
        });
      });
    });
  }
}
