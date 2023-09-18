import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:serverpod_cli/src/test_util/builders/serializable_entity_field_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/compilation_unit_helpers.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;

import 'package:serverpod_cli/src/test_util/builders/class_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartClientCodeGenerator();

void main() {
  var testClassName = 'Example';
  var testClassFileName = 'example';
  var expectedFileName = path.join(
    '..',
    'example_project_client',
    'lib',
    'src',
    'protocol',
    '$testClassFileName.dart',
  );

  group('Given an empty class named $testClassName when generating code', () {
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

    var compilationUnit = parseString(content: codeMap[expectedFileName]!).unit;

    test('then generated class imports client version of serverpod.', () {
      expect(
          CompilationUnitHelpers.hasImportDirective(
            compilationUnit,
            uri: 'package:serverpod_client/serverpod_client.dart',
          ),
          isTrue,
          reason:
              'Missing import of package:serverpod_client/serverpod_client.dart.');
    });

    var maybeClassNamedExample = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: testClassName,
    );

    test('then a class named $testClassName is generated.', () {
      expect(maybeClassNamedExample, isNotNull,
          reason: 'Missing definition for class named $testClassName.');
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
            reason: 'Missing declaration for toJson method.');
      });
    }, skip: maybeClassNamedExample == null);
  });

  group('Given a class with documentation when generating code', () {
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
        expect(codeMap[expectedFileName], contains(comment));
      }
    });
  });

  group('Given a class with table name when generating code', () {
    var entities = [
      ClassDefinitionBuilder()
          .withFileName(testClassFileName)
          .withTableName('example_table')
          .build()
    ];

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFileName]!).unit;
    var maybeClassNamedExample = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: testClassName,
    );
    group('then the class named $testClassName', () {
      test('still inherits from SerializableEntity.', () {
        expect(
            CompilationUnitHelpers.hasExtendsClause(
              maybeClassNamedExample!,
              name: 'SerializableEntity',
            ),
            isTrue,
            reason: 'Missing extends clause for SerializableEntity.');
      });

      test('has id in constructor.', () {
        expect(
            CompilationUnitHelpers.hasConstructorDeclaration(
              maybeClassNamedExample!,
              name: null,
              parameters: ['int? id'],
            ),
            isTrue,
            reason: 'Missing declaration for $testClassName constructor.');
      });

      test('is generated with id field.', () {
        expect(
            CompilationUnitHelpers.hasFieldDeclaration(
              maybeClassNamedExample!,
              name: 'id',
              type: 'int?',
            ),
            isTrue,
            reason: 'Declaration for id field was should be generated.');
      });
    },
        skip: maybeClassNamedExample == null
            ? 'Could not run test because $testClassName class was not found.'
            : false);

    test('then a class named ${testClassName}Include does NOT exist.', () {
      expect(
          CompilationUnitHelpers.hasClassDeclaration(compilationUnit,
              name: '${testClassName}Include'),
          isFalse,
          reason: 'Class ${testClassName}Include should not be generated.');
    });
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

    var compilationUnit = parseString(content: codeMap[expectedFileName]!).unit;
    var maybeClassNamedExample = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: testClassName,
    );

    group('then the class name $testClassName', () {
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

    var compilationUnit = parseString(content: codeMap[expectedFileName]!).unit;
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
          .withFileName(testClassFileName)
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

    var compilationUnit = parseString(content: codeMap[expectedFileName]!).unit;
    var maybeClassNamedExample = CompilationUnitHelpers.tryFindClassDeclaration(
        compilationUnit,
        name: testClassName);
    test(
      'then the class is generated with that class variable.',
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
          ? 'Could not run test because $testClassName class was not found'
          : false,
    );
  });

  group(
      'Given a class with a non persistent field with scope server only when generating code',
      () {
    var entities = [
      ClassDefinitionBuilder()
          .withFileName(testClassFileName)
          .withField(
            FieldDefinitionBuilder()
                .withName('title')
                .withTypeDefinition('String', true)
                .withScope(EntityFieldScopeDefinition.serverOnly)
                .withShouldPersist(false)
                .build(),
          )
          .build()
    ];

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFileName]!).unit;
    var maybeClassNamedExample = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: testClassName,
    );
    test(
      'then class is NOT generated with that class variable.',
      () {
        expect(
            CompilationUnitHelpers.hasFieldDeclaration(
              maybeClassNamedExample!,
              name: 'title',
              type: 'String?',
            ),
            isFalse,
            reason: 'Field title should not be generated.');
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
          .withFileName(testClassFileName)
          .withField(
            SerializableEntityFieldDefinition(
                name: 'title',
                type: TypeDefinition(className: 'String', nullable: true),
                scope: EntityFieldScopeDefinition.none,
                shouldPersist: false),
          )
          .build()
    ];

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFileName]!).unit;
    var maybeClassNamedExample = CompilationUnitHelpers.tryFindClassDeclaration(
        compilationUnit,
        name: testClassName);
    test(
      'then class is NOT generated with that class variable.',
      () {
        expect(
            CompilationUnitHelpers.hasFieldDeclaration(maybeClassNamedExample!,
                name: 'title', type: 'String?'),
            isFalse,
            reason: 'Field title should not be generated.');
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

    var compilationUnit = parseString(content: codeMap[expectedFileName]!).unit;

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
}
