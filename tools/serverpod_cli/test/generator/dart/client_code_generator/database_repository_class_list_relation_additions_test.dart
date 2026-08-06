import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
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
  var expectedFilePath = path.join(
    '..',
    'example_project_client',
    'lib',
    'src',
    'protocol',
    '$testClassFileName.dart',
  );

  group(
    'Given a class with a client database table and explicit nullable list relation field, '
    'when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withTableName('example_table')
            .withDatabase(ModelDatabaseDefinition.client)
            .withListRelationField(
              'people',
              'Person',
              'organizationId',
              nullableRelation: true,
            )
            .build(),
      ];

      var codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      var compilationUnit = parseString(
        content: codeMap[expectedFilePath]!,
      ).unit;

      var repositoryClass = CompilationUnitHelpers.tryFindClassDeclaration(
        compilationUnit,
        name: '${testClassName}Repository',
      );

      group(
        'then the class name ${testClassName}Repository',
        () {
          test('has a final detach field', () {
            var field = CompilationUnitHelpers.tryFindFieldDeclaration(
              repositoryClass!,
              name: 'detach',
            );

            expect(
              field?.toSource(),
              'final detach = const ${testClassName}DetachRepository._();',
              reason: 'Missing static instance field.',
            );
          });

          test('has a final detachRow field', () {
            var field = CompilationUnitHelpers.tryFindFieldDeclaration(
              repositoryClass!,
              name: 'detachRow',
            );

            expect(
              field?.toSource(),
              'final detachRow = const ${testClassName}DetachRowRepository._();',
              reason: 'Missing static instance field.',
            );
          });
        },
        skip: repositoryClass == null,
      );

      test(
        'then a class named ${testClassName}DetachRepository is generated',
        () {
          expect(
            CompilationUnitHelpers.hasClassDeclaration(
              compilationUnit,
              name: '${testClassName}DetachRepository',
            ),
            isTrue,
            reason:
                'Expected the class ${testClassName}DetachRepository to be generated.',
          );
        },
      );

      test(
        'then a class named ${testClassName}DetachRowRepository is generated',
        () {
          expect(
            CompilationUnitHelpers.hasClassDeclaration(
              compilationUnit,
              name: '${testClassName}DetachRowRepository',
            ),
            isTrue,
            reason:
                'Expected the class ${testClassName}DetachRowRepository to be generated.',
          );
        },
      );
    },
  );

  group(
    'Given a class with a client database table and explicit non-nullable list relation field, '
    'when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withTableName('example_table')
            .withDatabase(ModelDatabaseDefinition.client)
            .withListRelationField(
              'people',
              'Person',
              'organizationId',
              nullableRelation: false,
            )
            .build(),
      ];

      var codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      var compilationUnit = parseString(
        content: codeMap[expectedFilePath]!,
      ).unit;

      var repositoryClass = CompilationUnitHelpers.tryFindClassDeclaration(
        compilationUnit,
        name: '${testClassName}Repository',
      );

      group(
        'then the class name ${testClassName}Repository',
        () {
          test('has a final attach field', () {
            var field = CompilationUnitHelpers.tryFindFieldDeclaration(
              repositoryClass!,
              name: 'attach',
            );

            expect(
              field?.toSource(),
              'final attach = const ${testClassName}AttachRepository._();',
              reason: 'Missing static instance field.',
            );
          });

          test('has NO detachRow field', () {
            var field = CompilationUnitHelpers.tryFindFieldDeclaration(
              repositoryClass!,
              name: 'detachRow',
            );

            expect(
              field,
              isNull,
              reason:
                  'The field detachRow was found but was expected to not exist.',
            );
          });

          test('has NO detach field', () {
            var field = CompilationUnitHelpers.tryFindFieldDeclaration(
              repositoryClass!,
              name: 'detach',
            );

            expect(
              field,
              isNull,
              reason:
                  'The field detach was found but was expected to not exist.',
            );
          });
        },
        skip: repositoryClass == null,
      );

      test(
        'then a class named ${testClassName}AttachRepository is generated',
        () {
          expect(
            CompilationUnitHelpers.hasClassDeclaration(
              compilationUnit,
              name: '${testClassName}AttachRepository',
            ),
            isTrue,
            reason:
                'Expected the class ${testClassName}AttachRepository to be generated.',
          );
        },
      );

      test(
        'then a class named ${testClassName}DetachRepository is NOT generated',
        () {
          expect(
            CompilationUnitHelpers.hasClassDeclaration(
              compilationUnit,
              name: '${testClassName}DetachRepository',
            ),
            isFalse,
            reason:
                'The class ${testClassName}DetachRepository was found but was expected to not exist.',
          );
        },
      );

      test(
        'then a class named ${testClassName}DetachRowRepository is NOT generated',
        () {
          expect(
            CompilationUnitHelpers.hasClassDeclaration(
              compilationUnit,
              name: '${testClassName}DetachRowRepository',
            ),
            isFalse,
            reason:
                'The class ${testClassName}DetachRowRepository was found but was expected to not exist.',
          );
        },
      );
    },
  );
}
