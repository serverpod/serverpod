import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/generator/dart/shared_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/model_class_definition_builder.dart';
import '../../../test_util/builders/serializable_entity_field_definition_builder.dart';
import '../../../test_util/compilation_unit_helpers.dart';

const sharedPackageName = 'shared_pkg';
const projectName = 'example_project';
const serverPathParts = ['server_root'];
final config = GeneratorConfigBuilder()
    .withServerPackageDirectoryPathParts(serverPathParts)
    .withSharedModelsSourcePathsParts({
      sharedPackageName: ['packages', 'shared'],
    })
    .withModules([])
    .build();
const generator = DartSharedCodeGenerator();

void main() {
  var testClassName = 'Example';
  var testClassFileName = 'example';
  var expectedFilePath = path.joinAll([
    ...serverPathParts,
    'packages',
    'shared',
    'lib',
    'src',
    'generated',
    '$testClassFileName.dart',
  ]);

  group(
    'Given an immutable class named $testClassName with one primitive var when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withIsImmutable(true)
            .withSimpleField('name', 'String')
            .withSharedPackageName(sharedPackageName)
            .build(),
      ];

      late var codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      late var compilationUnit = parseString(
        content: codeMap[expectedFilePath]!,
      ).unit;

      group('then the $testClassName', () {
        late var baseClass = CompilationUnitHelpers.tryFindClassDeclaration(
          compilationUnit,
          name: testClassName,
        );

        group('has a hashCode method', () {
          late var hashCodeGetter =
              CompilationUnitHelpers.tryFindMethodDeclaration(
                baseClass!,
                name: 'hashCode',
              );

          test('declared.', () {
            expect(
              hashCodeGetter,
              isNotNull,
              reason: 'No hashCode method found on $testClassName',
            );
          });

          test('declared as a getter (no parameters).', () {
            expect(hashCodeGetter?.isGetter, equals(true));
            expect(
              hashCodeGetter?.parameters,
              isNull,
              reason: 'hashCode should not declare parameters',
            );
          });

          test('with the return type of integer.', () {
            expect(hashCodeGetter?.returnType?.toSource(), equals('int'));
          });

          test('with Object.hash usage.', () {
            expect(
              hashCodeGetter?.body.toSource().contains('Object.hash'),
              equals(true),
              reason: 'hashCode should use Object.hash',
            );
          });
        });

        group('has a == operator', () {
          late var equalsOperator =
              CompilationUnitHelpers.tryFindMethodDeclaration(
                baseClass!,
                name: '==',
              );

          test('declared.', () {
            expect(
              equalsOperator,
              isNotNull,
              reason: 'No == operator found on $testClassName',
            );
          });

          test('declared as an operator.', () {
            expect(
              equalsOperator?.isOperator,
              equals(true),
              reason: '== should be declared as an operator',
            );
          });

          test('with one parameter.', () {
            expect(
              equalsOperator?.parameters?.parameters.length,
              equals(1),
              reason: '== should have one parameter',
            );
          });

          test('with the return type of boolean.', () {
            expect(equalsOperator?.returnType?.toSource(), equals('bool'));
          });
        });

        group('has an immutable annotation', () {
          test('declared.', () {
            final metadata = baseClass!.metadata;
            final hasImmutable = metadata.any((annotation) {
              final name = annotation.name.name;
              // Handles both direct and aliased imports (e.g. @_i1.immutable)
              return name == 'immutable' ||
                  name == 'Immutable' ||
                  name.endsWith('.immutable') ||
                  name.endsWith('.Immutable');
            });
            expect(
              hasImmutable,
              isTrue,
              reason: 'No @immutable annotation found on $testClassName',
            );
          });
        });
      });
    },
  );

  group(
    'Given an immutable class named $testClassName with twenty primitive vars when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withIsImmutable(true)
            .withSimpleField('variable1', 'String')
            .withSimpleField('variable2', 'String')
            .withSimpleField('variable3', 'String')
            .withSimpleField('variable4', 'String')
            .withSimpleField('variable5', 'String')
            .withSimpleField('variable6', 'String')
            .withSimpleField('variable7', 'String')
            .withSimpleField('variable8', 'String')
            .withSimpleField('variable9', 'String')
            .withSimpleField('variable10', 'String')
            .withSimpleField('variable11', 'String')
            .withSimpleField('variable12', 'String')
            .withSimpleField('variable13', 'String')
            .withSimpleField('variable14', 'String')
            .withSimpleField('variable15', 'String')
            .withSimpleField('variable16', 'String')
            .withSimpleField('variable17', 'String')
            .withSimpleField('variable18', 'String')
            .withSimpleField('variable19', 'String')
            .withSimpleField('variable20', 'String')
            .withSharedPackageName(sharedPackageName)
            .build(),
      ];

      late var codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      late var compilationUnit = parseString(
        content: codeMap[expectedFilePath]!,
      ).unit;

      group('then the $testClassName', () {
        late var baseClass = CompilationUnitHelpers.tryFindClassDeclaration(
          compilationUnit,
          name: testClassName,
        );

        group('has a hashCode method', () {
          late var hashCodeGetter =
              CompilationUnitHelpers.tryFindMethodDeclaration(
                baseClass!,
                name: 'hashCode',
              );

          test('declared.', () {
            expect(
              hashCodeGetter,
              isNotNull,
              reason: 'No hashCode method found on $testClassName',
            );
          });

          test('declared as a getter (no parameters).', () {
            expect(hashCodeGetter?.isGetter, equals(true));
            expect(
              hashCodeGetter?.parameters,
              isNull,
              reason: 'hashCode should not declare parameters',
            );
          });

          test('with the return type of integer.', () {
            expect(hashCodeGetter?.returnType?.toSource(), equals('int'));
          });

          test('with Object.hashAll usage.', () {
            expect(
              hashCodeGetter?.body.toSource().contains('Object.hashAll'),
              equals(true),
              reason: 'hashCode should use Object.hashAll',
            );
          });
        });

        group('has a == operator', () {
          late var equalsOperator =
              CompilationUnitHelpers.tryFindMethodDeclaration(
                baseClass!,
                name: '==',
              );

          test('declared.', () {
            expect(
              equalsOperator,
              isNotNull,
              reason: 'No == operator found on $testClassName',
            );
          });

          test('declared as an operator.', () {
            expect(
              equalsOperator?.isOperator,
              equals(true),
              reason: '== should be declared as an operator',
            );
          });

          test('with one parameter.', () {
            expect(
              equalsOperator?.parameters?.parameters.length,
              equals(1),
              reason: '== should have one parameter',
            );
          });

          test('with the return type of boolean.', () {
            expect(equalsOperator?.returnType?.toSource(), equals('bool'));
          });
        });

        group('has an immutable annotation', () {
          test('declared.', () {
            final metadata = baseClass!.metadata;
            final hasImmutable = metadata.any((annotation) {
              final name = annotation.name.name;
              // Handles both direct and aliased imports (e.g. @_i1.immutable)
              return name == 'immutable' ||
                  name == 'Immutable' ||
                  name.endsWith('.immutable') ||
                  name.endsWith('.Immutable');
            });
            expect(
              hasImmutable,
              isTrue,
              reason: 'No @immutable annotation found on $testClassName',
            );
          });
        });
      });
    },
  );

  group(
    'Given an immutable class with an implicit foreign key field (scope none) when generating shared code',
    () {
      var testClassName = 'MealToResource';
      var testClassFileName = 'meal_to_resource';
      var expectedFilePath = path.joinAll([
        ...serverPathParts,
        'packages',
        'shared',
        'lib',
        'src',
        'generated',
        '$testClassFileName.dart',
      ]);

      // Create a model with an implicit foreign key field that has scope: none
      // This simulates what happens when Serverpod generates a foreign key
      // for an implicit one-to-many relationship
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withTableName('meal_to_resource')
            .withIsImmutable(true)
            .withSimpleField('quantity', 'int')
            // Add an implicit foreign key field with scope: none
            // This field should NOT appear in hashCode or == on the shared side
            .withField(
              FieldDefinitionBuilder()
                  .withName(r'$_mealResourceMealId')
                  .withTypeDefinition('int', true)
                  .withScope(ModelFieldScopeDefinition.none)
                  .withShouldPersist(true)
                  .build(),
            )
            .withSharedPackageName(sharedPackageName)
            .build(),
      ];

      late var codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      late var compilationUnit = parseString(
        content: codeMap[expectedFilePath]!,
      ).unit;

      group('then the $testClassName', () {
        late var baseClass = CompilationUnitHelpers.tryFindClassDeclaration(
          compilationUnit,
          name: testClassName,
        );

        test('compiles without referencing private implicit fields.', () {
          // Verify that the generated code does not reference the implicit
          // foreign key field which is server-only (scope: none)
          var generatedCode = codeMap[expectedFilePath]!;

          // The implicit field should not appear in hashCode or == methods
          // on the shared side since it has scope: none
          expect(
            generatedCode.contains(r'$_mealResourceMealId'),
            isFalse,
            reason:
                'shared code should not reference implicit foreign key fields '
                'with scope: none',
          );
        });

        group('has a hashCode method', () {
          late var hashCodeGetter =
              CompilationUnitHelpers.tryFindMethodDeclaration(
                baseClass!,
                name: 'hashCode',
              );

          test('that does not reference implicit foreign key fields.', () {
            expect(
              hashCodeGetter,
              isNotNull,
              reason: 'No hashCode method found on $testClassName',
            );

            var hashCodeBody = hashCodeGetter!.body.toSource();
            expect(
              hashCodeBody.contains(r'$_mealResourceMealId'),
              isFalse,
              reason:
                  'hashCode should not reference implicit foreign key fields',
            );
          });
        });

        group('has a == operator', () {
          late var equalsOperator =
              CompilationUnitHelpers.tryFindMethodDeclaration(
                baseClass!,
                name: '==',
              );

          test('that does not reference implicit foreign key fields.', () {
            expect(
              equalsOperator,
              isNotNull,
              reason: 'No == operator found on $testClassName',
            );

            var equalsBody = equalsOperator!.body.toSource();
            expect(
              equalsBody.contains(r'$_mealResourceMealId'),
              isFalse,
              reason: '== should not reference implicit foreign key fields',
            );
          });
        });
      });
    },
  );
}
