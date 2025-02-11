import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:serverpod_cli/src/test_util/builders/class_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/compilation_unit_helpers.dart';
import 'package:test/test.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  var testClassName = 'Example';
  var testClassFileName = 'example';
  var expectedFilePath =
      path.join('lib', 'src', 'generated', '$testClassFileName.dart');
  var tableName = 'example_table';

  for (var idType in SupportedIdType.all) {
    var idClassName = idType.className;
    var idTypeAlias = idType.aliases.first;

    group('Given the default id type is $idTypeAlias', () {
      group('Given a class with table name when generating code', () {
        var models = [
          ClassDefinitionBuilder()
              .withFileName(testClassFileName)
              .withTableName(tableName)
              .withIdFieldType(idType)
              .build()
        ];

        var codeMap = generator.generateSerializableModelsCode(
          models: models,
          config: config,
        );

        var compilationUnit =
            parseString(content: codeMap[expectedFilePath]!).unit;
        var maybeClassNamedExample =
            CompilationUnitHelpers.tryFindClassDeclaration(
          compilationUnit,
          name: testClassName,
        );

        test('then a class named $testClassName is correctly generated.', () {
          expect(
            maybeClassNamedExample,
            isNotNull,
            reason: 'Missing definition for class named $testClassName.',
          );
        });

        group('then the class named $testClassName', () {
          test('has TableRow implements generic to $idClassName.', () {
            var typeName = maybeClassNamedExample!.implementsClause?.interfaces
                .first.typeArguments?.arguments.first as NamedType?;

            expect(
              typeName?.name2.toString(),
              idClassName,
              reason: 'Wrong generic type for TableRow.',
            );
          });

          test('has Table generic to $idClassName as table getter return type.',
              () {
            var maybeTableGetter =
                CompilationUnitHelpers.tryFindMethodDeclaration(
              maybeClassNamedExample!,
              name: 'table',
            );

            var typeArguments = maybeTableGetter?.returnType as NamedType?;
            var genericType = typeArguments?.typeArguments?.arguments.first;

            expect(
              (genericType as NamedType?)?.name2.toString(),
              idClassName,
              reason: 'Wrong generic type for Table getter.',
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
        }, skip: maybeClassNamedExample == null);
      });
    });
  }
}
