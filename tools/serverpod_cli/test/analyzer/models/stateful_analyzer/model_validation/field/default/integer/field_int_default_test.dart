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
      'when the field is of type int and the default is set to "10", then the field should have a "default model" and "default persist" value',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            intType: int, default=10
          ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        var definitions =
            StatefulAnalyzer(config, models, onErrorsCollector(collector))
                .validateAll();

        expect(collector.errors, isEmpty);

        var definition = definitions.first as ClassDefinition;
        expect(definition.fields.last.defaultModelValue, '10');
        expect(definition.fields.last.defaultPersistValue, '10');
      },
    );

    test(
      'when the field is of type int and the default is set to "20", then the field should have a "default model" and "default persist" value',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            intType: int, default=20
          ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        var definitions =
            StatefulAnalyzer(config, models, onErrorsCollector(collector))
                .validateAll();

        expect(collector.errors, isEmpty);

        var definition = definitions.first as ClassDefinition;

        expect(definition.fields.last.defaultModelValue, '20');
        expect(definition.fields.last.defaultPersistValue, '20');
      },
    );

    test(
      'when the field is of type int and the default is empty, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            intType: int, default=
          ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(config, models, onErrorsCollector(collector))
            .validateAll();

        expect(collector.errors, isNotEmpty);

        var firstError = collector.errors.first as SourceSpanSeverityException;
        expect(
          firstError.message,
          'The "default" value must be a valid integer (e.g., "default"=10).',
        );
      },
    );

    test(
      'when the field is of type int with an invalid default value "TEN", then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
        class: Example
        table: example
        fields:
          intInvalid: int?, default=TEN
        ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(config, models, onErrorsCollector(collector))
            .validateAll();

        expect(collector.errors, isNotEmpty);

        var firstError = collector.errors.first as SourceSpanSeverityException;
        expect(
          firstError.message,
          'The "default" value must be a valid integer (e.g., "default"=10).',
        );
      },
    );

    test(
      'when the field is of type int with an invalid default value containing decimals, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
        class: Example
        table: example
        fields:
          intInvalid: int?, default=10.5
        ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(config, models, onErrorsCollector(collector))
            .validateAll();

        expect(collector.errors, isNotEmpty);

        var firstError = collector.errors.first as SourceSpanSeverityException;
        expect(
          firstError.message,
          'The "default" value must be a valid integer (e.g., "default"=10).',
        );
      },
    );

    test(
      'when the field is of type int with an invalid default value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            intInvalid: int?, default=test
          ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(config, models, onErrorsCollector(collector))
            .validateAll();

        expect(collector.errors, isNotEmpty);

        var firstError = collector.errors.first as SourceSpanSeverityException;
        expect(
          firstError.message,
          'The "default" value must be a valid integer (e.g., "default"=10).',
        );
      },
    );
  });

  test(
    'Given a class with a declared id field of type int with a "default" keyword, then an error is collected.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            id: int?, default=serial
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(config, models, onErrorsCollector(collector))
          .validateAll();

      expect(
        collector.errors.first.message,
        'The "default" key is not allowed on the "id" field. Either omit the '
        'default key or use the "defaultPersist" key instead.',
      );
    },
  );
}
