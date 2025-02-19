import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/keywords.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

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

  for (var idType in SupportedIdType.all) {
    var idClassName = idType.className;
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

        var definition = definitions.first as ClassDefinition;

        test("then the id of the table is '$idClassName'.", () {
          expect(definition.idField.type.className, idClassName);
        }, skip: errors.isNotEmpty);

        test('then the id type is nullable.', () {
          expect(definition.idField.type.nullable, true);
        }, skip: errors.isNotEmpty);

        test("then the default persist value is '$defaultValue'", () {
          expect(definition.idField.defaultPersistValue, defaultValue);
        }, skip: errors.isNotEmpty);
      });

      for (var forbiddenKey in [
        Keyword.defaultModelKey,
        Keyword.defaultPersistKey,
        Keyword.persist,
        Keyword.scope,
      ]) {
        test(
          'and the forbidden $forbiddenKey key, then an error is collected.',
          () {
            var models = [
              ModelSourceBuilder().withYaml(
                '''
            class: Example
            table: example
            fields:
              id: $idClassName, default=$defaultValue, $forbiddenKey
            ''',
              ).build()
            ];

            var collector = CodeGenerationCollector();
            StatefulAnalyzer(config, models, onErrorsCollector(collector))
                .validateAll();

            expect(
              collector.errors.first.message,
              contains(
                'The "$forbiddenKey" key is not allowed on the "id" field.',
              ),
            );
          },
        );
      }
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

    expect(
      collector.errors.first.message,
      contains(
        'The default value "$invalidDefaultValue" is not supported for the id type "UuidValue". Valid options are:',
      ),
    );
  });
}
