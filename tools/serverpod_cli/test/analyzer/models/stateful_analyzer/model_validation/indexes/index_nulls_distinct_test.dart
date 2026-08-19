import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  test(
    'Given a unique index without a nulls_distinct property, '
    'when the model is analyzed, '
    'then the index uses the database default null handling.',
    () {
      var model = ModelSourceBuilder().withYaml(
        '''
class: Example
table: example
fields:
  name: String?
indexes:
  example_index:
    fields: name
    unique: true
''',
      ).build();
      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(
        config,
        [model],
        onErrorsCollector(collector),
      );

      var definitions = analyzer.validateAll();
      var definition = definitions.single as ModelClassDefinition;

      expect(collector.errors, isEmpty);
      expect(definition.indexes.single.nullsDistinct, isNull);
    },
  );

  test(
    'Given a unique index with nulls_distinct set to true, '
    'when the model is analyzed, '
    'then the index preserves the configured null handling.',
    () {
      var model = ModelSourceBuilder().withYaml(
        '''
class: Example
table: example
fields:
  name: String?
indexes:
  example_index:
    fields: name
    unique: true
    nulls_distinct: true
''',
      ).build();
      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(
        config,
        [model],
        onErrorsCollector(collector),
      );

      var definitions = analyzer.validateAll();
      var definition = definitions.single as ModelClassDefinition;

      expect(collector.errors, isEmpty);
      expect(definition.indexes.single.nullsDistinct, true);
    },
  );

  test(
    'Given a unique index with nulls_distinct set to false, '
    'when the model is analyzed, '
    'then the index preserves the configured null handling.',
    () {
      var model = ModelSourceBuilder().withYaml(
        '''
class: Example
table: example
fields:
  name: String?
indexes:
  example_index:
    fields: name
    unique: true
    nulls_distinct: false
''',
      ).build();
      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(
        config,
        [model],
        onErrorsCollector(collector),
      );

      var definitions = analyzer.validateAll();
      var definition = definitions.single as ModelClassDefinition;

      expect(collector.errors, isEmpty);
      expect(definition.indexes.single.nullsDistinct, false);
    },
  );

  test(
    'Given an index with a non-boolean nulls_distinct property, '
    'when the model is analyzed, '
    'then a boolean validation error is reported.',
    () {
      var model = ModelSourceBuilder().withYaml(
        '''
class: Example
table: example
fields:
  name: String?
indexes:
  example_index:
    fields: name
    unique: true
    nulls_distinct: invalid
''',
      ).build();
      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(
        config,
        [model],
        onErrorsCollector(collector),
      );

      analyzer.validateAll();

      expect(
        collector.errors.map((error) => error.message),
        contains('The value must be a boolean.'),
      );
    },
  );

  test(
    'Given a non-unique index with a nulls_distinct property, '
    'when the model is analyzed, '
    'then an error requiring a unique index is reported.',
    () {
      var model = ModelSourceBuilder().withYaml(
        '''
class: Example
table: example
fields:
  name: String?
indexes:
  example_index:
    fields: name
    nulls_distinct: false
''',
      ).build();
      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(
        config,
        [model],
        onErrorsCollector(collector),
      );

      analyzer.validateAll();

      expect(
        collector.errors.map((error) => error.message),
        contains(
          'The "nulls_distinct" property can only be used with unique indexes.',
        ),
      );
    },
  );
}
