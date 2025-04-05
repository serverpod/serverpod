import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/keywords.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().withEnabledExperimentalFeatures(
    [ExperimentalFeature.changeIdType],
  ).build();

  group('Given a class with a table defined and no id field', () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          name: String
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer =
        StatefulAnalyzer(config, models, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();

    var definition = definitions.first as ClassDefinition;

    test('then an id field is added to the generated model.', () {
      expect(definition.fields.first.name, 'id');
    });

    test('then the id type is "int".', () {
      expect(definition.fields.first.type.className, 'int');
    });

    test('then the id type is nullable.', () {
      expect(definition.fields.first.type.nullable, true);
    });

    test('then the default persist is "serial".', () {
      expect(definition.fields.first.defaultPersistValue, defaultIntSerial);
    });
  });

  test(
      'Given a class changing the id type, when changeIdType is not enabled, then an error is collected that it is not allowed',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          id: int
        ''',
      ).build()
    ];

    var config = GeneratorConfigBuilder().build();
    var collector = CodeGenerationCollector();
    StatefulAnalyzer(config, models, onErrorsCollector(collector))
        .validateAll();

    expect(collector.errors, isNotEmpty);

    expect(
      collector.errors.first.message,
      contains(
        'The "changeIdType" experimental feature is not enabled. Enable '
        'it first to change the id type of a table class.',
      ),
    );
  });

  for (var idType in SupportedIdType.all) {
    var idClassName = idType.type.className;
    var defaultValue = idType.defaultValue;

    group('Given a class with the $idClassName id type', () {
      if (idClassName == 'int') {
        test('and no default value, then no error is collected.', () {
          var models = [
            ModelSourceBuilder().withYaml(
              '''
              class: Example
              table: example
              fields:
                id: $idClassName
              ''',
            ).build()
          ];

          var collector = CodeGenerationCollector();
          StatefulAnalyzer(config, models, onErrorsCollector(collector))
              .validateAll();

          expect(collector.errors, isEmpty);
        });
      } else {
        test('and no default value, then an error is collected.', () {
          var models = [
            ModelSourceBuilder().withYaml(
              '''
              class: Example
              table: example
              fields:
                id: $idClassName
              ''',
            ).build()
          ];

          var collector = CodeGenerationCollector();
          StatefulAnalyzer(config, models, onErrorsCollector(collector))
              .validateAll();

          expect(
            collector.errors.first.message,
            contains('The type "$idClassName" must have a default value.'),
          );
        });
      }

      group('and default value set to $defaultValue', () {
        var yamlSource = ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            id: $idClassName, default=$defaultValue
          ''',
        ).build();

        var collector = CodeGenerationCollector();
        var statefulAnalyzer = StatefulAnalyzer(config, [yamlSource]);
        var definitions = statefulAnalyzer.validateAll();
        var errors = collector.errors;

        test('then no errors are collected.', () {
          expect(errors, isEmpty);
        });

        var definition = definitions.first as ModelClassDefinition;

        test("then the id of the table is '$idClassName'.", () {
          expect(definition.idField.type.className, idClassName);
        }, skip: errors.isNotEmpty);

        test('then the id type is nullable.', () {
          expect(definition.idField.type.nullable, true);
        }, skip: errors.isNotEmpty);

        var expectedDefaultValue = idType.defaultValue;
        test("then the default model value is '$expectedDefaultValue'", () {
          expect(definition.idField.defaultModelValue, expectedDefaultValue);
        }, skip: errors.isNotEmpty);

        test("then the default persist value is '$expectedDefaultValue'", () {
          expect(definition.idField.defaultPersistValue, expectedDefaultValue);
        }, skip: errors.isNotEmpty);
      });

      var defaultModelKey = Keyword.defaultModelKey;
      test(
        'and the forbidden $defaultModelKey key, then an error is collected.',
        () {
          var models = [
            ModelSourceBuilder().withYaml(
              '''
              class: Example
              table: example
              fields:
                id: $idClassName, $defaultModelKey=$defaultValue
              ''',
            ).build()
          ];

          var collector = CodeGenerationCollector();
          StatefulAnalyzer(config, models, onErrorsCollector(collector))
              .validateAll();

          expect(
            collector.errors.first.message,
            contains(
              'The "$defaultModelKey" key is not allowed on the "id" field.',
            ),
          );
        },
      );

      var defaultPersistKey = Keyword.defaultPersistKey;
      test(
        'and the forbidden $defaultPersistKey key, then an error is collected.',
        () {
          var models = [
            ModelSourceBuilder().withYaml(
              '''
              class: Example
              table: example
              fields:
                id: $idClassName, $defaultPersistKey=$defaultValue
              ''',
            ).build()
          ];

          var collector = CodeGenerationCollector();
          StatefulAnalyzer(config, models, onErrorsCollector(collector))
              .validateAll();

          expect(
            collector.errors.first.message,
            contains(
              'The "$defaultPersistKey" key is not allowed on the "id" field.',
            ),
          );
        },
      );

      var persistKey = Keyword.persist;
      test(
        'and the forbidden $persistKey key, then an error is collected.',
        () {
          var models = [
            ModelSourceBuilder().withYaml(
              '''
              class: Example
              table: example
              fields:
                id: $idClassName, default=$defaultValue, !$persistKey
              ''',
            ).build()
          ];

          var collector = CodeGenerationCollector();
          StatefulAnalyzer(config, models, onErrorsCollector(collector))
              .validateAll();

          expect(
            collector.errors.first.message,
            contains(
              'The "$persistKey" key is not allowed on the "id" field.',
            ),
          );
        },
      );

      var scopeKey = Keyword.scope;
      test(
        'and the forbidden $scopeKey key, then an error is collected.',
        () {
          var models = [
            ModelSourceBuilder().withYaml(
              '''
              class: Example
              table: example
              fields:
                id: $idClassName, default=$defaultValue, $scopeKey
              ''',
            ).build()
          ];

          var collector = CodeGenerationCollector();
          StatefulAnalyzer(config, models, onErrorsCollector(collector))
              .validateAll();

          expect(
            collector.errors.first.message,
            contains(
              'The "$scopeKey" key is not allowed on the "id" field.',
            ),
          );
        },
      );
    });
  }

  test(
    'Given a class without a table defined, then no id field is added.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields:
            name: String
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      var analyzer =
          StatefulAnalyzer(config, models, onErrorsCollector(collector));
      var definitions = analyzer.validateAll();

      var definition = definitions.first as ClassDefinition;

      expect(definition.fields.first.name, isNot('id'));
      expect(definition.fields, hasLength(1));
    },
  );

  test(
    'Given a class with the int id field and a wrong value on the default key, then an error is collected.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            id: int, default=1
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(config, models, onErrorsCollector(collector))
          .validateAll();

      // TODO: Complete the message.
      expect(
        collector.errors.first.message,
        contains(
          'The default value "1" is not supported for the id type "int".',
        ),
      );
    },
  );

  test(
      'Given a class with the UuidValue id type and an invalid default value, then an error is collected.',
      () {
    var invalidDefaultValue = "'550e8400-e29b-41d4-a716-446655440000'";
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          id: UuidValue, default=$invalidDefaultValue
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer(config, models, onErrorsCollector(collector))
        .validateAll();

    // TODO: Complete the message.
    expect(
      collector.errors.first.message,
      contains(
        'The default value "$invalidDefaultValue" is not supported for the id type "UuidValue". Valid options are:',
      ),
    );
  });
}
