import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/analyzer/entities/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/protocol_source_builder.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given a valid enum definition when validating then serialized is set to int.',
      () {
    var protocols = [
      ProtocolSourceBuilder().withYaml(
        '''
        enum: ExampleEnum
        values:
          - first
          - second
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));

    var definitions = analyzer.validateAll();

    var definition = definitions.first as EnumDefinition;

    expect(definition.serializeAs, EnumSerialization.byIndex);
  });

  test(
      'Given a valid enum definition with serialized set to int when validating then no errors are collected',
      () {
    var protocols = [
      ProtocolSourceBuilder().withYaml(
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
    var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));

    analyzer.validateAll();

    expect(collector.errors, isEmpty);
  });

  test(
      'Given a valid enum definition with serialized set to int when validating then serialized is set to int.',
      () {
    var protocols = [
      ProtocolSourceBuilder().withYaml(
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
    var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));

    var definitions = analyzer.validateAll();

    var definition = definitions.first as EnumDefinition;

    expect(definition.serializeAs, EnumSerialization.byIndex);
  });

  test(
      'Given a valid enum definition with serialized set to string when validating then serialized is set to string.',
      () {
    var protocols = [
      ProtocolSourceBuilder().withYaml(
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
    var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));

    var definitions = analyzer.validateAll();

    var definition = definitions.first as EnumDefinition;

    expect(definition.serializeAs, EnumSerialization.byName);
  });

  test(
      'Given a valid enum definition with serialized set to an invalid value when validating then collect an error that the serialized value is invalid.',
      () {
    var protocols = [
      ProtocolSourceBuilder().withYaml(
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
    var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));

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
    var protocols = [
      ProtocolSourceBuilder().withFileName('example').withYaml(
        '''
        class: Example
        fields:
          myEnum: ExampleEnum
        ''',
      ).build(),
      ProtocolSourceBuilder().withFileName('example_enum').withYaml(
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
      protocols,
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
        definition.fields.first.type.serializeEnumAs,
        EnumSerialization.byIndex,
      );
    });
  });

  group(
      'Given a class with a field with the type ExampleEnum serialized as a String',
      () {
    var protocols = [
      ProtocolSourceBuilder().withFileName('example').withYaml(
        '''
        class: Example
        fields:
          myEnum: ExampleEnum
        ''',
      ).build(),
      ProtocolSourceBuilder().withFileName('example_enum').withYaml(
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
      protocols,
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
        definition.fields.first.type.serializeEnumAs,
        EnumSerialization.byName,
      );
    });
  });
}
