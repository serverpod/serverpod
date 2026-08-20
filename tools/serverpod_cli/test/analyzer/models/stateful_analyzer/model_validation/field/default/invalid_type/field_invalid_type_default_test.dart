import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group('Given a class with a field of an invalid type with a "default" keyword', () {
    test(
      'when the type is an unknown primitive-like name, then only the invalid datatype error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          fields:
            intType: Int, default=1
          ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, hasLength(1));

        var error = collector.errors.first as SourceSpanSeverityException;
        expect(
          error.message,
          'The field has an invalid datatype "Int".',
        );
      },
    );

    test(
      'when the type is an unknown class name, then only the invalid datatype error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          fields:
            classType: UnknownClass, default=test
          ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, hasLength(1));

        var error = collector.errors.first as SourceSpanSeverityException;
        expect(
          error.message,
          'The field has an invalid datatype "UnknownClass".',
        );
      },
    );

    test(
      'when the field is defined with the expanded yaml syntax, then only the invalid datatype error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          fields:
            intType:
              type: Int
              default: 1
          ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, hasLength(1));

        var error = collector.errors.first as SourceSpanSeverityException;
        expect(
          error.message,
          'The field has an invalid datatype "Int".',
        );
      },
    );

    test(
      'when the model is an exception, then only the invalid datatype error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          exception: ExampleException
          fields:
            intType: Int, default=1
          ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, hasLength(1));

        var error = collector.errors.first as SourceSpanSeverityException;
        expect(
          error.message,
          'The field has an invalid datatype "Int".',
        );
      },
    );

    test(
      'when the type references a module that is not found, then only the module not found error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          fields:
            moduleType: module:missing:SomeType, default=test
          ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, hasLength(1));

        var error = collector.errors.first as SourceSpanSeverityException;
        expect(
          error.message,
          'The referenced module "missing" is not found.',
        );
      },
    );

    test(
      'when an invalid type is used on the id field, then the error that the "default" key is not allowed on the id field is still generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            id: UnknownType, default=test
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

        var errorMessages = collector.errors
            .map((error) => (error as SourceSpanSeverityException).message)
            .toList();

        expect(
          errorMessages,
          contains(
            'The "default" key is not allowed on the "id" field. Use either '
            'the "defaultModel" key or the "defaultPersist" key instead.',
          ),
        );
        expect(
          errorMessages,
          isNot(
            contains(
              'The "default" key is not supported for "UnknownType" types',
            ),
          ),
        );
      },
    );
  });
}
