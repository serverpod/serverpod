import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/model_class_definition_builder.dart';
import '../../../test_util/builders/serializable_entity_field_definition_builder.dart';
import '../../../test_util/builders/type_definition_builder.dart';
import '../../../test_util/compilation_unit_helpers.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartClientCodeGenerator();

void main() {
  const testClassName = 'Example';
  const testClassFileName = 'example';
  final expectedFilePath = path.join(
    '..',
    'example_project_client',
    'lib',
    'src',
    'protocol',
    '$testClassFileName.dart',
  );

  group('Given a class with a field with jsonKey set', () {
    const fieldName = 'displayName';
    const jsonKeyValue = 'display_name';
    const fieldType = 'String';

    final jsonKeyField = FieldDefinitionBuilder()
        .withName(fieldName)
        .withType(
          TypeDefinitionBuilder().withClassName(fieldType).build(),
        )
        .withJsonKeyOverride(jsonKeyValue)
        .build();

    const noJsonKeyFieldName = 'email';
    final noJsonKeyField = FieldDefinitionBuilder()
        .withName(noJsonKeyFieldName)
        .withType(
          TypeDefinitionBuilder().withClassName(fieldType).build(),
        )
        .build();

    final models = [
      ModelClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withField(jsonKeyField)
          .withField(noJsonKeyField)
          .build(),
    ];

    final codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    final compilationUnit = parseString(
      content: codeMap[expectedFilePath]!,
    ).unit;

    final maybeClassNamedExample =
        CompilationUnitHelpers.tryFindClassDeclaration(
          compilationUnit,
          name: testClassName,
        );

    group('when generating client code', () {
      group('then the fromJson method', () {
        test('uses jsonKey value for field with jsonKey set', () {
          final fromJsonConstructor =
              CompilationUnitHelpers.tryFindConstructorDeclaration(
                maybeClassNamedExample!,
                name: 'fromJson',
              );

          final fromJsonCode = fromJsonConstructor!.toSource();

          expect(
            fromJsonCode,
            contains("jsonSerialization['$jsonKeyValue']"),
            reason:
                'fromJson should use the jsonKey value for deserialization.',
          );
        });

        test('uses field name for field without jsonKey set', () {
          final fromJsonConstructor =
              CompilationUnitHelpers.tryFindConstructorDeclaration(
                maybeClassNamedExample!,
                name: 'fromJson',
              );

          final fromJsonCode = fromJsonConstructor!.toSource();

          expect(
            fromJsonCode,
            contains("jsonSerialization['$noJsonKeyFieldName']"),
            reason:
                'fromJson should use the field name when jsonKey is not set.',
          );
        });
      });

      group('then the toJson method', () {
        test('uses jsonKey value for field with jsonKey set', () {
          final toJsonMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
            maybeClassNamedExample!,
            name: 'toJson',
          );

          final toJsonCode = toJsonMethod!.toSource();

          expect(
            toJsonCode,
            contains("'$jsonKeyValue'"),
            reason: 'toJson should use the jsonKey value for the key.',
          );
        });

        test('uses field name for field without jsonKey set', () {
          final toJsonMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
            maybeClassNamedExample!,
            name: 'toJson',
          );

          final toJsonCode = toJsonMethod!.toSource();

          expect(
            toJsonCode,
            contains("'$noJsonKeyFieldName'"),
            reason: 'toJson should use the field name when jsonKey is not set.',
          );
        });
      });
    });
  });
}
