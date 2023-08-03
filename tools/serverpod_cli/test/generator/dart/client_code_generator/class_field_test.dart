import 'package:analyzer/dart/analysis/utilities.dart';
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

    var compilationUnit = parseString(content: codeMap[expectedFileName]!).unit;

    test('then generated class imports client version of serverpod.', () {
      expect(
          CompilationUnitHelpers.hasImportDirective(compilationUnit,
              uri: 'package:serverpod_client/serverpod_client.dart'),
          isTrue,
          reason:
              'Missing import of package:serverpod_client/serverpod_client.dart.');
    });

    var maybeClassNamedExample = CompilationUnitHelpers.tryFindClassDeclaration(
        compilationUnit,
        name: testClassName);

    test('then class named $testClassName is generated.', () {
      expect(maybeClassNamedExample, isNotNull,
          reason: 'Missing definition for class named $testClassName.');
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

    var compilationUnit = parseString(content: codeMap[expectedFileName]!).unit;
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
}
