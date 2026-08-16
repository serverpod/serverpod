import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:test/test.dart';

import '../../../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();
  var models = <ModelSource>[];

  setUpAll(() {
    models = [
      ModelSourceBuilder()
          .withYaml(
            '''
      enum: ByNameEnum
      serialized: byName
      values:
        - byName1
        - byName2
      ''',
          )
          .withFileName('by_name_enum')
          .build(),
    ];
  });

  group('Given a class with fields with a "default" enum keyword', () {
    test(
      'when the field is of enum type and the default is set to "byName1", then the field should have a "default model" and "default persist" value',
      () {
        var localModels = List<ModelSource>.from(models);
        localModels.add(
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            enumType: ByNameEnum, default=byName1
          ''',
          ).build(),
        );

        var collector = CodeGenerationCollector();
        var definitions = StatefulAnalyzer(
          config,
          localModels,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isEmpty);

        var definition = definitions.last as ClassDefinition;
        expect(definition.fields.last.defaultModelValue, 'byName1');
        expect(definition.fields.last.defaultPersistValue, 'byName1');
      },
    );

    test(
      'when the field is of nullable enum type and the default is set to "byName2", then the field should have a "default model" and "default persist" value',
      () {
        var localModels = List<ModelSource>.from(models);
        localModels.add(
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            enumType: ByNameEnum?, default=byName2
          ''',
          ).build(),
        );

        var collector = CodeGenerationCollector();
        var definitions = StatefulAnalyzer(
          config,
          localModels,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isEmpty);

        var definition = definitions.last as ClassDefinition;
        expect(definition.fields.last.defaultModelValue, 'byName2');
        expect(definition.fields.last.defaultPersistValue, 'byName2');
      },
    );

    test(
      'when the field is of enum type and the default is empty, then an error is generated',
      () {
        var localModels = List<ModelSource>.from(models);
        localModels.add(
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            enumType: ByNameEnum, default=
          ''',
          ).build(),
        );

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          localModels,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isNotEmpty);

        var firstError = collector.errors.first as SourceSpanSeverityException;
        expect(
          firstError.message,
          'The "default" value must be a valid enum value from the set: (byName1, byName2).',
        );
      },
    );

    test(
      'when the field is of nullable enum type with an invalid default value "INVALID", then an error is generated',
      () {
        var localModels = List<ModelSource>.from(models);
        localModels.add(
          ModelSourceBuilder().withYaml(
            '''
        class: Example
        table: example
        fields:
          enumInvalid: ByNameEnum?, default=INVALID
        ''',
          ).build(),
        );

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          localModels,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isNotEmpty);

        var firstError = collector.errors.first as SourceSpanSeverityException;
        expect(
          firstError.message,
          'The "default" value must be a valid enum value from the set: (byName1, byName2).',
        );
      },
    );

    test(
      'when the field is of enum type with an invalid default value, then an error is generated',
      () {
        var localModels = List<ModelSource>.from(models);
        localModels.add(
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            enumInvalid: ByNameEnum, default=test
          ''',
          ).build(),
        );

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          localModels,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isNotEmpty);

        var firstError = collector.errors.first as SourceSpanSeverityException;
        expect(
          firstError.message,
          'The "default" value must be a valid enum value from the set: (byName1, byName2).',
        );
      },
    );
  });
}
