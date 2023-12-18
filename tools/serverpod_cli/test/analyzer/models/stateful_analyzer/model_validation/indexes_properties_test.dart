import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given a class with the index property defined but without any index, then collect an error that at least one index has to be added.',
    () {
      var protocols = [
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
      var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));
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
      var protocols = [
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
      var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));
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
      'Given a class with an index key that is not a string, then collect an error that the index name has to be defined as a string.',
      () {
    var protocols = [
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
    var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));
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
      var protocols = [
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
      var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));
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

  test(
    'Given a class with an index without any fields, then collect an error that at least one field has to be added.',
    () {
      var protocols = [
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
      var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));
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
      var protocols = [
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
      var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));
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
      var protocols = [
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
      var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));
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
      var protocols = [
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
      var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));
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
      var protocols = [
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
      var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));
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

  test(
    'Given a class with an index with a defined field, then the definition contains the index.',
    () {
      var protocols = [
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
      var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));
      var definitions = analyzer.validateAll();
      var definition = definitions.first as ClassDefinition;

      var index = definition.indexes.first;
      expect(index.name, 'example_index');
    },
  );

  group(
    'Given a class with an index with a defined field',
    () {
      var protocols = [
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
      var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));
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
      var protocols = [
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
      var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));
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
      var protocols = [
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
      var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));
      var definitions = analyzer.validateAll();
      var definition = definitions.first as ClassDefinition;

      var index1 = definition.indexes.first;
      var index2 = definition.indexes.last;

      expect(index1.name, 'example_index');
      expect(index2.name, 'example_index2');
    },
  );

  test(
      'Given a class with an index with a unique key that is not a bool, then collect an error that the unique key has to be defined as a bool.',
      () {
    var protocols = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          name: String
        indexes:
          example_index:
            fields: name
            unique: InvalidValue
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));
    analyzer.validateAll();

    expect(
      collector.errors,
      isNotEmpty,
      reason: 'Expected an error but none was generated.',
    );

    var error = collector.errors.first;
    expect(error.message, 'The value must be a boolean.');
  });

  test(
      'Given a class with an index with an undefined unique key, then return a definition where unique is set to false.',
      () {
    var protocols = [
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
    var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();
    var definition = definitions.first as ClassDefinition;

    var index = definition.indexes.first;
    expect(index.unique, false);
  });

  test(
      'Given a class with an index with a unique key set to false, then return a definition where unique is set to false.',
      () {
    var protocols = [
      ModelSourceBuilder().withYaml(
        '''
      class: Example
      table: example
      fields:
        name: String
      indexes:
        example_index:
          fields: name
          unique: false
      ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();
    var definition = definitions.first as ClassDefinition;

    var index = definition.indexes.first;
    expect(index.unique, false);
  });

  test(
      'Given a class with an index with a unique key set to true, then return a definition where unique is set to true.',
      () {
    var protocols = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          name: String
        indexes:
          example_index:
            fields: name
            unique: true
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();
    var definition = definitions.first as ClassDefinition;

    var index = definition.indexes.first;
    expect(index.unique, true);
  });

  test(
      'Given a class with an index with an invalid key, then collect an error indicating that the key is invalid.',
      () {
    var protocols = [
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
    var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));
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

  group('Index relationships.', () {
    test(
        'Given two classes with the same index name defined, then collect an error notifying that the index name is already in use.',
        () {
      var protocols = [
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
      var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));
      analyzer.validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(
        error.message,
        'The index name "example_index" is already used by the protocol class "ExampleCollision".',
      );
    });
  });

  group('Index type tests.', () {
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
        var protocols = [
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
          protocols,
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
      var protocols = [
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
      var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));
      var definitions = analyzer.validateAll();

      var definition = definitions.first as ClassDefinition;

      var index = definition.indexes.first;

      expect(index.type, 'btree');
    });

    test(
        'Given a class with an index type explicitly set to an invalid type, then collect an error that only the defined index types can be used.',
        () {
      var protocols = [
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
      var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));
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
      var protocols = [
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
      var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));
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
  });
}
