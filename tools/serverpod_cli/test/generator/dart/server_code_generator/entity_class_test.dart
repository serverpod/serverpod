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

  group(
      'Given a class with a persistent field with scope none when generating code',
      () {
    var fieldName = 'implicit_field';
    var entities = [
      ClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withTableName(tableName)
          .withField(
            SerializableEntityFieldDefinition(
              name: fieldName,
              type: TypeDefinition(className: 'String', nullable: true),
              scope: EntityFieldScopeDefinition.none,
              shouldPersist: true,
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
      name: testClassName,
    );

    group(
      'then class',
      () {
        test('is generated with field as hidden class variable.', () {
          expect(
              CompilationUnitHelpers.hasFieldDeclaration(
                  maybeClassNamedExample!,
                  name: '_$fieldName',
                  type: 'String?'),
              isTrue,
              reason: 'Field declaration missing for $fieldName.');
        });

        test('has a toJsonForDatabase that uses hidden class variable.', () {
          var maybeToJsonForDatabase =
              CompilationUnitHelpers.tryFindMethodDeclaration(
            maybeClassNamedExample!,
            name: 'toJsonForDatabase',
          );

          expect(maybeToJsonForDatabase, isNotNull,
              reason: 'Missing declaration for toJsonForDatabase method.');
          expect(maybeToJsonForDatabase!.toSource(),
              contains('\'$fieldName\' : _$fieldName'),
              reason:
                  'Missing use of hidden class variable in toJsonForDatabase method.');
        });

        test('has a allToJson that uses hidden class variable.', () {
          var maybeAllToJson = CompilationUnitHelpers.tryFindMethodDeclaration(
            maybeClassNamedExample!,
            name: 'allToJson',
          );

          expect(maybeAllToJson, isNotNull,
              reason: 'Missing declaration for allToJson method.');
          expect(maybeAllToJson!.toSource(),
              contains('\'$fieldName\' : _$fieldName'),
              reason:
                  'Missing use of hidden class variable in setColumn method.');
        });

        test('has a setColumn that uses hidden class variable.', () {
          var maybeAllToJson = CompilationUnitHelpers.tryFindMethodDeclaration(
            maybeClassNamedExample!,
            name: 'setColumn',
          );

          expect(maybeAllToJson, isNotNull,
              reason: 'Missing declaration for setColumn method.');
          expect(maybeAllToJson!.toSource(), contains('_$fieldName = value'),
              reason:
                  'Missing use of hidden class variable in setColumn method.');
        });
      },
      skip: maybeClassNamedExample == null
          ? 'Could not run test because $testClassName class was not found.'
          : false,
    );
  });

  group(
    'Given a class with a persistent field with scope none starting with underscore when generating code',
    () {
      var fieldName = '_implicit_field';
      var entities = [
        ClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withTableName(tableName)
            .withField(
              SerializableEntityFieldDefinition(
                name: fieldName,
                type: TypeDefinition(className: 'String', nullable: true),
                scope: EntityFieldScopeDefinition.none,
                shouldPersist: true,
              ),
            )
            .build()
      ];

      var codeMap = generator.generateSerializableEntitiesCode(
        entities: entities,
        config: config,
      );

      var compilationUnit =
          parseString(content: codeMap[expectedFilePath]!).unit;

      var maybeClassNamedExample =
          CompilationUnitHelpers.tryFindClassDeclaration(
        compilationUnit,
        name: testClassName,
      );

      test(
        'then class is generated with field as hidden class variable with no extra underscore appended.',
        () {
          expect(
              CompilationUnitHelpers.hasFieldDeclaration(
                  maybeClassNamedExample!,
                  name: fieldName,
                  type: 'String?'),
              isTrue,
              reason: 'Field declaration missing for $fieldName.');
        },
        skip: maybeClassNamedExample == null
            ? 'Could not run test because $testClassName class was not found.'
            : false,
      );
    },
  );
}
