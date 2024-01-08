import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given a class with an index without any fields, then collect an error that at least one field has to be added.',
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
              fields:
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
        'The "fields" property must have at least one field, (e.g. fields: fieldName).',
      );
    },
  );

  test(
    'Given a class with an index with a field that does not exist, then collect an error that the field is missing in the class.',
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
              fields: missingField
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
        'The field name "missingField" is not added to the class or has an api scope.',
      );
    },
  );

  test(
    'Given a class with an index with two duplicated fields, then collect an error that duplicated fields are not allowed.',
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
              fields: name, name
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
        'Duplicated field name "name", can only reference a field once per index.',
      );
    },
  );

  test(
    'Given a class with an index with a field that has an api scope, then collect an error that the field is missing in the class.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            name: String
            apiField: String, api
          indexes:
            example_index:
              fields: apiField
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

      var error = collector.errors.last;
      expect(
        error.message,
        'The field name "apiField" is not added to the class or has an api scope.',
      );
    },
  );

  test(
    'Given a class with an index with two fields where the second is null, then collect an error that the field must be defined.',
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
              fields: name,
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
        'The field name "" is not added to the class or has an api scope.',
      );
    },
  );
}
