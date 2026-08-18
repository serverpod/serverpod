import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group('Given a class with fields with a "defaultPersist" keyword', () {
    test(
      'when the field is of type Uri and the defaultPersist is set to a Uri string in single quotes, then the field should have a "default persist" value and not have a "default model" value',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            uriType: Uri?, defaultPersist='https://example.com'
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
        expect(
          definition.fields.last.defaultPersistValue,
          '\'https://example.com\'',
        );
        expect(definition.fields.last.defaultModelValue, isNull);
      },
    );

    test(
      'when the field is of type Uri and the defaultPersist is set to a Uri string in double quotes, then the field should have a "default persist" value converted to single quotes',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            uriType: Uri?, defaultPersist="https://example.com"
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
        expect(
          definition.fields.last.defaultPersistValue,
          '\'https://example.com\'',
        );
      },
    );

    test(
      'when the field is of type Uri with a defaultPersist value without quotes, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            uriType: Uri?, defaultPersist=https://example.com
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
          'The "defaultPersist" value must be a a valid Uri string (e.g., "defaultPersist"=\'http://serverpod.dev\').',
        );
      },
    );

    test(
      'when the field is of type Uri and the defaultPersist is empty, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            uriType: Uri?, defaultPersist=
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
          'The "defaultPersist" value must be a a valid Uri string (e.g., "defaultPersist"=\'http://serverpod.dev\').',
        );
      },
    );

    test(
      'when the field is of type Uri with an invalid defaultPersist value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            uriInvalid: Uri?, defaultPersist="http://[invalid"
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
          'The "defaultPersist" value must be a valid Uri (e.g., \'http://serverpod.dev\').',
        );
      },
    );

    test(
      'when the field is of type Uri non-nullable type, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            uriType: Uri, defaultPersist="https://example.com"
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
        expect(
          error.message,
          'When setting only the "defaultPersist" key, its type should be nullable',
        );
      },
    );

    test(
      'when the field has the "!persist" keyword, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            uriType: Uri?, defaultPersist="https://example.com", !persist
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
        expect(
          error.message,
          'The "defaultPersist" property is mutually exclusive with the "!persist" property.',
        );
      },
    );
  });
}
