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

      expect(collector.errors, isEmpty);
    },
  );

  test(
    'Given a shared enum and a server enum with the same name '
    'when analyzing models '
    'then an error is collected that server enums cannot share names with shared package enums.',
    () {
      var models = <ModelSource>[
        ModelSourceBuilder()
            .withIsSharedModel(true)
            .withModuleAlias('shared')
            .withFileName('shared_enum')
            .withYaml(
              '''
enum: SharedEnum
values:
  - value1
  - value2
''',
            )
            .build(),
        ModelSourceBuilder().withFileName('shared_enum').withYaml(
          '''
enum: SharedEnum
values:
  - other1
  - other2
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
        reason: 'Expected an error when server enum reuses shared enum name',
      );
      expect(
        collector.errors.first.message,
        'The enum name "SharedEnum" is already used by a model in the shared '
        'package "shared". Server and client models cannot have the same name '
        'as shared package models.',
      );
    },
  );

  test(
    'Given a shared enum and a server enum with different names '
    'when analyzing models '
    'then no error is collected for enum name conflict.',
    () {
      var models = <ModelSource>[
        ModelSourceBuilder()
            .withIsSharedModel(true)
            .withModuleAlias('shared')
            .withFileName('shared_enum')
            .withYaml(
              '''
enum: SharedEnum
values:
  - value1
  - value2
''',
            )
            .build(),
        ModelSourceBuilder().withFileName('server_enum').withYaml(
          '''
enum: ServerEnum
values:
  - other1
  - other2
''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, isEmpty);
    },
  );

  test(
    'Given a shared exception and a server exception with the same name '
    'when analyzing models '
    'then an error is collected that server exceptions cannot share names with shared package exceptions.',
    () {
      var models = <ModelSource>[
        ModelSourceBuilder()
            .withIsSharedModel(true)
            .withModuleAlias('shared')
            .withFileName('shared_exception')
            .withYaml(
              '''
exception: SharedException
fields:
  message: String
''',
            )
            .build(),
        ModelSourceBuilder().withFileName('shared_exception').withYaml(
          '''
exception: SharedException
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
            'Expected an error when server exception reuses shared exception name',
      );
      expect(
        collector.errors.first.message,
        'The exception name "SharedException" is already used by a model in the '
        'shared package "shared". Server and client models cannot have the same '
        'name as shared package models.',
      );
    },
  );

  test(
    'Given a shared exception and a server exception with different names '
    'when analyzing models '
    'then no error is collected for exception name conflict.',
    () {
      var models = <ModelSource>[
        ModelSourceBuilder()
            .withIsSharedModel(true)
            .withModuleAlias('shared')
            .withFileName('shared_exception')
            .withYaml(
              '''
exception: SharedException
fields:
  message: String
''',
            )
            .build(),
        ModelSourceBuilder().withFileName('server_exception').withYaml(
          '''
exception: ServerException
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

      expect(collector.errors, isEmpty);
    },
  );
}
