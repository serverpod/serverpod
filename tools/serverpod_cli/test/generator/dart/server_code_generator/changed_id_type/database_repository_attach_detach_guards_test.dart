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

  String methodBody(
    CompilationUnit compilationUnit,
    String className,
    String methodName,
  ) {
    var classDeclaration = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: className,
    );
    var method = CompilationUnitHelpers.tryFindMethodDeclaration(
      classDeclaration!,
      name: methodName,
    );
    return method!.body.toSource();
  }

  group(
    'Given a class with an object relation where both ids are nullable when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withFileName('example')
            .withTableName('example_table')
            .withObjectRelationField(
              'company',
              'Company',
              'company',
              referenceIdType: TypeDefinition.int.asNullable,
              nullableRelation: true,
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

      test('then the attachRow method checks both ids for null', () {
        var body = methodBody(
          compilationUnit,
          'ExampleAttachRowRepository',
          'company',
        );

        expect(body, contains("ArgumentError.notNull('example.id')"));
        expect(body, contains("ArgumentError.notNull('company.id')"));
      });

      test('then the detachRow method checks the id for null', () {
        var body = methodBody(
          compilationUnit,
          'ExampleDetachRowRepository',
          'company',
        );

        expect(body, contains("ArgumentError.notNull('example.id')"));
      });
    },
  );

  group(
    'Given a class with a non-nullable id and an object relation to a class '
    'with a nullable id when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withFileName('example')
            .withTableName('example_table')
            .withIdFieldType(SupportedIdType.uuidV4, nullable: false)
            .withObjectRelationField(
              'company',
              'Company',
              'company',
              referenceIdType: TypeDefinition.int.asNullable,
              nullableRelation: true,
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

      test(
        'then the attachRow method only checks the related id for null',
        () {
          var body = methodBody(
            compilationUnit,
            'ExampleAttachRowRepository',
            'company',
          );

          expect(body, isNot(contains("ArgumentError.notNull('example.id')")));
          expect(body, contains("ArgumentError.notNull('company.id')"));
        },
      );

      test('then the detachRow method has no null check', () {
        var body = methodBody(
          compilationUnit,
          'ExampleDetachRowRepository',
          'company',
        );

        expect(body, isNot(contains('ArgumentError.notNull')));
      });
    },
  );

  group(
    'Given a class with a nullable id and an object relation to a class with '
    'a non-nullable id when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withFileName('example')
            .withTableName('example_table')
            .withObjectRelationField(
              'company',
              'Company',
              'company',
              referenceIdType: TypeDefinition.uuid,
              nullableRelation: true,
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

      test('then the attachRow method only checks the own id for null', () {
        var body = methodBody(
          compilationUnit,
          'ExampleAttachRowRepository',
          'company',
        );

        expect(body, contains("ArgumentError.notNull('example.id')"));
        expect(body, isNot(contains("ArgumentError.notNull('company.id')")));
      });
    },
  );

  group(
    'Given a class with a foreign-side object relation to a class with a '
    'non-nullable id when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withFileName('example')
            .withTableName('example_table')
            .withObjectRelationFieldNoForeignKey(
              'company',
              'Company',
              'company',
              referenceIdType: TypeDefinition.uuid,
              nullableRelation: true,
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

      test(
        'then the attachRow method only checks the own id for null',
        () {
          var body = methodBody(
            compilationUnit,
            'ExampleAttachRowRepository',
            'company',
          );

          expect(body, contains("ArgumentError.notNull('example.id')"));
          expect(body, isNot(contains("ArgumentError.notNull('company.id')")));
        },
      );

      test(
        'then the detachRow method checks the relation field but not its id '
        'for null',
        () {
          var body = methodBody(
            compilationUnit,
            'ExampleDetachRowRepository',
            'company',
          );

          expect(body, contains("ArgumentError.notNull('example.company')"));
          expect(
            body,
            isNot(contains("ArgumentError.notNull('example.company.id')")),
          );
          expect(body, contains("ArgumentError.notNull('example.id')"));
        },
      );
    },
  );

  group(
    'Given a class with a named list relation where all ids are nullable when '
    'generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withFileName('example')
            .withTableName('example_table')
            .withListRelationField(
              'citizens',
              'Person',
              'exampleId',
              nullableRelation: true,
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

      test('then the attach method checks all ids for null', () {
        var body = methodBody(
          compilationUnit,
          'ExampleAttachRepository',
          'citizens',
        );

        expect(body, contains('person.any((e) => e.id == null)'));
        expect(body, contains("ArgumentError.notNull('example.id')"));
      });

      test('then the attachRow method checks both ids for null', () {
        var body = methodBody(
          compilationUnit,
          'ExampleAttachRowRepository',
          'citizens',
        );

        expect(body, contains("ArgumentError.notNull('person.id')"));
        expect(body, contains("ArgumentError.notNull('example.id')"));
      });

      test('then the detach method checks the related ids for null', () {
        var body = methodBody(
          compilationUnit,
          'ExampleDetachRepository',
          'citizens',
        );

        expect(body, contains('person.any((e) => e.id == null)'));
      });

      test('then the detachRow method checks the related id for null', () {
        var body = methodBody(
          compilationUnit,
          'ExampleDetachRowRepository',
          'citizens',
        );

        expect(body, contains("ArgumentError.notNull('person.id')"));
      });
    },
  );

  group(
    'Given a class with a named list relation to a class with a non-nullable '
    'id when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withFileName('example')
            .withTableName('example_table')
            .withListRelationField(
              'citizens',
              'Person',
              'exampleId',
              foreignKeyOwnerIdType: TypeDefinition.uuid,
              nullableRelation: true,
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

      test('then the attach method only checks the own id for null', () {
        var body = methodBody(
          compilationUnit,
          'ExampleAttachRepository',
          'citizens',
        );

        expect(body, isNot(contains('person.any((e) => e.id == null)')));
        expect(body, contains("ArgumentError.notNull('example.id')"));
      });

      test('then the attachRow method only checks the own id for null', () {
        var body = methodBody(
          compilationUnit,
          'ExampleAttachRowRepository',
          'citizens',
        );

        expect(body, isNot(contains("ArgumentError.notNull('person.id')")));
        expect(body, contains("ArgumentError.notNull('example.id')"));
      });

      test('then the detach method has no null check', () {
        var body = methodBody(
          compilationUnit,
          'ExampleDetachRepository',
          'citizens',
        );

        expect(body, isNot(contains('ArgumentError.notNull')));
      });

      test('then the detachRow method has no null check', () {
        var body = methodBody(
          compilationUnit,
          'ExampleDetachRowRepository',
          'citizens',
        );

        expect(body, isNot(contains('ArgumentError.notNull')));
      });
    },
  );

  group(
    'Given a class with an implicit list relation to a class with a '
    'non-nullable id when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withFileName('example')
            .withTableName('example_table')
            .withImplicitListRelationField(
              'citizens',
              'Person',
              foreignKeyOwnerIdType: TypeDefinition.uuid,
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

      test('then the attach method only checks the own id for null', () {
        var body = methodBody(
          compilationUnit,
          'ExampleAttachRepository',
          'citizens',
        );

        expect(body, isNot(contains('person.any((e) => e.id == null)')));
        expect(body, contains("ArgumentError.notNull('example.id')"));
      });

      test('then the attachRow method only checks the own id for null', () {
        var body = methodBody(
          compilationUnit,
          'ExampleAttachRowRepository',
          'citizens',
        );

        expect(body, isNot(contains("ArgumentError.notNull('person.id')")));
        expect(body, contains("ArgumentError.notNull('example.id')"));
      });

      test('then the detachRow method has no null check', () {
        var body = methodBody(
          compilationUnit,
          'ExampleDetachRowRepository',
          'citizens',
        );

        expect(body, isNot(contains('ArgumentError.notNull')));
      });
    },
  );

  group(
    'Given a class with an implicit list relation where all ids are nullable '
    'when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withFileName('example')
            .withTableName('example_table')
            .withImplicitListRelationField('citizens', 'Person')
            .build(),
      ];

      late final codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      late final compilationUnit = parseString(
        content: codeMap[expectedFilePath]!,
      ).unit;

      test('then the attach method checks all ids for null', () {
        var body = methodBody(
          compilationUnit,
          'ExampleAttachRepository',
          'citizens',
        );

        expect(body, contains('person.any((e) => e.id == null)'));
        expect(body, contains("ArgumentError.notNull('example.id')"));
      });

      test('then the detach method checks the related ids for null', () {
        var body = methodBody(
          compilationUnit,
          'ExampleDetachRepository',
          'citizens',
        );

        expect(body, contains('person.any((e) => e.id == null)'));
      });
    },
  );
}
