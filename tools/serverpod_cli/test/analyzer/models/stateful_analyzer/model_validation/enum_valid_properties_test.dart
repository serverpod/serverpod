import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group('Given an enum with valid properties when parsing', () {
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
            name: String
          values:
            - first:
                id: 1
                name: 'First'
            - second:
                id: 2
                name: 'Second'
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

    test('then isEnhanced returns true.', () {
      expect(definition.isEnhanced, isTrue);
    });

    test('then properties are parsed correctly.', () {
      expect(definition.properties, hasLength(2));
      expect(definition.properties[0].name, 'id');
      expect(definition.properties[0].type, 'int');
      expect(definition.properties[1].name, 'name');
      expect(definition.properties[1].type, 'String');
    });

    test('then property values are parsed correctly.', () {
      var firstValue = definition.values.first;
      expect(firstValue.name, 'first');
      expect(firstValue.propertyValues['id'], 1);
      expect(firstValue.propertyValues['name'], "'First'");

      var secondValue = definition.values[1];
      expect(secondValue.name, 'second');
      expect(secondValue.propertyValues['id'], 2);
      expect(secondValue.propertyValues['name'], "'Second'");
    });
  });

  group('Given an enum without properties when parsing', () {
    late EnumDefinition definition;

    setUp(() {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          enum: ExampleEnum
          values:
            - first
            - second
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(
        config,
        modelSources,
        onErrorsCollector(collector),
      );

      var definitions = analyzer.validateAll();
      definition = definitions.first as EnumDefinition;
    });

    test('then isEnhanced returns false.', () {
      expect(definition.isEnhanced, isFalse);
    });

    test('then properties is empty.', () {
      expect(definition.properties, isEmpty);
    });
  });
}
