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
  var testClassName = 'ExampleWithGeographyGeometryCollection';
  var testClassFileName = 'example_with_geography_geometry_collection';
  var expectedFilePath = path.join(
    'lib',
    'src',
    'generated',
    '$testClassFileName.dart',
  );
  var tableName = 'example_with_geography_geometry_collection_table';

  group(
    'Given a class with a non-nullable geography geometry collection field when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withTableName(tableName)
            .withSimpleField('shapes', 'GeographyGeometryCollection')
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
        test('has a ColumnGeographyGeometryCollection field declaration.', () {
          expect(
            CompilationUnitHelpers.hasFieldDeclaration(
              maybeTableClass!,
              name: 'shapes',
              isLate: true,
            ),
            isTrue,
            reason:
                'Missing late field declaration for shapes in ${testClassName}Table',
          );
        });

        test(
          'has constructor that initializes shapes as ColumnGeographyGeometryCollection.',
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
                "ColumnGeographyGeometryCollection('shapes', this)",
              ),
              isTrue,
              reason:
                  'Constructor should initialize shapes with ColumnGeographyGeometryCollection',
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
          'fromJson uses GeographyGeometryCollectionJsonExtension.fromJson to deserialize shapes.',
          () {
            final fromJsonConstructor =
                CompilationUnitHelpers.tryFindConstructorDeclaration(
                  maybeMainClass!,
                  name: 'fromJson',
                );

            expect(fromJsonConstructor, isNotNull);

            final fromJsonSource = fromJsonConstructor!.toSource();
            expect(
              fromJsonSource.contains(
                'GeographyGeometryCollectionJsonExtension.fromJson',
              ),
              isTrue,
              reason:
                  'fromJson should use GeographyGeometryCollectionJsonExtension.fromJson',
            );
          },
        );

        test('toJson serializes shapes by calling toJson().', () {
          final toJsonMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
            maybeMainClass!,
            name: 'toJson',
          );

          expect(toJsonMethod, isNotNull);

          final toJsonSource = toJsonMethod!.toSource();
          expect(
            toJsonSource.contains('shapes.toJson()'),
            isTrue,
            reason: 'toJson should serialize shapes via .toJson()',
          );
        });
      });
    },
  );

  group(
    'Given a class with a nullable geography geometry collection field when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withTableName(tableName)
            .withSimpleField(
              'shapes',
              'GeographyGeometryCollection',
              nullable: true,
            )
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
        'then the table class constructor initializes shapes as ColumnGeographyGeometryCollection.',
        () {
          final constructor =
              CompilationUnitHelpers.tryFindConstructorDeclaration(
                maybeTableClass!,
                name: null,
              );

          final constructorSource = constructor!.toSource();
          expect(
            constructorSource.contains('ColumnGeographyGeometryCollection'),
            isTrue,
            reason:
                'Constructor should initialize nullable shapes with ColumnGeographyGeometryCollection',
          );
        },
      );
    },
  );
}
