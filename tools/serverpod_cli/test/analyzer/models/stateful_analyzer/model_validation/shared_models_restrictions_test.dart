import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  test(
    'Given a shared package model when the model has a table property '
    'when analyzing model '
    'then an error is collected that table is not allowed in shared packages.',
    () {
      var models = <ModelSource>[
        ModelSourceBuilder()
            .withIsSharedModel(true)
            .withModuleAlias('shared')
            .withYaml(
              '''
class: SharedExample
table: shared_example
fields:
  name: String
''',
            )
            .build(),
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
        'The "table" property is not allowed in shared packages.',
      );
    },
  );

  test(
    'Given a shared package model when the model has a serverOnly property '
    'when analyzing model '
    'then an error is collected that serverOnly is not allowed in shared packages.',
    () {
      var models = <ModelSource>[
        ModelSourceBuilder()
            .withIsSharedModel(true)
            .withModuleAlias('shared')
            .withYaml(
              '''
          class: SharedExample
          serverOnly: true
          fields:
            name: String
          ''',
            )
            .build(),
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
        'The "serverOnly" property is not allowed in shared packages.',
      );
    },
  );

  test(
    'Given a shared package model when the model has a field with scope serverOnly '
    'when analyzing model '
    'then an error is collected that field is part of a shared model and can not have scope defined to "serverOnly".',
    () {
      var models = <ModelSource>[
        ModelSourceBuilder()
            .withIsSharedModel(true)
            .withModuleAlias('shared')
            .withYaml(
              '''
          class: SharedExample
          fields:
            name: String, scope=serverOnly
          ''',
            )
            .build(),
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
        'Field "name" is part of a shared model and can not have scope defined '
        'to "serverOnly". To create a server only field, define a subclass of '
        'the shared model on the server project and set the field to '
        '"serverOnly" in the subclass.',
      );
    },
  );

  test(
    'Given a sealed shared package model and a subclass on the same shared package '
    'when analyzing model '
    'then no error is collected.',
    () {
      var models = <ModelSource>[
        ModelSourceBuilder()
            .withIsSharedModel(true)
            .withModuleAlias('shared')
            .withFileName('shared_example')
            .withYaml(
              '''
          class: SharedExample
          sealed: true
          fields:
            name: String
          ''',
            )
            .build(),
        ModelSourceBuilder()
            .withIsSharedModel(true)
            .withModuleAlias('shared')
            .withFileName('shared_example_child')
            .withYaml(
              '''
          class: SharedExampleChild
          extends: SharedExample
          fields:
            other: String
          ''',
            )
            .build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors to be collected',
      );
    },
  );

  test(
    'Given a sealed shared package model and a subclass on the project package '
    'when analyzing model '
    'then an error is collected that sealed models can not be inherited from.',
    () {
      var models = <ModelSource>[
        ModelSourceBuilder()
            .withIsSharedModel(true)
            .withModuleAlias('shared')
            .withYaml(
              '''
          class: SharedExample
          sealed: true
          fields:
            name: String
          ''',
            )
            .build(),
        ModelSourceBuilder().withFileName('example').withYaml(
          '''
          class: Example
          extends: SharedExample
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
        reason: 'Expected an error to be collected',
      );

      expect(
        collector.errors.first.message,
        'Can not extend a sealed model from another package.',
      );
    },
  );
}
