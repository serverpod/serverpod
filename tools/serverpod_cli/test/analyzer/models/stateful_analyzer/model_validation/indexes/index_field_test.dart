import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

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
      var analyzer =
          StatefulAnalyzer(config, models, onErrorsCollector(collector));
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
      var analyzer =
          StatefulAnalyzer(config, models, onErrorsCollector(collector));
      analyzer.validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(
        error.message,
        'The field name "missingField" is not added to the class or has an !persist scope.',
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
      var analyzer =
          StatefulAnalyzer(config, models, onErrorsCollector(collector));
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
    'Given a class with an index with a field that has an !persist scope, then collect an error that the field is missing in the class.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            name: String
            apiField: String, !persist
          indexes:
            example_index:
              fields: apiField
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      var analyzer =
          StatefulAnalyzer(config, models, onErrorsCollector(collector));
      analyzer.validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.last;
      expect(
        error.message,
        'The field name "apiField" is not added to the class or has an !persist scope.',
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
      var analyzer =
          StatefulAnalyzer(config, models, onErrorsCollector(collector));
      analyzer.validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(
        error.message,
        'The field name "" is not added to the class or has an !persist scope.',
      );
    },
  );

  test(
    'Given a class with an index that mixes vector and non-vector fields, then collect an error that mixing is not allowed.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            name: String
            vector: Vector(512)
          indexes:
            example_index:
              fields: name, vector
              type: btree
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      var analyzer =
          StatefulAnalyzer(config, models, onErrorsCollector(collector));
      analyzer.validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.firstWhere(
        (e) => e.message.contains('Mixing vector and non-vector'),
      );

      expect(
        error.message,
        'Mixing vector and non-vector fields in the same index is not allowed.',
      );
    },
  );

  test(
    'Given a class with an index containing more than one vector field, then collect an error that multiple vector fields are not allowed.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            vector1: Vector(512)
            vector2: Vector(512)
          indexes:
            example_index:
              fields: vector1, vector2
              type: hnsw
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      var analyzer =
          StatefulAnalyzer(config, models, onErrorsCollector(collector));
      analyzer.validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.firstWhere(
        (e) => e.message.contains('Only one vector'),
      );

      expect(
        error.message,
        'Only one vector field is allowed in an index.',
      );
    },
  );

  test(
    'Given a class with an index that mixes half vector and non-vector fields, then collect an error that mixing is not allowed.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            name: String
            vector: HalfVector(512)
          indexes:
            example_index:
              fields: name, vector
              type: btree
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      var analyzer =
          StatefulAnalyzer(config, models, onErrorsCollector(collector));
      analyzer.validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.firstWhere(
        (e) => e.message.contains('Mixing vector and non-vector'),
      );

      expect(
        error.message,
        'Mixing vector and non-vector fields in the same index is not allowed.',
      );
    },
  );

  test(
    'Given a class with an index containing more than one half vector field, then collect an error that multiple vector fields are not allowed.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            vector1: HalfVector(512)
            vector2: HalfVector(512)
          indexes:
            example_index:
              fields: vector1, vector2
              type: hnsw
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      var analyzer =
          StatefulAnalyzer(config, models, onErrorsCollector(collector));
      analyzer.validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.firstWhere(
        (e) => e.message.contains('Only one vector'),
      );

      expect(
        error.message,
        'Only one vector field is allowed in an index.',
      );
    },
  );

  test(
    'Given a class with an index that mixes sparse vector and non-vector fields, then collect an error that mixing is not allowed.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            name: String
            vector: SparseVector(512)
          indexes:
            example_index:
              fields: name, vector
              type: btree
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      var analyzer =
          StatefulAnalyzer(config, models, onErrorsCollector(collector));
      analyzer.validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.firstWhere(
        (e) => e.message.contains('Mixing vector and non-vector'),
      );

      expect(
        error.message,
        'Mixing vector and non-vector fields in the same index is not allowed.',
      );
    },
  );

  test(
    'Given a class with an index containing more than one sparse vector field, then collect an error that multiple vector fields are not allowed.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            vector1: SparseVector(512)
            vector2: SparseVector(512)
          indexes:
            example_index:
              fields: vector1, vector2
              type: hnsw
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      var analyzer =
          StatefulAnalyzer(config, models, onErrorsCollector(collector));
      analyzer.validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.firstWhere(
        (e) => e.message.contains('Only one vector'),
      );

      expect(
        error.message,
        'Only one vector field is allowed in an index.',
      );
    },
  );

  test(
    'Given a class with an index that mixes bit vector and non-vector fields, then collect an error that mixing is not allowed.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            name: String
            vector: Bit(512)
          indexes:
            example_index:
              fields: name, vector
              type: btree
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      var analyzer =
          StatefulAnalyzer(config, models, onErrorsCollector(collector));
      analyzer.validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.firstWhere(
        (e) => e.message.contains('Mixing vector and non-vector'),
      );

      expect(
        error.message,
        'Mixing vector and non-vector fields in the same index is not allowed.',
      );
    },
  );

  test(
    'Given a class with an index containing more than one bit vector field, then collect an error that multiple vector fields are not allowed.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            vector1: Bit(512)
            vector2: Bit(512)
          indexes:
            example_index:
              fields: vector1, vector2
              type: hnsw
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      var analyzer =
          StatefulAnalyzer(config, models, onErrorsCollector(collector));
      analyzer.validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.firstWhere(
        (e) => e.message.contains('Only one vector'),
      );

      expect(
        error.message,
        'Only one vector field is allowed in an index.',
      );
    },
  );
}
