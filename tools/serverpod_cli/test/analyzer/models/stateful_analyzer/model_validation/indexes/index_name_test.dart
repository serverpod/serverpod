import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given a class with an index key that is not a string, then collect an error that the index name has to be defined as a string.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          name: String
        indexes:
          1:
            fields: name
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer = StatefulAnalyzer(models, onErrorsCollector(collector));
    analyzer.validateAll();

    expect(
      collector.errors,
      isNotEmpty,
      reason: 'Expected an error but none was generated.',
    );

    var error = collector.errors.first;
    expect(
      error.message,
      'Key must be of type String.',
    );
  });

  test(
    'Given a class with an index key that is not a string in snake_case_format, then collect an error that the index name is using an invalid format.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            name: String
          indexes:
            PascalCaseIndex:
              fields: name
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(models, onErrorsCollector(collector));
      analyzer.validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(
        error.message,
        'Invalid format for index "PascalCaseIndex", must follow the format lower_snake_case.',
      );
    },
  );

  group('Index relationships.', () {
    test(
        'Given two classes with the same index name defined, then collect an error notifying that the index name is already in use.',
        () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            name: String
          indexes:
            example_index:
              fields: name
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('example_collision').withYaml(
          '''
          class: ExampleCollision
          table: example_collision
          fields:
            name: String
          indexes:
            example_index:
              fields: name
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(models, onErrorsCollector(collector));
      analyzer.validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(
        error.message,
        'The index name "example_index" is already used by the model class "ExampleCollision".',
      );
    });
  });
}
