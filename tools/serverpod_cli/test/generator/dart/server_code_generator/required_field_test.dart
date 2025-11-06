import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/exception_class_definition_builder.dart';
import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/model_class_definition_builder.dart';
import '../../../test_util/builders/serializable_entity_field_definition_builder.dart';
import '../../../test_util/builders/type_definition_builder.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  group('Given a model with required nullable fields', () {
    test(
      'then constructor parameters are marked as required for nullable required fields',
      () {
        var models = [
          ModelClassDefinitionBuilder()
              .withClassName('Example')
              .withFileName('example')
              .withField(
                FieldDefinitionBuilder()
                    .withName('name')
                    .withType(
                      TypeDefinitionBuilder()
                          .withClassName('String')
                          .withNullable(false)
                          .build(),
                    )
                    .withIsRequired(false)
                    .build(),
              )
              .withField(
                FieldDefinitionBuilder()
                    .withName('email')
                    .withType(
                      TypeDefinitionBuilder()
                          .withClassName('String')
                          .withNullable(true)
                          .build(),
                    )
                    .withIsRequired(true)
                    .build(),
              )
              .withField(
                FieldDefinitionBuilder()
                    .withName('phone')
                    .withType(
                      TypeDefinitionBuilder()
                          .withClassName('String')
                          .withNullable(true)
                          .build(),
                    )
                    .withIsRequired(false)
                    .build(),
              )
              .build(),
        ];

        var codeMap = generator.generateSerializableModelsCode(
          models: models,
          config: config,
        );

        // Check that the generated code has the correct constructor
        var generatedCode = codeMap.values.first;

        // The required nullable field should be marked as required
        expect(generatedCode, contains('required String? email'));
        // The non-required nullable field should not be marked as required
        expect(generatedCode, contains('String? phone'));
        // The non-nullable field should be marked as required (default behavior)
        expect(generatedCode, contains('required String name'));
      },
    );
  });

  group('Given a exception with required nullable fields', () {
    test(
      'then constructor parameters are marked as required for nullable required fields',
      () {
        var models = [
          ExceptionClassDefinitionBuilder()
              .withClassName('Example')
              .withFileName('example')
              .withField(
                FieldDefinitionBuilder()
                    .withName('name')
                    .withType(
                      TypeDefinitionBuilder()
                          .withClassName('String')
                          .withNullable(false)
                          .build(),
                    )
                    .withIsRequired(false)
                    .build(),
              )
              .withField(
                FieldDefinitionBuilder()
                    .withName('email')
                    .withType(
                      TypeDefinitionBuilder()
                          .withClassName('String')
                          .withNullable(true)
                          .build(),
                    )
                    .withIsRequired(true)
                    .build(),
              )
              .withField(
                FieldDefinitionBuilder()
                    .withName('phone')
                    .withType(
                      TypeDefinitionBuilder()
                          .withClassName('String')
                          .withNullable(true)
                          .build(),
                    )
                    .withIsRequired(false)
                    .build(),
              )
              .build(),
        ];

        var codeMap = generator.generateSerializableModelsCode(
          models: models,
          config: config,
        );

        // Check that the generated code has the correct constructor
        var generatedCode = codeMap.values.first;

        // The required nullable field should be marked as required
        expect(generatedCode, contains('required String? email'));
        // The non-required nullable field should not be marked as required
        expect(generatedCode, contains('String? phone'));
        // The non-nullable field should be marked as required (default behavior)
        expect(generatedCode, contains('required String name'));
      },
    );
  });
}
