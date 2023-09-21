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
          CompilationUnitHelpers.hasImportDirective(
            compilationUnit,
            uri: 'package:serverpod/serverpod.dart',
          ),
          isTrue,
          reason: 'Missing import of package:serverpod/serverpod.dart');
    });

    var maybeClassNamedExample = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: testClassName,
    );
    test('then a class named $testClassName is generated.', () {
      expect(
        maybeClassNamedExample,
        isNotNull,
        reason: 'Missing definition for class named $testClassName',
      );
    });

    group('then the class named $testClassName', () {
      test('inherits from SerializableEntity.', () {
        expect(
            CompilationUnitHelpers.hasExtendsClause(
              maybeClassNamedExample!,
              name: 'SerializableEntity',
            ),
            isTrue,
            reason: 'Missing extends clause for SerializableEntity.');
      });

      test('has a fromJson factory.', () {
        expect(
            CompilationUnitHelpers.hasConstructorDeclaration(
              maybeClassNamedExample!,
              name: 'fromJson',
            ),
            isTrue,
            reason: 'Missing declaration for fromJson factory.');
      });

      test('has a toJson method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              maybeClassNamedExample!,
              name: 'toJson',
            ),
            isTrue,
            reason: 'Missing declaration for toJson method');
      });

      test('has a allToJson method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              maybeClassNamedExample!,
              name: 'allToJson',
            ),
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
      name: testClassName,
    );

    test('then a class named $testClassName is generated.', () {
      expect(
        maybeClassNamedExample,
        isNotNull,
        reason: 'Missing definition for class named $testClassName.',
      );
    });

    group('then the class named $testClassName', () {
      test('inherits from TableRow.', () {
        expect(
            CompilationUnitHelpers.hasExtendsClause(
              maybeClassNamedExample!,
              name: 'TableRow',
            ),
            isTrue,
            reason: 'Missing extends clause for TableRow.');
      });

      group('has a constructor', () {
        var constructor = CompilationUnitHelpers.tryFindConstructorDeclaration(
            maybeClassNamedExample!,
            name: '_');

        test('defined', () {
          expect(constructor, isNotNull, reason: 'No private constructor');
        });

        test('with id param', () {
          expect(constructor?.parameters.toSource(), '({int? id})');
        });

        test('passing id to super', () {
          expect(constructor?.initializers.first.toSource(), 'super(id)');
        });
      });

      test('has a static Singleton instance.', () {
        expect(
            CompilationUnitHelpers.hasFieldDeclaration(
              maybeClassNamedExample!,
              name: 't',
              isFinal: true,
              isStatic: true,
              initializerMethod: '${testClassName}Table',
            ),
            isTrue,
            reason: 'Missing declaration for ${testClassName}Table singleton.');
      });

      test('has a table getter.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              maybeClassNamedExample!,
              name: 'table',
            ),
            isTrue,
            reason: 'Missing declaration for table method.');
      });

      test('is NOT generated with id field.', () {
        expect(
            CompilationUnitHelpers.hasFieldDeclaration(
              maybeClassNamedExample!,
              name: 'id',
            ),
            isFalse,
            reason: 'Declaration for id field should not be generated.');
      });

      test('has a toJsonForDatabase method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              maybeClassNamedExample!,
              name: 'toJsonForDatabase',
            ),
            isTrue,
            reason: 'Missing declaration for toJsonForDatabase method.');
      });

      test('has a setColumn method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              maybeClassNamedExample!,
              name: 'setColumn',
            ),
            isTrue,
            reason: 'Missing declaration for setColumn method.');
      });

      test('has a static find method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              maybeClassNamedExample!,
              name: 'find',
              isStatic: true,
            ),
            isTrue,
            reason: 'Missing declaration for static find method.');
      });

      test('has a static findSingleRow method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              maybeClassNamedExample!,
              name: 'findSingleRow',
              isStatic: true,
            ),
            isTrue,
            reason: 'Missing declaration for static findSingleRow method.');
      });

      test('has a findById static method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              maybeClassNamedExample!,
              name: 'findById',
              isStatic: true,
            ),
            isTrue,
            reason: 'Missing declaration for static findById method.');
      });

      test('has a static delete method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              maybeClassNamedExample!,
              name: 'delete',
              isStatic: true,
            ),
            isTrue,
            reason: 'Missing declaration for static delete method.');
      });

      test('has a static deleteRow method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              maybeClassNamedExample!,
              name: 'deleteRow',
              isStatic: true,
            ),
            isTrue,
            reason: 'Missing declaration static deleteRow method.');
      });

      test('has a static update method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              maybeClassNamedExample!,
              name: 'update',
              isStatic: true,
            ),
            isTrue,
            reason: 'Missing declaration for static update method.');
      });

      test('has a static insert method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              maybeClassNamedExample!,
              name: 'insert',
              isStatic: true,
            ),
            isTrue,
            reason: 'Missing declaration for static insert method.');
      });

      test('has a static count method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              maybeClassNamedExample!,
              name: 'count',
              isStatic: true,
            ),
            isTrue,
            reason: 'Missing declaration for static count method.');
      });

      test('has a static include method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              maybeClassNamedExample!,
              name: 'include',
              isStatic: true,
            ),
            isTrue,
            reason: 'Missing declaration for static include method.');
      });
    }, skip: maybeClassNamedExample == null);

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

    test(
        'then top level variable t$testClassName marked deprecated is generated.',
        () {
      expect(
          CompilationUnitHelpers.hasTopLevelVariableDeclaration(
            compilationUnit,
            name: 't$testClassName',
            annotations: ['Deprecated'],
          ),
          isTrue,
          reason:
              'Missing top level variable declaration for "t$testClassName" marked deprecated.');
    });

    test('then type alias ${testClassName}ExpressionBuilder is generated.', () {
      expect(
          CompilationUnitHelpers.hasTypeAliasDeclaration(
            compilationUnit,
            name: '${testClassName}ExpressionBuilder',
          ),
          isTrue,
          reason:
              'Missing type alias for "${testClassName}ExpressionBuilder".');
    });

    test('then a class named ${testClassName}Include is generated.', () {
      expect(
          CompilationUnitHelpers.hasClassDeclaration(
            compilationUnit,
            name: '${testClassName}Include',
          ),
          isTrue,
          reason: 'Missing class named ${testClassName}Include.');
    });
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
    var maybeClassNamedExampleInclude =
        CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '${testClassName}Include',
    );

    group('then the class named ${testClassName}Include', () {
      var exampleIncludeClass = maybeClassNamedExampleInclude!;
      test('inherits from Include.', () {
        expect(
            CompilationUnitHelpers.hasExtendsClause(
              exampleIncludeClass,
              name: 'Include',
            ),
            isTrue,
            reason: 'Missing extends clause for Include.');
      });
      test('has named parameter for field in private constructor.', () {
        expect(
            CompilationUnitHelpers.hasConstructorDeclaration(
              exampleIncludeClass,
              name: '_',
              parameters: ['CompanyInclude? company'],
            ),
            isTrue,
            reason:
                'Missing constructor with named parameter for field in ${testClassName}Include.');
      });

      test('has private field as nullable class variable.', () {
        expect(
            CompilationUnitHelpers.hasFieldDeclaration(
              exampleIncludeClass,
              name: '_company',
              type: 'CompanyInclude?',
            ),
            isTrue,
            reason:
                'Missing declaration for company field in ${testClassName}Include.');
      });
      test('has an includes method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              exampleIncludeClass,
              name: 'includes',
            ),
            isTrue,
            reason: 'Missing declaration for includes method.');
      });

      test('has a table method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(
              exampleIncludeClass,
              name: 'table',
              functionExpression: 'Example.t',
            ),
            isTrue,
            reason: 'Missing declaration for table method.');
      });
    },
        skip: maybeClassNamedExampleInclude == null
            ? 'Could not run test because ${testClassName}Include class was not found.'
            : false);

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
      name: testClassName,
    );
    group('then the class named $testClassName', () {
      test('has field as required in constructor.', () {
        expect(
            CompilationUnitHelpers.hasConstructorDeclaration(
              maybeClassNamedExample!,
              name: null,
              parameters: ['required String title'],
            ),
            isTrue,
            reason: 'Missing declaration for $testClassName constructor.');
      });

      test('has that class variable.', () {
        expect(
          CompilationUnitHelpers.hasFieldDeclaration(
            maybeClassNamedExample!,
            name: 'title',
            type: 'String',
          ),
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
      name: testClassName,
    );
    group('then the class named $testClassName', () {
      test('has field in constructor.', () {
        expect(
            CompilationUnitHelpers.hasConstructorDeclaration(
              maybeClassNamedExample!,
              name: null,
              parameters: ['String? title'],
            ),
            isTrue,
            reason: 'Missing declaration for $testClassName constructor.');
      });

      test('has that class variable.', () {
        expect(
          CompilationUnitHelpers.hasFieldDeclaration(
            maybeClassNamedExample!,
            name: 'title',
            type: 'String?',
          ),
          isTrue,
          reason: 'Missing declaration for title field.',
        );
      });
    },
        skip: maybeClassNamedExample == null
            ? 'Could not run test because $testClassName class was not found.'
            : false);
  });

  group(
      'Given a class with a non persistent field with scope all when generating code',
      () {
    var entities = [
      ClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withField(
            FieldDefinitionBuilder()
                .withName('title')
                .withTypeDefinition('String', true)
                .withScope(EntityFieldScopeDefinition.all)
                .build(),
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
      name: testClassName,
    );
    test(
      'then a class is generated with that class variable.',
      () {
        expect(
            CompilationUnitHelpers.hasFieldDeclaration(
              maybeClassNamedExample!,
              name: 'title',
              type: 'String?',
            ),
            isTrue,
            reason: 'Missing declaration for title field');
      },
      skip: maybeClassNamedExample == null
          ? 'Could not run test because $testClassName class was not found.'
          : false,
    );
  });

  group(
      'Given a class with a non persistent field with scope serverOnly when generating code',
      () {
    var entities = [
      ClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withField(
            FieldDefinitionBuilder()
                .withName('title')
                .withTypeDefinition('String', true)
                .withScope(EntityFieldScopeDefinition.serverOnly)
                .build(),
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
      name: testClassName,
    );
    test(
      'then a class is generated with that class variable.',
      () {
        expect(
            CompilationUnitHelpers.hasFieldDeclaration(
              maybeClassNamedExample!,
              name: 'title',
              type: 'String?',
            ),
            isTrue,
            reason: 'Missing declaration for title field.');
      },
      skip: maybeClassNamedExample == null
          ? 'Could not run test because $testClassName class was not found.'
          : false,
    );
  });

  group(
      'Given a class with a non persistent field with scope none when generating code',
      () {
    var entities = [
      ClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withField(
            SerializableEntityFieldDefinition(
              name: 'title',
              type: TypeDefinition(className: 'String', nullable: true),
              scope: EntityFieldScopeDefinition.none,
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
      'then a class is NOT generated with that class variable.',
      () {
        expect(
            CompilationUnitHelpers.hasFieldDeclaration(maybeClassNamedExample!,
                name: 'title', type: 'String?'),
            isFalse,
            reason: 'Found declaration for field that should not exist.');
      },
      skip: maybeClassNamedExample == null
          ? 'Could not run test because $testClassName class was not found.'
          : false,
    );
  });

  group('Given exception class when generating code', () {
    var entities = [
      ClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withIsException(true)
          .build()
    ];

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;

    var maybeClassNamedExample = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: testClassName,
    );
    test(
      'then class implements SerializableException.',
      () {
        expect(
            CompilationUnitHelpers.hasImplementsClause(
              maybeClassNamedExample!,
              name: 'SerializableException',
            ),
            isTrue,
            reason: 'Class should implement SerializableException.');
      },
      skip: maybeClassNamedExample == null
          ? 'Could not run test because $testClassName class was not found.'
          : false,
    );
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
