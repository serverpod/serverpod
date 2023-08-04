import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
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

  group('Given empty class named $testClassName when generating code', () {
    var entities = [
      ClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .build()
    ];

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;

    test('then generated class imports server version of serverpod.', () {
      expect(
          CompilationUnitHelpers.hasImportDirective(compilationUnit,
              uri: 'package:serverpod/serverpod.dart'),
          isTrue,
          reason: 'Missing import of package:serverpod/serverpod.dart');
    });

    var maybeClassNamedExample = CompilationUnitHelpers.tryFindClassDeclaration(
        compilationUnit,
        name: testClassName);
    test('then class named $testClassName is generated.', () {
      expect(
        maybeClassNamedExample,
        isNotNull,
        reason: 'Missing definition for class named $testClassName',
      );
    });

    group('then class named $testClassName', () {
      var exampleClass = maybeClassNamedExample!;
      test('inherits from SerializableEntity.', () {
        expect(
            CompilationUnitHelpers.hasExtendsClause(exampleClass,
                name: 'SerializableEntity'),
            isTrue,
            reason: 'Missing extends clause for SerializableEntity.');
      });

      test('has fromJson factory.', () {
        expect(
            CompilationUnitHelpers.hasConstructorDeclaration(exampleClass,
                name: 'fromJson'),
            isTrue,
            reason: 'Missing declaration for fromJson factory.');
      });

      test('has toJson method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(exampleClass,
                name: 'toJson'),
            isTrue,
            reason: 'Missing declaration for toJson method');
      });

      test('has allToJson method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(exampleClass,
                name: 'allToJson'),
            isTrue,
            reason: 'Missing declaration for allToJson method.');
      });
    }, skip: maybeClassNamedExample == null);
  });

  group('Given class with documentation when generating code', () {
    var documentation = [
      '// This is an example documentation',
      '// This is another example'
    ];
    var entities = [
      ClassDefinitionBuilder()
          .withFileName(testClassFileName)
          .withDocumentation(documentation)
          .build()
    ];

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );

    test('then documentation is included in code.', () {
      for (var comment in documentation) {
        expect(codeMap[expectedFilePath], contains(comment));
      }
    });
  });

  group('Given a class with table name when generating code', () {
    var tableName = 'example_table';
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
    var maybeClassNamedExample = CompilationUnitHelpers.tryFindClassDeclaration(
        compilationUnit,
        name: testClassName);

    test('then class named $testClassName is generated.', () {
      expect(
        maybeClassNamedExample,
        isNotNull,
        reason: 'Missing definition for class named $testClassName.',
      );
    });

    group('then class named $testClassName', () {
      var exampleClass = maybeClassNamedExample!;
      test('inherits from TableRow.', () {
        expect(
            CompilationUnitHelpers.hasExtendsClause(exampleClass,
                name: 'TableRow'),
            isTrue,
            reason: 'Missing extends clause for TableRow.');
      });

      test('has id in constructor passed to super.', () {
        expect(
            CompilationUnitHelpers.hasConstructorDeclaration(exampleClass,
                name: null, parameters: ['int? id'], superArguments: ['id']),
            isTrue,
            reason:
                'Missing declaration for $testClassName constructor with nullable id field passed to super.');
      });

      test('has static Singleton instance.', () {
        expect(
            CompilationUnitHelpers.hasFieldDeclaration(exampleClass,
                name: 't',
                isFinal: true,
                isStatic: true,
                initializerMethod: '${testClassName}Table'),
            isTrue,
            reason: 'Missing declaration for ${testClassName}Table singleton.');
      });

      test('has "tableName" method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(exampleClass,
                name: 'tableName'),
            isTrue,
            reason: 'Missing declaration for "tableName" method.');
      });

      test('is NOT generated with id field.', () {
        expect(
            CompilationUnitHelpers.hasFieldDeclaration(exampleClass,
                name: 'id'),
            isFalse,
            reason: 'Declaration for id field should not be generated.');
      });

      test('has toJsonForDatabase method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(exampleClass,
                name: 'toJsonForDatabase'),
            isTrue,
            reason: 'Missing declaration for toJsonForDatabase method.');
      });

      test('has setColumn method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(exampleClass,
                name: 'setColumn'),
            isTrue,
            reason: 'Missing declaration for setColumn method.');
      });

      test('has a static "find" method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(exampleClass,
                name: 'find', isStatic: true),
            isTrue,
            reason: 'Missing declaration for static "find" method.');
      });

      test('has static "findSingleRow" method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(exampleClass,
                name: 'findSingleRow', isStatic: true),
            isTrue,
            reason: 'Missing declaration for static "findSingleRow" method.');
      });

      test('has findById static method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(exampleClass,
                name: 'findById', isStatic: true),
            isTrue,
            reason: 'Missing declaration for static "findById" method.');
      });

      test('has static "delete" method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(exampleClass,
                name: 'delete', isStatic: true),
            isTrue,
            reason: 'Missing declaration for static "delete" method.');
      });

      test('has static "deleteRow" method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(exampleClass,
                name: 'deleteRow', isStatic: true),
            isTrue,
            reason: 'Missing declaration static "deleteRow" method.');
      });

      test('has static "update" method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(exampleClass,
                name: 'update', isStatic: true),
            isTrue,
            reason: 'Missing declaration for static "update" method.');
      });

      test('has static "insert" method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(exampleClass,
                name: 'insert', isStatic: true),
            isTrue,
            reason: 'Missing declaration for static "insert" method.');
      });

      test('has static "count" method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(exampleClass,
                name: 'count', isStatic: true),
            isTrue,
            reason: 'Missing declaration for static "count" method.');
      });
    }, skip: maybeClassNamedExample == null);

    var maybeClassNamedExampleTable =
        CompilationUnitHelpers.tryFindClassDeclaration(compilationUnit,
            name: '${testClassName}Table');

    test('then class named ${testClassName}Table is generated.', () {
      expect(
        maybeClassNamedExampleTable,
        isNotNull,
        reason: 'Missing definition for class named ${testClassName}Table',
      );
    });
    group('then class named ${testClassName}Table', () {
      var exampleTableClass = maybeClassNamedExampleTable!;
      test('inherits from Table.', () {
        expect(
            CompilationUnitHelpers.hasExtendsClause(exampleTableClass,
                name: 'Table'),
            isTrue,
            reason: 'Missing extends clause for Table.');
      });

      test('has empty constructor that passes table name to super.', () {
        expect(
            CompilationUnitHelpers.hasConstructorDeclaration(exampleTableClass,
                name: null,
                parameters: [],
                superArguments: ['tableName: \'$tableName\'']),
            isTrue,
            reason:
                'Missing declaration for $testClassName constructor with nullable id field passed to super.');
      });

      test('has "columns" method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(exampleTableClass,
                name: 'columns'),
            isTrue,
            reason: 'Missing declaration for "columns" getter.');
      });
    }, skip: maybeClassNamedExampleTable == null);

    test(
        'then top level variable t$testClassName marked deprecated is generated.',
        () {
      expect(
          CompilationUnitHelpers.hasTopLevelVariableDeclaration(compilationUnit,
              name: 't$testClassName', annotations: ['Deprecated']),
          isTrue,
          reason:
              'Missing top level variable declaration for "t$testClassName" marked deprecated.');
    });

    test('then type alias ${testClassName}ExpressionBuilder is generated.', () {
      expect(
          CompilationUnitHelpers.hasTypeAliasDeclaration(compilationUnit,
              name: '${testClassName}ExpressionBuilder'),
          isTrue,
          reason:
              'Missing type alias for "${testClassName}ExpressionBuilder".');
    });
  });

  group(
      'Given a class with table name and persistent field when generating code',
      () {
    var entities = [
      ClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withTableName('example_table')
          .withField(
            SerializableEntityFieldDefinition(
                name: 'title',
                type: TypeDefinition(className: 'String', nullable: true),
                scope: EntityFieldScopeDefinition.all,
                shouldPersist: true),
          )
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

    group('then class named ${testClassName}Table', () {
      test('has class variable for field.', () {
        var exampleTableClass = maybeClassNamedExampleTable!;
        expect(
            CompilationUnitHelpers.hasFieldDeclaration(exampleTableClass,
                name: 'title', isFinal: true),
            isTrue,
            reason: 'Missing declaration for title field.');
      });

      test('has field included in columns.', () {
        var exampleTableClass = maybeClassNamedExampleTable!;
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(exampleTableClass,
                name: 'columns', functionExpression: '[id, title]'),
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
          .withTableName('example_table')
          .withField(
            SerializableEntityFieldDefinition(
                name: 'title',
                type: TypeDefinition(className: 'String', nullable: true),
                scope: EntityFieldScopeDefinition.all,
                shouldPersist: false),
          )
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

    group('then class named ${testClassName}Table', () {
      test(
        'does NOT have class variable for field.',
        () {
          var exampleTableClass = maybeClassNamedExampleTable!;
          expect(
              CompilationUnitHelpers.hasFieldDeclaration(exampleTableClass,
                  name: 'title', isFinal: true),
              isFalse,
              reason: 'Should not have declaration for title field.');
        },
      );

      test('does NOT have field included in columns.', () {
        var exampleTableClass = maybeClassNamedExampleTable!;
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(exampleTableClass,
                name: 'columns', functionExpression: '[id]'),
            isTrue,
            reason: 'Should not include field in columns.');
      });
    },
        skip: maybeClassNamedExampleTable == null
            ? 'Could not run test because ${testClassName}Table class was not found.'
            : false);
  });

  group('Given a class with a none nullable field when generating code', () {
    var entities = [
      ClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withSimpleField('title', 'String')
          .build()
    ];

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;
    var maybeClassNamedExample = CompilationUnitHelpers.tryFindClassDeclaration(
        compilationUnit,
        name: testClassName);
    group('then class name $testClassName', () {
      var exampleClass = maybeClassNamedExample!;
      test('has field as required in constructor.', () {
        expect(
            CompilationUnitHelpers.hasConstructorDeclaration(exampleClass,
                name: null, parameters: ['required this.title']),
            isTrue,
            reason: 'Missing declaration for $testClassName constructor.');
      });

      test('has that class variable.', () {
        expect(
          CompilationUnitHelpers.hasFieldDeclaration(exampleClass,
              name: 'title', type: 'String'),
          isTrue,
          reason: 'Missing declaration for title field.',
        );
      });
    },
        skip: maybeClassNamedExample == null
            ? 'Could not run test because $testClassName class was not found.'
            : false);
  });

  group('Given a class with a nullable field when generating code', () {
    var entities = [
      ClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withSimpleField('title', 'String', nullable: true)
          .build()
    ];

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;
    var maybeClassNamedExample = CompilationUnitHelpers.tryFindClassDeclaration(
        compilationUnit,
        name: testClassName);
    group('then class named $testClassName', () {
      var exampleClass = maybeClassNamedExample!;
      test('has field in constructor.', () {
        expect(
            CompilationUnitHelpers.hasConstructorDeclaration(exampleClass,
                name: null, parameters: ['this.title']),
            isTrue,
            reason: 'Missing declaration for $testClassName constructor.');
      });

      test('has that class variable.', () {
        expect(
          CompilationUnitHelpers.hasFieldDeclaration(exampleClass,
              name: 'title', type: 'String?'),
          isTrue,
          reason: 'Missing declaration for title field.',
        );
      });
    },
        skip: maybeClassNamedExample == null
            ? 'Could not run test because $testClassName class was not found.'
            : false);
  });

  group('Given a class with an all scoped field when generating code', () {
    var entities = [
      ClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withField(
            SerializableEntityFieldDefinition(
                name: 'title',
                type: TypeDefinition(className: 'String', nullable: true),
                scope: EntityFieldScopeDefinition.all,
                shouldPersist: false),
          )
          .build()
    ];

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;
    var maybeClassNamedExample = CompilationUnitHelpers.tryFindClassDeclaration(
        compilationUnit,
        name: testClassName);
    test(
      'then a class is generated with that class variable.',
      () {
        var exampleClass = maybeClassNamedExample!;
        expect(
            CompilationUnitHelpers.hasFieldDeclaration(exampleClass,
                name: 'title', type: 'String?'),
            isTrue,
            reason: 'Missing declaration for title field');
      },
      skip: maybeClassNamedExample == null
          ? 'Could not run test because $testClassName class was not found.'
          : false,
    );
  });

  group('Given a class with a database scoped field when generating code', () {
    var entities = [
      ClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withField(
            SerializableEntityFieldDefinition(
              name: 'title',
              type: TypeDefinition(className: 'String', nullable: true),
              scope: EntityFieldScopeDefinition.serverOnly,
              shouldPersist: false,
            ),
          )
          .build()
    ];

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;
    var maybeClassNamedExample = CompilationUnitHelpers.tryFindClassDeclaration(
        compilationUnit,
        name: testClassName);
    test(
      'then a class is generated with that class variable.',
      () {
        var exampleClass = maybeClassNamedExample!;
        expect(
            CompilationUnitHelpers.hasFieldDeclaration(exampleClass,
                name: 'title', type: 'String?'),
            isTrue,
            reason: 'Missing declaration for title field.');
      },
      skip: maybeClassNamedExample == null
          ? 'Could not run test because $testClassName class was not found.'
          : false,
    );
  });
}
