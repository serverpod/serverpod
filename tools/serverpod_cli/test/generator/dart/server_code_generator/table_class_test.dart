import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/model_class_definition_builder.dart';
import '../../../test_util/builders/serializable_entity_field_definition_builder.dart';
import '../../../test_util/compilation_unit_helpers.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  var testClassName = 'Example';
  var testClassFileName = 'example';
  var expectedFilePath = path.join(
    'lib',
    'src',
    'generated',
    '$testClassFileName.dart',
  );
  var tableName = 'example_table';
  group('Given a class with table name when generating code', () {
    var models = [
      ModelClassDefinitionBuilder()
          .withFileName(testClassFileName)
          .withTableName(tableName)
          .build(),
    ];

    late final codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    late final compilationUnit = parseString(
      content: codeMap[expectedFilePath]!,
    ).unit;

    late final maybeClassNamedExampleTable =
        CompilationUnitHelpers.tryFindClassDeclaration(
          compilationUnit,
          name: '${testClassName}Table',
        );

    test('then a class named ${testClassName}Table is generated.', () {
      expect(
        maybeClassNamedExampleTable,
        isNotNull,
        reason: 'Missing definition for class named ${testClassName}Table',
      );
    });
    group('then the class named ${testClassName}Table', () {
      test('inherits from Table.', () {
        expect(
          CompilationUnitHelpers.hasExtendsClause(
            maybeClassNamedExampleTable!,
            name: 'Table',
          ),
          isTrue,
          reason: 'Missing extends clause for Table.',
        );
      });

      test('has Table extends generic to the default id type int.', () {
        expect(
          maybeClassNamedExampleTable!
              .extendsClause
              ?.superclass
              .typeArguments
              ?.arguments
              .first
              .toString(),
          'int?',
          reason: 'Missing generic to default id type int.',
        );
      });

      test(
        'has constructor taking table relation and passes table name to super.',
        () {
          expect(
            CompilationUnitHelpers.hasConstructorDeclaration(
              maybeClassNamedExampleTable!,
              name: null,
              parameters: ['super.tableRelation'],
              superArguments: ['tableName: \'$tableName\''],
            ),
            isTrue,
            reason:
                'Missing declaration for $testClassName constructor with nullable id field passed to super.',
          );
        },
      );

      test('has a columns method.', () {
        expect(
          CompilationUnitHelpers.hasMethodDeclaration(
            maybeClassNamedExampleTable!,
            name: 'columns',
          ),
          isTrue,
          reason: 'Missing declaration for columns getter.',
        );
      });

      test('does NOT have getRelationTable method.', () {
        expect(
          CompilationUnitHelpers.hasMethodDeclaration(
            maybeClassNamedExampleTable!,
            name: 'getRelationTable',
          ),
          isFalse,
          reason:
              'Declaration for getRelationTable method should not be generated.',
        );
      });

      test('does NOT have id field.', () {
        expect(
          CompilationUnitHelpers.hasFieldDeclaration(
            maybeClassNamedExampleTable!,
            name: 'id',
          ),
          isFalse,
          reason: 'Declaration for id field should not be generated.',
        );
      });
    });
  });

  group(
    'Given a class with table name and persistent field when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withTableName(tableName)
            .withField(
              FieldDefinitionBuilder()
                  .withName('title')
                  .withTypeDefinition('String', true)
                  .withScope(ModelFieldScopeDefinition.all)
                  .withShouldPersist(true)
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
      late final maybeClassNamedExampleTable =
          CompilationUnitHelpers.tryFindClassDeclaration(
            compilationUnit,
            name: '${testClassName}Table',
          );

      group('then the class named ${testClassName}Table', () {
        test('has class variable for field.', () {
          expect(
            CompilationUnitHelpers.hasFieldDeclaration(
              maybeClassNamedExampleTable!,
              name: 'title',
              isFinal: true,
              isLate: true,
            ),
            isTrue,
            reason: 'Missing declaration for title field.',
          );
        });

        test('has field included in columns.', () {
          expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              maybeClassNamedExampleTable!,
              name: 'columns',
              functionExpression: '[id, title]',
            ),
            isTrue,
            reason: 'Missing title field in columns.',
          );
        });
      });
    },
  );

  group(
    'Given a class with table name and NON persistent field when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withTableName(tableName)
            .withField(
              FieldDefinitionBuilder()
                  .withName('title')
                  .withTypeDefinition('String', true)
                  .withScope(ModelFieldScopeDefinition.all)
                  .withShouldPersist(false)
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
      late final maybeClassNamedExampleTable =
          CompilationUnitHelpers.tryFindClassDeclaration(
            compilationUnit,
            name: '${testClassName}Table',
          );

      group('then the class named ${testClassName}Table', () {
        test(
          'does NOT have class variable for field.',
          () {
            expect(
              CompilationUnitHelpers.hasFieldDeclaration(
                maybeClassNamedExampleTable!,
                name: 'title',
                isFinal: true,
              ),
              isFalse,
              reason: 'Should not have declaration for title field.',
            );
          },
        );

        test('does NOT have field included in columns.', () {
          expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              maybeClassNamedExampleTable!,
              name: 'columns',
              functionExpression: '[id]',
            ),
            isTrue,
            reason: 'Should not include field in columns.',
          );
        });
      });
    },
  );

  group(
    'Given a class with table name and object relation field when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withTableName(tableName)
            .withObjectRelationField('company', 'Company', 'company')
            .build(),
      ];

      late final codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      late final compilationUnit = parseString(
        content: codeMap[expectedFilePath]!,
      ).unit;
      late final maybeClassNamedExampleTable =
          CompilationUnitHelpers.tryFindClassDeclaration(
            compilationUnit,
            name: '${testClassName}Table',
          );

      test(
        'then the class named ${testClassName}Table has a getRelationTable method.',
        () {
          expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              maybeClassNamedExampleTable!,
              name: 'getRelationTable',
            ),
            isTrue,
            reason: 'Missing declaration for getRelationTable method.',
          );
        },
      );
    },
  );

  group(
    'Given a class with table name and persistent field with scope none when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withTableName(tableName)
            .withField(
              FieldDefinitionBuilder()
                  .withName('_fieldName')
                  .withTypeDefinition('String', true)
                  .withScope(ModelFieldScopeDefinition.none)
                  .withShouldPersist(true)
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
      late final maybeClassNamedExampleTable =
          CompilationUnitHelpers.tryFindClassDeclaration(
            compilationUnit,
            name: '${testClassName}Table',
          );

      group('then the class named ${testClassName}Table', () {
        test('has \$ prefixed class variable for field.', () {
          expect(
            CompilationUnitHelpers.hasFieldDeclaration(
              maybeClassNamedExampleTable!,
              name: '\$_fieldName',
            ),
            isTrue,
            reason: 'Missing declaration for "\$_fieldName" field.',
          );
        });

        test('has \$ prefixed class variable included in columns getter.', () {
          var columnsGetter = CompilationUnitHelpers.tryFindMethodDeclaration(
            maybeClassNamedExampleTable!,
            name: 'columns',
          );

          expect(
            columnsGetter?.toSource(),
            contains('\$_fieldName'),
            reason: '"\$_fieldName" is missing in columns getter.',
          );
        });

        test('has \$ prefixed class variable included constructor.', () {
          var constructor =
              CompilationUnitHelpers.tryFindConstructorDeclaration(
                maybeClassNamedExampleTable!,
                name: null,
              );

          expect(
            constructor?.toSource(),
            contains('\$_fieldName'),
            reason: '"\$_fieldName" is missing in constructor getter.',
          );
        });

        test('has managedColumns override for columns', () {
          expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              maybeClassNamedExampleTable!,
              name: 'managedColumns',
            ),
            isTrue,
            reason: 'Missing declaration for managedColumns override.',
          );
        });
      });
    },
  );
  group(
    'Given a class with table name and object relation field when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withTableName(tableName)
            .withObjectRelationField('company', 'Company', 'company')
            .build(),
      ];

      late final codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      late final compilationUnit = parseString(
        content: codeMap[expectedFilePath]!,
      ).unit;
      late final maybeClassNamedExampleTable =
          CompilationUnitHelpers.tryFindClassDeclaration(
            compilationUnit,
            name: '${testClassName}Table',
          );

      group('then the class named ${testClassName}Table', () {
        test('has private field for relation table.', () {
          expect(
            CompilationUnitHelpers.hasFieldDeclaration(
              maybeClassNamedExampleTable!,
              type: 'CompanyTable?',
              name: '_company',
            ),
            isTrue,
            reason: 'Missing private field declaration for relation table.',
          );
        });

        test('has getter method for relation table.', () {
          expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              maybeClassNamedExampleTable!,
              name: 'company',
            ),
            isTrue,
            reason: 'Missing declaration for relation table getter.',
          );
        });
      });
    },
  );

  group(
    'Given a class with many relation object relation field when generating code',
    () {
      var relationFieldName = 'employees';
      var objectRelationType = 'Citizen';
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withTableName(tableName)
            .withListRelationField(
              relationFieldName,
              objectRelationType,
              'companyId',
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
      late final maybeClassNamedExampleTable =
          CompilationUnitHelpers.tryFindClassDeclaration(
            compilationUnit,
            name: '${testClassName}Table',
          );

      group(
        'then the class named ${testClassName}Table has many relation private field.',
        () {
          test('has private field for relation.', () {
            expect(
              CompilationUnitHelpers.hasFieldDeclaration(
                maybeClassNamedExampleTable!,
                name: '_$relationFieldName',
              ),
              isTrue,
              reason:
                  'Missing declaration for _$relationFieldName private field.',
            );
          });

          test('has getter for many relation.', () {
            expect(
              CompilationUnitHelpers.hasMethodDeclaration(
                maybeClassNamedExampleTable!,
                name: relationFieldName,
              ),
              isTrue,
              reason:
                  'Missing declaration for $relationFieldName many relation getter.',
            );
          });

          test(
            'has private field for the relation returning the relation table',
            () {
              var field = CompilationUnitHelpers.tryFindFieldDeclaration(
                maybeClassNamedExampleTable!,
                name: '___$relationFieldName',
              );

              expect(field, isNotNull);
              expect(field!.toSource(), contains('CitizenTable?'));
            },
          );

          test('has getter for many relation table', () {
            expect(
              CompilationUnitHelpers.hasMethodDeclaration(
                maybeClassNamedExampleTable!,
                name: '__$relationFieldName',
              ),
              isTrue,
              reason:
                  'Missing declaration for __$relationFieldName many relation getter.',
            );
          });
        },
      );
    },
  );

  group('Given a class with table name when generating code', () {
    var models = [
      ModelClassDefinitionBuilder()
          .withFileName(testClassFileName)
          .withClassName(testClassName)
          .withTableName(tableName)
          .build(),
    ];

    late final codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    late final compilationUnit = parseString(
      content: codeMap[expectedFilePath]!,
    ).unit;

    late final maybeClassNamedExampleUpdateTable =
        CompilationUnitHelpers.tryFindClassDeclaration(
          compilationUnit,
          name: '${testClassName}UpdateTable',
        );

    late final maybeClassNamedExampleTable =
        CompilationUnitHelpers.tryFindClassDeclaration(
          compilationUnit,
          name: '${testClassName}Table',
        );

    test('then a class named ${testClassName}UpdateTable is generated.', () {
      expect(
        maybeClassNamedExampleUpdateTable,
        isNotNull,
        reason:
            'Missing definition for class named ${testClassName}UpdateTable',
      );
    });

    group('then the class named ${testClassName}UpdateTable', () {
      test('extends UpdateTable<${testClassName}Table>.', () {
        expect(
          CompilationUnitHelpers.hasExtendsClause(
            maybeClassNamedExampleUpdateTable!,
            name: 'UpdateTable',
          ),
          isTrue,
          reason: 'Missing extends clause for UpdateTable.',
        );
      });

      test('has a constructor that takes super parameter.', () {
        expect(
          CompilationUnitHelpers.hasConstructorDeclaration(
            maybeClassNamedExampleUpdateTable!,
            name: null,
            parameters: ['super.table'],
          ),
          isTrue,
          reason: 'Missing constructor with super.table parameter.',
        );
      });
    });

    group('then the class named ${testClassName}Table', () {
      test('has an updateTable field.', () {
        expect(
          CompilationUnitHelpers.hasFieldDeclaration(
            maybeClassNamedExampleTable!,
            name: 'updateTable',
            type: '${testClassName}UpdateTable',
            isFinal: true,
            isLate: true,
          ),
          isTrue,
          reason: 'Missing updateTable field declaration.',
        );
      });
    });
  });

  group(
    'Given a class with table name and persistent field when generating UpdateTable',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withTableName(tableName)
            .withField(
              FieldDefinitionBuilder()
                  .withName('title')
                  .withTypeDefinition('String', true)
                  .withScope(ModelFieldScopeDefinition.all)
                  .withShouldPersist(true)
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

      late final maybeClassNamedExampleUpdateTable =
          CompilationUnitHelpers.tryFindClassDeclaration(
            compilationUnit,
            name: '${testClassName}UpdateTable',
          );

      group('then the class named ${testClassName}UpdateTable', () {
        test('has a method for the field.', () {
          expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              maybeClassNamedExampleUpdateTable!,
              name: 'title',
            ),
            isTrue,
            reason: 'Missing title method declaration.',
          );
        });

        test(
          'title method returns ColumnValue with correct type parameters.',
          () {
            var titleMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
              maybeClassNamedExampleUpdateTable!,
              name: 'title',
            );

            expect(titleMethod, isNotNull);
            expect(
              titleMethod!.toSource(),
              contains('ColumnValue<String, String>'),
              reason: 'title method should return ColumnValue<String, String>.',
            );
          },
        );

        test('title method takes nullable parameter.', () {
          var titleMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
            maybeClassNamedExampleUpdateTable!,
            name: 'title',
          );

          expect(titleMethod, isNotNull);
          expect(
            titleMethod!.toSource(),
            contains('String? value'),
            reason: 'title method should take nullable String parameter.',
          );
        });
      });
    },
  );

  group(
    'Given a class with table name and record field when generating UpdateTable',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withTableName(tableName)
            .withField(
              FieldDefinitionBuilder()
                  .withName('record')
                  .withType(
                    TypeDefinition(
                      className: '_Record',
                      generics: [
                        TypeDefinition(className: 'String', nullable: false),
                        TypeDefinition(className: 'int', nullable: false),
                      ],
                      nullable: true,
                    ),
                  )
                  .withScope(ModelFieldScopeDefinition.all)
                  .withShouldPersist(true)
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

      late final maybeClassNamedExampleUpdateTable =
          CompilationUnitHelpers.tryFindClassDeclaration(
            compilationUnit,
            name: '${testClassName}UpdateTable',
          );

      group('then the class named ${testClassName}UpdateTable', () {
        test('has a method for the record field.', () {
          expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              maybeClassNamedExampleUpdateTable!,
              name: 'record',
            ),
            isTrue,
            reason: 'Missing record method declaration.',
          );
        });

        test(
          'record method returns ColumnValue with Map<String, dynamic>? as second type parameter.',
          () {
            var recordMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
              maybeClassNamedExampleUpdateTable!,
              name: 'record',
            );

            expect(recordMethod, isNotNull);
            expect(
              recordMethod!.toSource(),
              contains('ColumnValue<(String, int), Map<String, dynamic>?>'),
              reason:
                  'record method should return ColumnValue with Map<String, dynamic>? as second type parameter.',
            );
          },
        );

        test('record method uses mapRecordToJson for value conversion.', () {
          var recordMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
            maybeClassNamedExampleUpdateTable!,
            name: 'record',
          );

          expect(recordMethod, isNotNull);
          expect(
            recordMethod!.toSource(),
            contains('mapRecordToJson(value)'),
            reason:
                'record method should use mapRecordToJson for value conversion.',
          );
        });
      });
    },
  );

  group(
    'Given a class with table name and NON persistent field when generating UpdateTable',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withTableName(tableName)
            .withField(
              FieldDefinitionBuilder()
                  .withName('title')
                  .withTypeDefinition('String', true)
                  .withScope(ModelFieldScopeDefinition.all)
                  .withShouldPersist(false)
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

      late final maybeClassNamedExampleUpdateTable =
          CompilationUnitHelpers.tryFindClassDeclaration(
            compilationUnit,
            name: '${testClassName}UpdateTable',
          );

      group('then the class named ${testClassName}UpdateTable', () {
        test('does NOT have a method for non-persistent field.', () {
          expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              maybeClassNamedExampleUpdateTable!,
              name: 'title',
            ),
            isFalse,
            reason: 'Should not have method for non-persistent field.',
          );
        });
      });
    },
  );
}
