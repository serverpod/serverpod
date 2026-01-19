import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

const projectName = 'example_project';

void main() {
  group('Given a class with a jsonKey field property', () {
    var config = GeneratorConfigBuilder().withName(projectName).build();

    test(
      'when jsonKey is a valid string then no errors are collected and the field has the correct jsonKey',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            fields:
              displayName: String, jsonKey=display_name
            ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        var definitions = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isEmpty);
        expect(definitions, isNotEmpty);

        var definition = definitions.first as ClassDefinition;
        var field = definition.fields.first;
        expect(field.jsonKey, equals('display_name'));
        expect(field.hasJsonKeyOverride, isTrue);
      },
    );

    test(
      'when jsonKey is not set then field uses the field name as jsonKey',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            fields:
              displayName: String
            ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        var definitions = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isEmpty);
        expect(definitions, isNotEmpty);

        var definition = definitions.first as ClassDefinition;
        var field = definition.fields.first;
        expect(field.jsonKey, equals('displayName'));
        expect(field.hasJsonKeyOverride, isFalse);
      },
    );

    test(
      'when jsonKey contains special characters then no errors are collected',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            fields:
              id: String, jsonKey=_id
            ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        var definitions = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isEmpty);
        expect(definitions, isNotEmpty);

        var definition = definitions.first as ClassDefinition;
        var field = definition.fields.first;
        expect(field.jsonKey, equals('_id'));
      },
    );

    test(
      'when jsonKey is used with a table class then no errors are collected',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
            class: Example
            table: example
            fields:
              displayName: String, jsonKey=display_name
            ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        var definitions = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isEmpty);
        expect(definitions, isNotEmpty);
      },
    );

    test(
      'when multiple fields have different jsonKey values then no errors are collected',
      () {
        var models = [
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

        var collector = CodeGenerationCollector();
        var definitions = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isEmpty);
        expect(definitions, isNotEmpty);

        var definition = definitions.first as ClassDefinition;
        expect(definition.fields[0].jsonKey, equals('first_name'));
        expect(definition.fields[1].jsonKey, equals('last_name'));
        expect(definition.fields[2].jsonKey, equals('email'));
      },
    );
  });
}
