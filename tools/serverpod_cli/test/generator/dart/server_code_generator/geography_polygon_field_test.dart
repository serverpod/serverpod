import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/model_class_definition_builder.dart';
import '../../../test_util/compilation_unit_helpers.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  var testClassName = 'ExampleWithGeographyPolygon';
  var testClassFileName = 'example_with_geography_polygon';
  var expectedFilePath = path.join(
    'lib',
    'src',
    'generated',
    '$testClassFileName.dart',
  );
  var tableName = 'example_with_geography_polygon_table';

  group(
    'Given a class with a non-nullable geography polygon field when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withTableName(tableName)
            .withSimpleField('region', 'GeographyPolygon')
            .build(),
      ];

      late final codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      late final compilationUnit = parseString(
        content: codeMap[expectedFilePath]!,
      ).unit;

      late final maybeMainClass =
          CompilationUnitHelpers.tryFindClassDeclaration(
            compilationUnit,
            name: testClassName,
          );

      late final maybeTableClass =
          CompilationUnitHelpers.tryFindClassDeclaration(
            compilationUnit,
            name: '${testClassName}Table',
          );

      test('then a class named ${testClassName}Table is generated.', () {
        expect(
          maybeTableClass,
          isNotNull,
          reason: 'Missing definition for class named ${testClassName}Table',
        );
      });

      group('then the class named ${testClassName}Table', () {
        test('has a ColumnGeographyPolygon field declaration.', () {
          expect(
            CompilationUnitHelpers.hasFieldDeclaration(
              maybeTableClass!,
              name: 'region',
              isLate: true,
            ),
            isTrue,
            reason:
                'Missing late field declaration for region in ${testClassName}Table',
          );
        });

        test(
          'has constructor that initializes region as ColumnGeographyPolygon.',
          () {
            final constructor =
                CompilationUnitHelpers.tryFindConstructorDeclaration(
                  maybeTableClass!,
                  name: null,
                );

            expect(constructor, isNotNull);

            final constructorSource = constructor!.toSource();
            expect(
              constructorSource.contains(
                "ColumnGeographyPolygon('region', this)",
              ),
              isTrue,
              reason:
                  'Constructor should initialize region with ColumnGeographyPolygon',
            );
          },
        );
      });

      group('then the class named $testClassName', () {
        test('has a fromJson factory.', () {
          expect(
            CompilationUnitHelpers.hasConstructorDeclaration(
              maybeMainClass!,
              name: 'fromJson',
            ),
            isTrue,
            reason: 'Missing fromJson factory in $testClassName',
          );
        });

        test(
          'fromJson uses GeographyPolygonJsonExtension.fromJson to deserialize region.',
          () {
            final fromJsonConstructor =
                CompilationUnitHelpers.tryFindConstructorDeclaration(
                  maybeMainClass!,
                  name: 'fromJson',
                );

            expect(fromJsonConstructor, isNotNull);

            final fromJsonSource = fromJsonConstructor!.toSource();
            expect(
              fromJsonSource.contains('GeographyPolygonJsonExtension.fromJson'),
              isTrue,
              reason:
                  'fromJson should use GeographyPolygonJsonExtension.fromJson',
            );
          },
        );

        test('toJson serializes region by calling toJson().', () {
          final toJsonMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
            maybeMainClass!,
            name: 'toJson',
          );

          expect(toJsonMethod, isNotNull);

          final toJsonSource = toJsonMethod!.toSource();
          expect(
            toJsonSource.contains('region.toJson()'),
            isTrue,
            reason: 'toJson should serialize region via .toJson()',
          );
        });
      });
    },
  );

  group(
    'Given a class with a nullable geography polygon field when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withTableName(tableName)
            .withSimpleField('region', 'GeographyPolygon', nullable: true)
            .build(),
      ];

      late final codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      late final compilationUnit = parseString(
        content: codeMap[expectedFilePath]!,
      ).unit;

      late final maybeTableClass =
          CompilationUnitHelpers.tryFindClassDeclaration(
            compilationUnit,
            name: '${testClassName}Table',
          );

      test('then a class named ${testClassName}Table is generated.', () {
        expect(
          maybeTableClass,
          isNotNull,
          reason: 'Missing definition for class named ${testClassName}Table',
        );
      });

      test(
        'then the table class constructor initializes region as ColumnGeographyPolygon.',
        () {
          final constructor =
              CompilationUnitHelpers.tryFindConstructorDeclaration(
                maybeTableClass!,
                name: null,
              );

          final constructorSource = constructor!.toSource();
          expect(
            constructorSource.contains('ColumnGeographyPolygon'),
            isTrue,
            reason:
                'Constructor should initialize nullable region with ColumnGeographyPolygon',
          );
        },
      );
    },
  );
}
