import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/generator/dart/shared_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/exception_class_definition_builder.dart';
import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/model_class_definition_builder.dart';
import '../../../test_util/builders/serializable_entity_field_definition_builder.dart';
import '../../../test_util/compilation_unit_helpers.dart';

const sharedPackageName = 'shared_pkg';
const projectName = 'example_project';
const serverPathParts = ['server_root'];
final config = GeneratorConfigBuilder()
    .withServerPackageDirectoryPathParts(serverPathParts)
    .withSharedModelsSourcePathsParts({
      sharedPackageName: ['packages', 'shared'],
    })
    .withModules([])
    .build();
const generator = DartSharedCodeGenerator();

void main() {
  var testClassName = 'Example';
  var testClassFileName = 'example';
  var expectedFileName = path.joinAll([
    ...serverPathParts,
    'packages',
    'shared',
    'lib',
    'src',
    'generated',
    '$testClassFileName.dart',
  ]);

  group('Given an empty class named $testClassName when generating code', () {
    var models = [
      ModelClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withSharedPackageName(sharedPackageName)
          .build(),
    ];

    late var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    late var compilationUnit = parseString(
      content: codeMap[expectedFileName]!,
    ).unit;

    test(
      'then generated class imports the serverpod serialization package.',
      () {
        expect(
          CompilationUnitHelpers.hasImportDirective(
            compilationUnit,
            uri: 'package:serverpod_serialization/serverpod_serialization.dart',
          ),
          isTrue,
        );
      },
    );

    late var maybeClassNamedExample =
        CompilationUnitHelpers.tryFindClassDeclaration(
          compilationUnit,
          name: testClassName,
        );

    test('then a class named $testClassName is generated.', () {
      expect(
        maybeClassNamedExample,
        isNotNull,
        reason: 'Missing definition for class named $testClassName.',
      );
    });

    group('then the class named $testClassName', () {
      test('implements SerializableModel.', () {
        expect(
          CompilationUnitHelpers.hasImplementsClause(
            maybeClassNamedExample!,
            name: 'SerializableModel',
          ),
          isTrue,
          reason: 'Missing extends clause for SerializableModel.',
        );
      });

      test('implements ProtocolSerialization.', () {
        expect(
          CompilationUnitHelpers.hasImplementsClause(
            maybeClassNamedExample!,
            name: 'ProtocolSerialization',
          ),
          isTrue,
          reason: 'Every model implements ProtocolSerialization.',
        );
      });

      test('has a fromJson factory.', () {
        expect(
          CompilationUnitHelpers.hasConstructorDeclaration(
            maybeClassNamedExample!,
            name: 'fromJson',
          ),
          isTrue,
          reason: 'Missing declaration for fromJson factory.',
        );
      });

      test('has a toJson method.', () {
        expect(
          CompilationUnitHelpers.hasMethodDeclaration(
            maybeClassNamedExample!,
            name: 'toJson',
          ),
          isTrue,
          reason: 'Missing declaration for toJson method.',
        );
      });

      test('has a toJsonForProtocol method.', () {
        expect(
          CompilationUnitHelpers.hasMethodDeclaration(
            maybeClassNamedExample!,
            name: 'toJsonForProtocol',
          ),
          isTrue,
          reason: 'Every model has a toJsonForProtocol method.',
        );
      });
    });
  });

  group('Given a class with documentation when generating code', () {
    var documentation = [
      '// This is an example documentation',
      '// This is another example',
    ];
    var models = [
      ModelClassDefinitionBuilder()
          .withFileName(testClassFileName)
          .withSharedPackageName(sharedPackageName)
          .withDocumentation(documentation)
          .build(),
    ];

    late var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    test('then documentation is included in code.', () {
      for (var comment in documentation) {
        expect(codeMap[expectedFileName], contains(comment));
      }
    });
  });

  group('Given a class with table name when generating code', () {
    var tableName = 'example_table';
    var models = [
      ModelClassDefinitionBuilder()
          .withFileName(testClassFileName)
          .withTableName(tableName)
          .withDatabase(ModelDatabaseDefinition.all)
          .withSharedPackageName(sharedPackageName)
          .build(),
    ];

    late var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    late var compilationUnit = parseString(
      content: codeMap[expectedFileName]!,
    ).unit;

    late var maybeClassNamedExample =
        CompilationUnitHelpers.tryFindClassDeclaration(
          compilationUnit,
          name: testClassName,
        );

    test('then a class named $testClassName is generated.', () {
      expect(
        maybeClassNamedExample,
        isNotNull,
        reason: 'Missing definition for class named $testClassName.',
      );
    });

    group('then the class named $testClassName', () {
      test('implements TableRow.', () {
        expect(
          CompilationUnitHelpers.hasImplementsClause(
            maybeClassNamedExample!,
            name: 'TableRow',
          ),
          isTrue,
          reason: 'Missing extends clause for TableRow.',
        );
      });

      test('has TableRow implements generic to the default id type int.', () {
        var typeName =
            maybeClassNamedExample!
                    .implementsClause
                    ?.interfaces
                    .first
                    .typeArguments
                    ?.arguments
                    .first
                as NamedType?;

        expect(
          typeName?.name.toString(),
          'int',
          reason: 'Wrong generic type for TableRow.',
        );
      });

      test('implements ProtocolSerialization', () {
        expect(
          CompilationUnitHelpers.hasImplementsClause(
            maybeClassNamedExample!,
            name: 'ProtocolSerialization',
          ),
          isTrue,
          reason: 'Missing implements clause for ProtocolSerialization.',
        );
      });

      group('has a constructor', () {
        var constructor = CompilationUnitHelpers.tryFindConstructorDeclaration(
          maybeClassNamedExample!,
          name: '_',
        );

        test('defined', () {
          expect(constructor, isNotNull, reason: 'No private constructor');
        });

        test('initializing id in initializer list', () {
          expect(constructor?.parameters.toSource(), '({this.id})');
        });
      });

      test('has a static Singleton instance.', () {
        expect(
          CompilationUnitHelpers.hasFieldDeclaration(
            maybeClassNamedExample!,
            name: 't',
            isFinal: true,
            isStatic: true,
            initializerMethod: '${testClassName}Table',
          ),
          isTrue,
          reason: 'Missing declaration for ${testClassName}Table singleton.',
        );
      });

      test('has a table getter.', () {
        expect(
          CompilationUnitHelpers.hasMethodDeclaration(
            maybeClassNamedExample!,
            name: 'table',
            isGetter: true,
          ),
          isTrue,
          reason: 'Missing declaration for table getter.',
        );
      });

      test(
        'has Table generic to the default id type int as table getter return type.',
        () {
          var maybeTableGetter =
              CompilationUnitHelpers.tryFindMethodDeclaration(
                maybeClassNamedExample!,
                name: 'table',
              );

          var typeArguments = maybeTableGetter?.returnType as NamedType?;
          var genericType = typeArguments?.typeArguments?.arguments.first;

          expect(
            (genericType as NamedType?)?.name.toString(),
            'int',
            reason: 'Wrong generic type for Table getter.',
          );
        },
      );

      test('is generated with id field.', () {
        expect(
          CompilationUnitHelpers.hasFieldDeclaration(
            maybeClassNamedExample!,
            name: 'id',
          ),
          isTrue,
          reason: 'Declaration for id field should be generated.',
        );
      });

      test('has type of the id field default to int.', () {
        var maybeIdField = CompilationUnitHelpers.tryFindFieldDeclaration(
          maybeClassNamedExample!,
          name: 'id',
        );

        expect(
          (maybeIdField?.fields.type as NamedType).name.toString(),
          'int',
          reason: 'Wrong type for the id field.',
        );
      });

      test('has a static include method.', () {
        expect(
          CompilationUnitHelpers.hasMethodDeclaration(
            maybeClassNamedExample!,
            name: 'include',
            isStatic: true,
          ),
          isTrue,
          reason: 'Missing declaration for static include method.',
        );
      });

      test('has a static includeList method.', () {
        expect(
          CompilationUnitHelpers.hasMethodDeclaration(
            maybeClassNamedExample!,
            name: 'includeList',
            isStatic: true,
          ),
          isTrue,
          reason: 'Missing declaration for static includeList method.',
        );
      });
    });
  });

  group('Given a class with a none nullable field when generating code', () {
    var models = [
      ModelClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withSimpleField('title', 'String')
          .withSharedPackageName(sharedPackageName)
          .build(),
    ];

    late var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    late var compilationUnit = parseString(
      content: codeMap[expectedFileName]!,
    ).unit;

    late var maybeClassNamedExample =
        CompilationUnitHelpers.tryFindClassDeclaration(
          compilationUnit,
          name: testClassName,
        );

    group(
      'then the class name $testClassName',
      () {
        test('has field as required in constructor.', () {
          expect(
            CompilationUnitHelpers.hasConstructorDeclaration(
              maybeClassNamedExample!,
              name: null,
              parameters: ['required String title'],
            ),
            isTrue,
            reason: 'Missing declaration for $testClassName constructor.',
          );
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
    );
  });

  group('Given a class with a nullable field when generating code', () {
    var models = [
      ModelClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withSimpleField('title', 'String', nullable: true)
          .withSharedPackageName(sharedPackageName)
          .build(),
    ];

    late var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    late var compilationUnit = parseString(
      content: codeMap[expectedFileName]!,
    ).unit;

    late var maybeClassNamedExample =
        CompilationUnitHelpers.tryFindClassDeclaration(
          compilationUnit,
          name: testClassName,
        );

    group(
      'then the class named $testClassName',
      () {
        test('has field in constructor.', () {
          expect(
            CompilationUnitHelpers.hasConstructorDeclaration(
              maybeClassNamedExample!,
              name: null,
              parameters: ['String? title'],
            ),
            isTrue,
            reason: 'Missing declaration for $testClassName constructor.',
          );
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
    );
  });

  group(
    'Given a class with a non persistent field with scope all when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withFileName(testClassFileName)
            .withField(
              FieldDefinitionBuilder()
                  .withName('title')
                  .withTypeDefinition('String', true)
                  .withScope(ModelFieldScopeDefinition.all)
                  .withShouldPersist(false)
                  .build(),
            )
            .withSharedPackageName(sharedPackageName)
            .build(),
      ];

      late var codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      late var compilationUnit = parseString(
        content: codeMap[expectedFileName]!,
      ).unit;
      var maybeClassNamedExample =
          CompilationUnitHelpers.tryFindClassDeclaration(
            compilationUnit,
            name: testClassName,
          );
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
            reason: 'Missing declaration for title field.',
          );
        },
      );
    },
  );

  group(
    'Given a class with a non persistent field with scope server only when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withFileName(testClassFileName)
            .withField(
              FieldDefinitionBuilder()
                  .withName('title')
                  .withTypeDefinition('String', true)
                  .withScope(ModelFieldScopeDefinition.serverOnly)
                  .withShouldPersist(false)
                  .build(),
            )
            .withSharedPackageName(sharedPackageName)
            .build(),
      ];

      late var codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      late var compilationUnit = parseString(
        content: codeMap[expectedFileName]!,
      ).unit;
      var maybeClassNamedExample =
          CompilationUnitHelpers.tryFindClassDeclaration(
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
            reason: 'Field title should not be generated.',
          );
        },
      );
    },
  );

  group(
    'Given a class with a non persistent field with scope none when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withFileName(testClassFileName)
            .withField(
              SerializableModelFieldDefinition(
                name: 'title',
                type: TypeDefinition(className: 'String', nullable: true),
                scope: ModelFieldScopeDefinition.none,
                shouldPersist: false,
              ),
            )
            .withSharedPackageName(sharedPackageName)
            .build(),
      ];

      late var codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      late var compilationUnit = parseString(
        content: codeMap[expectedFileName]!,
      ).unit;
      var maybeClassNamedExample =
          CompilationUnitHelpers.tryFindClassDeclaration(
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
            reason: 'Field title should not be generated.',
          );
        },
      );
    },
  );

  group('Given exception class when generating code', () {
    var models = [
      ExceptionClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withSharedPackageName(sharedPackageName)
          .build(),
    ];

    late var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    late var compilationUnit = parseString(
      content: codeMap[expectedFileName]!,
    ).unit;

    late var maybeClassNamedExample =
        CompilationUnitHelpers.tryFindClassDeclaration(
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
          reason: 'Class should implement SerializableException.',
        );
      },
    );
  });
}
