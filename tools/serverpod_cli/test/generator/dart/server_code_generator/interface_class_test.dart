import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:test/test.dart';

import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:serverpod_cli/src/test_util/builders/class_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/compilation_unit_helpers.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  String getExpectedFilePath(String fileName, {List<String>? subDirParts}) =>
      p.joinAll([
        'lib',
        'src',
        'generated',
        ...?subDirParts,
        '$fileName.dart',
      ]);

  group('Given an interface and a class implementing it, when generating code',
      () {
    var exampleInterface = ClassDefinitionBuilder()
        .withClassName('ExampleInterface')
        .withFileName('example_interface')
        .withSimpleField('age', 'int', nullable: true)
        .withIsInterface(true)
        .build();

    var exampleClass = ClassDefinitionBuilder()
        .withClassName('Example')
        .withFileName('example')
        .withSimpleField('name', 'String')
        .withImplementedInterfaces([exampleInterface]).build();

    var models = [
      exampleClass,
      exampleInterface,
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    var exampleClassCompilationUnit = parseString(
            content: codeMap[getExpectedFilePath(exampleClass.fileName)]!)
        .unit;
    var exampleInterfaceCompilationUnit = parseString(
            content: codeMap[getExpectedFilePath(exampleInterface.fileName)]!)
        .unit;

    group('Then the ${exampleInterface.className}', () {
      var exampleInterfaceDeclaration =
          CompilationUnitHelpers.tryFindClassDeclaration(
        exampleInterfaceCompilationUnit,
        name: exampleInterface.className,
      );

      test('is defined', () {
        expect(exampleInterfaceDeclaration, isNotNull);
      });

      group('does have a constructor', () {
        var constructor = CompilationUnitHelpers.tryFindConstructorDeclaration(
          exampleInterfaceDeclaration!,
          name: null,
        );

        test('defined', () {
          expect(constructor, isNotNull);
        });

        test('with the passed params', () {
          expect(constructor?.parameters.toSource(), '({this.age})');
        });
      });

      test('does NOT have a copyWith method', () {
        var copyWithMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          exampleInterfaceDeclaration!,
          name: 'copyWith',
        );

        expect(copyWithMethod, isNull);
      });

      test('does NOT have a toJson method', () {
        var toJsonMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          exampleInterfaceDeclaration!,
          name: 'toJson',
        );

        expect(toJsonMethod, isNull);
      });

      test('does NOT have a toJsonForProtocol method', () {
        var toJsonForProtocolMethod =
            CompilationUnitHelpers.tryFindMethodDeclaration(
          exampleInterfaceDeclaration!,
          name: 'toJsonForProtocol',
        );

        expect(toJsonForProtocolMethod, isNull);
      });

      test('does NOT have a toString method', () {
        var toStringMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          exampleInterfaceDeclaration!,
          name: 'toString',
        );

        expect(toStringMethod, isNull);
      });
    });

    group('Then the ${exampleClass.className}', () {
      var exampleClassDeclaration =
          CompilationUnitHelpers.tryFindClassDeclaration(
        exampleClassCompilationUnit,
        name: exampleClass.className,
      );

      test('is defined', () {
        expect(exampleClassDeclaration, isNotNull);
      });

      test('implements ${exampleInterface.className}', () {
        var implementsDirective =
            CompilationUnitHelpers.tryFindImplementedClass(
          exampleClassDeclaration!,
          name: exampleInterface.className,
        );

        expect(
          implementsDirective,
          isNotNull,
        );
      });

      group('has a private constructor', () {
        var privateConstructor =
            CompilationUnitHelpers.tryFindConstructorDeclaration(
          exampleClassDeclaration!,
          name: '_',
        );

        test('defined', () {
          expect(privateConstructor, isNotNull);
        });

        test('with vars as params from interface and itself', () {
          expect(
            privateConstructor?.parameters.toSource(),
            '({this.age, required this.name})',
          );
        });
      });

      test('does have a copyWith method', () {
        var copyWithMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          exampleClassDeclaration!,
          name: 'copyWith',
        );

        expect(copyWithMethod, isNotNull);
      });

      test('does have a toJson method', () {
        var toJsonMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          exampleClassDeclaration!,
          name: 'toJson',
        );

        expect(toJsonMethod, isNotNull);
      });

      test('does have a toJsonForProtocol method', () {
        var toJsonForProtocolMethod =
            CompilationUnitHelpers.tryFindMethodDeclaration(
          exampleClassDeclaration!,
          name: 'toJsonForProtocol',
        );

        expect(toJsonForProtocolMethod, isNotNull);
      });

      test('does have a toString method', () {
        var toStringMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          exampleClassDeclaration!,
          name: 'toString',
        );

        expect(toStringMethod, isNotNull);
      });
    });
  });

  group('Given a parent class implementing an interface, when generating code',
      () {
    var interfaceClass = ClassDefinitionBuilder()
        .withClassName('ExampleInterface')
        .withFileName('example_interface')
        .withSimpleField('age', 'int', nullable: true)
        .withIsInterface(true)
        .build();

    var parent = ClassDefinitionBuilder()
        .withClassName('ExampleParent')
        .withFileName('example_parent')
        .withSimpleField('name', 'String')
        .withImplementedInterfaces([interfaceClass]).build();

    var child = ClassDefinitionBuilder()
        .withClassName('ExampleChild')
        .withFileName('example_child')
        .withSimpleField('foo', 'int')
        .withExtendsClass(parent)
        .build();

    parent.childClasses.add(ResolvedInheritanceDefinition(child));

    var models = [
      parent,
      child,
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    var childCompilationUnit =
        parseString(content: codeMap[getExpectedFilePath(child.fileName)]!)
            .unit;

    group('Then the ${child.className} ', () {
      var childClass = CompilationUnitHelpers.tryFindClassDeclaration(
        childCompilationUnit,
        name: child.className,
      );

      test('is defined', () {
        expect(childClass, isNotNull);
      });

      group('has a private constructor', () {
        var constructor = CompilationUnitHelpers.tryFindConstructorDeclaration(
          childClass!,
          name: '_',
        );

        test('defined', () {
          expect(constructor, isNotNull);
        });

        test('with vars as params from interface, parent and itself', () {
          expect(
            constructor?.parameters.toSource(),
            '({super.age, required super.name, required this.foo})',
          );
        });
      });
    });
  });

  group('Given an exception implementing an interface, when generating code',
      () {
    var interfaceClass = ClassDefinitionBuilder()
        .withClassName('ExampleInterface')
        .withFileName('example_interface')
        .withSimpleField('age', 'int', nullable: true)
        .withIsInterface(true)
        .build();

    var exceptionClass = ClassDefinitionBuilder()
        .withClassName('ExampleException')
        .withFileName('example_exception')
        .withSimpleField('name', 'String')
        .withIsException(true)
        .withImplementedInterfaces([interfaceClass]).build();

    var models = [
      exceptionClass,
      interfaceClass,
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    var exceptionCompilationUnit = parseString(
            content: codeMap[getExpectedFilePath(exceptionClass.fileName)]!)
        .unit;

    group('Then the ${exceptionClass.className}', () {
      var exceptionClassDeclaration =
          CompilationUnitHelpers.tryFindClassDeclaration(
        exceptionCompilationUnit,
        name: exceptionClass.className,
      );

      test('is defined', () {
        expect(exceptionClassDeclaration, isNotNull);
      });

      test('implements ${interfaceClass.className}', () {
        var implementsDirective =
            CompilationUnitHelpers.tryFindImplementedClass(
          exceptionClassDeclaration!,
          name: interfaceClass.className,
        );

        expect(implementsDirective, isNotNull);
      });

      group('has a private constructor', () {
        var constructor = CompilationUnitHelpers.tryFindConstructorDeclaration(
          exceptionClassDeclaration!,
          name: '_',
        );

        test('defined', () {
          expect(constructor, isNotNull);
        });

        test('with vars as params from interface and itself', () {
          expect(
            constructor?.parameters.toSource(),
            '({this.age, required this.name})',
          );
        });
      });
    });
  });
}
