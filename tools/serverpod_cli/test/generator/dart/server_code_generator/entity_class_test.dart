import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/exception_class_definition_builder.dart';
import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/model_class_definition_builder.dart';
import '../../../test_util/builders/serializable_entity_field_definition_builder.dart';
import '../../../test_util/compilation_unit_helpers.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  var testClassName = 'Example';
  var testClassFileName = 'example';
  var expectedFilePath = path.join(
    'lib',
    'src',
    'generated',
    '$testClassFileName.dart',
  );
  var tableName = 'example_table';

  group('Given empty class named $testClassName when generating code', () {
    var models = [
      ModelClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .build(),
    ];

    late final codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    late final compilationUnit = parseString(
      content: codeMap[expectedFilePath]!,
    ).unit;

    test('then generated class imports server version of serverpod.', () {
      expect(
        CompilationUnitHelpers.hasImportDirective(
          compilationUnit,
          uri: 'package:serverpod/serverpod.dart',
        ),
        isTrue,
        reason: 'Missing import of package:serverpod/serverpod.dart',
      );
    });

    late final maybeClassNamedExample =
        CompilationUnitHelpers.tryFindClassDeclaration(
          compilationUnit,
          name: testClassName,
        );
    test('then a class named $testClassName is generated.', () {
      expect(
        maybeClassNamedExample,
        isNotNull,
        reason: 'Missing definition for class named $testClassName',
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
          reason: 'Missing implements clause for SerializableModel.',
        );
      });

      test('implements ProtocolSerialization.', () {
        expect(
          CompilationUnitHelpers.hasImplementsClause(
            maybeClassNamedExample!,
            name: 'ProtocolSerialization',
          ),
          isTrue,
          reason: 'Missing implements clause for ProtocolSerialization',
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
          reason: 'Missing declaration for toJson method',
        );
      });

      test('has a toJsonForProtocol method.', () {
        expect(
          CompilationUnitHelpers.hasMethodDeclaration(
            maybeClassNamedExample!,
            name: 'toJsonForProtocol',
          ),
          isTrue,
          reason: 'Missing declaration for toJsonForProtocol method.',
        );
      });
    });
  });

  group('Given a class with table name when generating code', () {
    var models = [
      ModelClassDefinitionBuilder()
          .withFileName(testClassFileName)
          .withTableName(tableName)
          .build(),
    ];

    late final codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    late final compilationUnit = parseString(
      content: codeMap[expectedFilePath]!,
    ).unit;
    late final maybeClassNamedExample =
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
          ),
          isTrue,
          reason: 'Missing declaration for table method.',
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
          .build(),
    ];

    late final codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    late final compilationUnit = parseString(
      content: codeMap[expectedFilePath]!,
    ).unit;
    late final maybeClassNamedExample =
        CompilationUnitHelpers.tryFindClassDeclaration(
          compilationUnit,
          name: testClassName,
        );
    group('then the class named $testClassName', () {
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

      test('has that class variable as a mutable field.', () {
        expect(
          CompilationUnitHelpers.hasFieldDeclaration(
            maybeClassNamedExample!,
            name: 'title',
            type: 'String',
            isFinal: false,
          ),
          isTrue,
          reason: 'Missing declaration for title field.',
        );
      });
    });
  });

  group('Given a class with a nullable field when generating code', () {
    var models = [
      ModelClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withSimpleField('title', 'String', nullable: true)
          .build(),
    ];

    late final codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    late final compilationUnit = parseString(
      content: codeMap[expectedFilePath]!,
    ).unit;
    late final maybeClassNamedExample =
        CompilationUnitHelpers.tryFindClassDeclaration(
          compilationUnit,
          name: testClassName,
        );
    group('then the class named $testClassName', () {
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
    });
  });

  group(
    'Given a class with a non persistent field with scope all when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withField(
              FieldDefinitionBuilder()
                  .withName('title')
                  .withTypeDefinition('String', true)
                  .withScope(ModelFieldScopeDefinition.all)
                  .build(),
            )
            .build(),
      ];

      late final codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      late final compilationUnit = parseString(
        content: codeMap[expectedFilePath]!,
      ).unit;
      late final maybeClassNamedExample =
          CompilationUnitHelpers.tryFindClassDeclaration(
            compilationUnit,
            name: testClassName,
          );
      test(
        'then a class is generated with that class variable.',
        () {
          expect(
            CompilationUnitHelpers.hasFieldDeclaration(
              maybeClassNamedExample!,
              name: 'title',
              type: 'String?',
            ),
            isTrue,
            reason: 'Missing declaration for title field',
          );
        },
      );
    },
  );

  group(
    'Given a class with a non persistent field with scope serverOnly when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withField(
              FieldDefinitionBuilder()
                  .withName('title')
                  .withTypeDefinition('String', true)
                  .withScope(ModelFieldScopeDefinition.serverOnly)
                  .withShouldPersist(false)
                  .build(),
            )
            .build(),
      ];

      late final codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      late final compilationUnit = parseString(
        content: codeMap[expectedFilePath]!,
      ).unit;
      late final maybeClassNamedExample =
          CompilationUnitHelpers.tryFindClassDeclaration(
            compilationUnit,
            name: testClassName,
          );
      test(
        'then a class is generated with that class variable.',
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
    'Given a class with a non persistent field with scope none when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withField(
              SerializableModelFieldDefinition(
                name: 'title',
                type: TypeDefinition(className: 'String', nullable: true),
                scope: ModelFieldScopeDefinition.none,
                shouldPersist: false,
              ),
            )
            .build(),
      ];

      late final codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      late final compilationUnit = parseString(
        content: codeMap[expectedFilePath]!,
      ).unit;
      late final maybeClassNamedExample =
          CompilationUnitHelpers.tryFindClassDeclaration(
            compilationUnit,
            name: testClassName,
          );
      test(
        'then a class is NOT generated with that class variable.',
        () {
          expect(
            CompilationUnitHelpers.hasFieldDeclaration(
              maybeClassNamedExample!,
              name: 'title',
              type: 'String?',
            ),
            isFalse,
            reason: 'Found declaration for field that should not exist.',
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
          .build(),
    ];

    late final codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    late final compilationUnit = parseString(
      content: codeMap[expectedFilePath]!,
    ).unit;

    late final maybeClassNamedExample =
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

  group(
    'Given a class with a persistent field with scope none when generating code',
    () {
      var fieldName = 'implicit_field';
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withTableName(tableName)
            .withField(
              SerializableModelFieldDefinition(
                name: fieldName,
                type: TypeDefinition(className: 'String', nullable: true),
                scope: ModelFieldScopeDefinition.none,
                shouldPersist: true,
              ),
            )
            .build(),
      ];

      late final codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      late final compilationUnit = parseString(
        content: codeMap[expectedFilePath]!,
      ).unit;

      late final maybeClassNamedExample =
          CompilationUnitHelpers.tryFindClassDeclaration(
            compilationUnit,
            name: testClassName,
          );

      group(
        'then class',
        () {
          test('is generated with field as hidden class variable.', () {
            expect(
              CompilationUnitHelpers.hasFieldDeclaration(
                maybeClassNamedExample!,
                name: '_$fieldName',
                type: 'String?',
                isFinal: true,
              ),
              isTrue,
              reason: 'Field declaration missing for $fieldName.',
            );
          });

          test('has a toJson that uses hidden class variable.', () {
            var maybeToJson = CompilationUnitHelpers.tryFindMethodDeclaration(
              maybeClassNamedExample!,
              name: 'toJson',
            );

            expect(
              maybeToJson,
              isNotNull,
              reason: 'Missing declaration for toJson method.',
            );
            expect(
              maybeToJson!.toSource(),
              contains('\'$fieldName\' : _$fieldName'),
              reason:
                  'Missing use of hidden class variable in setColumn method.',
            );
          });

          test('then constructor initializes private field with null', () {
            var maybeConstructor =
                CompilationUnitHelpers.tryFindConstructorDeclaration(
                  maybeClassNamedExample!,
                  name: '_',
                );

            expect(
              maybeConstructor?.toSource(),
              contains('_$fieldName = null'),
              reason: 'Missing initialization of private field in constructor.',
            );
          });
        },
      );
    },
  );

  group(
    'Given a class with a persistent field with scope none starting with underscore when generating code',
    () {
      var fieldName = '_implicit_field';
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withTableName(tableName)
            .withField(
              SerializableModelFieldDefinition(
                name: fieldName,
                type: TypeDefinition(className: 'String', nullable: true),
                scope: ModelFieldScopeDefinition.none,
                shouldPersist: true,
              ),
            )
            .build(),
      ];

      late final codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      late final compilationUnit = parseString(
        content: codeMap[expectedFilePath]!,
      ).unit;

      late final maybeClassNamedExample =
          CompilationUnitHelpers.tryFindClassDeclaration(
            compilationUnit,
            name: testClassName,
          );

      test(
        'then class is generated with field as hidden class variable with no extra underscore appended.',
        () {
          expect(
            CompilationUnitHelpers.hasFieldDeclaration(
              maybeClassNamedExample!,
              name: fieldName,
              type: 'String?',
            ),
            isTrue,
            reason: 'Field declaration missing for $fieldName.',
          );
        },
      );
    },
  );
}
