import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

const projectName = 'example_project';

void main() {
  final config = GeneratorConfigBuilder().withName(projectName).build();

  group('Given a class with a field with jsonKey set to a valid string', () {
    final models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        fields:
          displayName: String, jsonKey=display_name
        ''',
      ).build(),
    ];

    late CodeGenerationCollector collector;
    late List<SerializableModelDefinition> definitions;

    setUp(() {
      collector = CodeGenerationCollector();
      definitions = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();
    });

    group('when analyzing', () {
      test('then no errors are collected', () {
        expect(collector.errors, isEmpty);
      });

      test('then the field has the correct jsonKey', () {
        expect(definitions, isNotEmpty);
        final definition = definitions.first as ClassDefinition;
        final field = definition.fields.first;
        expect(field.jsonKey, equals('display_name'));
        expect(field.hasJsonKeyOverride, isTrue);
      });
    });
  });

  group('Given a class with a field without jsonKey set', () {
    final models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        fields:
          displayName: String
        ''',
      ).build(),
    ];

    late CodeGenerationCollector collector;
    late List<SerializableModelDefinition> definitions;

    setUp(() {
      collector = CodeGenerationCollector();
      definitions = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();
    });

    group('when analyzing', () {
      test('then no errors are collected', () {
        expect(collector.errors, isEmpty);
      });

      test('then the field uses the field name as jsonKey', () {
        expect(definitions, isNotEmpty);
        final definition = definitions.first as ClassDefinition;
        final field = definition.fields.first;
        expect(field.jsonKey, equals('displayName'));
        expect(field.hasJsonKeyOverride, isFalse);
      });
    });
  });

  group(
    'Given a class with a field with jsonKey containing special characters',
    () {
      final models = [
        ModelSourceBuilder().withYaml(
          '''
        class: Example
        fields:
          id: String, jsonKey=_id
        ''',
        ).build(),
      ];

      late CodeGenerationCollector collector;
      late List<SerializableModelDefinition> definitions;

      setUp(() {
        collector = CodeGenerationCollector();
        definitions = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();
      });

      group('when analyzing', () {
        test('then no errors are collected', () {
          expect(collector.errors, isEmpty);
        });

        test('then the field has the correct jsonKey', () {
          expect(definitions, isNotEmpty);
          final definition = definitions.first as ClassDefinition;
          final field = definition.fields.first;
          expect(field.jsonKey, equals('_id'));
        });
      });
    },
  );

  group('Given a table class with a field with jsonKey set', () {
    final models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          displayName: String, jsonKey=display_name
        ''',
      ).build(),
    ];

    late CodeGenerationCollector collector;
    late List<SerializableModelDefinition> definitions;

    setUp(() {
      collector = CodeGenerationCollector();
      definitions = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();
    });

    group('when analyzing', () {
      test('then no errors are collected', () {
        expect(collector.errors, isEmpty);
        expect(definitions, isNotEmpty);
      });
    });
  });

  group('Given a class with multiple fields with different jsonKey values', () {
    final models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        fields:
          firstName: String, jsonKey=first_name
          lastName: String, jsonKey=last_name
          email: String
        ''',
      ).build(),
    ];

    late CodeGenerationCollector collector;
    late List<SerializableModelDefinition> definitions;

    setUp(() {
      collector = CodeGenerationCollector();
      definitions = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();
    });

    group('when analyzing', () {
      test('then no errors are collected', () {
        expect(collector.errors, isEmpty);
        expect(definitions, isNotEmpty);
      });

      test('then each field has the correct jsonKey', () {
        final definition = definitions.first as ClassDefinition;
        expect(definition.fields[0].jsonKey, equals('first_name'));
        expect(definition.fields[1].jsonKey, equals('last_name'));
        expect(definition.fields[2].jsonKey, equals('email'));
      });
    });
  });

  group('Given a class with a field with jsonKey set to an empty string', () {
    final models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        fields:
          displayName:
            type: String
            jsonKey:
        ''',
      ).build(),
    ];

    late CodeGenerationCollector collector;

    setUp(() {
      collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();
    });

    group('when analyzing', () {
      test('then an error is collected', () {
        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error for empty jsonKey value.',
        );

        final error = collector.errors.first;
        expect(error.message, contains('jsonKey'));
      });
    });
  });

  group(
    'Given a class with a field with jsonKey set to a non-string value',
    () {
      final models = [
        ModelSourceBuilder().withYaml(
          '''
        class: Example
        fields:
          displayName:
            type: String
            jsonKey: 123
        ''',
        ).build(),
      ];

      late CodeGenerationCollector collector;

      setUp(() {
        collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();
      });

      group('when analyzing', () {
        test('then an error is collected', () {
          expect(
            collector.errors,
            isNotEmpty,
            reason: 'Expected an error for non-string jsonKey value.',
          );

          final error = collector.errors.first;
          expect(error.message, contains('jsonKey'));
          expect(error.message, contains('String'));
        });
      });
    },
  );

  group('Given a class with multiple fields with the same jsonKey', () {
    final models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        fields:
          firstName: String, jsonKey=name
          lastName: String, jsonKey=name
        ''',
      ).build(),
    ];

    late CodeGenerationCollector collector;

    setUp(() {
      collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();
    });

    group('when analyzing', () {
      test('then an error is collected', () {
        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error for duplicate jsonKey values.',
        );

        final error = collector.errors.first;
        expect(error.message, contains('name'));
        expect(error.message, contains('multiple fields'));
      });
    });
  });

  group(
    'Given a class with a field with jsonKey matching another field name',
    () {
      final models = [
        ModelSourceBuilder().withYaml(
          '''
        class: Example
        fields:
          email: String
          userEmail: String, jsonKey=email
        ''',
        ).build(),
      ];

      late CodeGenerationCollector collector;

      setUp(() {
        collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();
      });

      group('when analyzing', () {
        test('then an error is collected', () {
          expect(
            collector.errors,
            isNotEmpty,
            reason:
                'Expected an error when jsonKey matches another field name.',
          );

          final error = collector.errors.first;
          expect(error.message, contains('email'));
        });
      });
    },
  );
}
