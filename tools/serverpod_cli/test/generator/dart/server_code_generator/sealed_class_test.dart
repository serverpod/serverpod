import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
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

  var serverpodImportPath = 'package:serverpod/serverpod.dart';

  group(
      'Given a hierarchy with a sealed parent and a normal child, when generating code',
      () {
    var parent = ClassDefinitionBuilder()
        .withClassName('Example')
        .withFileName('example')
        .withSimpleField('name', 'String')
        .withIsSealed(true) // <= sealed
        .build();

    var child = ClassDefinitionBuilder()
        .withClassName('ExampleChild')
        .withFileName('example_child')
        .withSimpleField('age', 'int')
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

    var parentCompilationUnit =
        parseString(content: codeMap[getExpectedFilePath(parent.fileName)]!)
            .unit;
    var childCompilationUnit =
        parseString(content: codeMap[getExpectedFilePath(child.fileName)]!)
            .unit;

    group('Then the ${parent.className}', () {
      var parentClass = CompilationUnitHelpers.tryFindClassDeclaration(
        parentCompilationUnit,
        name: parent.className,
      );

      test('is defined', () {
        expect(parentClass, isNotNull);
      });

      test('has a part directive with ${child.className} uri', () {
        var partDirective = CompilationUnitHelpers.tryFindPartDirective(
          parentCompilationUnit,
          uri: '${child.fileName}.dart',
        );

        expect(
          partDirective?.uri.stringValue,
          '${child.fileName}.dart',
        );
      });

      test('has import directive for serverpod', () {
        var serverpodImport = CompilationUnitHelpers.tryFindImportDirective(
          parentCompilationUnit,
          uri: serverpodImportPath,
        );

        expect(serverpodImport, isNotNull);
      });

      test('does NOT have a copyWith method', () {
        var copyWithMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          parentClass!,
          name: 'copyWith',
        );

        expect(copyWithMethod, isNull);
      });

      test('does NOT have a toJson method', () {
        var toJsonMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          parentClass!,
          name: 'toJson',
        );

        expect(toJsonMethod, isNull);
      });

      test('does NOT have a toJsonForProtocol method', () {
        var toJsonForProtocolMethod =
            CompilationUnitHelpers.tryFindMethodDeclaration(
          parentClass!,
          name: 'toJsonForProtocol',
        );

        expect(toJsonForProtocolMethod, isNull);
      });

      test('does NOT have a toString method', () {
        var toStringMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          parentClass!,
          name: 'toString',
        );
        expect(toStringMethod, isNull);
      });
    });

    group('Then the ${child.className}', () {
      var childClass = CompilationUnitHelpers.tryFindClassDeclaration(
        childCompilationUnit,
        name: child.className,
      );

      test('is defined', () {
        expect(childClass, isNotNull);
      });

      test('has a part-of directive with ${parent.className} uri', () {
        var partDirectives = CompilationUnitHelpers.tryFindPartOfDirective(
          childCompilationUnit,
          uri: '${parent.fileName}.dart',
        );

        expect(
          partDirectives?.uri?.stringValue,
          '${parent.fileName}.dart',
        );
      });

      test('does not have import directive for serverpod', () {
        var importDirective = CompilationUnitHelpers.hasImportDirective(
          childCompilationUnit,
          uri: serverpodImportPath,
        );

        expect(importDirective, false);
      });

      test('does have a copyWith method', () {
        var copyWithMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          childClass!,
          name: 'copyWith',
        );

        expect(copyWithMethod, isNotNull);
      });

      test('does have a toJson method', () {
        var toJsonMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          childClass!,
          name: 'toJson',
        );

        expect(toJsonMethod, isNotNull);
      });

      test('does have a toJsonForProtocol method', () {
        var toJsonForProtocolMethod =
            CompilationUnitHelpers.tryFindMethodDeclaration(
          childClass!,
          name: 'toJsonForProtocol',
        );

        expect(toJsonForProtocolMethod, isNotNull);
      });

      test('does have a toString method', () {
        var toStringMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          childClass!,
          name: 'toString',
        );

        expect(toStringMethod, isNotNull);
      });
    });
  });

  group(
      'Given a hierarchy with a sealed parent and two normal children with nullable fields when generating code',
      () {
    var parent = ClassDefinitionBuilder()
        .withClassName('Example')
        .withFileName('example')
        .withSimpleField('name', 'String')
        .withIsSealed(true) // <= sealed
        .build();

    var child1 = ClassDefinitionBuilder()
        .withClassName('ExampleChild')
        .withFileName('example_child')
        .withSimpleField('age', 'int')
        .withExtendsClass(parent)
        .build();

    var child2 = ClassDefinitionBuilder()
        .withClassName('ExampleChild2')
        .withFileName('example_child2')
        .withSimpleField('age', 'int', nullable: true)
        .withExtendsClass(parent)
        .build();

    parent.childClasses.add(ResolvedInheritanceDefinition(child1));
    parent.childClasses.add(ResolvedInheritanceDefinition(child2));

    var models = [
      parent,
      child1,
      child2,
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    var parentCompilationUnit =
        parseString(content: codeMap[getExpectedFilePath(parent.fileName)]!)
            .unit;
    var child1CompilationUnit =
        parseString(content: codeMap[getExpectedFilePath(child1.fileName)]!)
            .unit;
    var child2CompilationUnit =
        parseString(content: codeMap[getExpectedFilePath(child2.fileName)]!)
            .unit;

    test('then ${parent.className} has a _Undefined class', () {
      var undefinedMethod = CompilationUnitHelpers.tryFindClassDeclaration(
        parentCompilationUnit,
        name: '_Undefined',
      );

      expect(
        undefinedMethod,
        isNotNull,
        reason: '_Undefined class was not created',
      );
    });

    test('then ${child1.className} does NOT have a _Undefined class', () {
      var undefinedClass = CompilationUnitHelpers.tryFindClassDeclaration(
        child1CompilationUnit,
        name: '_Undefined',
      );

      expect(
        undefinedClass,
        isNull,
        reason: '_Undefined class was created in child of a sealed class',
      );
    });

    test('then ${child2.className} does NOT have a _Undefined class', () {
      var undefinedClass = CompilationUnitHelpers.tryFindClassDeclaration(
        child2CompilationUnit,
        name: '_Undefined',
      );

      expect(
        undefinedClass,
        isNull,
        reason: '_Undefined class was created in child of a sealed class',
      );
    });
  });

  group(
      'Given a hierarchy with a normal parent, a sealed child and a normal grandchild when generating code',
      () {
    var grandparent = ClassDefinitionBuilder()
        .withClassName('ExampleGrandparent')
        .withFileName('example_grandparent')
        .withSimpleField('name', 'String')
        .build();
    var parent = ClassDefinitionBuilder()
        .withClassName('ExampleParent')
        .withFileName('example_parent')
        .withSimpleField('name', 'String')
        .withExtendsClass(grandparent)
        .withIsSealed(true)
        .build();
    var child = ClassDefinitionBuilder()
        .withClassName('ExampleChild')
        .withFileName('example_child')
        .withSimpleField('age', 'int', nullable: true)
        .withExtendsClass(parent)
        .build();

    grandparent.childClasses.add(ResolvedInheritanceDefinition(parent));
    parent.childClasses.add(ResolvedInheritanceDefinition(child));

    var models = [
      grandparent,
      parent,
      child,
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    var grandparentCompilationUnit = parseString(
            content: codeMap[getExpectedFilePath(grandparent.fileName)]!)
        .unit;
    var parentCompilationUnit =
        parseString(content: codeMap[getExpectedFilePath(parent.fileName)]!)
            .unit;

    var childCompilationUnit =
        parseString(content: codeMap[getExpectedFilePath(child.fileName)]!)
            .unit;

    group('then ${grandparent.className}', () {
      var grandparentClass = CompilationUnitHelpers.tryFindClassDeclaration(
        grandparentCompilationUnit,
        name: grandparent.className,
      );

      test('has a copyWith method', () {
        var copyWithMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          grandparentClass!,
          name: 'copyWith',
        );
        expect(copyWithMethod, isNotNull);
      });

      test('has an import directive for serverpod', () {
        var serverpodImport = CompilationUnitHelpers.tryFindImportDirective(
          grandparentCompilationUnit,
          uri: serverpodImportPath,
        );

        expect(serverpodImport, isNotNull);
      });
    });

    group('then ${parent.className} ', () {
      var parentClass = CompilationUnitHelpers.tryFindClassDeclaration(
        parentCompilationUnit,
        name: parent.className,
      );

      test('does NOT have a copyWith method', () {
        var copyWithMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          parentClass!,
          name: 'copyWith',
        );
        expect(copyWithMethod, isNull);
      });

      test('has a part directive with ${child.className} uri', () {
        var partDirective = CompilationUnitHelpers.tryFindPartDirective(
          parentCompilationUnit,
          uri: '${child.fileName}.dart',
        );

        expect(
          partDirective?.uri.stringValue,
          '${child.fileName}.dart',
        );
      });

      test('has import directive for serverpod', () {
        var serverpodImport = CompilationUnitHelpers.tryFindImportDirective(
          parentCompilationUnit,
          uri: serverpodImportPath,
        );

        expect(serverpodImport, isNotNull);
      });
    });

    group('then ${child.className} has a copyWith method', () {
      var childClass = CompilationUnitHelpers.tryFindClassDeclaration(
        childCompilationUnit,
        name: child.className,
      );

      var copyWithMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
        childClass!,
        name: 'copyWith',
      );

      test('defined', () {
        expect(copyWithMethod, isNotNull);
      });

      test('with the override annotation', () {
        var overrideAnnotation = CompilationUnitHelpers.tryFindAnnotation(
          copyWithMethod!,
          name: 'override',
        );

        expect(overrideAnnotation, isNotNull);
      });
    });
  });

  group(
      'Given a hierarchy: sealed > normal > sealed > normal when generating code',
      () {
    var greatGrandparent = ClassDefinitionBuilder()
        .withClassName('ExampleGreatGrandparent')
        .withFileName('example_great_grandparent')
        .withSimpleField('name', 'String')
        .withIsSealed(true)
        .build();
    var grandparent = ClassDefinitionBuilder()
        .withClassName('ExampleGrandparent')
        .withFileName('example_grandparent')
        .withSimpleField('name', 'String')
        .withExtendsClass(greatGrandparent)
        .build();
    var parent = ClassDefinitionBuilder()
        .withClassName('ExampleParent')
        .withFileName('example_parent')
        .withSimpleField('name', 'String')
        .withExtendsClass(grandparent)
        .build();
    var child = ClassDefinitionBuilder()
        .withClassName('ExampleChild')
        .withFileName('example_child')
        .withSimpleField('age', 'int', nullable: true)
        .withExtendsClass(parent)
        .build();

    greatGrandparent.childClasses
        .add(ResolvedInheritanceDefinition(grandparent));
    grandparent.childClasses.add(ResolvedInheritanceDefinition(parent));
    parent.childClasses.add(ResolvedInheritanceDefinition(child));

    var models = [
      greatGrandparent,
      grandparent,
      parent,
      child,
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    var greatGrandparentCompilationUnit = parseString(
            content: codeMap[getExpectedFilePath(greatGrandparent.fileName)]!)
        .unit;

    var grandparentCompilationUnit = parseString(
            content: codeMap[getExpectedFilePath(grandparent.fileName)]!)
        .unit;

    var parentCompilationUnit =
        parseString(content: codeMap[getExpectedFilePath(parent.fileName)]!)
            .unit;

    var childCompilationUnit =
        parseString(content: codeMap[getExpectedFilePath(child.fileName)]!)
            .unit;

    group('then ${greatGrandparent.className}', () {
      test('has part directives for all children', () {
        var partDirective = CompilationUnitHelpers.tryFindPartDirective(
          greatGrandparentCompilationUnit,
          uri: '${grandparent.fileName}.dart',
        );

        expect(
          partDirective?.uri.stringValue,
          '${grandparent.fileName}.dart',
        );

        partDirective = CompilationUnitHelpers.tryFindPartDirective(
          greatGrandparentCompilationUnit,
          uri: '${parent.fileName}.dart',
        );

        expect(
          partDirective?.uri.stringValue,
          '${parent.fileName}.dart',
        );

        partDirective = CompilationUnitHelpers.tryFindPartDirective(
          greatGrandparentCompilationUnit,
          uri: '${child.fileName}.dart',
        );

        expect(
          partDirective?.uri.stringValue,
          '${child.fileName}.dart',
        );
      });
    });

    group('then ${grandparent.className} has a copyWith method', () {
      var grandparentClass = CompilationUnitHelpers.tryFindClassDeclaration(
        grandparentCompilationUnit,
        name: grandparent.className,
      );

      var copyWithMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
        grandparentClass!,
        name: 'copyWith',
      );

      test('defined', () {
        expect(copyWithMethod, isNotNull);
      });

      test('without the override annotation', () {
        var overrideAnnotation = CompilationUnitHelpers.tryFindAnnotation(
          copyWithMethod!,
          name: 'override',
        );

        expect(overrideAnnotation, isNull);
      });
    });

    test(
        'then ${parent.className} has a part-of directive with ${greatGrandparent.className} uri',
        () {
      var partOfDirective = CompilationUnitHelpers.tryFindPartOfDirective(
        parentCompilationUnit,
        uri: '${greatGrandparent.fileName}.dart',
      );

      expect(
        partOfDirective?.uri?.stringValue,
        '${greatGrandparent.fileName}.dart',
      );
    });

    group('then ${child.className} ', () {
      var childClass = CompilationUnitHelpers.tryFindClassDeclaration(
        childCompilationUnit,
        name: child.className,
      );

      var copyWithMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
        childClass!,
        name: 'copyWith',
      );

      group('has a copyWith method', () {
        test('defined', () {
          expect(copyWithMethod, isNotNull);
        });

        test('with the override annotation', () {
          var overrideAnnotation = CompilationUnitHelpers.tryFindAnnotation(
            copyWithMethod!,
            name: 'override',
          );

          expect(overrideAnnotation, isNotNull);
        });
      });

      test('has a part-of directive with ${greatGrandparent.className} uri',
          () {
        var partOfDirective = CompilationUnitHelpers.tryFindPartOfDirective(
          childCompilationUnit,
          uri: '${greatGrandparent.fileName}.dart',
        );

        expect(
          partOfDirective?.uri?.stringValue,
          '${greatGrandparent.fileName}.dart',
        );
      });
    });
  });

  group('Given a hierarchy: sealed > sealed > normal when generating code', () {
    var grandparent = ClassDefinitionBuilder()
        .withClassName('ExampleGrandparent')
        .withFileName('example_grandparent')
        .withSimpleField('name', 'String')
        .withIsSealed(true)
        .build();
    var parent = ClassDefinitionBuilder()
        .withClassName('ExampleParent')
        .withFileName('example_parent')
        .withSimpleField('name', 'String')
        .withExtendsClass(grandparent)
        .withIsSealed(true)
        .build();
    var child = ClassDefinitionBuilder()
        .withClassName('ExampleChild')
        .withFileName('example_child')
        .withSimpleField('age', 'int', nullable: true)
        .withExtendsClass(parent)
        .build();

    grandparent.childClasses.add(ResolvedInheritanceDefinition(parent));
    parent.childClasses.add(ResolvedInheritanceDefinition(child));

    var models = [
      grandparent,
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

    group('then ${child.className}', () {
      var childClass = CompilationUnitHelpers.tryFindClassDeclaration(
        childCompilationUnit,
        name: child.className,
      );

      var copyWithMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
        childClass!,
        name: 'copyWith',
      );

      test('has a copyWith method', () {
        expect(copyWithMethod, isNotNull);
      });

      test('without the override annotation', () {
        var overrideAnnotation = CompilationUnitHelpers.tryFindAnnotation(
          copyWithMethod!,
          name: 'override',
        );

        expect(overrideAnnotation, isNull);
      });
    });
  });

  group('Given a sealed class with no children when generating code', () {
    var parent = ClassDefinitionBuilder()
        .withClassName('ExampleParent')
        .withFileName('example_parent')
        .withSimpleField('name', 'String')
        .withIsSealed(true)
        .build();

    var models = [
      parent,
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    var parentCompilationUnit =
        parseString(content: codeMap[getExpectedFilePath(parent.fileName)]!)
            .unit;

    group('then ${parent.className}', () {
      var parentClass = CompilationUnitHelpers.tryFindClassDeclaration(
        parentCompilationUnit,
        name: parent.className,
      );

      test('is defined', () {
        expect(parentClass, isNotNull);
      });

      test('does NOT have a copyWith method', () {
        var copyWithMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          parentClass!,
          name: 'copyWith',
        );

        expect(copyWithMethod, isNull);
      });

      var directives = parentCompilationUnit.directives;

      test('has only directive which is an import', () {
        expect(directives.length, 1);
        expect(directives.first, isA<ImportDirective>());
      });

      test('does NOT have a part directive', () {
        expect(directives.first, isNot(isA<PartDirective>()));
      });
    });
  });

  group(
      'Given a hierarchy: sealed > normal > normal, when the sealed top node is in another directory',
      () {
    var grandparent = ClassDefinitionBuilder()
        .withClassName('ExampleGrandparent')
        .withSubDirParts(['sub_dir'])
        .withFileName('example_grandparent')
        .withSimpleField('name', 'String')
        .withIsSealed(true) // <= sealed
        .build();
    var parent = ClassDefinitionBuilder()
        .withClassName('ExampleParent')
        .withFileName('example_parent')
        .withSimpleField('name', 'String')
        .withExtendsClass(grandparent)
        .build();
    var child = ClassDefinitionBuilder()
        .withClassName('ExampleChild')
        .withFileName('example_child')
        .withSimpleField('age', 'int', nullable: true)
        .withExtendsClass(parent)
        .build();

    grandparent.childClasses.add(ResolvedInheritanceDefinition(parent));
    parent.childClasses.add(ResolvedInheritanceDefinition(child));

    var models = [
      grandparent,
      parent,
      child,
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    var grandparentPath = getExpectedFilePath(
      grandparent.fileName,
      subDirParts: ['sub_dir'],
    );
    var parentPath = getExpectedFilePath(parent.fileName);
    var childPath = getExpectedFilePath(child.fileName);

    var grandparentCompilationUnit =
        parseString(content: codeMap[grandparentPath]!).unit;
    var parentCompilationUnit = parseString(content: codeMap[parentPath]!).unit;
    var childCompilationUnit = parseString(content: codeMap[childPath]!).unit;

    group('then ${grandparent.className}', () {
      test('has a part directive with ${parent.className} uri', () {
        var partDirective = CompilationUnitHelpers.tryFindPartDirective(
          grandparentCompilationUnit,
          uri: '../${parent.fileName}.dart',
        );

        expect(
          partDirective,
          isNotNull,
        );
      });

      test('has a part directive with ${child.className} uri', () {
        var partDirective = CompilationUnitHelpers.tryFindPartDirective(
          grandparentCompilationUnit,
          uri: '../${child.fileName}.dart',
        );
        expect(
          partDirective,
          isNotNull,
        );
      });
    });

    group('then ${parent.className}', () {
      test('has a part-of directive with ${grandparent.className} uri', () {
        var partOfDirective = CompilationUnitHelpers.tryFindPartOfDirective(
          parentCompilationUnit,
          uri: 'sub_dir/${grandparent.fileName}.dart',
        );
        expect(
          partOfDirective,
          isNotNull,
        );
      });
    });

    group('then ${child.className}', () {
      test('has a part-of directive with ${grandparent.className} uri', () {
        var partOfDirective = CompilationUnitHelpers.tryFindPartOfDirective(
          childCompilationUnit,
          uri: 'sub_dir/${grandparent.fileName}.dart',
        );
        expect(
          partOfDirective,
          isNotNull,
        );
      });
    });
  });

  group(
      'Given a hierarchy: sealed > normal > normal when the middle node is in another directory',
      () {
    var grandparent = ClassDefinitionBuilder()
        .withClassName('ExampleGrandparent')
        .withFileName('example_grandparent')
        .withSimpleField('name', 'String')
        .withIsSealed(true) // <= sealed
        .build();
    var parent = ClassDefinitionBuilder()
        .withClassName('ExampleParent')
        .withFileName('example_parent')
        .withSubDirParts(['sub_dir'])
        .withSimpleField('name', 'String')
        .withExtendsClass(grandparent)
        .build();
    var child = ClassDefinitionBuilder()
        .withClassName('ExampleChild')
        .withFileName('example_child')
        .withSimpleField('age', 'int', nullable: true)
        .withExtendsClass(parent)
        .build();

    grandparent.childClasses.add(ResolvedInheritanceDefinition(parent));
    parent.childClasses.add(ResolvedInheritanceDefinition(child));

    var models = [
      grandparent,
      parent,
      child,
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    var grandparentPath = getExpectedFilePath(grandparent.fileName);
    var parentPath = getExpectedFilePath(
      parent.fileName,
      subDirParts: ['sub_dir'],
    );
    var childPath = getExpectedFilePath(child.fileName);

    var grandparentCompilationUnit =
        parseString(content: codeMap[grandparentPath]!).unit;
    var parentCompilationUnit = parseString(content: codeMap[parentPath]!).unit;
    var childCompilationUnit = parseString(content: codeMap[childPath]!).unit;

    group('then ${grandparent.className}', () {
      test('has a part directive with ${parent.className} uri', () {
        var partDirective = CompilationUnitHelpers.tryFindPartDirective(
          grandparentCompilationUnit,
          uri: 'sub_dir/${parent.fileName}.dart',
        );
        expect(
          partDirective,
          isNotNull,
        );
      });

      test('has a part directive with ${child.className} uri', () {
        var partDirective = CompilationUnitHelpers.tryFindPartDirective(
          grandparentCompilationUnit,
          uri: '${child.fileName}.dart',
        );
        expect(
          partDirective,
          isNotNull,
        );
      });
    });

    group('then ${parent.className}', () {
      test('has a part-of directive with ${grandparent.className} uri', () {
        var partOfDirective = CompilationUnitHelpers.tryFindPartOfDirective(
          parentCompilationUnit,
          uri: '../${grandparent.fileName}.dart',
        );
        expect(
          partOfDirective,
          isNotNull,
        );
      });
    });

    group('then ${child.className}', () {
      test('has a part-of directive with ${grandparent.className} uri', () {
        var partOfDirective = CompilationUnitHelpers.tryFindPartOfDirective(
          childCompilationUnit,
          uri: '${grandparent.fileName}.dart',
        );
        expect(
          partOfDirective,
          isNotNull,
        );
      });
    });
  });

  group(
      'Given a hierarchy: sealed > normal > normal when the bottom node is in another directory',
      () {
    var grandparent = ClassDefinitionBuilder()
        .withClassName('ExampleGrandparent')
        .withFileName('example_grandparent')
        .withSimpleField('name', 'String')
        .withIsSealed(true) // <= sealed
        .build();
    var parent = ClassDefinitionBuilder()
        .withClassName('ExampleParent')
        .withFileName('example_parent')
        .withSimpleField('name', 'String')
        .withExtendsClass(grandparent)
        .build();
    var child = ClassDefinitionBuilder()
        .withClassName('ExampleChild')
        .withFileName('example_child')
        .withSubDirParts(['sub_dir'])
        .withSimpleField('age', 'int', nullable: true)
        .withExtendsClass(parent)
        .build();

    grandparent.childClasses.add(ResolvedInheritanceDefinition(parent));
    parent.childClasses.add(ResolvedInheritanceDefinition(child));

    var models = [
      grandparent,
      parent,
      child,
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    var grandparentPath = getExpectedFilePath(grandparent.fileName);
    var parentPath = getExpectedFilePath(parent.fileName);
    var childPath = getExpectedFilePath(
      child.fileName,
      subDirParts: ['sub_dir'],
    );

    var grandparentCompilationUnit =
        parseString(content: codeMap[grandparentPath]!).unit;
    var parentCompilationUnit = parseString(content: codeMap[parentPath]!).unit;
    var childCompilationUnit = parseString(content: codeMap[childPath]!).unit;

    group('then ${grandparent.className}', () {
      test('has a part directive with ${parent.className} uri', () {
        var partDirective = CompilationUnitHelpers.tryFindPartDirective(
          grandparentCompilationUnit,
          uri: '${parent.fileName}.dart',
        );
        expect(
          partDirective,
          isNotNull,
        );
      });

      test('has a part directive with ${child.className} uri', () {
        var partDirective = CompilationUnitHelpers.tryFindPartDirective(
          grandparentCompilationUnit,
          uri: 'sub_dir/${child.fileName}.dart',
        );
        expect(
          partDirective,
          isNotNull,
        );
      });
    });

    group('then ${parent.className}', () {
      test('has a part-of directive with ${grandparent.className} uri', () {
        var partOfDirective = CompilationUnitHelpers.tryFindPartOfDirective(
          parentCompilationUnit,
          uri: '${grandparent.fileName}.dart',
        );
        expect(
          partOfDirective,
          isNotNull,
        );
      });
    });

    group('then ${child.className}', () {
      test('has a part-of directive with ${grandparent.className} uri', () {
        var partOfDirective = CompilationUnitHelpers.tryFindPartOfDirective(
          childCompilationUnit,
          uri: '../${grandparent.fileName}.dart',
        );
        expect(
          partOfDirective,
          isNotNull,
        );
      });
    });
  });

  test(
      'CompilationUnit.directives[i].uri.stringValue returns relative path without separators on Windows.',
      () {
    var content = Platform.isWindows
        ? "part 'sub_dir\\example_child.dart';"
        : "part 'sub_dir/example_child.dart';";

    var unit = parseString(content: content).unit;

    var directive = unit.directives.whereType<PartDirective>().first;

    var directiveStringValue = directive.uri.stringValue;

    var expectedPath = Platform.isWindows
        ? 'sub_direxample_child.dart'
        : 'sub_dir/example_child.dart';

    expect(directiveStringValue == expectedPath, isTrue);
  });
}
