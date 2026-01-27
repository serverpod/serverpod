import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

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
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
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
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
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

  group(
    'Given a class with an index defined as an empty map when fields keyword is missing',
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
    type: btree''',
        ).build(),
      ];

      late var collector = CodeGenerationCollector();
      late var analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );

      setUp(() {
        analyzer.validateAll();
      });

      test('then collect an error that fields are required.', () {
        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error but none was generated.',
        );

        expect(
          collector.errors.first.message,
          'No "fields" property is defined for "example_index".',
        );
      });

      late var error = collector.errors.first;

      test('then the error span has the correct line and column.', () {
        expect(error.span, isNotNull);
        expect(error.span!.start.line, 5);
        expect(error.span!.start.column, 2);
        expect(error.span!.end.line, 5);
        expect(error.span!.end.column, 15);
      });
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
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      var definitions = analyzer.validateAll();
      var definition = definitions.first as ModelClassDefinition;

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
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      var definitions = analyzer.validateAll();

      var errors = collector.errors;
      test('then no errors are collected.', () {
        expect(errors, isEmpty);
      });

      var definition = definitions.firstOrNull as ModelClassDefinition?;
      test(
        'then the index definition contains the fields of the index.',
        () {
          var index = definition?.indexes.first;
          var field = index?.fields.first;
          expect(field, 'name');
        },
        skip: errors.isNotEmpty,
      );

      test('then the field definition contains index.', () {
        var field = definition?.fields.firstWhere(
          (field) => field.name == 'name',
        );
        var index = field?.indexes.firstOrNull;

        expect(index?.name, 'example_index');
      }, skip: errors.isNotEmpty);
    },
  );

  group(
    'Given a class with an index with a defined field '
    'that has an explicit column name',
    () {
      const columnOverride = 'example_name';
      const indexName = 'example_override_index';
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            name: String, column=$columnOverride
          indexes:
            $indexName:
              fields: name
          ''',
        ).build(),
      ];
      final columnOverrideConfig = GeneratorConfigBuilder()
          .withEnabledExperimentalFeatures([
            ExperimentalFeature.columnOverride,
          ])
          .build();

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(
        columnOverrideConfig,
        models,
        onErrorsCollector(collector),
      );
      var definitions = analyzer.validateAll();

      var errors = collector.errors;
      test('then no errors are collected.', () {
        expect(errors, isEmpty);
      });

      var definition = definitions.firstOrNull as ModelClassDefinition?;
      test(
        'then the index definition contains the explicit column name of '
        'the field of the index.',
        () {
          var index = definition?.indexes.first;
          var field = index?.fields.first;
          expect(field, columnOverride);
        },
        skip: errors.isNotEmpty,
      );

      test('then the field definition contains index.', () {
        var field = definition?.fields.firstWhere(
          (field) => field.name == 'name',
        );
        var index = field?.indexes.firstOrNull;

        expect(index?.name, indexName);
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
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      var definitions = analyzer.validateAll();

      var errors = collector.errors;
      test('then no errors are collected.', () {
        expect(errors, isEmpty);
      });

      var definition = definitions.firstOrNull as ModelClassDefinition?;
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
        var field = definition?.fields.firstWhere(
          (field) => field.name == 'name',
        );
        var index = field?.indexes.firstOrNull;

        expect(index?.name, 'example_index');
      });

      test('then second field definition contains index.', () {
        var field = definition?.fields.firstWhere(
          (field) => field.name == 'foo',
        );
        var index = field?.indexes.firstOrNull;

        expect(index?.name, 'example_index');
      });
    },
  );

  group(
    'Given a class with an index with two defined fields'
    'and both have explicit column names',
    () {
      const nameOverride = 'example_name';
      const fooOverride = 'example_foo';
      const indexName = 'example_override_index';
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            name: String, column=$nameOverride
            foo: String, column=$fooOverride
          indexes:
            $indexName:
              fields: name, foo
          ''',
        ).build(),
      ];

      final columnOverrideConfig = GeneratorConfigBuilder()
          .withEnabledExperimentalFeatures([
            ExperimentalFeature.columnOverride,
          ])
          .build();

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(
        columnOverrideConfig,
        models,
        onErrorsCollector(collector),
      );
      var definitions = analyzer.validateAll();

      var errors = collector.errors;
      test('then no errors are collected.', () {
        expect(errors, isEmpty);
      });

      var definition = definitions.firstOrNull as ModelClassDefinition?;
      test(
        'then index definition contains the first field explicit column name.',
        () {
          var index = definition?.indexes.first;
          var indexFields = index?.fields;

          expect(indexFields, contains(nameOverride));
        },
      );

      test(
        'then index definition contains the second field explicit column name.',
        () {
          var index = definition?.indexes.first;
          var indexFields = index?.fields;

          expect(indexFields, contains(fooOverride));
        },
      );

      test('then first field definition contains index.', () {
        var field = definition?.fields.firstWhere(
          (field) => field.name == 'name',
        );
        var index = field?.indexes.firstOrNull;

        expect(index?.name, indexName);
      });

      test('then second field definition contains index.', () {
        var field = definition?.fields.firstWhere(
          (field) => field.name == 'foo',
        );
        var index = field?.indexes.firstOrNull;

        expect(index?.name, indexName);
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
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      var definitions = analyzer.validateAll();
      var definition = definitions.first as ModelClassDefinition;

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
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(
        error.message,
        'The "invalidKey" property is not allowed for example_index type. Valid '
        'keys are {fields, type, unique, distanceFunction, parameters}.',
      );
    },
  );
}
