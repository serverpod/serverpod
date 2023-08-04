import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:serverpod_cli/src/test_util/compilation_unit_helpers.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;

import 'package:serverpod_cli/src/test_util/builders/class_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartClientCodeGenerator();

void main() {
  var expectedFileName = path.join(
    '..',
    'example_project_client',
    'lib',
    'src',
    'protocol',
    'example.dart',
  );
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

    test('then generated class imports client version of serverpod', () {
      expect(
          CompilationUnitHelpers.hasImportDirective(compilationUnit,
              uri: 'package:serverpod_client/serverpod_client.dart'),
          isTrue,
          reason:
              'Missing import of package:serverpod_client/serverpod_client.dart');
    });

    var maybeClassNamedExample = CompilationUnitHelpers.tryFindClassDeclaration(
        compilationUnit,
        name: 'Example');

    test('then class named Example is generated', () {
      expect(maybeClassNamedExample, isNotNull,
          reason: 'Missing definition for class named Example');
    });

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
      test('then generated class still inherits from SerializableEntity', () {
        expect(
            CompilationUnitHelpers.hasExtendsClause(exampleClass,
                name: 'SerializableEntity'),
            isTrue,
            reason: 'Missing extends clause for SerializableEntity');
      });

      test('then generated class has id in constructor', () {
        expect(
            CompilationUnitHelpers.hasConstructorDeclaration(exampleClass,
                name: null, parameters: ['this.id']),
            isTrue,
            reason: 'Missing declaration for Example constructor');
      });

      test('then a class is generated with id field.', () {
        expect(
            CompilationUnitHelpers.hasFieldDeclaration(exampleClass,
                name: 'id', type: 'int?'),
            isTrue,
            reason: 'Declaration for id field was should be generated');
        expect(codeMap[expectedFileName], contains('int? id;'));
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

  group(
      'Given a class with a a non persistent all scoped field when generating code',
      () {
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

  group(
      'Given a class with non persistent a server only scoped field when generating code',
      () {
    var entities = [
      ClassDefinitionBuilder()
          .withFileName('example')
          .withField(
            SerializableEntityFieldDefinition(
                name: 'title',
                type: TypeDefinition(className: 'String', nullable: true),
                scope: EntityFieldScopeDefinition.serverOnly,
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
      'then a class is NOT generated with that class variable.',
      () {
        var exampleClass = maybeClassNamedExample!;
        expect(
            CompilationUnitHelpers.hasFieldDeclaration(exampleClass,
                name: 'title', type: 'String?'),
            isFalse,
            reason: 'Field title should not be generated');
      },
      skip: maybeClassNamedExample == null
          ? 'Could not run test because Example class was not found'
          : false,
    );
  });
}
