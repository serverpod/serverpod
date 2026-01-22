import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  test('Check error span for missing fields in index - empty value', () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
class: Example
table: example
fields:
  name: String
indexes:
  example_index:
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    var analyzer = StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    );
    analyzer.validateAll();

    expect(collector.errors, isNotEmpty);
    var error = collector.errors.first;
    
    print('=== Test 1: Empty value ===');
    print('Error message: ${error.message}');
    print('Error span: ${error.span}');
    print('Span text: "${error.span?.text}"');
    print('Span start line: ${error.span?.start.line}');
    print('Span start column: ${error.span?.start.column}');
    print('Span end line: ${error.span?.end.line}');
    print('Span end column: ${error.span?.end.column}');
  });

  test('Check error span for missing fields in index - null value', () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
class: Example
table: example
fields:
  name: String
indexes:
  example_index: null
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    var analyzer = StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    );
    analyzer.validateAll();

    expect(collector.errors, isNotEmpty);
    var error = collector.errors.first;
    
    print('=== Test 2: Null value ===');
    print('Error message: ${error.message}');
    print('Error span: ${error.span}');
    print('Span text: "${error.span?.text}"');
    print('Span start line: ${error.span?.start.line}');
    print('Span start column: ${error.span?.start.column}');
    print('Span end line: ${error.span?.end.line}');
    print('Span end column: ${error.span?.end.column}');
  });

  test('Check error span for missing fields in index - empty map', () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
class: Example
table: example
fields:
  name: String
indexes:
  example_index: {}
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    var analyzer = StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    );
    analyzer.validateAll();

    expect(collector.errors, isNotEmpty);
    var error = collector.errors.first;
    
    print('=== Test 3: Empty map ===');
    print('Error message: ${error.message}');
    print('Error span: ${error.span}');
    print('Span text: "${error.span?.text}"');
    print('Span start line: ${error.span?.start.line}');
    print('Span start column: ${error.span?.start.column}');
    print('Span end line: ${error.span?.end.line}');
    print('Span end column: ${error.span?.end.column}');
  });
}
