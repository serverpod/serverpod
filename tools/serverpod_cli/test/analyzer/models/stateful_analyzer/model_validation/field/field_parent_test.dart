import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();
  test(
    'Given a class with a field with a parent, then a error is generated.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            parentId: int, parent=example
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
        'The "parent" property is deprecated. Use the relation keyword instead. E.g. relation(parent=parent_table). Note that the default onDelete action changes from "Cascade" to "NoAction" when using the relation keyword.',
      );
    },
  );
}
