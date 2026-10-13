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
      'when the field is of an unsupported type ByteData with a default value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            byteDataType: ByteData, default=test
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
          'The "default" key is not supported for "ByteData" types',
        );
      },
    );

    test(
      'when the field is of an unsupported type Map with a default value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            mapType: Map<String, int>, default=test
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
          'The "default" key is not supported for "Map" types',
        );
      },
    );

    test(
      'when the field is of an unsupported type List with a default value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            listType: List<int>, default=test
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
          'The "default" key is not supported for "List" types',
        );
      },
    );

    test(
      'when the field is of an unsupported type Example with a default value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            classType: Example, default=test
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
          'The "default" key is not supported for "Example" types',
        );
      },
    );

    test(
      'when the field is of an inline "package:" custom type with a default value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          fields:
            customType: package:my_pkg/src/my_class.dart:MyClass, default=test
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
          'The "default" key is not supported for "MyClass" types',
        );
      },
    );

    test(
      'when the field is of an inline "project:" custom type with a default value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          fields:
            customType: project:src/my_class.dart:MyClass, default=test
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
          'The "default" key is not supported for "MyClass" types',
        );
      },
    );

    test(
      'when the field is of a bare "package:" custom type without a path with a default value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          fields:
            customType: package:MyClass, default=test
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
          'The "default" key is not supported for "MyClass" types',
        );
      },
    );

    test(
      'when the field is of a bare "project:" custom type without a path with a default value, then an error is generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          fields:
            customType: project:MyClass, default=test
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
          'The "default" key is not supported for "MyClass" types',
        );
      },
    );
  });
}
