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
  var testClassName = 'Example';
  var testClassFileName = 'example';
  var expectedFilePath = path.join(
    'lib',
    'src',
    'generated',
    '$testClassFileName.dart',
  );

  group(
    'Given class $testClassName with nullable custom class field when generating code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withField(
              FieldDefinitionBuilder()
                  .withName('nullableCustomClassField')
                  .withType(
                    TypeDefinitionBuilder()
                        .withClassName('CustomClass')
                        .withCustomClass(true)
                        .withNullable(true)
                        .build(),
                  )
                  .build(),
            )
            .build(),
      ];

      var codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      var compilationUnit = parseString(
        content: codeMap[expectedFilePath]!,
      ).unit;

      var maybeClassNamedExample =
          CompilationUnitHelpers.tryFindClassDeclaration(
            compilationUnit,
            name: testClassName,
          );

      test(
        'then toJsonForProtocol method should not use null-aware operator after type cast for nullable custom class field',
        () {
          var toJsonForProtocolMethod =
              CompilationUnitHelpers.tryFindMethodDeclaration(
                maybeClassNamedExample!,
                name: 'toJsonForProtocol',
              );

          var toJsonForProtocolCode = toJsonForProtocolMethod!.toSource();

          // This regex checks that the generated code does NOT contain the unnecessary null-aware operator
          // after the type cast. The pattern should be:
          // (nullableCustomClassField as _i1.ProtocolSerialization).toJsonForProtocol()
          // NOT:
          // (nullableCustomClassField as _i1.ProtocolSerialization)?.toJsonForProtocol()
          var correctPatternRegex = RegExp(
            r'\(nullableCustomClassField\s+as\s+_i\d+\.ProtocolSerialization\)\.toJsonForProtocol\(\)',
          );

          var incorrectPatternRegex = RegExp(
            r'\(nullableCustomClassField\s+as\s+_i\d+\.ProtocolSerialization\)\?\.toJsonForProtocol\(\)',
          );

          expect(
            correctPatternRegex.hasMatch(toJsonForProtocolCode),
            isTrue,
            reason:
                'The toJsonForProtocol method should cast nullable custom class field without null-aware operator after the cast.',
          );

          expect(
            incorrectPatternRegex.hasMatch(toJsonForProtocolCode),
            isFalse,
            reason:
                'The toJsonForProtocol method should NOT use null-aware operator (?.) after type cast.',
          );
        },
      );

      test(
        'then toJsonForProtocol method should still use null-aware operator for toJson fallback',
        () {
          var toJsonForProtocolMethod =
              CompilationUnitHelpers.tryFindMethodDeclaration(
                maybeClassNamedExample!,
                name: 'toJsonForProtocol',
              );

          var toJsonForProtocolCode = toJsonForProtocolMethod!.toSource();

          // Check that the fallback toJson call still uses null-aware operator
          // Pattern: nullableCustomClassField?.toJson()
          var nullSafeToJsonRegex = RegExp(
            r'nullableCustomClassField\?\.toJson\(\)',
          );

          expect(
            nullSafeToJsonRegex.hasMatch(toJsonForProtocolCode),
            isTrue,
            reason:
                'The toJsonForProtocol method should use null-aware operator for toJson() fallback on nullable fields.',
          );
        },
      );

      test(
        'then toJsonForProtocol method should handle nullable field correctly in the map',
        () {
          var toJsonForProtocolMethod =
              CompilationUnitHelpers.tryFindMethodDeclaration(
                maybeClassNamedExample!,
                name: 'toJsonForProtocol',
              );

          var toJsonForProtocolCode = toJsonForProtocolMethod!.toSource();

          // Check that the field is only added to the map if it's not null
          // Pattern should include: if (nullableCustomClassField != null)
          var nullCheckRegex = RegExp(
            r'if\s*\(\s*nullableCustomClassField\s*!=\s*null\s*\)',
          );

          expect(
            nullCheckRegex.hasMatch(toJsonForProtocolCode),
            isTrue,
            reason:
                'The toJsonForProtocol method should check if nullable field is not null before adding to map.',
          );
        },
      );
    },
  );
}
