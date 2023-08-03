import 'package:analyzer/dart/analysis/utilities.dart';
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
}
