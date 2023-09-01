import 'package:serverpod_cli/src/analyzer/entities/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/protocol_source_builder.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given two protocols with the same class name, then an error is collected that there is a collision in the class names.',
      () {
    var protocols = [
      ProtocolSourceBuilder().withYaml(
        '''
        class: Example
        fields:
          name: String
        ''',
      ).build(),
      ProtocolSourceBuilder().withFileName('example2').withYaml(
        '''
        class: Example
        fields:
          differentName: String
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer(protocols, onErrorsCollector(collector)).validateAll();

    expect(
      collector.errors,
      isNotEmpty,
      reason: 'Expected an error but none was generated.',
    );

    var error = collector.errors.first;
    expect(
      error.message,
      'The class name "Example" is already used by another protocol class.',
    );
  });

  test(
      'Given a single valid protocol, then there is no error collected for the class name.',
      () {
    var protocols = [
      ProtocolSourceBuilder().withYaml(
        '''
        class: Example
        fields:
          name: String
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer(protocols, onErrorsCollector(collector)).validateAll();

    expect(
      collector.errors,
      isEmpty,
      reason: 'Expected no errors but some were generated.',
    );
  });
}
