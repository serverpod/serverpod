import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  var validIndexTypes = [
    'btree',
    'hash',
    'gist',
    'spgist',
    'gin',
    'brin',
  ];

  for (var indexType in validIndexTypes) {
    test(
        'Given a class with an index type explicitly set to $indexType, then use that type',
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
                type: $indexType
            ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var analyzer = StatefulAnalyzer(
        models,
        onErrorsCollector(collector),
      );
      var definitions = analyzer.validateAll();

      var definition = definitions.first as ClassDefinition;

      var index = definition.indexes.first;

      expect(index.type, indexType);
    });
  }

  test(
      'Given a class with an index without a type set, then default to type btree',
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
    var analyzer = StatefulAnalyzer(models, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();

    var definition = definitions.first as ClassDefinition;

    var index = definition.indexes.first;

    expect(index.type, 'btree');
  });

  test(
      'Given a class with an index type explicitly set to an invalid type, then collect an error that only the defined index types can be used.',
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
              type: invalid_pgsql_type
          ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer = StatefulAnalyzer(models, onErrorsCollector(collector));
    analyzer.validateAll();

    expect(
      collector.errors,
      isNotEmpty,
      reason: 'Expected an error, but none was collected.',
    );

    var error = collector.errors.first;
    expect(
      error.message,
      'The "type" property must be one of: btree, hash, gin, gist, spgist, brin.',
    );
  });

  test(
      'Given a class with an index with an invalid type, then collect an error indicating that the type is invalid.',
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
              type: 1
          ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer = StatefulAnalyzer(models, onErrorsCollector(collector));
    analyzer.validateAll();

    expect(
      collector.errors,
      isNotEmpty,
      reason: 'Expected an error, but none was collected.',
    );

    var error = collector.errors.first;
    expect(
      error.message,
      'The "type" property must be one of: btree, hash, gin, gist, spgist, brin.',
    );
  });
}
