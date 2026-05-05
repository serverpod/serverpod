import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  test(
    'Given a class with a table level database keyword '
    'when validating '
    'then no error is generated.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          database: client
          fields:
            name: String
          ''',
        ).build(),
      ];
      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, isEmpty);
    },
  );

  test(
    'Given a class without a table and a database keyword '
    'when validating '
    'then an error is generated.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          database: client
          fields:
            name: String
          ''',
        ).build(),
      ];
      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first as SourceSpanSeverityException;
      expect(error.severity, SourceSpanSeverity.error);
      expect(
        error.message,
        'The "database" property can only be used on classes with a "table" property.',
      );
    },
  );
}
