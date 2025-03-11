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
  var testClassName = 'Example';
  var repositoryClassName = '${testClassName}Repository';
  var testClassFileName = 'example';
  var expectedFilePath =
      path.join('lib', 'src', 'generated', '$testClassFileName.dart');

  for (var idType in SupportedIdType.all) {
    var idClassName = idType.className;
    var idTypeAlias = idType.aliases.first;

    group('Given the default id type is $idTypeAlias', () {
      group('Given a class with table name when generating code', () {
        var tableName = 'example_table';
        var models = [
          ModelClassDefinitionBuilder()
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

        var repositoryClass = CompilationUnitHelpers.tryFindClassDeclaration(
          compilationUnit,
          name: repositoryClassName,
        );

        test('then the class name $repositoryClassName is generated', () {
          expect(
            repositoryClass,
            isNotNull,
            reason: 'Missing class named $repositoryClassName.',
          );
        });

        group('then the $repositoryClassName class has a findById method', () {
          var findByIdMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
            repositoryClass!,
            name: 'findById',
          );

          test('that takes an $idClassName as a required param', () {
            expect(
              findByIdMethod?.parameters?.toSource(),
              contains('$idClassName id, '),
            );
          });
        });
      });
    });
  }
}
