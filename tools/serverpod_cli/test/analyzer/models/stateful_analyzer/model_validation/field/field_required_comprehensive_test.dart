import 'package:test/test.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';
import '../../../../../test_util/builders/model_class_definition_builder.dart';
import '../../../../../test_util/builders/serializable_entity_field_definition_builder.dart';
import '../../../../../test_util/builders/type_definition_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();
  
  group('Required keyword parsing and validation', () {
    test('parses required keyword correctly on nullable field', () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
            class: Example
            fields:
              email: String?, required
            ''',
        ).build()
      ];
      var collector = CodeGenerationCollector();
      var definitions = StatefulAnalyzer(config, models, onErrorsCollector(collector))
          .validateAll();

      expect(collector.errors, isEmpty);
      var definition = definitions.firstOrNull as ClassDefinition?;
      var emailField = definition?.findField('email');
      expect(emailField?.isRequired, isTrue);
    });

    test('validates required keyword on non-nullable field produces error', () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
            class: Example
            fields:
              name: String, required
            ''',
        ).build()
      ];
      var collector = CodeGenerationCollector();
      StatefulAnalyzer(config, models, onErrorsCollector(collector))
          .validateAll();

      expect(collector.errors, isNotEmpty);
      expect(collector.errors.first.message, contains('required'));
      expect(collector.errors.first.message, contains('nullable'));
    });

    test('required=false is allowed and has no effect', () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
            class: Example
            fields:
              name: String?, required=false
            ''',
        ).build()
      ];
      var collector = CodeGenerationCollector();
      var definitions = StatefulAnalyzer(config, models, onErrorsCollector(collector))
          .validateAll();

      expect(collector.errors, isEmpty);
      var definition = definitions.firstOrNull as ClassDefinition?;
      var nameField = definition?.findField('name');
      expect(nameField?.isRequired, isFalse);
    });
  });

  group('Code generation with required fields', () {
    test('generates correct constructor parameters', () {
      const generator = DartServerCodeGenerator();
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
            .build()
      ];

      var codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      var generatedCode = codeMap.values.first;
      
      // Test constructor signatures
      expect(generatedCode, contains('required String name'));
      expect(generatedCode, contains('required String? email'));
      expect(generatedCode, contains('String? phone'));
      expect(generatedCode, isNot(contains('required String? phone')));
    });
  });
}