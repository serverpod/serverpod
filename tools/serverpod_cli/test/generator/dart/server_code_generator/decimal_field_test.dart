import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/model_class_definition_builder.dart';
import '../../../test_util/builders/serializable_entity_field_definition_builder.dart';
import '../../../test_util/builders/type_definition_builder.dart';
import '../../../test_util/compilation_unit_helpers.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  var testClassName = 'ExampleWithDecimal';
  var testClassFileName = 'example_with_decimal';
  var expectedFilePath = path.join(
    'lib',
    'src',
    'generated',
    '$testClassFileName.dart',
  );
  var tableName = 'example_with_decimal_table';

  group(
    'Given a class with a Decimal field without precision when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withTableName(tableName)
            .withField(
              FieldDefinitionBuilder()
                  .withName('amount')
                  .withType(
                    TypeDefinitionBuilder()
                        .withClassName('Decimal')
                        .withNullable(false)
                        .build(),
                  )
                  .build(),
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

      late final maybeClassNamedTable =
          CompilationUnitHelpers.tryFindClassDeclaration(
            compilationUnit,
            name: '${testClassName}Table',
          );

      test('then a class named ${testClassName}Table is generated.', () {
        expect(
          maybeClassNamedTable,
          isNotNull,
          reason: 'Missing definition for class named ${testClassName}Table',
        );
      });

      group('then the class named ${testClassName}Table', () {
        test(
          'has a Decimal field declaration without precision parameters.',
          () {
            final constructorDeclaration =
                CompilationUnitHelpers.tryFindConstructorDeclaration(
                  maybeClassNamedTable!,
                  name: null,
                );

            expect(
              constructorDeclaration,
              isNotNull,
              reason:
                  'Missing constructor declaration in ${testClassName}Table',
            );

            final constructorSource = constructorDeclaration!.toSource();
            expect(
              constructorSource.contains(
                "ColumnDecimal('amount', this)",
              ),
              isTrue,
              reason:
                  'Constructor should initialize amount as ColumnDecimal without precision',
            );
          },
        );
      });
    },
  );

  group(
    'Given a class with a Decimal(10,2) field when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withTableName(tableName)
            .withField(
              FieldDefinitionBuilder()
                  .withName('price')
                  .withType(
                    TypeDefinitionBuilder()
                        .withClassName('Decimal')
                        .withNullable(false)
                        .withDecimalPrecision(10)
                        .withDecimalScale(2)
                        .build(),
                  )
                  .build(),
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

      late final maybeClassNamedTable =
          CompilationUnitHelpers.tryFindClassDeclaration(
            compilationUnit,
            name: '${testClassName}Table',
          );

      test('then a class named ${testClassName}Table is generated.', () {
        expect(
          maybeClassNamedTable,
          isNotNull,
          reason: 'Missing definition for class named ${testClassName}Table',
        );
      });

      group('then the class named ${testClassName}Table', () {
        test(
          'has a Decimal field declaration with precision: 10, scale: 2.',
          () {
            final constructorDeclaration =
                CompilationUnitHelpers.tryFindConstructorDeclaration(
                  maybeClassNamedTable!,
                  name: null,
                );

            expect(
              constructorDeclaration,
              isNotNull,
              reason:
                  'Missing constructor declaration in ${testClassName}Table',
            );

            final constructorSource = constructorDeclaration!.toSource();
            expect(
              constructorSource.contains(
                "ColumnDecimal('price', this, precision: 10, scale: 2)",
              ),
              isTrue,
              reason:
                  'Constructor should initialize price with precision: 10, scale: 2',
            );
          },
        );
      });
    },
  );

  group(
    'Given a class with a Decimal(19) field (precision only) when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withTableName(tableName)
            .withField(
              FieldDefinitionBuilder()
                  .withName('quantity')
                  .withType(
                    TypeDefinitionBuilder()
                        .withClassName('Decimal')
                        .withNullable(false)
                        .withDecimalPrecision(19)
                        .withDecimalScale(0)
                        .build(),
                  )
                  .build(),
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

      late final maybeClassNamedTable =
          CompilationUnitHelpers.tryFindClassDeclaration(
            compilationUnit,
            name: '${testClassName}Table',
          );

      test('then a class named ${testClassName}Table is generated.', () {
        expect(
          maybeClassNamedTable,
          isNotNull,
          reason: 'Missing definition for class named ${testClassName}Table',
        );
      });

      group('then the class named ${testClassName}Table', () {
        test(
          'has a Decimal field declaration with precision: 19, scale: 0.',
          () {
            final constructorDeclaration =
                CompilationUnitHelpers.tryFindConstructorDeclaration(
                  maybeClassNamedTable!,
                  name: null,
                );

            expect(
              constructorDeclaration,
              isNotNull,
              reason:
                  'Missing constructor declaration in ${testClassName}Table',
            );

            final constructorSource = constructorDeclaration!.toSource();
            expect(
              constructorSource.contains(
                "ColumnDecimal('quantity', this, precision: 19, scale: 0)",
              ),
              isTrue,
              reason:
                  'Constructor should initialize quantity with precision: 19, scale: 0',
            );
          },
        );
      });
    },
  );

  group(
    'Given a class with a nullable Decimal? field when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withTableName(tableName)
            .withField(
              FieldDefinitionBuilder()
                  .withName('optionalAmount')
                  .withType(
                    TypeDefinitionBuilder()
                        .withClassName('Decimal')
                        .withNullable(true)
                        .build(),
                  )
                  .build(),
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

      late final maybeClassNamedTable =
          CompilationUnitHelpers.tryFindClassDeclaration(
            compilationUnit,
            name: '${testClassName}Table',
          );

      test('then a class named ${testClassName}Table is generated.', () {
        expect(
          maybeClassNamedTable,
          isNotNull,
          reason: 'Missing definition for class named ${testClassName}Table',
        );
      });

      group('then the class named ${testClassName}Table', () {
        test(
          'has a nullable Decimal field declaration without precision parameters.',
          () {
            final constructorDeclaration =
                CompilationUnitHelpers.tryFindConstructorDeclaration(
                  maybeClassNamedTable!,
                  name: null,
                );

            expect(
              constructorDeclaration,
              isNotNull,
              reason:
                  'Missing constructor declaration in ${testClassName}Table',
            );

            final constructorSource = constructorDeclaration!.toSource();
            expect(
              constructorSource.contains(
                "ColumnDecimal('optionalAmount', this)",
              ),
              isTrue,
              reason:
                  'Constructor should initialize nullable Decimal without precision',
            );
          },
        );
      });
    },
  );

  group(
    'Given a class with a nullable Decimal(10,2)? field when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withTableName(tableName)
            .withField(
              FieldDefinitionBuilder()
                  .withName('optionalPrice')
                  .withType(
                    TypeDefinitionBuilder()
                        .withClassName('Decimal')
                        .withNullable(true)
                        .withDecimalPrecision(10)
                        .withDecimalScale(2)
                        .build(),
                  )
                  .build(),
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

      late final maybeClassNamedTable =
          CompilationUnitHelpers.tryFindClassDeclaration(
            compilationUnit,
            name: '${testClassName}Table',
          );

      test('then a class named ${testClassName}Table is generated.', () {
        expect(
          maybeClassNamedTable,
          isNotNull,
          reason: 'Missing definition for class named ${testClassName}Table',
        );
      });

      group('then the class named ${testClassName}Table', () {
        test(
          'has a nullable Decimal field declaration with precision: 10, scale: 2.',
          () {
            final constructorDeclaration =
                CompilationUnitHelpers.tryFindConstructorDeclaration(
                  maybeClassNamedTable!,
                  name: null,
                );

            expect(
              constructorDeclaration,
              isNotNull,
              reason:
                  'Missing constructor declaration in ${testClassName}Table',
            );

            final constructorSource = constructorDeclaration!.toSource();
            expect(
              constructorSource.contains(
                "ColumnDecimal('optionalPrice', this, precision: 10, scale: 2)",
              ),
              isTrue,
              reason:
                  'Constructor should initialize nullable Decimal with precision: 10, scale: 2',
            );
          },
        );
      });
    },
  );
}
