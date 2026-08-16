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

  group('Given a class with fields with a "defaultPersist" keyword', () {
    test(
      'when the field is of enum type and the defaultPersist is set to "byName1", then the field should have a "default persist" value',
      () {
        var localModels = List<ModelSource>.from(models);
        localModels.add(
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            enumType: ByNameEnum?, defaultPersist=byName1
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
        expect(definition.fields.last.defaultPersistValue, 'byName1');
      },
    );

    test(
      'when the field is of enum type and the defaultPersist is set to "byName2", then the field should have a "default persist" value',
      () {
        var localModels = List<ModelSource>.from(models);
        localModels.add(
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            enumType: ByNameEnum?, defaultPersist=byName2
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
        expect(definition.fields.last.defaultPersistValue, 'byName2');
      },
    );

    test(
      'when the field is of enum type and the defaultPersist is empty, then an error is generated',
      () {
        var localModels = List<ModelSource>.from(models);
        localModels.add(
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            enumType: ByNameEnum?, defaultPersist=
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
          'The "defaultPersist" value must be a valid enum value from the set: (byName1, byName2).',
        );
      },
    );

    test(
      'when the field is of enum type with an invalid defaultPersist value "INVALID", then an error is generated',
      () {
        var localModels = List<ModelSource>.from(models);
        localModels.add(
          ModelSourceBuilder().withYaml(
            '''
        class: Example
        table: example
        fields:
          enumInvalid: ByNameEnum?, defaultPersist=INVALID
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
          'The "defaultPersist" value must be a valid enum value from the set: (byName1, byName2).',
        );
      },
    );

    test(
      'when the field is of enum type with an invalid defaultPersist value, then an error is generated',
      () {
        var localModels = List<ModelSource>.from(models);
        localModels.add(
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            enumInvalid: ByNameEnum?, defaultPersist=test
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

        var error = collector.errors.first as SourceSpanSeverityException;
        expect(
          error.message,
          'The "defaultPersist" value must be a valid enum value from the set: (byName1, byName2).',
        );
      },
    );

    test(
      'when the field is of enum non-nullable type, then an error is generated',
      () {
        var localModels = List<ModelSource>.from(models);
        localModels.add(
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            enumType: ByNameEnum, defaultPersist=byName1
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

        var error = collector.errors.first as SourceSpanSeverityException;
        expect(
          error.message,
          'When setting only the "defaultPersist" key, its type should be nullable',
        );
      },
    );

    test(
      'when the field has the "!persist" keyword, then an error is generated',
      () {
        var localModels = List<ModelSource>.from(models);
        localModels.add(
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            enumType: ByNameEnum?, defaultPersist=byName1, !persist
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

        var error = collector.errors.first as SourceSpanSeverityException;
        expect(
          error.message,
          'The "defaultPersist" property is mutually exclusive with the "!persist" property.',
        );
      },
    );
  });
}
