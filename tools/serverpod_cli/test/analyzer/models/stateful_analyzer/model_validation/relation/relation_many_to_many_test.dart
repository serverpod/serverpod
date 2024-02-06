import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  test(
      'Given a class with an implicit many to many relation then an error is collected that it is not supported.',
      () {
    var models = [
      ModelSourceBuilder().withFileName('post').withYaml(
        '''
        class: Post
        table: post
        fields:
          title: String
          categories: List<Category>?, relation(name=post_category)
        ''',
      ).build(),
      ModelSourceBuilder().withFileName('category').withYaml(
        '''
        class: Category
        table: category
        fields:
          name: String
          posts: List<Post>?, relation(name=post_category)
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    );
    analyzer.validateAll();
    var errors = collector.errors;

    expect(errors, isNotEmpty);
    expect(
      errors.first.message,
      contains('A named relation to another list field is not supported.'),
    );
  });
}
