import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
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

      test('does not implement ProtocolSerialization.', () {
        expect(
          CompilationUnitHelpers.hasImplementsClause(
            maybeClassNamedExample!,
            name: 'ProtocolSerialization',
          ),
          isFalse,
          reason: 'Should not implement ProtocolSerialization',
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

      test('does not have a toJsonForProtocol method.', () {
        expect(
          CompilationUnitHelpers.hasMethodDeclaration(
            maybeClassNamedExample!,
            name: 'toJsonForProtocol',
          ),
          isFalse,
          reason: 'Class should not have a toJsonForProtocol method.',
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
    var models = [
      ModelClassDefinitionBuilder()
          .withFileName(testClassFileName)
          .withTableName('example_table')
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
        test('still implements SerializableModel.', () {
          expect(
            CompilationUnitHelpers.hasImplementsClause(
              maybeClassNamedExample!,
              name: 'SerializableModel',
            ),
            isTrue,
            reason: 'Missing extends clause for SerializableModel.',
          );
        });

        test('has id in constructor.', () {
          expect(
            CompilationUnitHelpers.hasConstructorDeclaration(
              maybeClassNamedExample!,
              name: null,
              parameters: ['int? id'],
            ),
            isTrue,
            reason: 'Missing declaration for $testClassName constructor.',
          );
        });

        test('is generated with id field.', () {
          expect(
            CompilationUnitHelpers.hasFieldDeclaration(
              maybeClassNamedExample!,
              name: 'id',
              type: 'int?',
            ),
            isTrue,
            reason: 'Declaration for id field was should be generated.',
          );
        });
      },
    );

    test('then a class named ${testClassName}Include does NOT exist.', () {
      expect(
        CompilationUnitHelpers.hasClassDeclaration(
          compilationUnit,
          name: '${testClassName}Include',
        ),
        isFalse,
        reason: 'Class ${testClassName}Include should not be generated.',
      );
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
