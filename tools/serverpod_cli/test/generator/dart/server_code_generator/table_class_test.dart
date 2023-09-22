import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:serverpod_cli/src/test_util/builders/serializable_entity_field_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/compilation_unit_helpers.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;

import 'package:serverpod_cli/src/test_util/builders/class_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  var testClassName = 'Example';
  var testClassFileName = 'example';
  var expectedFilePath =
      path.join('lib', 'src', 'generated', '$testClassFileName.dart');
  var tableName = 'example_table';
  group('Given a class with table name when generating code', () {
    var entities = [
      ClassDefinitionBuilder()
          .withFileName(testClassFileName)
          .withTableName(tableName)
          .build()
    ];

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;

    var maybeClassNamedExampleTable =
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

    group('then class named ${testClassName}Table', () {
      test('inherits from ${testClassName}WithoutManyRelationsTable.', () {
        expect(
            CompilationUnitHelpers.hasExtendsClause(
              maybeClassNamedExampleTable!,
              name: '${testClassName}WithoutManyRelationsTable',
            ),
            isTrue,
            reason:
                'Missing extends clause for ${testClassName}WithoutManyRelationsTable.');
      });

      test('has constructor taking query prefix and table relations as super.',
          () {
        expect(
            CompilationUnitHelpers.hasConstructorDeclaration(
              maybeClassNamedExampleTable!,
              name: null,
              parameters: ['super.queryPrefix', 'super.tableRelations'],
            ),
            isTrue,
            reason:
                'Missing declaration for ${testClassName}Table constructor.');
      });
    }, skip: maybeClassNamedExampleTable == null);

    var maybeClassNamedExampleWithoutManyRelationsTable =
        CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '${testClassName}WithoutManyRelationsTable',
    );

    test(
        'then a class named ${testClassName}WithoutManyRelationsTable is generated.',
        () {
      expect(
        maybeClassNamedExampleWithoutManyRelationsTable,
        isNotNull,
        reason:
            'Missing definition for class named ${testClassName}WithoutManyRelationsTable',
      );
    });
    group('then the class named ${testClassName}WithoutManyRelationsTable', () {
      test('inherits from Table.', () {
        expect(
            CompilationUnitHelpers.hasExtendsClause(
              maybeClassNamedExampleWithoutManyRelationsTable!,
              name: 'Table',
            ),
            isTrue,
            reason: 'Missing extends clause for Table.');
      });

      test(
          'has constructor taking query prefix and table relations and passes table name to super.',
          () {
        expect(
            CompilationUnitHelpers.hasConstructorDeclaration(
              maybeClassNamedExampleWithoutManyRelationsTable!,
              name: null,
              parameters: ['super.queryPrefix', 'super.tableRelations'],
              superArguments: ['tableName: \'$tableName\''],
            ),
            isTrue,
            reason:
                'Missing declaration for ${testClassName}WithoutManyRelationsTable constructor.');
      });

      test('has a columns method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              maybeClassNamedExampleWithoutManyRelationsTable!,
              name: 'columns',
            ),
            isTrue,
            reason: 'Missing declaration for columns getter.');
      });

      test('does NOT have getRelationTable method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              maybeClassNamedExampleWithoutManyRelationsTable!,
              name: 'getRelationTable',
            ),
            isFalse,
            reason:
                'Declaration for getRelationTable method should not be generated.');
      });

      test('does NOT have id field.', () {
        expect(
            CompilationUnitHelpers.hasFieldDeclaration(
              maybeClassNamedExampleWithoutManyRelationsTable!,
              name: 'id',
            ),
            isFalse,
            reason: 'Declaration for id field should not be generated.');
      });
    }, skip: maybeClassNamedExampleWithoutManyRelationsTable == null);
  });

  group(
      'Given a class with table name and persistent field when generating code',
      () {
    var entities = [
      ClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withTableName(tableName)
          .withField(
            FieldDefinitionBuilder()
                .withName('title')
                .withTypeDefinition('String', true)
                .withScope(EntityFieldScopeDefinition.all)
                .withShouldPersist(true)
                .build(),
          )
          .build()
    ];

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;
    var maybeClassNamedExampleWithoutManyRelationsTable =
        CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '${testClassName}WithoutManyRelationsTable',
    );

    group('then the class named ${testClassName}WithoutManyRelationsTable', () {
      test('has class variable for field.', () {
        expect(
            CompilationUnitHelpers.hasFieldDeclaration(
              maybeClassNamedExampleWithoutManyRelationsTable!,
              name: 'title',
              isFinal: true,
              isLate: true,
            ),
            isTrue,
            reason: 'Missing declaration for title field.');
      });

      test('has field included in columns.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              maybeClassNamedExampleWithoutManyRelationsTable!,
              name: 'columns',
              functionExpression: '[id, title]',
            ),
            isTrue,
            reason: 'Missing title field in columns.');
      });
    },
        skip: maybeClassNamedExampleWithoutManyRelationsTable == null
            ? 'Could not run test because ${testClassName}WithoutManyRelationsTable class was not found'
            : false);
  });

  group(
      'Given a class with table name and NON persistent field when generating code',
      () {
    var entities = [
      ClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withTableName(tableName)
          .withField(
            FieldDefinitionBuilder()
                .withName('title')
                .withTypeDefinition('String', true)
                .withScope(EntityFieldScopeDefinition.all)
                .withShouldPersist(false)
                .build(),
          )
          .build()
    ];

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;
    var maybeClassNamedExampleWithoutManyRelationsTable =
        CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '${testClassName}WithoutManyRelationsTable',
    );

    group('then the class named ${testClassName}WithoutManyRelationsTable', () {
      test(
        'does NOT have class variable for field.',
        () {
          expect(
              CompilationUnitHelpers.hasFieldDeclaration(
                maybeClassNamedExampleWithoutManyRelationsTable!,
                name: 'title',
                isFinal: true,
              ),
              isFalse,
              reason: 'Should not have declaration for title field.');
        },
      );

      test('does NOT have field included in columns.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              maybeClassNamedExampleWithoutManyRelationsTable!,
              name: 'columns',
              functionExpression: '[id]',
            ),
            isTrue,
            reason: 'Should not include field in columns.');
      });
    },
        skip: maybeClassNamedExampleWithoutManyRelationsTable == null
            ? 'Could not run test because ${testClassName}WithoutManyRelationsTable class was not found.'
            : false);
  });

  group(
      'Given a class with table name and object relation field when generating code',
      () {
    var objectRelationType = 'Company';
    var entities = [
      ClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withTableName(tableName)
          .withObjectRelationField('company', objectRelationType, 'company')
          .build()
    ];

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;
    var maybeClassNamedExampleWithoutManyRelationsTable =
        CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '${testClassName}WithoutManyRelationsTable',
    );

    group('then the class named ${testClassName}WithoutManyRelationsTable', () {
      test('has a getRelationTable method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              maybeClassNamedExampleWithoutManyRelationsTable!,
              name: 'getRelationTable',
            ),
            isTrue,
            reason: 'Missing declaration for getRelationTable method.');
      });

      test('has private field for relation.', () {
        expect(
            CompilationUnitHelpers.hasFieldDeclaration(
              maybeClassNamedExampleWithoutManyRelationsTable!,
              name: '_company',
            ),
            isTrue,
            reason: 'Missing declaration for _company field.');
      });

      test(
          'has private field for relation with return type ${objectRelationType}Table.',
          () {
        var field = CompilationUnitHelpers.tryFindFieldDeclaration(
          maybeClassNamedExampleWithoutManyRelationsTable!,
          name: '_company',
        );

        expect(field?.toSource(), contains('${objectRelationType}Table?'),
            reason:
                'Wrong return type for field declaration for _company field.');
      });

      test('has getter for relation field.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              maybeClassNamedExampleWithoutManyRelationsTable!,
              name: 'company',
            ),
            isTrue,
            reason: 'Missing declaration for company getter method.');
      });

      test(
          'has getter for relation with return type ${objectRelationType}Table.',
          () {
        var getter = CompilationUnitHelpers.tryFindMethodDeclaration(
          maybeClassNamedExampleWithoutManyRelationsTable!,
          name: 'company',
        );

        expect(getter?.toSource(), contains('${objectRelationType}Table get'),
            reason:
                'Wrong return type for field declaration for company getter method.');
      });
    },
        skip: maybeClassNamedExampleWithoutManyRelationsTable == null
            ? 'Could not run test because ${testClassName}WithoutManyRelationsTable class was not found.'
            : false);
  });

  group(
      'Given a class with many relation object relation field when generating code',
      () {
    var relationFieldName = 'employees';
    var objectRelationType = 'Citizen';
    var entities = [
      ClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withTableName(tableName)
          .withListObjectRelationField(relationFieldName, objectRelationType)
          .build()
    ];

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;
    var maybeClassNamedExampleTable =
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
                'Missing declaration for _$relationFieldName private field.');
      });

      test(
          'has private field for relation with return type ${objectRelationType}WithoutManyRelationsTable.',
          () {
        var field = CompilationUnitHelpers.tryFindFieldDeclaration(
          maybeClassNamedExampleTable!,
          name: '_$relationFieldName',
        );

        expect(field?.toSource(),
            contains('${objectRelationType}WithoutManyRelationsTable?'),
            reason: 'Wrong return type for _$relationFieldName field.');
      });

      test('has private getter for relation table.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              maybeClassNamedExampleTable!,
              name: '_${relationFieldName}Table',
            ),
            isTrue,
            reason:
                'Missing declaration for _$relationFieldName private getter.');
      });

      test(
          'has getter for relation table with return type ${objectRelationType}WithoutManyRelationsTable.',
          () {
        var getter = CompilationUnitHelpers.tryFindMethodDeclaration(
          maybeClassNamedExampleTable!,
          name: '_${relationFieldName}Table',
        );

        expect(getter?.toSource(),
            contains('${objectRelationType}WithoutManyRelationsTable get'),
            reason: 'Wrong return type for _$relationFieldName field.');
      });

      test('has method for many relation.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(
                maybeClassNamedExampleTable!,
                name: relationFieldName,
                parameters: [
                  '${objectRelationType}WithoutManyRelationsExpressionBuilder where'
                ],
                returnTypeContains: 'ManyRelation'),
            isTrue,
            reason:
                'Missing method declaration for $relationFieldName many relation.');
      });
    },
        skip: maybeClassNamedExampleTable == null
            ? 'Could not run test because ${testClassName}WithoutManyRelationsTable class was not found.'
            : false);
  });
}
