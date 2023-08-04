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
  var expectedFileName = path.join('lib', 'src', 'generated', 'example.dart');
  group('Given a class named Example when generating code', () {
    var entities = [
      ClassDefinitionBuilder()
          .withClassName('Example')
          .withFileName('example')
          .build()
    ];

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFileName]!).unit;

    test('then generated class imports server version of serverpod', () {
      expect(
          CompilationUnitHelpers.hasImportDirective(compilationUnit,
              uri: 'package:serverpod/serverpod.dart'),
          isTrue,
          reason: 'Missing import of package:serverpod/serverpod.dart');
    });

    test('then class named Example is generated', () {
      expect(
        CompilationUnitHelpers.hasClassDeclaration(compilationUnit,
            name: 'Example'),
        isNotNull,
        reason: 'Missing definition for class named Example',
      );
    });

    var maybeClassNamedExample = CompilationUnitHelpers.tryFindClassDeclaration(
        compilationUnit,
        name: 'Example');
    group(',', () {
      var exampleClass = maybeClassNamedExample!;
      test('then generated class inherits from SerializableEntity', () {
        expect(
            CompilationUnitHelpers.hasExtendsClause(exampleClass,
                name: 'SerializableEntity'),
            isTrue,
            reason: 'Missing extends clause for SerializableEntity');
      });

      test('then generated class has fromJson factory', () {
        expect(
            CompilationUnitHelpers.hasConstructorDeclaration(exampleClass,
                name: 'fromJson'),
            isTrue,
            reason: 'Missing declaration for fromJson factory');
      });

      test('then generated class has toJson method', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(exampleClass,
                name: 'toJson'),
            isTrue,
            reason: 'Missing declaration for toJson method');
      });

      test('then generated class has allToJson method', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(exampleClass,
                name: 'allToJson'),
            isTrue,
            reason: 'Missing declaration for allToJson method');
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
          .withFileName('example')
          .withDocumentation(documentation)
          .build()
    ];

    var codeMap = generator.generateSerializableEntitiesCode(
      entities: entities,
      config: config,
    );

    test('then documentation is included in code', () {
      for (var comment in documentation) {
        expect(codeMap[expectedFileName], contains(comment));
      }
    });
  });

  group('Given a class with table name when generating code', () {
    var entities = [
      ClassDefinitionBuilder()
          .withFileName('example')
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
        name: 'Example');
    group(',', () {
      var exampleClass = maybeClassNamedExample!;
      test('then generated class inherits from TableRow', () {
        expect(
            CompilationUnitHelpers.hasExtendsClause(exampleClass,
                name: 'TableRow'),
            isTrue,
            reason: 'Missing extends clause for TableRow');
      });

      test('then generated class has id in constructor passed to super', () {
        expect(
            CompilationUnitHelpers.hasConstructorDeclaration(exampleClass,
                name: null, parameters: ['int? id'], superArguments: ['id']),
            isTrue,
            reason:
                'Missing declaration for Example constructor with nullable id field passed to super');
      });

      test('then a class is generated with static Singleton instance.', () {
        expect(
            CompilationUnitHelpers.hasFieldDeclaration(exampleClass,
                name: 't',
                isFinal: true,
                isStatic: true,
                initializerMethod: 'ExampleTable'),
            isTrue,
            reason: 'Missing declaration for ExampleTable singleton');
      });

      test('then a class is generated with table name getter.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(exampleClass,
                name: 'tableName'),
            isTrue,
            reason: 'Missing declaration for tableName getter');
      });

      test('then a class is NOT generated with id field.', () {
        expect(
            CompilationUnitHelpers.hasFieldDeclaration(exampleClass,
                name: 'id'),
            isFalse,
            reason: 'Declaration for id field should not be generated');
      });

      test('then a class is generated with a toJsonForDatabase method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(exampleClass,
                name: 'toJsonForDatabase'),
            isTrue,
            reason: 'Missing declaration for toJsonForDatabase method');
      });

      test('then a class is generated with a setColumn method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(exampleClass,
                name: 'setColumn'),
            isTrue,
            reason: 'Missing declaration for setColumn method');
      });

      test('then a class is generated with a find method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(exampleClass,
                name: 'find', isStatic: true),
            isTrue,
            reason: 'Missing declaration for find method');
      });

      test('then a class is generated with a findSingleRow method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(exampleClass,
                name: 'findSingleRow', isStatic: true),
            isTrue,
            reason: 'Missing declaration for findSingleRow method');
      });

      test('then a class is generated with a findById method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(exampleClass,
                name: 'findById', isStatic: true),
            isTrue,
            reason: 'Missing declaration for findById method');
      });

      test('then a class is generated with a delete method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(exampleClass,
                name: 'delete', isStatic: true),
            isTrue,
            reason: 'Missing declaration for delete method');
      });

      test('then a class is generated with a deleteRow method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(exampleClass,
                name: 'deleteRow', isStatic: true),
            isTrue,
            reason: 'Missing declaration for deleteRow method');
      });

      test('then a class is generated with an update method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(exampleClass,
                name: 'update', isStatic: true),
            isTrue,
            reason: 'Missing declaration for update method');
      });

      test('then a class is generated with an insert method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(exampleClass,
                name: 'insert', isStatic: true),
            isTrue,
            reason: 'Missing declaration for insert method');
      });

      test('then a class is generated with a count method.', () {
        expect(
            CompilationUnitHelpers.hasMethodDeclaration(exampleClass,
                name: 'count', isStatic: true),
            isTrue,
            reason: 'Missing declaration for count method');
      });
    },
        skip: maybeClassNamedExample == null
            ? 'Could not run test because Example class was not found'
            : false);
  });

  group('Given a class with a none nullable field when generating code', () {
    var entities = [
      ClassDefinitionBuilder()
          .withClassName('Example')
          .withFileName('example')
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
        name: 'Example');
    test(
      'then a class is generated with that class variable.',
      () {
        var exampleClass = maybeClassNamedExample!;
        expect(
          CompilationUnitHelpers.hasFieldDeclaration(exampleClass,
              name: 'title', type: 'String'),
          isTrue,
          reason: 'Missing declaration for title field',
        );
      },
      skip: maybeClassNamedExample == null
          ? 'Could not run test because Example class was not found'
          : false,
    );
  });

  group('Given a class with a nullable field when generating code', () {
    var entities = [
      ClassDefinitionBuilder()
          .withClassName('Example')
          .withFileName('example')
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
        name: 'Example');
    test(
      'then a class is generated with that class variable.',
      () {
        var exampleClass = maybeClassNamedExample!;
        expect(
          CompilationUnitHelpers.hasFieldDeclaration(exampleClass,
              name: 'title', type: 'String?'),
          isTrue,
          reason: 'Missing declaration for title field',
        );
      },
      skip: maybeClassNamedExample == null
          ? 'Could not run test because Example class was not found'
          : false,
    );
  });

  group('Given a class with an all scoped field when generating code', () {
    var entities = [
      ClassDefinitionBuilder()
          .withFileName('example')
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

    var compilationUnit = parseString(content: codeMap[expectedFileName]!).unit;
    var maybeClassNamedExample = CompilationUnitHelpers.tryFindClassDeclaration(
        compilationUnit,
        name: 'Example');
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
          ? 'Could not run test because Example class was not found'
          : false,
    );
  });

  group('Given a class with a database scoped field when generating code', () {
    var entities = [
      ClassDefinitionBuilder()
          .withFileName('example')
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

    var compilationUnit = parseString(content: codeMap[expectedFileName]!).unit;
    var maybeClassNamedExample = CompilationUnitHelpers.tryFindClassDeclaration(
        compilationUnit,
        name: 'Example');
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
          ? 'Could not run test because Example class was not found'
          : false,
    );
  });
}
