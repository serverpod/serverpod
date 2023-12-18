import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

void main() {
  group('Given a valid enum definition when validating', () {
    var modelSources = [
      ModelSourceBuilder().withYaml(
        '''
        enum: ExampleEnum
        values:
          - first
          - second
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer = StatefulAnalyzer(modelSources, onErrorsCollector(collector));

    var definitions = analyzer.validateAll();

    var definition = definitions.first as EnumDefinition;

    test('then no errors are collected', () {
      expect(collector.errors, isEmpty);
    });

    test('then serialized is set to int.', () {
      expect(definition.serialized, EnumSerialization.byIndex);
    });
  });

  group(
      'Given a valid enum definition with serialized set to int when validating',
      () {
    var modelSources = [
      ModelSourceBuilder().withYaml(
        '''
        enum: ExampleEnum
        serialized: byIndex
        values:
          - first
          - second
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer = StatefulAnalyzer(modelSources, onErrorsCollector(collector));

    var definitions = analyzer.validateAll();

    var definition = definitions.first as EnumDefinition;

    test('then no errors are collected', () {
      expect(collector.errors, isEmpty);
    });

    test('then serialized is set to int.', () {
      expect(definition.serialized, EnumSerialization.byIndex);
    });
  });

  group(
      'Given a valid enum definition with serialized set to string when validating',
      () {
    var modelSources = [
      ModelSourceBuilder().withYaml(
        '''
        enum: ExampleEnum
        serialized: byName
        values:
          - first
          - second
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer = StatefulAnalyzer(modelSources, onErrorsCollector(collector));

    var definitions = analyzer.validateAll();

    var definition = definitions.first as EnumDefinition;

    test('then no errors are collected', () {
      expect(collector.errors, isEmpty);
    });

    test('then serialized is set to string.', () {
      expect(definition.serialized, EnumSerialization.byName);
    });
  });

  test(
      'Given a valid enum definition with serialized set to an invalid value when validating then collect an error that the serialized value is invalid.',
      () {
    var modelSources = [
      ModelSourceBuilder().withYaml(
        '''
        enum: ExampleEnum
        serialized: Invalid
        values:
          - first
          - second
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer = StatefulAnalyzer(modelSources, onErrorsCollector(collector));

    analyzer.validateAll();

    expect(collector.errors, isNotEmpty);
    expect(
      collector.errors.first.message,
      '"Invalid" is not a valid property. Valid properties are (byName, byIndex).',
    );
  });

  group(
      'Given a class with a field with the type ExampleEnum serialized as an int',
      () {
    var modelSources = [
      ModelSourceBuilder().withFileName('example').withYaml(
        '''
        class: Example
        fields:
          myEnum: ExampleEnum
        ''',
      ).build(),
      ModelSourceBuilder().withFileName('example_enum').withYaml(
        '''
        enum: ExampleEnum
        serialized: byIndex
        values:
          - first
          - second
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      modelSources,
      onErrorsCollector(collector),
    );
    var definitions = analyzer.validateAll();

    var definition = definitions.first as ClassDefinition;

    test('then no errors was generated', () {
      expect(collector.errors, isEmpty);
    });

    test('then the field type is tagged as an enum', () {
      expect(definition.fields.first.type.isEnumType, isTrue);
    });

    test('then the field type is serialized as an int', () {
      expect(
        definition.fields.first.type.serializeEnum,
        EnumSerialization.byIndex,
      );
    });
  });

  group(
      'Given a class with a field with the type ExampleEnum serialized as a String',
      () {
    var modelSources = [
      ModelSourceBuilder().withFileName('example').withYaml(
        '''
        class: Example
        fields:
          myEnum: ExampleEnum
        ''',
      ).build(),
      ModelSourceBuilder().withFileName('example_enum').withYaml(
        '''
        enum: ExampleEnum
        serialized: byName
        values:
          - first
          - second
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      modelSources,
      onErrorsCollector(collector),
    );
    var definitions = analyzer.validateAll();

    var definition = definitions.first as ClassDefinition;

    test('then no errors was generated', () {
      expect(collector.errors, isEmpty);
    });

    test('then the field type is tagged as an enum', () {
      expect(definition.fields.first.type.isEnumType, isTrue);
    });

    test('then the field type is serialized as a String', () {
      expect(
        definition.fields.first.type.serializeEnum,
        EnumSerialization.byName,
      );
    });
  });
}
