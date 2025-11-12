import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group('Given a class with fields with a "default" keyword', () {
    test(
      'when the field is of type bool and the default is set to "true", then the field should have a "default model" and "default persist" value',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            boolType: bool, default=true
          ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        var definitions = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isEmpty);

        var definition = definitions.first as ClassDefinition;
        expect(definition.fields.last.defaultModelValue, 'true');
        expect(definition.fields.last.defaultPersistValue, 'true');
      },
    );

    test(
      'when the field is of type bool and the default is set to "false", then the field should have a "default model" and "default persist" value',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            boolType: bool, default=false
          ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        var definitions = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isEmpty);

        var definition = definitions.first as ClassDefinition;

        expect(definition.fields.last.defaultModelValue, 'false');
        expect(definition.fields.last.defaultPersistValue, 'false');
      },
    );

    test(
      'when the field is of type bool and the default is empty, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            boolType: bool, default=
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

        var firstError = collector.errors.first as SourceSpanSeverityException;
        expect(
          firstError.message,
          'The "default" value must be a valid boolean: "true" or "false"',
        );
      },
    );

    test(
      'when the field is of type bool with an invalid default value "TRUE", then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
        class: Example
        table: example
        fields:
          boolInvalid: bool?, default=TRUE
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

        var firstError = collector.errors.first as SourceSpanSeverityException;
        expect(
          firstError.message,
          'The "default" value must be a valid boolean: "true" or "false"',
        );
      },
    );

    test(
      'when the field is of type bool with an invalid default value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            boolInvalid: bool?, default=test
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

        var firstError = collector.errors.first as SourceSpanSeverityException;
        expect(
          firstError.message,
          'The "default" value must be a valid boolean: "true" or "false"',
        );
      },
    );
  });
}
