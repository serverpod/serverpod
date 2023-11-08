import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/analyzer/entities/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/protocol_source_builder.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given a valid enum definition when validating then serializeAs is set to int.',
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

    expect(definition.serializeAs, SerializeEnumAs.int);
  });

  test(
      'Given a valid enum definition with serializeAs set to int when validating then no errors are collected',
      () {
    var protocols = [
      ProtocolSourceBuilder().withYaml(
        '''
        enum: ExampleEnum
        serializeAs: int
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
      'Given a valid enum definition with serializeAs set to int when validating then serializeAs is set to int.',
      () {
    var protocols = [
      ProtocolSourceBuilder().withYaml(
        '''
        enum: ExampleEnum
        serializeAs: int
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

    expect(definition.serializeAs, SerializeEnumAs.int);
  });

  test(
      'Given a valid enum definition with serializeAs set to string when validating then serializeAs is set to string.',
      () {
    var protocols = [
      ProtocolSourceBuilder().withYaml(
        '''
        enum: ExampleEnum
        serializeAs: String
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

    expect(definition.serializeAs, SerializeEnumAs.string);
  });

  test(
      'Given a valid enum definition with serializeAs set to an invalid value when validating then collect an error that the serializeAs value is invalid.',
      () {
    var protocols = [
      ProtocolSourceBuilder().withYaml(
        '''
        enum: ExampleEnum
        serializeAs: Invalid
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
      '"Invalid" is not a valid property. Valid properties are (string, int).',
    );
  });
}
