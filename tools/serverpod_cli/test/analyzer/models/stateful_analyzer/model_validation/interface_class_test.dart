import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group('Interface Class Tests', () {
    test(
        'Given an interface class with an invalid class name, when analyzed, then an error is collected that the name is not valid',
        () {
      var modelSources = [
        ModelSourceBuilder().withFileName('example1').withYaml(
          '''
          interface: example
          fields:
            name: String
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(config, modelSources, onErrorsCollector(collector))
          .validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(
        error.message,
        'The "interface" type must be a valid class name (e.g. PascalCaseString).',
      );
    });

    test(
        'Given an interface class with a reserved keyword name, when analyzed, then an error is collected that the class name is reserved',
        () {
      var modelSources = [
        ModelSourceBuilder().withFileName('example1').withYaml(
          '''
          interface: List
          fields:
            name: String
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(config, modelSources, onErrorsCollector(collector))
          .validateAll();

      var error = collector.errors.first;
      expect(
        error.message,
        'The class name "List" is reserved and cannot be used.',
      );
    });
  });
}
