import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:serverpod_cli/src/test_util/builders/class_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/compilation_unit_helpers.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  var parentClassName = 'Example';
  var parentClassFileName = 'example';
  var parentExpectedFilePath =
      path.join('lib', 'src', 'generated', '$parentClassFileName.dart');

  var childClassName = 'ChildExample';
  var childClassFileName = 'child_example';
  var childExpectedFilePath =
      path.join('lib', 'src', 'generated', '$childClassFileName.dart');
  var childTableName = 'child_example_table';

  group(
      'Given a child-class named $childClassName with one primitive var extending a parent-class named $parentClassName with one primitive var when generating code',
      () {
    var models = [
      ClassDefinitionBuilder()
          .withClassName(parentClassName)
          .withFileName(parentClassFileName)
          .withSimpleField('name', 'String')
          .withChildClasses(
        [
          ClassDefinitionBuilder()
              .withClassName(childClassName)
              .withFileName(childClassFileName)
              .withSimpleField('age', 'int')
              .build(),
        ],
      ).build(),
      ClassDefinitionBuilder()
          .withClassName(childClassName)
          .withFileName(childClassFileName)
          .withSimpleField('age', 'int', nullable: true)
          .withExtendsClass(
            ClassDefinitionBuilder()
                .withClassName(parentClassName)
                .withFileName(parentClassFileName)
                .withSimpleField('name', 'String')
                .build(),
          )
          .build(),
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    var parentCompilationUnit =
        parseString(content: codeMap[parentExpectedFilePath]!).unit;
    var childCompilationUnit =
        parseString(content: codeMap[childExpectedFilePath]!).unit;

    group('Then the $parentClassName', () {
      var parentClass = CompilationUnitHelpers.tryFindClassDeclaration(
        parentCompilationUnit,
        name: parentClassName,
      );

      group('has a public constructor', () {
        var publicConstructor =
            CompilationUnitHelpers.tryFindConstructorDeclaration(
          parentClass!,
          name: null,
        );

        test('defined', () {
          expect(publicConstructor, isNotNull);
        });

        test('without the factory keyword', () {
          expect(publicConstructor?.factoryKeyword, isNull);
        });
      });
    });

    group('Then the $childClassName', () {
      var childClass = CompilationUnitHelpers.tryFindClassDeclaration(
        childCompilationUnit,
        name: childClassName,
      );

      group('has a private constructor', () {
        var privateConstructor =
            CompilationUnitHelpers.tryFindConstructorDeclaration(
          childClass!,
          name: '_',
        );

        test('defined', () {
          expect(privateConstructor, isNotNull);
        });

        test('with both classes vars as params', () {
          expect(
            privateConstructor?.parameters.toSource(),
            '({required super.name, this.age})',
          );
        }, skip: privateConstructor == null);
      });

      group('has a factory constructor', () {
        var factoryConstructor =
            CompilationUnitHelpers.tryFindConstructorDeclaration(
          childClass!,
          name: null,
        );

        test('defined', () {
          expect(factoryConstructor, isNotNull);
        });

        test('with the factory keyword', () {
          expect(
            factoryConstructor?.factoryKeyword,
            isNotNull,
            reason: 'No factory keyword found on $childClassName',
          );
        }, skip: factoryConstructor == null);

        test('passed to private implementing class', () {
          expect(
            factoryConstructor?.redirectedConstructor?.toSource(),
            '_${childClassName}Impl',
          );
        }, skip: factoryConstructor == null);

        test('with the class vars as params', () {
          expect(
            factoryConstructor?.parameters.toSource(),
            '({required String name, int? age})',
          );
        }, skip: factoryConstructor == null);
      });

      group('has a copyWith method', () {
        var copyWithMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          childClass!,
          name: 'copyWith',
        );

        test('declared', () {
          expect(
            copyWithMethod,
            isNotNull,
            reason: 'No copyWith method found on $childClassName',
          );
        });

        test('with the return type of $childClassName.', () {
          expect(copyWithMethod?.returnType?.toSource(), childClassName);
        }, skip: copyWithMethod == null);

        test('with the named params set where all variables are nullable.', () {
          expect(
            copyWithMethod?.parameters?.toSource(),
            '({String? name, int? age})',
          );
        }, skip: copyWithMethod == null);

        test('with no code body.', () {
          var sourceCode = copyWithMethod?.body.toSource();
          expect(sourceCode, ';');
        }, skip: copyWithMethod == null);
      }, skip: childClass == null);
    });
    var copyWithClass = CompilationUnitHelpers.tryFindClassDeclaration(
      childCompilationUnit,
      name: '_${childClassName}Impl',
    );
    test('then a class named _${childClassName}Impl is generated.', () {
      expect(
        copyWithClass,
        isNotNull,
        reason: 'Missing definition for class named _${childClassName}Impl',
      );
    });

    group('then the class named _${childClassName}Impl', () {
      group('has a constructor', () {
        var defaultConstructor =
            CompilationUnitHelpers.tryFindConstructorDeclaration(
          copyWithClass!,
          name: null,
        );

        test('without a name.', () {
          expect(
            defaultConstructor,
            isNotNull,
            reason: 'Missing declaration for base private constructor.',
          );
        });

        test('with the params set to the same as the parent-class.', () {
          expect(
            defaultConstructor?.parameters.toSource(),
            '({required String name, int? age})',
          );
        }, skip: defaultConstructor == null);

        test('with super call to named private constructor', () {
          expect(
            defaultConstructor?.initializers.first.toSource(),
            'super._(name: name, age: age)',
          );
        });
      });
    });
  });

  group(
      'Given a child-class named $childClassName with one primitive var and a var with default value extending a parent-class named $parentClassName with one primitive var and a var with default value when generating code',
      () {
    var models = [
      ClassDefinitionBuilder()
          .withClassName(parentClassName)
          .withFileName(parentClassFileName)
          .withSimpleField('name', 'String')
          .withSimpleField('parentDefault', 'int', defaultValue: '0')
          .withChildClasses(
        [
          ClassDefinitionBuilder()
              .withClassName(childClassName)
              .withFileName(childClassFileName)
              .withSimpleField('age', 'int')
              .withSimpleField('childDefault', 'int', defaultValue: '-1')
              .build(),
        ],
      ).build(),
      ClassDefinitionBuilder()
          .withClassName(childClassName)
          .withFileName(childClassFileName)
          .withSimpleField('age', 'int', nullable: true)
          .withSimpleField('childDefault', 'int', defaultValue: '-1')
          .withExtendsClass(
            ClassDefinitionBuilder()
                .withClassName(parentClassName)
                .withFileName(parentClassFileName)
                .withSimpleField('name', 'String')
                .withSimpleField('parentDefault', 'int', defaultValue: '0')
                .build(),
          )
          .build(),
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    var parentCompilationUnit =
        parseString(content: codeMap[parentExpectedFilePath]!).unit;
    var childCompilationUnit =
        parseString(content: codeMap[childExpectedFilePath]!).unit;

    group('Then the $parentClassName', () {
      var parentClass = CompilationUnitHelpers.tryFindClassDeclaration(
        parentCompilationUnit,
        name: parentClassName,
      );

      group('has a public constructor', () {
        var publicConstructor =
            CompilationUnitHelpers.tryFindConstructorDeclaration(
          parentClass!,
          name: null,
        );

        group('with the initializers', () {
          test('containing 1 entry', () {
            expect(publicConstructor?.initializers.length, 1);
          }, skip: publicConstructor == null);

          test('correctly set', () {
            expect(
              publicConstructor?.initializers.first.toSource(),
              'parentDefault = parentDefault ?? 0',
            );
          }, skip: publicConstructor == null);
        });
      });
    });

    group('Then the $childClassName', () {
      var childClass = CompilationUnitHelpers.tryFindClassDeclaration(
        childCompilationUnit,
        name: childClassName,
      );

      group('has a private constructor', () {
        var privateConstructor =
            CompilationUnitHelpers.tryFindConstructorDeclaration(
          childClass!,
          name: '_',
        );

        test('with both classes vars as params', () {
          expect(
            privateConstructor?.parameters.toSource(),
            '({required super.name, super.parentDefault, this.age, int? childDefault})',
          );
        }, skip: privateConstructor == null);

        group('with the initializers', () {
          test('containing 1 entry', () {
            expect(privateConstructor?.initializers.length, 1);
          }, skip: privateConstructor == null);

          test('correctly set', () {
            expect(
              privateConstructor?.initializers.first.toSource(),
              'childDefault = childDefault ?? -1',
            );
          }, skip: privateConstructor == null);
        });
      });

      group('has a factory constructor', () {
        var factoryConstructor =
            CompilationUnitHelpers.tryFindConstructorDeclaration(
          childClass!,
          name: null,
        );

        test('with the class vars as params', () {
          expect(
            factoryConstructor?.parameters.toSource(),
            '({required String name, int? parentDefault, int? age, int? childDefault})',
          );
        }, skip: factoryConstructor == null);
      });

      group('has a copyWith method', () {
        var copyWithMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          childClass!,
          name: 'copyWith',
        );

        test('with the named params set where all variables are nullable.', () {
          expect(
            copyWithMethod?.parameters?.toSource(),
            '({String? name, int? parentDefault, int? age, int? childDefault})',
          );
        }, skip: copyWithMethod == null);
      }, skip: childClass == null);
    });
    var copyWithClass = CompilationUnitHelpers.tryFindClassDeclaration(
      childCompilationUnit,
      name: '_${childClassName}Impl',
    );

    group('then the class named _${childClassName}Impl', () {
      group('has a constructor', () {
        var defaultConstructor =
            CompilationUnitHelpers.tryFindConstructorDeclaration(
          copyWithClass!,
          name: null,
        );

        test('with the params set to the same as the parent class.', () {
          expect(
            defaultConstructor?.parameters.toSource(),
            '({required String name, int? parentDefault, int? age, int? childDefault})',
          );
        }, skip: defaultConstructor == null);

        test('with super call to named private constructor', () {
          expect(
            defaultConstructor?.initializers.first.toSource(),
            'super._(name: name, parentDefault: parentDefault, age: age, childDefault: childDefault)',
          );
        });
      });
    });
  });

  group('Given a child-class with table name when generating code', () {
    var models = [
      ClassDefinitionBuilder()
          .withClassName(parentClassName)
          .withFileName(parentClassFileName)
          .withSimpleField('name', 'String')
          .withChildClasses(
        [
          ClassDefinitionBuilder()
              .withClassName(childClassName)
              .withFileName(childClassFileName)
              .withSimpleField('age', 'int', nullable: true)
              .build(),
        ],
      ).build(),
      ClassDefinitionBuilder()
          .withClassName(childClassName)
          .withFileName(childClassFileName)
          .withTableName(childTableName)
          .withSimpleField('age', 'int', nullable: true)
          .withExtendsClass(
            ClassDefinitionBuilder()
                .withClassName(parentClassName)
                .withFileName(parentClassFileName)
                .withSimpleField('name', 'String')
                .build(),
          )
          .build(),
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    var compilationUnit =
        parseString(content: codeMap[childExpectedFilePath]!).unit;

    var maybeClassNamedExampleTable =
        CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '${childClassName}Table',
    );

    test('then a class named ${childClassName}Table is generated.', () {
      expect(
        maybeClassNamedExampleTable,
        isNotNull,
        reason: 'Missing definition for class named ${childClassName}Table',
      );
    });
    group('then the class named ${childClassName}Table', () {
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
          'has constructor taking table relation and passes table name to super.',
          () {
        expect(
            CompilationUnitHelpers.hasConstructorDeclaration(
              maybeClassNamedExampleTable!,
              name: null,
              parameters: ['super.tableRelation'],
              superArguments: ['tableName: \'$childTableName\''],
            ),
            isTrue,
            reason:
                'Missing declaration for $childClassName constructor with nullable id field passed to super.');
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

      test('has both parents and own fields.', () {
        expect(
            CompilationUnitHelpers.hasFieldDeclaration(
              maybeClassNamedExampleTable!,
              name: 'name',
            ),
            isTrue,
            reason: 'Missing parent fields in ${childClassName}Table.');
        expect(
            CompilationUnitHelpers.hasFieldDeclaration(
              maybeClassNamedExampleTable,
              name: 'age',
            ),
            isTrue,
            reason: 'Missing own field in ${childClassName}Table.');
      });
    }, skip: maybeClassNamedExampleTable == null);
  });

  group(
      'Given a child-class with a nullable field inheriting a nullable field when generating code',
      () {
    var models = [
      ClassDefinitionBuilder()
          .withClassName(parentClassName)
          .withFileName(parentClassFileName)
          .withSimpleField('name', 'String', nullable: true)
          .withChildClasses(
        [
          ClassDefinitionBuilder()
              .withClassName(childClassName)
              .withFileName(childClassFileName)
              .withSimpleField('age', 'int', nullable: true)
              .build(),
        ],
      ).build(),
      ClassDefinitionBuilder()
          .withClassName(childClassName)
          .withFileName(childClassFileName)
          .withTableName(childTableName)
          .withSimpleField('age', 'int', nullable: true)
          .withExtendsClass(
            ClassDefinitionBuilder()
                .withClassName(parentClassName)
                .withFileName(parentClassFileName)
                .withSimpleField('name', 'String', nullable: true)
                .build(),
          )
          .build(),
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    var compilationUnit =
        parseString(content: codeMap[childExpectedFilePath]!).unit;

    group('then the $childClassName', () {
      var childClass = CompilationUnitHelpers.tryFindClassDeclaration(
        compilationUnit,
        name: childClassName,
      );

      group('has a copyWith method with named params', () {
        var copyWithMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          childClass!,
          name: 'copyWith',
        );

        test('where nullable-inherited fields are "Object?"', () {
          var nameParam = copyWithMethod?.parameters?.parameters.firstWhere(
            (param) => param.name.toString() == 'name',
          );

          expect(nameParam?.toSource(), 'Object? name');
        }, skip: copyWithMethod == null);

        test('where nullable-local fields are typed', () {
          var ageParam = copyWithMethod?.parameters?.parameters.firstWhere(
            (param) => param.name.toString() == 'age',
          );

          expect(ageParam?.toSource(), 'int? age');
        }, skip: copyWithMethod == null);
      });
    });
  });
}
