import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../../../test_util/builders/model_source_builder.dart';

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
          definition.fields.last.defaultModelValue,
          '\'Default error message\'',
        );
      },
    );

    test(
      'when the field is of type Enum serialized by string, then the field should have a "default model" value',
      () {
        var models = [
          ModelSourceBuilder().withFileName('by_name_enum').withYaml(
            '''
          enum: ByNameEnum
          serialized: byName
          values:
            - byName1
            - byName2
          ''',
          ).build(),
          ModelSourceBuilder().withYaml(
            '''
          exception: DefaultException
          fields:
            defaultEnum: ByNameEnum, default=byName1
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

        var definition = definitions.last as ClassDefinition;
        expect(
          definition.fields.last.defaultModelValue,
          'byName1',
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
          'The "default" must be a quoted string (e.g., "default"=\'This is a string\' or "default"="This is a string").',
        );
      },
    );

    test(
      'when the field is of type bool and the default is set to true, then the field should have a "default model" value',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          exception: DefaultException
          fields:
            defaultBoolean: bool, default=true
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
          definition.fields.last.defaultModelValue,
          'true',
        );
      },
    );

    test(
      'when the field is of type bool and an invalid default is set, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          exception: DefaultException
          fields:
            defaultBoolean: bool, default=invalidBool
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
      'when the field is of type int and the default is set to 10, then the field should have a "default model" value',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          exception: DefaultException
          fields:
            defaultInteger: int, default=10
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
          definition.fields.last.defaultModelValue,
          '10',
        );
      },
    );

    test(
      'when the field is of type int and an invalid default is set, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          exception: DefaultException
          fields:
            defaultInteger: int, default=invalidInt
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
          'The "default" value must be a valid integer (e.g., "default"=10).',
        );
      },
    );

    test(
      'when the field is of type double and the default is set to 20.5, then the field should have a "default model" value',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          exception: DefaultException
          fields:
            defaultDouble: double, default=20.5
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
          definition.fields.last.defaultModelValue,
          '20.5',
        );
      },
    );

    test(
      'when the field is of type double and an invalid default is set, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          exception: DefaultException
          fields:
            defaultDouble: double, default=invalidDouble
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
          'The "default" value must be a valid double (e.g., "default"=10.5).',
        );
      },
    );

    test(
      'when the field is of type UuidValue and the default is set to a specific UUID, then the field should have a "default model" value',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          exception: DefaultException
          fields:
            defaultUuid: UuidValue, default='550e8400-e29b-41d4-a716-446655440000'
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
          definition.fields.last.defaultModelValue,
          '\'550e8400-e29b-41d4-a716-446655440000\'',
        );
      },
    );

    test(
      'when the field is of type UuidValue and an invalid UUID is set as default, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          exception: DefaultException
          fields:
            defaultUuid: UuidValue, default='invalid-uuid'
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
          'The "default" value must be a valid UUID (e.g., \'550e8400-e29b-41d4-a716-446655440000\').',
        );
      },
    );

    test(
      'when the field is of type Duration and the default is set to "1d 2h 30min", then the field should have a "default model" value',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          exception: DefaultException
          fields:
            defaultDuration: Duration, default=1d 2h 30min
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
          definition.fields.last.defaultModelValue,
          '1d 2h 30min',
        );
      },
    );

    test(
      'when the field is of type Duration and an invalid duration is set as default, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          exception: DefaultException
          fields:
            defaultDuration: Duration, default='invalid-duration'
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
          'The "default" value must be a valid duration in the format "Xd Xh Xmin Xs Xms" (e.g., "default"=1d 2h 30min 45s 100ms).',
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
          'The "defaultPersist" property is not allowed for defaultMessage type. Valid keys are {type, required, default, defaultModel}.',
        );
      },
    );
  });
}
