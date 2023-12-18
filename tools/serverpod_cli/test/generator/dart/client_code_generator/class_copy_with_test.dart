import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:serverpod_cli/src/test_util/builders/serializable_entity_field_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/type_definition_builder.dart';
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
  var expectedFilePath = path.join(
    '..',
    'example_project_client',
    'lib',
    'src',
    'protocol',
    '$testClassFileName.dart',
  );

  group(
      'Given a class named $testClassName with two primitive vars when generating code',
      () {
    var models = [
      ClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withSimpleField('name', 'String')
          .withSimpleField('age', 'int', nullable: true)
          .build()
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;

    group('then the $testClassName', () {
      var baseClass = CompilationUnitHelpers.tryFindClassDeclaration(
        compilationUnit,
        name: testClassName,
      );

      test('is an abstract class.', () {
        expect(
          baseClass?.abstractKeyword,
          isNotNull,
          reason: 'Class was not abstract',
        );
      });

      group('has a copyWith method', () {
        var copyWithMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          baseClass!,
          name: 'copyWith',
        );
        test('declared', () {
          expect(
            copyWithMethod,
            isNotNull,
            reason: 'No copyWith method found on $testClassName',
          );
        });

        test('with the return type of $testClassName.', () {
          expect(copyWithMethod?.returnType?.toSource(), testClassName);
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
      }, skip: baseClass == null);
    });

    var copyWithClass = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '_${testClassName}Impl',
    );

    test('then an empty class named _Undefined is generated.', () {
      expect(
        CompilationUnitHelpers.tryFindClassDeclaration(
          compilationUnit,
          name: '_Undefined',
        ),
        isNotNull,
        reason: 'Missing definition for class named _Undefined',
      );
    });

    test('then a class named _${testClassName}Impl is generated.', () {
      expect(
        copyWithClass,
        isNotNull,
        reason: 'Missing definition for class named _${testClassName}Impl',
      );
    });

    group('then the class named _${testClassName}Impl', () {
      test('inherits from base class.', () {
        expect(
            CompilationUnitHelpers.hasExtendsClause(
              copyWithClass!,
              name: testClassName,
            ),
            isTrue,
            reason: 'Missing extends clause for $testClassName.');
      });

      group('has a copyWith method', () {
        var copyWithMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          copyWithClass!,
          name: 'copyWith',
        );
        test('declared', () {
          expect(copyWithMethod, isNotNull);
        });

        test('with the return type of $testClassName', () {
          expect(copyWithMethod?.returnType?.toSource(), testClassName);
        }, skip: copyWithMethod == null);

        test('annotated with @override', () {
          expect(copyWithMethod?.metadata.first.toSource(), '@override');
        }, skip: copyWithMethod == null);

        test(
            'with the named params set where none nullable defaults to null and nullable defaults to _Undefined',
            () {
          expect(
            copyWithMethod?.parameters?.toSource(),
            '({String? name, Object? age = _Undefined})',
          );
        }, skip: copyWithMethod == null);

        test(
            'with the code body to check undefined and create a new $testClassName object.',
            () {
          var sourceCode = copyWithMethod?.body.toSource();
          expect(sourceCode,
              '{return $testClassName(name: name ?? this.name, age: age is int? ? age : this.age);}');
        }, skip: copyWithMethod == null);
      });
    }, skip: copyWithClass == null);
  });

  group(
      'Given a class named $testClassName with a var with none scope when generating code',
      () {
    var models = [
      ClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withField(FieldDefinitionBuilder()
              .withName('noneName')
              .withTypeDefinition('String')
              .withScope(ModelFieldScopeDefinition.none)
              .build())
          .build()
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;

    group('then the $testClassName', () {
      var baseClass = CompilationUnitHelpers.tryFindClassDeclaration(
        compilationUnit,
        name: testClassName,
      );

      group('has a copyWith method', () {
        var copyWithMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          baseClass!,
          name: 'copyWith',
        );

        test('with no params.', () {
          expect(
            copyWithMethod?.parameters?.toSource(),
            '()',
          );
        }, skip: copyWithMethod == null);
      }, skip: baseClass == null);
    });

    var copyWithClass = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '_${testClassName}Impl',
    );

    group('then the class named _${testClassName}Impl', () {
      group('has a copyWith method', () {
        var copyWithMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          copyWithClass!,
          name: 'copyWith',
        );

        test('with no params', () {
          expect(
            copyWithMethod?.parameters?.toSource(),
            '()',
          );
        }, skip: copyWithMethod == null);

        test('with the code body returning a new $testClassName object.', () {
          var sourceCode = copyWithMethod?.body.toSource();
          expect(sourceCode, '{return $testClassName();}');
        }, skip: copyWithMethod == null);
      });
    }, skip: copyWithClass == null);
  });

  group(
      'Given a class named $testClassName with a var with serverOnly scope when generating code',
      () {
    var models = [
      ClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withField(FieldDefinitionBuilder()
              .withName('serverOnlyName')
              .withTypeDefinition('String')
              .withScope(ModelFieldScopeDefinition.serverOnly)
              .build())
          .build()
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;

    test('then the _Undefined class is NOT generated.', () {
      expect(
        CompilationUnitHelpers.tryFindClassDeclaration(
          compilationUnit,
          name: '_Undefined',
        ),
        isNull,
        reason: 'Expected no definition for class named _Undefined',
      );
    });

    group('then the $testClassName', () {
      var baseClass = CompilationUnitHelpers.tryFindClassDeclaration(
        compilationUnit,
        name: testClassName,
      );

      group('has a copyWith method', () {
        var copyWithMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          baseClass!,
          name: 'copyWith',
        );

        test('with no params.', () {
          expect(
            copyWithMethod?.parameters?.toSource(),
            '()',
          );
        }, skip: copyWithMethod == null);
      }, skip: baseClass == null);
    });

    var copyWithClass = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '_${testClassName}Impl',
    );

    group('then the class named _${testClassName}Impl', () {
      group('has a copyWith method', () {
        var copyWithMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          copyWithClass!,
          name: 'copyWith',
        );

        test('with no params', () {
          expect(
            copyWithMethod?.parameters?.toSource(),
            '()',
          );
        }, skip: copyWithMethod == null);

        test('with the code body returning a new $testClassName object.', () {
          var sourceCode = copyWithMethod?.body.toSource();
          expect(sourceCode, '{return $testClassName();}');
        }, skip: copyWithMethod == null);
      });
    }, skip: copyWithClass == null);
  });

  group('Given a class named $testClassName with a list of strings', () {
    var models = [
      ClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withField(FieldDefinitionBuilder()
              .withName('names')
              .withType(TypeDefinitionBuilder().withListOf('String').build())
              .build())
          .build()
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;

    var copyWithClass = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '_${testClassName}Impl',
    );

    var copyWithMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
      copyWithClass!,
      name: 'copyWith',
    );

    test('then the clone method is called on field when copying the object.',
        () {
      var sourceCode = copyWithMethod?.body.toSource();
      expect(
          sourceCode, '{return Example(names: names ?? this.names.clone());}');
    }, skip: copyWithMethod == null);
  });

  group('Given a class named $testClassName with a map of strings', () {
    var models = [
      ClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withField(FieldDefinitionBuilder()
              .withName('map')
              .withType(
                  TypeDefinitionBuilder().withMapOf('String', 'String').build())
              .build())
          .build()
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;

    var copyWithClass = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '_${testClassName}Impl',
    );

    var copyWithMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
      copyWithClass!,
      name: 'copyWith',
    );

    test('then the clone method is called on field when copying the object.',
        () {
      var sourceCode = copyWithMethod?.body.toSource();
      expect(sourceCode, '{return Example(map: map ?? this.map.clone());}');
    }, skip: copyWithMethod == null);
  });

  group('Given a class named $testClassName with a ByteData field', () {
    var models = [
      ClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withField(FieldDefinitionBuilder()
              .withName('data')
              .withTypeDefinition('ByteData')
              .build())
          .build()
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;

    var copyWithClass = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '_${testClassName}Impl',
    );

    var copyWithMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
      copyWithClass!,
      name: 'copyWith',
    );

    test('then the clone method is called on field when copying the object.',
        () {
      var sourceCode = copyWithMethod?.body.toSource();
      expect(sourceCode, '{return Example(data: data ?? this.data.clone());}');
    }, skip: copyWithMethod == null);
  });

  group('Given a class named $testClassName with a nested object', () {
    var models = [
      ClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withField(FieldDefinitionBuilder()
              .withName('nested')
              .withTypeDefinition('Example2')
              .build())
          .build()
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;

    var copyWithClass = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '_${testClassName}Impl',
    );

    var copyWithMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
      copyWithClass!,
      name: 'copyWith',
    );

    test('then the clone method is called on field when copying the object.',
        () {
      var sourceCode = copyWithMethod?.body.toSource();
      expect(sourceCode,
          '{return Example(nested: nested ?? this.nested.copyWith());}');
    }, skip: copyWithMethod == null);
  });
}
