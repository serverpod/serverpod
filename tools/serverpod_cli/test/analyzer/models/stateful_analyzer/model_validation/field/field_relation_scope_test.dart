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
        class: Post
        table: post
        fields:
          title: String
        ''',
      )
      .withFileName('post_class')
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
                class: Comment
                table: comment
                fields:
                  post: Post?, relation, scope=serverOnly
                ''',
              )
              .withFileName('comment_class')
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
      'when analyzed then no errors are generated for a manual field relation',
      () {
        var models = [
          parentClassModel,
          ModelSourceBuilder()
              .withYaml(
                '''
                class: Comment
                table: comment
                fields:
                  postId: int,
                  post: Post?, relation(field=postId), scope=serverOnly
                ''',
              )
              .withFileName('comment_class')
              .build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(config, models, onErrorsCollector(collector))
            .validateAll();

        expect(collector.errors, isEmpty);
      },
    );
  });

  test(
    'Given a class with an optional relation and "serverOnly" scope '
    'when analyzed then no errors are generated for an object relation',
    () {
      var models = [
        parentClassModel,
        ModelSourceBuilder()
            .withYaml(
              '''
                class: Comment
                table: comment
                fields:
                  post: Post?, relation(optional), scope=serverOnly
                ''',
            )
            .withFileName('comment_class')
            .build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(config, models, onErrorsCollector(collector))
          .validateAll();

      expect(collector.errors, isEmpty);
    },
  );
}
