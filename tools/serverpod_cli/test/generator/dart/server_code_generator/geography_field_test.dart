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
  // ====== GeographyPoint ======

  group(
    'Given a class with a non-nullable geography point field when generating code',
    () {
      var testClassName = 'ExampleWithGeographyPoint';
      var testClassFileName = 'example_with_geography_point';
      var expectedFilePath = path.join(
        'lib',
        'src',
        'generated',
        '$testClassFileName.dart',
      );
      var tableName = 'example_with_geography_point_table';

      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withTableName(tableName)
            .withSimpleField('location', 'GeographyPoint')
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
        test('has a ColumnGeographyPoint field declaration.', () {
          expect(
            CompilationUnitHelpers.hasFieldDeclaration(
              maybeTableClass!,
              name: 'location',
              isLate: true,
            ),
            isTrue,
            reason:
                'Missing late field declaration for location in ${testClassName}Table',
          );
        });

        test(
          'has constructor that initializes location as ColumnGeographyPoint.',
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
                "ColumnGeographyPoint('location', this)",
              ),
              isTrue,
              reason:
                  'Constructor should initialize location with ColumnGeographyPoint',
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
          'fromJson uses GeographyPointJsonExtension.fromJson to deserialize location.',
          () {
            final fromJsonConstructor =
                CompilationUnitHelpers.tryFindConstructorDeclaration(
                  maybeMainClass!,
                  name: 'fromJson',
                );

            expect(fromJsonConstructor, isNotNull);

            final fromJsonSource = fromJsonConstructor!.toSource();
            expect(
              fromJsonSource.contains('GeographyPointJsonExtension.fromJson'),
              isTrue,
              reason:
                  'fromJson should use GeographyPointJsonExtension.fromJson to deserialize location',
            );
          },
        );

        test('toJson serializes location by calling toJson().', () {
          final toJsonMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
            maybeMainClass!,
            name: 'toJson',
          );

          expect(toJsonMethod, isNotNull);

          final toJsonSource = toJsonMethod!.toSource();
          expect(
            toJsonSource.contains('location.toJson()'),
            isTrue,
            reason: 'toJson should serialize location via .toJson()',
          );
        });
      });
    },
  );

  group(
    'Given a class with a nullable geography point field when generating code',
    () {
      var testClassName = 'ExampleWithGeographyPoint';
      var testClassFileName = 'example_with_geography_point';
      var expectedFilePath = path.join(
        'lib',
        'src',
        'generated',
        '$testClassFileName.dart',
      );
      var tableName = 'example_with_geography_point_table';

      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withTableName(tableName)
            .withSimpleField('location', 'GeographyPoint', nullable: true)
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

      test(
        'then the main class has a nullable GeographyPoint field.',
        () {
          final field = CompilationUnitHelpers.tryFindFieldDeclaration(
            maybeMainClass!,
            name: 'location',
          );
          expect(
            field,
            isNotNull,
            reason: 'Missing location field in $testClassName',
          );
          expect(
            field!.fields.type?.toString(),
            contains('GeographyPoint?'),
            reason: 'location field should be nullable (GeographyPoint?)',
          );
        },
      );

      test(
        'then the table class constructor initializes location as ColumnGeographyPoint.',
        () {
          final constructor =
              CompilationUnitHelpers.tryFindConstructorDeclaration(
                maybeTableClass!,
                name: null,
              );

          final constructorSource = constructor!.toSource();
          expect(
            constructorSource.contains('ColumnGeographyPoint'),
            isTrue,
            reason:
                'Constructor should initialize nullable location with ColumnGeographyPoint',
          );
        },
      );
    },
  );

  // ====== GeographyLineString ======

  group(
    'Given a class with a non-nullable geography line string field when generating code',
    () {
      var testClassName = 'ExampleWithGeographyLineString';
      var testClassFileName = 'example_with_geography_line_string';
      var expectedFilePath = path.join(
        'lib',
        'src',
        'generated',
        '$testClassFileName.dart',
      );
      var tableName = 'example_with_geography_line_string_table';

      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withTableName(tableName)
            .withSimpleField('route', 'GeographyLineString')
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
        test('has a ColumnGeographyLineString field declaration.', () {
          expect(
            CompilationUnitHelpers.hasFieldDeclaration(
              maybeTableClass!,
              name: 'route',
              isLate: true,
            ),
            isTrue,
            reason:
                'Missing late field declaration for route in ${testClassName}Table',
          );
        });

        test(
          'has constructor that initializes route as ColumnGeographyLineString.',
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
                "ColumnGeographyLineString('route', this)",
              ),
              isTrue,
              reason:
                  'Constructor should initialize route with ColumnGeographyLineString',
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
          'fromJson uses GeographyLineStringJsonExtension.fromJson to deserialize route.',
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
                'GeographyLineStringJsonExtension.fromJson',
              ),
              isTrue,
              reason:
                  'fromJson should use GeographyLineStringJsonExtension.fromJson',
            );
          },
        );

        test('toJson serializes route by calling toJson().', () {
          final toJsonMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
            maybeMainClass!,
            name: 'toJson',
          );

          expect(toJsonMethod, isNotNull);

          final toJsonSource = toJsonMethod!.toSource();
          expect(
            toJsonSource.contains('route.toJson()'),
            isTrue,
            reason: 'toJson should serialize route via .toJson()',
          );
        });
      });
    },
  );

  group(
    'Given a class with a nullable geography line string field when generating code',
    () {
      var testClassName = 'ExampleWithGeographyLineString';
      var testClassFileName = 'example_with_geography_line_string';
      var expectedFilePath = path.join(
        'lib',
        'src',
        'generated',
        '$testClassFileName.dart',
      );
      var tableName = 'example_with_geography_line_string_table';

      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withTableName(tableName)
            .withSimpleField('route', 'GeographyLineString', nullable: true)
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
        'then the main class has a nullable GeographyLineString field.',
        () {
          final maybeMainClass = CompilationUnitHelpers.tryFindClassDeclaration(
            compilationUnit,
            name: testClassName,
          );
          final field = CompilationUnitHelpers.tryFindFieldDeclaration(
            maybeMainClass!,
            name: 'route',
          );
          expect(
            field,
            isNotNull,
            reason: 'Missing route field in $testClassName',
          );
          expect(
            field!.fields.type?.toString(),
            contains('GeographyLineString?'),
            reason: 'route field should be nullable (GeographyLineString?)',
          );
        },
      );

      test(
        'then the table class constructor initializes route as ColumnGeographyLineString.',
        () {
          final constructor =
              CompilationUnitHelpers.tryFindConstructorDeclaration(
                maybeTableClass!,
                name: null,
              );

          final constructorSource = constructor!.toSource();
          expect(
            constructorSource.contains('ColumnGeographyLineString'),
            isTrue,
            reason:
                'Constructor should initialize nullable route with ColumnGeographyLineString',
          );
        },
      );
    },
  );

  // ====== GeographyPolygon ======

  group(
    'Given a class with a non-nullable geography polygon field when generating code',
    () {
      var testClassName = 'ExampleWithGeographyPolygon';
      var testClassFileName = 'example_with_geography_polygon';
      var expectedFilePath = path.join(
        'lib',
        'src',
        'generated',
        '$testClassFileName.dart',
      );
      var tableName = 'example_with_geography_polygon_table';

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
      var testClassName = 'ExampleWithGeographyPolygon';
      var testClassFileName = 'example_with_geography_polygon';
      var expectedFilePath = path.join(
        'lib',
        'src',
        'generated',
        '$testClassFileName.dart',
      );
      var tableName = 'example_with_geography_polygon_table';

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

  // ====== GeographyGeometryCollection ======

  group(
    'Given a class with a non-nullable geography geometry collection field when generating code',
    () {
      var testClassName = 'ExampleWithGeographyGeometryCollection';
      var testClassFileName = 'example_with_geography_geometry_collection';
      var expectedFilePath = path.join(
        'lib',
        'src',
        'generated',
        '$testClassFileName.dart',
      );
      var tableName = 'example_with_geography_geometry_collection_table';

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
      var testClassName = 'ExampleWithGeographyGeometryCollection';
      var testClassFileName = 'example_with_geography_geometry_collection';
      var expectedFilePath = path.join(
        'lib',
        'src',
        'generated',
        '$testClassFileName.dart',
      );
      var tableName = 'example_with_geography_geometry_collection_table';

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
