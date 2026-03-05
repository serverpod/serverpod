import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  test(
    'Given a shared model and a server model with the same class name '
    'when analyzing models '
    'then an error is collected that server models cannot share names with shared package models.',
    () {
      var models = <ModelSource>[
        ModelSourceBuilder()
            .withIsSharedModel(true)
            .withModuleAlias('shared')
            .withFileName('shared_model')
            .withYaml(
              '''
class: SharedModel
fields:
  name: String
''',
            )
            .build(),
        ModelSourceBuilder().withFileName('shared_model').withYaml(
          '''
class: SharedModel
fields:
  other: String
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
        reason:
            'Expected an error when server model reuses shared model class name',
      );
      expect(
        collector.errors.first.message,
        'The class name "SharedModel" is already used by a model in the shared '
        'package "shared". Server and client models cannot have the same name '
        'as shared package models.',
      );
    },
  );

  test(
    'Given a shared model and a server model with different class names '
    'when analyzing models '
    'then no error is collected for class name conflict.',
    () {
      var models = <ModelSource>[
        ModelSourceBuilder()
            .withIsSharedModel(true)
            .withModuleAlias('shared')
            .withFileName('shared_example')
            .withYaml(
              '''
class: SharedExample
fields:
  name: String
''',
            )
            .build(),
        ModelSourceBuilder().withFileName('server_model').withYaml(
          '''
class: ServerModel
fields:
  other: String
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
        collector.errors.where(
          (e) =>
              e.message.contains('shared package') &&
              e.message.contains('class name'),
        ),
        isEmpty,
        reason: 'Expected no class name conflict error when names differ',
      );
    },
  );
}
