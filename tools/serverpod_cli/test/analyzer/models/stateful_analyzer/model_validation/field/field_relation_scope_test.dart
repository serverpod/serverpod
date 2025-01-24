import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  var parentClassModel = ModelSourceBuilder()
      .withYaml(
        '''
        class: ParentClass
        table: parent
        fields:
          name: String
        ''',
      )
      .withFileName('parent_class')
      .build();

  group('Given a class with a non-optional relation and "serverOnly" scope',
      () {
    test(
      'when analyzed then an error is generated for an object relation',
      () {
        var models = [
          parentClassModel,
          ModelSourceBuilder()
              .withYaml(
                '''
                class: Example
                table: example
                fields:
                  parentClass: ParentClass?, relation, scope=serverOnly
                ''',
              )
              .withFileName('example_class')
              .build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(config, models, onErrorsCollector(collector))
            .validateAll();

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first as SourceSpanSeverityException;
        expect(error.severity, SourceSpanSeverity.error);
        expect(
          error.message,
          'The relation with scope "serverOnly" requires the relation to be optional.',
        );
      },
    );

    test(
      'when analyzed then an error is generated for a foreign key relation',
      () {
        var models = [
          parentClassModel,
          ModelSourceBuilder()
              .withYaml(
                '''
                class: Example
                table: example
                fields:
                  relationId: int
                  parentClass: ParentClass?, relation(field=relationId), scope=serverOnly
                ''',
              )
              .withFileName('example_class')
              .build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(config, models, onErrorsCollector(collector))
            .validateAll();

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first as SourceSpanSeverityException;
        expect(error.severity, SourceSpanSeverity.error);
        expect(
          error.message,
          'The relation with scope "serverOnly" requires the relation to be optional.',
        );
      },
    );
  });

  group('Given a class with an optional relation and "serverOnly" scope', () {
    test(
      'when analyzed then no errors are generated for an object relation',
      () {
        var models = [
          parentClassModel,
          ModelSourceBuilder()
              .withYaml(
                '''
                class: Example
                table: example
                fields:
                  parentClass: ParentClass?, relation(optional), scope=serverOnly
                ''',
              )
              .withFileName('example_class')
              .build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(config, models, onErrorsCollector(collector))
            .validateAll();

        expect(collector.errors, isEmpty);
      },
    );

    test(
      'when analyzed then no errors are generated for a foreign key relation',
      () {
        var models = [
          parentClassModel,
          ModelSourceBuilder()
              .withYaml(
                '''
                class: Example
                table: example
                fields:
                  relationId: int
                  parentClass: ParentClass?, relation(optional, field=relationId), scope=serverOnly
                ''',
              )
              .withFileName('example_class')
              .build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(config, models, onErrorsCollector(collector))
            .validateAll();

        expect(collector.errors, isEmpty);
      },
    );
  });
}
