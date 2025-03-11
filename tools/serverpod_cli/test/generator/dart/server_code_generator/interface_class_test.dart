import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/exception_class_definition_builder.dart';
import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/interface_class_definition_builder.dart';
import '../../../test_util/builders/model_class_definition_builder.dart';
import '../../../test_util/compilation_unit_helpers.dart';

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
    var exampleInterface = InterfaceClassDefinitionBuilder()
        .withClassName('ExampleInterface')
        .withFileName('example_interface')
        .withSimpleField('age', 'int', nullable: true)
        .build();

    var exampleClass = ModelClassDefinitionBuilder()
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

      group('has a field definition', () {
        var field = CompilationUnitHelpers.tryFindFieldDeclaration(
          exampleInterfaceDeclaration!,
          name: 'age',
        );

        test('defined', () {
          expect(field, isNotNull);
        });

        test('without override annotation', () {
          expect(field?.toSource().contains('override'), false);
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

      group('has its own fields defined', () {
        var ownField = CompilationUnitHelpers.tryFindFieldDeclaration(
          exampleClassDeclaration!,
          name: 'name',
        );

        test('without override annotation', () {
          expect(ownField?.toSource().contains('override'), false);
        });
      });

      group('has fields from the interface', () {
        var interfaceField = CompilationUnitHelpers.tryFindFieldDeclaration(
          exampleClassDeclaration!,
          name: 'age',
        );

        test('defined', () {
          expect(interfaceField, isNotNull);
        });

        test('with override annotation', () {
          expect(interfaceField?.toSource().contains('override'), true);
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
    var interfaceClass = InterfaceClassDefinitionBuilder()
        .withClassName('ExampleInterface')
        .withFileName('example_interface')
        .withSimpleField('age', 'int', nullable: true)
        .build();

    var parent = ModelClassDefinitionBuilder()
        .withClassName('ExampleParent')
        .withFileName('example_parent')
        .withSimpleField('name', 'String')
        .withImplementedInterfaces([interfaceClass]).build();

    var child = ModelClassDefinitionBuilder()
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

  group(
      'Given a class implementing an interface that implements another interface, when generating code',
      () {
    var parentInterface = InterfaceClassDefinitionBuilder()
        .withClassName('ParentInterface')
        .withFileName('parent_interface')
        .withSimpleField('parentField', 'String')
        .build();

    var childInterface = InterfaceClassDefinitionBuilder()
        .withClassName('ChildInterface')
        .withFileName('child_interface')
        .withSimpleField('childField', 'String')
        .withImplementedInterfaces([parentInterface]).build();

    var exampleClass = ModelClassDefinitionBuilder()
        .withClassName('Example')
        .withFileName('example')
        .withSimpleField('name', 'String')
        .withImplementedInterfaces([childInterface]).build();

    var models = [
      exampleClass,
      parentInterface,
      childInterface,
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    var exampleClassCompilationUnit = parseString(
            content: codeMap[getExpectedFilePath(exampleClass.fileName)]!)
        .unit;

    group('Then the ${exampleClass.className}', () {
      var exampleClassDeclaration =
          CompilationUnitHelpers.tryFindClassDeclaration(
        exampleClassCompilationUnit,
        name: exampleClass.className,
      );

      test('is defined', () {
        expect(exampleClassDeclaration, isNotNull);
      });

      test('implements ${childInterface.className}', () {
        var implementsDirective =
            CompilationUnitHelpers.tryFindImplementedClass(
          exampleClassDeclaration!,
          name: childInterface.className,
        );

        expect(implementsDirective, isNotNull);
      });

      group('has a private constructor', () {
        var constructor = CompilationUnitHelpers.tryFindConstructorDeclaration(
          exampleClassDeclaration!,
          name: '_',
        );

        test('defined', () {
          expect(constructor, isNotNull);
        });

        test(
            'with vars as params from child interface, parent interface and itself',
            () {
          expect(
            constructor?.parameters.toSource(),
            '({required this.parentField, required this.childField, required this.name})',
          );
        });
      });
    });
  });
  group('Given an exception implementing an interface, when generating code',
      () {
    var interfaceClass = InterfaceClassDefinitionBuilder()
        .withClassName('ExampleInterface')
        .withFileName('example_interface')
        .withSimpleField('age', 'int', nullable: true)
        .build();

    var exceptionClass = ExceptionClassDefinitionBuilder()
        .withClassName('ExampleException')
        .withFileName('example_exception')
        .withSimpleField('name', 'String')
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

      group('has its own fields defined', () {
        var ownField = CompilationUnitHelpers.tryFindFieldDeclaration(
          exceptionClassDeclaration!,
          name: 'name',
        );

        test('without override annotation', () {
          expect(ownField?.toSource().contains('override'), false);
        });
      });

      group('has fields from the interface', () {
        var interfaceField = CompilationUnitHelpers.tryFindFieldDeclaration(
          exceptionClassDeclaration!,
          name: 'age',
        );

        test('defined', () {
          expect(interfaceField, isNotNull);
        });

        test('with override annotation', () {
          expect(interfaceField?.toSource().contains('override'), true);
        });
      });
    });
  });

  group(
      'Given a class implementing an interface and assigning a default value to a field from the interface, when generating code',
      () {
    var interfaceClass = InterfaceClassDefinitionBuilder()
        .withClassName('ExampleInterface')
        .withFileName('example_interface')
        .withSimpleField('status', 'String')
        .build();

    var exampleClass = ModelClassDefinitionBuilder()
        .withClassName('Example')
        .withFileName('example')
        .withSimpleField('name', 'String')
        .withSimpleField('status', 'String', defaultValue: 'active')
        .withImplementedInterfaces([interfaceClass]).build();

    var models = [
      exampleClass,
      interfaceClass,
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    var exampleClassCompilationUnit = parseString(
            content: codeMap[getExpectedFilePath(exampleClass.fileName)]!)
        .unit;

    group('Then the ${exampleClass.className}', () {
      var exampleClassDeclaration =
          CompilationUnitHelpers.tryFindClassDeclaration(
        exampleClassCompilationUnit,
        name: exampleClass.className,
      );

      group('has a constructor', () {
        var constructor = CompilationUnitHelpers.tryFindConstructorDeclaration(
          exampleClassDeclaration!,
          name: '_',
        );

        test('defined', () {
          expect(constructor, isNotNull);
        });

        test('with a default value for the field from the interface', () {
          expect(constructor?.initializers.toString(),
              contains('status = status ?? active'));
        });
      });
    });
  });
}
