import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given a class with the index property defined but without any index, then collect an error that at least one index has to be added.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            name: String
          indexes:
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
        'The "indexes" property must have at least one value.',
      );
    },
  );

  test(
    'Given a class with an index that does not define the fields keyword, then collect an error that fields are required.',
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
        'The "example_index" property is missing required keys (fields).',
      );
    },
  );

  test(
    'Given a class with an index with a defined field, then the definition contains the index.',
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
        ).build()
      ];

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(models, onErrorsCollector(collector));
      var definitions = analyzer.validateAll();
      var definition = definitions.first as ClassDefinition;

      var index = definition.indexes.first;
      expect(index.name, 'example_index');
    },
  );

  group(
    'Given a class with an index with a defined field',
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
        ).build()
      ];

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(models, onErrorsCollector(collector));
      var definitions = analyzer.validateAll();

      var errors = collector.errors;
      test('then no errors are collected.', () {
        expect(errors, isEmpty);
      });

      var definition = definitions.firstOrNull as ClassDefinition?;
      test('then the index definition contains the fields of the index.', () {
        var index = definition?.indexes.first;
        var field = index?.fields.first;
        expect(field, 'name');
      }, skip: errors.isNotEmpty);

      test('then the field definition contains index.', () {
        var field =
            definition?.fields.firstWhere((field) => field.name == 'name');
        var index = field?.indexes.firstOrNull;

        expect(index?.name, 'example_index');
      }, skip: errors.isNotEmpty);
    },
  );

  group(
    'Given a class with an index with two defined fields',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            name: String
            foo: String
          indexes:
            example_index:
              fields: name, foo
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(models, onErrorsCollector(collector));
      var definitions = analyzer.validateAll();

      var errors = collector.errors;
      test('then no errors are collected.', () {
        expect(errors, isEmpty);
      });

      var definition = definitions.firstOrNull as ClassDefinition?;
      test('then index definition contains the first field.', () {
        var index = definition?.indexes.first;
        var indexFields = index?.fields;

        expect(indexFields, contains('name'));
      });

      test('then index definition contains the second field.', () {
        var index = definition?.indexes.first;
        var indexFields = index?.fields;

        expect(indexFields, contains('foo'));
      });

      test('then first field definition contains index.', () {
        var field =
            definition?.fields.firstWhere((field) => field.name == 'name');
        var index = field?.indexes.firstOrNull;

        expect(index?.name, 'example_index');
      });

      test('then second field definition contains index.', () {
        var field =
            definition?.fields.firstWhere((field) => field.name == 'foo');
        var index = field?.indexes.firstOrNull;

        expect(index?.name, 'example_index');
      });
    },
  );

  test(
    'Given a class with two indexes, then the definition contains both the index names.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            name: String
            foo: String
          indexes:
            example_index:
              fields: name
            example_index2:
              fields: foo
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(models, onErrorsCollector(collector));
      var definitions = analyzer.validateAll();
      var definition = definitions.first as ClassDefinition;

      var index1 = definition.indexes.first;
      var index2 = definition.indexes.last;

      expect(index1.name, 'example_index');
      expect(index2.name, 'example_index2');
    },
  );

  test(
      'Given a class with an index with an invalid key, then collect an error indicating that the key is invalid.',
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
            invalidKey: true
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
      'The "invalidKey" property is not allowed for example_index type. Valid keys are {fields, type, unique}.',
    );
  });
}
