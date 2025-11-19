import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group(
    'Given a class without a table definition when defining a relation',
    () {
      test(
        'Given a class with an object relation but no table definition when analyzing model then an error is collected that the table property must be defined.',
        () {
          var models = [
            ModelSourceBuilder().withYaml(
              '''
              class: Animal
              fields:
                name: String
                breed: String
                owner: Owner?, relation
              ''',
            ).build(),
            ModelSourceBuilder().withFileName('owner').withYaml(
              '''
              class: Owner
              table: owner
              fields:
                name: String
              ''',
            ).build(),
          ];

          var collector = CodeGenerationCollector();
          StatefulAnalyzer(
            config,
            models,
            onErrorsCollector(collector),
          ).validateAll();

          expect(
            collector.errors,
            isNotEmpty,
            reason: 'Expected an error to be collected',
          );
          expect(
            collector.errors.first.message,
            'The "table" property must be defined in the class to set a relation on a field.',
          );
        },
      );

      test(
        'Given a class with a named object relation but no table definition when analyzing model then an error is collected that the table property must be defined.',
        () {
          var models = [
            ModelSourceBuilder().withYaml(
              '''
              class: Animal
              fields:
                name: String
                breed: String
                owner: Owner?, relation(name=animal_owner)
              ''',
            ).build(),
            ModelSourceBuilder().withFileName('owner').withYaml(
              '''
              class: Owner
              table: owner
              fields:
                name: String
                animals: List<Animal>?, relation(name=animal_owner)
              ''',
            ).build(),
          ];

          var collector = CodeGenerationCollector();
          StatefulAnalyzer(
            config,
            models,
            onErrorsCollector(collector),
          ).validateAll();

          expect(
            collector.errors,
            isNotEmpty,
            reason: 'Expected an error to be collected',
          );
          expect(
            collector.errors.first.message,
            'The "table" property must be defined in the class to set a relation on a field.',
          );
        },
      );

      test(
        'Given a class with a manual field relation but no table definition when analyzing model then an error is collected that the table property must be defined.',
        () {
          var models = [
            ModelSourceBuilder().withYaml(
              '''
              class: Animal
              fields:
                name: String
                breed: String
                ownerId: int
                owner: Owner?, relation(field=ownerId)
              ''',
            ).build(),
            ModelSourceBuilder().withFileName('owner').withYaml(
              '''
              class: Owner
              table: owner
              fields:
                name: String
              ''',
            ).build(),
          ];

          var collector = CodeGenerationCollector();
          StatefulAnalyzer(
            config,
            models,
            onErrorsCollector(collector),
          ).validateAll();

          expect(
            collector.errors,
            isNotEmpty,
            reason: 'Expected an error to be collected',
          );
          expect(
            collector.errors.first.message,
            'The "table" property must be defined in the class to set a relation on a field.',
          );
        },
      );

      test(
        'Given a class with a list relation but no table definition when analyzing model then an error is collected that the table property must be defined.',
        () {
          var models = [
            ModelSourceBuilder().withYaml(
              '''
              class: Owner
              fields:
                name: String
                animals: List<Animal>?, relation
              ''',
            ).build(),
            ModelSourceBuilder().withFileName('animal').withYaml(
              '''
              class: Animal
              table: animal
              fields:
                name: String
                breed: String
              ''',
            ).build(),
          ];

          var collector = CodeGenerationCollector();
          StatefulAnalyzer(
            config,
            models,
            onErrorsCollector(collector),
          ).validateAll();

          expect(
            collector.errors,
            isNotEmpty,
            reason: 'Expected an error to be collected',
          );
          expect(
            collector.errors.first.message,
            'The "table" property must be defined in the class to set a relation on a field.',
          );
        },
      );

      test(
        'Given a class with an id field but no table definition when setting a relation then an error is collected about missing table property.',
        () {
          var models = [
            ModelSourceBuilder().withYaml(
              '''
              class: Animal
              fields:
                id: int
                name: String
                owner: Owner?, relation
              ''',
            ).build(),
            ModelSourceBuilder().withFileName('owner').withYaml(
              '''
              class: Owner
              table: owner
              fields:
                name: String
              ''',
            ).build(),
          ];

          var collector = CodeGenerationCollector();
          StatefulAnalyzer(
            config,
            models,
            onErrorsCollector(collector),
          ).validateAll();

          expect(
            collector.errors,
            isNotEmpty,
            reason: 'Expected an error to be collected',
          );
          expect(
            collector.errors.first.message,
            'The "table" property must be defined in the class to set a relation on a field.',
          );
        },
      );
    },
  );
}
