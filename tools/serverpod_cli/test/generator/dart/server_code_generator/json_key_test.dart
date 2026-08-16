import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/model_class_definition_builder.dart';
import '../../../test_util/builders/serializable_entity_field_definition_builder.dart';
import '../../../test_util/builders/type_definition_builder.dart';
import '../../../test_util/compilation_unit_helpers.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  const testClassName = 'Example';
  const testClassFileName = 'example';
  final expectedFilePath = path.join(
    'lib',
    'src',
    'generated',
    '$testClassFileName.dart',
  );

  group(
    'Given a class with a field with jsonKey set when generating server code',
    () {
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

      group('then the fromJson method', () {
        late final fromJsonCode =
            CompilationUnitHelpers.tryFindConstructorDeclaration(
              maybeClassNamedExample!,
              name: 'fromJson',
            )!.toSource();

        test('uses jsonKey value for field with jsonKey set', () {
          expect(
            fromJsonCode,
            contains("jsonSerialization['$jsonKeyValue']"),
            reason:
                'fromJson should use the jsonKey value for deserialization.',
          );
        });

        test('uses field name for field without jsonKey set', () {
          expect(
            fromJsonCode,
            contains("jsonSerialization['$noJsonKeyFieldName']"),
            reason:
                'fromJson should use the field name when jsonKey is not set.',
          );
        });
      });

      group('then the toJson method', () {
        late final toJsonCode = CompilationUnitHelpers.tryFindMethodDeclaration(
          maybeClassNamedExample!,
          name: 'toJson',
        )!.toSource();

        test('uses jsonKey value for field with jsonKey set', () {
          expect(
            toJsonCode,
            contains("'$jsonKeyValue'"),
            reason: 'toJson should use the jsonKey value for the key.',
          );
        });

        test('uses field name for field without jsonKey set', () {
          expect(
            toJsonCode,
            contains("'$noJsonKeyFieldName'"),
            reason: 'toJson should use the field name when jsonKey is not set.',
          );
        });
      });

      group('then the toJsonForProtocol method', () {
        late final toJsonForProtocolCode =
            CompilationUnitHelpers.tryFindMethodDeclaration(
              maybeClassNamedExample!,
              name: 'toJsonForProtocol',
            )!.toSource();

        test('uses jsonKey value for field with jsonKey set', () {
          expect(
            toJsonForProtocolCode,
            contains("'$jsonKeyValue'"),
            reason:
                'toJsonForProtocol should use the jsonKey value for the key.',
          );
        });

        test('uses field name for field without jsonKey set', () {
          expect(
            toJsonForProtocolCode,
            contains("'$noJsonKeyFieldName'"),
            reason:
                'toJsonForProtocol should use the field name when jsonKey is not set.',
          );
        });
      });
    },
  );
}
