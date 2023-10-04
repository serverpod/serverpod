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
    group('then the class named ${testClassName}Table', () {
      test('inherits from Table.', () {
        expect(
            CompilationUnitHelpers.hasExtendsClause(
              maybeClassNamedExampleTable!,
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
              maybeClassNamedExampleTable!,
              name: null,
              parameters: ['super.queryPrefix', 'super.tableRelations'],
              superArguments: ['tableName: \'$tableName\''],
            ),
            isTrue,
            reason:
                'Missing declaration for $testClassName constructor with nullable id field passed to super.');
      });

      test('has a columns method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              maybeClassNamedExampleTable!,
              name: 'columns',
            ),
            isTrue,
            reason: 'Missing declaration for columns getter.');
      });

      test('does NOT have getRelationTable method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              maybeClassNamedExampleTable!,
              name: 'getRelationTable',
            ),
            isFalse,
            reason:
                'Declaration for getRelationTable method should not be generated.');
      });

      test('does NOT have id field.', () {
        expect(
            CompilationUnitHelpers.hasFieldDeclaration(
              maybeClassNamedExampleTable!,
              name: 'id',
            ),
            isFalse,
            reason: 'Declaration for id field should not be generated.');
      });
    }, skip: maybeClassNamedExampleTable == null);
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
    var maybeClassNamedExampleTable =
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
            reason: 'Missing declaration for title field.');
      });

      test('has field included in columns.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              maybeClassNamedExampleTable!,
              name: 'columns',
              functionExpression: '[id, title]',
            ),
            isTrue,
            reason: 'Missing title field in columns.');
      });
    },
        skip: maybeClassNamedExampleTable == null
            ? 'Could not run test because ${testClassName}Table class was not found'
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
    var maybeClassNamedExampleTable =
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
              reason: 'Should not have declaration for title field.');
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
            reason: 'Should not include field in columns.');
      });
    },
        skip: maybeClassNamedExampleTable == null
            ? 'Could not run test because ${testClassName}Table class was not found.'
            : false);
  });

  group(
      'Given a class with table name and object relation field when generating code',
      () {
    var entities = [
      ClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withTableName(tableName)
          .withObjectRelationField('company', 'Company', 'company')
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

    test(
        'then the class named ${testClassName}Table has a getRelationTable method.',
        () {
      expect(
          CompilationUnitHelpers.hasMethodDeclaration(
            maybeClassNamedExampleTable!,
            name: 'getRelationTable',
          ),
          isTrue,
          reason: 'Missing declaration for getRelationTable method.');
    },
        skip: maybeClassNamedExampleTable == null
            ? 'Could not run test because ${testClassName}Table class was not found.'
            : false);
  });

  group(
      'Given a class with table name and persistent field with scope none when generating code',
      () {
    var entities = [
      ClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withTableName(tableName)
          .withField(
            FieldDefinitionBuilder()
                .withName('_fieldName')
                .withTypeDefinition('String', true)
                .withScope(EntityFieldScopeDefinition.none)
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
    var maybeClassNamedExampleTable =
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
            reason: 'Missing declaration for "\$_fieldName" field.');
      });

      test('has \$ prefixed class variable included in columns getter.', () {
        var columnsGetter = CompilationUnitHelpers.tryFindMethodDeclaration(
          maybeClassNamedExampleTable!,
          name: 'columns',
        );

        expect(columnsGetter?.toSource(), contains('\$_fieldName'),
            reason: '"\$_fieldName" is missing in columns getter.');
      });

      test('has \$ prefixed class variable included constructor.', () {
        var constructor = CompilationUnitHelpers.tryFindConstructorDeclaration(
          maybeClassNamedExampleTable!,
          name: null,
        );

        expect(
          constructor?.toSource(),
          contains('\$_fieldName'),
          reason: '"\$_fieldName" is missing in constructor getter.',
        );
      },
          skip: maybeClassNamedExampleTable == null
              ? 'Could not run test because ${testClassName}Table class was not found.'
              : false);
    });
  });
  group(
      'Given a class with table name and object relation field when generating code',
      () {
    var entities = [
      ClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withTableName(tableName)
          .withObjectRelationField('company', 'Company', 'company')
          .build()
    ];

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;
    var maybeClassNamedExampleTable =
        CompilationUnitHelpers.tryFindClassDeclaration(compilationUnit,
            name: '${testClassName}Table');

    group('then the class named ${testClassName}Table', () {
      test('has private field for relation table.', () {
        expect(
            CompilationUnitHelpers.hasFieldDeclaration(
                maybeClassNamedExampleTable!,
                type: 'CompanyTable?',
                name: '_company'),
            isTrue,
            reason: 'Missing private field declaration for relation table.');
      });

      test('has getter method for relation table.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              maybeClassNamedExampleTable!,
              name: 'company',
            ),
            isTrue,
            reason: 'Missing declaration for relation table getter.');
      });
    },
        skip: maybeClassNamedExampleTable == null
            ? 'Could not run test because ${testClassName}Table class was not found.'
            : false);
  });
}
