import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group('Given an exception with fields with a "default" keyword', () {
    test(
      'when the field is of type String and the default is set to "Default error message", then the field should have a "default model" value',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          exception: DefaultException
          fields:
            defaultMessage: String, default='Default error message'
          ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        var definitions =
            StatefulAnalyzer(config, models, onErrorsCollector(collector))
                .validateAll();

        expect(collector.errors, isEmpty);

        var definition = definitions.first as ClassDefinition;
        expect(
          definition.fields.last.defaultModelValue,
          '\'Default error message\'',
        );
      },
    );

    test(
      'when the field is of type String and the defaultModel is set to "Default model error message", then the field should have a "default model" value',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          exception: DefaultException
          fields:
            defaultModelMessage: String, defaultModel='Default model error message'
          ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        var definitions =
            StatefulAnalyzer(config, models, onErrorsCollector(collector))
                .validateAll();

        expect(collector.errors, isEmpty);

        var definition = definitions.first as ClassDefinition;
        expect(
          definition.fields.last.defaultModelValue,
          '\'Default model error message\'',
        );
      },
    );

    test(
      'when the field is of type String and the default is empty, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          exception: DefaultException
          fields:
            defaultMessage: String, default=
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
          'The "default" must be a quoted string (e.g., "default"=\'This is a string\' or "default"="This is a string").',
        );
      },
    );

    test(
      'when the field is of type String and the defaultPersist is set, then an error is generated indicating that defaultPersist is not supported for exceptions',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          exception: DefaultException
          fields:
            defaultMessage: String, defaultPersist='This should fail'
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
          'The "defaultPersist" property is not allowed for defaultMessage type. Valid keys are {type, default, defaultModel}.',
        );
      },
    );
  });
}
