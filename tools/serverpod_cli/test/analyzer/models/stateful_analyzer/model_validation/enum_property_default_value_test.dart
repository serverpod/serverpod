import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group('Given an enum with a property that has a default value when parsing',
      () {
    late CodeGenerationCollector collector;
    late List<SerializableModelDefinition> definitions;
    late EnumDefinition definition;

    setUp(() {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          enum: ExampleEnum
          properties:
            id: int
            description: String, default=''
          values:
            - first:
                id: 1
            - second:
                id: 2
                description: 'Has description'
          ''',
        ).build(),
      ];

      collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(
        config,
        modelSources,
        onErrorsCollector(collector),
      );

      definitions = analyzer.validateAll();
      definition = definitions.first as EnumDefinition;
    });

    test('then no errors are collected.', () {
      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors but got: ${collector.errors}',
      );
    });

    test('then the property is marked as not required.', () {
      var descriptionProperty = definition.properties
          .firstWhere((p) => p.name == 'description');
      expect(descriptionProperty.required, isFalse);
    });

    test('then the default value is parsed correctly.', () {
      var descriptionProperty = definition.properties
          .firstWhere((p) => p.name == 'description');
      expect(descriptionProperty.defaultValue, "''");
    });

    test('then enum values without the property get the default value.', () {
      var firstValue = definition.values.first;
      // When enum value doesn't provide a value, the default is used
      expect(firstValue.propertyValues['description'], "''");
    });

    test('then enum values with the property have it parsed.', () {
      var secondValue = definition.values[1];
      expect(secondValue.propertyValues['description'], "'Has description'");
    });
  });
}
