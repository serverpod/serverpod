import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group('Given a class with fields with a "default" keyword', () {
    test(
      'when the field is of type String and the default is set to "This is a default value", then the field should have a "default model" and "default persist" value',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            stringType: String, default='This is a default value'
          ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        var definitions =
            StatefulAnalyzer(config, models, onErrorsCollector(collector))
                .validateAll();

        expect(collector.errors, isEmpty);

        var definition = definitions.first as ClassDefinition;
        expect(definition.fields.last.defaultModelValue,
            '\'This is a default value\'');
        expect(definition.fields.last.defaultPersistValue,
            '\'This is a default value\'');
      },
    );

    test(
      'when the field is of type String and the default is set to "This is a default null value", then the field should have a "default model" and "default persist" value',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            stringType: String?, default='This is a default null value'
          ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        var definitions =
            StatefulAnalyzer(config, models, onErrorsCollector(collector))
                .validateAll();

        expect(collector.errors, isEmpty);

        var definition = definitions.first as ClassDefinition;

        expect(definition.fields.last.defaultModelValue,
            '\'This is a default null value\'');
        expect(definition.fields.last.defaultPersistValue,
            '\'This is a default null value\'');
      },
    );

    test(
      'when the field is of type String with an invalid default value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
        class: Example
        table: example
        fields:
          stringInvalid: String?, default=10
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
          'The "default" value must be a properly quoted string.',
        );
      },
    );

    test(
      'when the field is of type String with an invalid default value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
        class: Example
        table: example
        fields:
          stringInvalid: String?, default=test
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
          'The "default" value must be a properly quoted string.',
        );
      },
    );

    test(
      'when the field is of type String with an invalid default value containing unescaped single quotes, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
        class: Example
        table: example
        fields:
          stringInvalid: String?, default='This 'is' a test'
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
          'The "default" value must be a properly quoted string.',
        );
      },
    );

    test(
      'when the field is of type String with an invalid default value containing unescaped double quotes, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
        class: Example
        table: example
        fields:
          stringInvalid: String?, default="This "is" a test"
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
          'The "default" value must be a properly quoted string.',
        );
      },
    );

    test(
      'when the field is of type String and the default is set to \'This \\\'is\\\' a default value\', then the field should have a "default model" and "default persist" value',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            stringType: String, default='This \\'is\\' a default value'
          ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        var definitions =
            StatefulAnalyzer(config, models, onErrorsCollector(collector))
                .validateAll();

        expect(collector.errors, isEmpty);

        var definition = definitions.first as ClassDefinition;
        expect(definition.fields.last.defaultModelValue,
            '\'This \\\'is\\\' a default value\'');
        expect(definition.fields.last.defaultPersistValue,
            '\'This \\\'is\\\' a default value\'');
      },
    );

    test(
      'when the field is of type String and the default is set to "This \\"is\\" a default value", then the field should have a "default model" and "default persist" value',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            stringType: String, default="This \\"is\\" a default value"
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
          '"This \\"is\\" a default value"',
        );
        expect(
          definition.fields.last.defaultPersistValue,
          '"This \\"is\\" a default value"',
        );
      },
    );

    test(
      'when the field is of type String and the default is set to "This, is a default value", then the field should have a "default model" and "default persist" value',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            stringType: String, default='This, is a default value'
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
          '\'This, is a default value\'',
        );
        expect(
          definition.fields.last.defaultPersistValue,
          '\'This, is a default value\'',
        );
      },
    );

    test(
      'when the field is of type String and the default is set to "This \\"is\\", a default value", then the field should have a "default model" and "default persist" value',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            stringType: String, default="This \\"is\\", a default value"
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
          '"This \\"is\\", a default value"',
        );
        expect(
          definition.fields.last.defaultPersistValue,
          '"This \\"is\\", a default value"',
        );
      },
    );
  });
}
