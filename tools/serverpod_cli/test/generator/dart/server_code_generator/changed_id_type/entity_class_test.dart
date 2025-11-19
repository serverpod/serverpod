import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_class_definition_builder.dart';
import '../../../../test_util/compilation_unit_helpers.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  var expectedFilePath = path.join('lib', 'src', 'generated', 'example.dart');

  group('Given a table class with id type "int" when generating code', () {
    var models = [
      ModelClassDefinitionBuilder()
          .withFileName('example')
          .withTableName('example_table')
          .withIdFieldType(SupportedIdType.int)
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
          name: 'Example',
        );

    test('then a class named "Example" is correctly generated.', () {
      expect(
        maybeClassNamedExample,
        isNotNull,
        reason: 'Missing definition for class named "Example".',
      );
    });

    test('then the class has TableRow implements generic to "int".', () {
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
        typeName?.toString(),
        'int?',
        reason: 'Wrong generic type for TableRow.',
      );
    });

    test(
      'then the class has Table generic to "int?" as table getter return type.',
      () {
        var maybeTableGetter = CompilationUnitHelpers.tryFindMethodDeclaration(
          maybeClassNamedExample!,
          name: 'table',
        );

        var typeArguments = maybeTableGetter?.returnType as NamedType?;
        var genericType = typeArguments?.typeArguments?.arguments.first;

        expect(
          (genericType as NamedType?)?.toString(),
          'int?',
          reason: 'Wrong generic type for Table getter.',
        );
      },
    );

    test('then the class has type of the id field "int".', () {
      var maybeIdField = CompilationUnitHelpers.tryFindFieldDeclaration(
        maybeClassNamedExample!,
        name: 'id',
      );

      expect(
        (maybeIdField?.fields.type as NamedType).toString(),
        'int?',
        reason: 'Wrong type for the id field.',
      );
    });
  });

  group(
    'Given a table class with non-nullable id type "UUIDv4" when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withFileName('example')
            .withTableName('example_table')
            .withIdFieldType(SupportedIdType.uuidV4, nullable: false)
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
            name: 'Example',
          );

      test('then a class named "Example" is correctly generated.', () {
        expect(
          maybeClassNamedExample,
          isNotNull,
          reason: 'Missing definition for class named "Example".',
        );
      });

      test(
        'then the class has TableRow implements generic to "UuidValue".',
        () {
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
            typeName?.toString(),
            '_i1.UuidValue',
            reason: 'Wrong generic type for TableRow.',
          );
        },
      );

      test(
        'then the class has Table generic to "UuidValue" as table getter return type.',
        () {
          var maybeTableGetter =
              CompilationUnitHelpers.tryFindMethodDeclaration(
                maybeClassNamedExample!,
                name: 'table',
              );

          var typeArguments = maybeTableGetter?.returnType as NamedType?;
          var genericType = typeArguments?.typeArguments?.arguments.first;

          expect(
            (genericType as NamedType?)?.toString(),
            '_i1.UuidValue',
            reason: 'Wrong generic type for Table getter.',
          );
        },
      );

      test('then the class has type of the id field "UuidValue".', () {
        var maybeIdField = CompilationUnitHelpers.tryFindFieldDeclaration(
          maybeClassNamedExample!,
          name: 'id',
        );

        expect(
          (maybeIdField?.fields.type as NamedType).toString(),
          '_i1.UuidValue',
          reason: 'Wrong type for the id field.',
        );
      });
    },
  );

  group(
    'Given a table class with nullable id type "UUIDv4" when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withFileName('example')
            .withTableName('example_table')
            .withIdFieldType(SupportedIdType.uuidV4, nullable: true)
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
            name: 'Example',
          );

      test('then a class named "Example" is correctly generated.', () {
        expect(
          maybeClassNamedExample,
          isNotNull,
          reason: 'Missing definition for class named "Example".',
        );
      });

      test(
        'then the class has TableRow implements generic to "UuidValue".',
        () {
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
            typeName?.toString(),
            '_i1.UuidValue?',
            reason: 'Wrong generic type for TableRow.',
          );
        },
      );

      test(
        'then the class has Table generic to "UuidValue" as table getter return type.',
        () {
          var maybeTableGetter =
              CompilationUnitHelpers.tryFindMethodDeclaration(
                maybeClassNamedExample!,
                name: 'table',
              );

          var typeArguments = maybeTableGetter?.returnType as NamedType?;
          var genericType = typeArguments?.typeArguments?.arguments.first;

          expect(
            (genericType as NamedType?)?.toString(),
            '_i1.UuidValue?',
            reason: 'Wrong generic type for Table getter.',
          );
        },
      );

      test('then the class has type of the id field "UuidValue".', () {
        var maybeIdField = CompilationUnitHelpers.tryFindFieldDeclaration(
          maybeClassNamedExample!,
          name: 'id',
        );

        expect(
          (maybeIdField?.fields.type as NamedType).toString(),
          '_i1.UuidValue?',
          reason: 'Wrong type for the id field.',
        );
      });
    },
  );

  group(
    'Given a serverOnly table class with nullable id type "UUIDv4" when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withFileName('example')
            .withTableName('example_table')
            .withIdFieldType(SupportedIdType.uuidV4, nullable: true)
            .withServerOnly(true)
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
            name: 'Example',
          );

      test('then toJsonForProtocol method should return an empty map.', () {
        var toJsonForProtocolMethod =
            CompilationUnitHelpers.tryFindMethodDeclaration(
              maybeClassNamedExample!,
              name: 'toJsonForProtocol',
            );

        var toJsonForProtocolCode = toJsonForProtocolMethod!.toSource();
        expect(toJsonForProtocolCode, contains('return {};'));
      });
    },
  );
}
