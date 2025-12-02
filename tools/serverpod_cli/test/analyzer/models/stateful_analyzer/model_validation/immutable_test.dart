import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  test(
    'Given a class defined to immutable, then the immutable property is set to true.',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
        class: Example
        immutable: true
        fields:
          name: String
        ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var models = StatefulAnalyzer(
        config,
        modelSources,
        onErrorsCollector(collector),
      ).validateAll();

      var model = models.first as ModelClassDefinition;
      expect(model.isImmutable, equals(true));
    },
  );

  test(
    'Given a class explicitly setting immutable to false, then the immutable property is set to false.',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
        class: Example
        immutable: false
        fields:
          name: String
        ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var models = StatefulAnalyzer(
        config,
        modelSources,
        onErrorsCollector(collector),
      ).validateAll();

      var model = models.first as ModelClassDefinition;
      expect(model.isImmutable, equals(false));
    },
  );

  test(
    'Given a class without the immutable property, then the default "false" value is used.',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
        class: Example
        fields:
          name: String
        ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var models = StatefulAnalyzer(
        config,
        modelSources,
        onErrorsCollector(collector),
      ).validateAll();

      var model = models.first as ModelClassDefinition;
      expect(model.isImmutable, equals(false));
    },
  );

  group('Given an immutable class with non-constant default values', () {
    test(
      'when a DateTime field has default=now then an error is generated.',
      () {
        var modelSources = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          immutable: true
          fields:
            name: String
            when: DateTime, default=now
          ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          modelSources,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isNotEmpty);

        var firstError = collector.errors.first as SourceSpanSeverityException;
        expect(
          firstError.message,
          contains('not allowed for immutable classes'),
        );
        expect(firstError.message, contains('now'));
      },
    );

    test(
      'when a UuidValue field has default=random then an error is generated.',
      () {
        var modelSources = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          immutable: true
          fields:
            name: String
            uuid: UuidValue, default=random
          ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          modelSources,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isNotEmpty);

        var firstError = collector.errors.first as SourceSpanSeverityException;
        expect(
          firstError.message,
          contains('not allowed for immutable classes'),
        );
        expect(firstError.message, contains('random'));
      },
    );

    test(
      'when a UuidValue field has default=random_v7 then an error is generated.',
      () {
        var modelSources = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          immutable: true
          fields:
            name: String
            uuid: UuidValue, default=random_v7
          ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          modelSources,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isNotEmpty);

        var firstError = collector.errors.first as SourceSpanSeverityException;
        expect(
          firstError.message,
          contains('not allowed for immutable classes'),
        );
        expect(firstError.message, contains('random_v7'));
      },
    );

    test(
      'when a DateTime field has defaultModel=now then an error is generated.',
      () {
        var modelSources = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          immutable: true
          table: example
          fields:
            name: String
            when: DateTime, defaultModel=now
          ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          modelSources,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isNotEmpty);

        var firstError = collector.errors.first as SourceSpanSeverityException;
        expect(
          firstError.message,
          contains('not allowed for immutable classes'),
        );
        expect(firstError.message, contains('defaultPersist'));
      },
    );

    test(
      'when a DateTime field has a constant default value then no error is generated.',
      () {
        var modelSources = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          immutable: true
          fields:
            name: String
            when: DateTime, default=2024-05-24T22:00:00.000Z
          ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          modelSources,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isEmpty);
      },
    );

    test(
      'when an int field has a constant default value then no error is generated.',
      () {
        var modelSources = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          immutable: true
          fields:
            name: String
            count: int, default=42
          ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          modelSources,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isEmpty);
      },
    );

    test(
      'when a UuidValue field has a constant default value then no error is generated.',
      () {
        var modelSources = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          immutable: true
          fields:
            name: String
            uuid: UuidValue, default='550e8400-e29b-41d4-a716-446655440000'
          ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          modelSources,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isEmpty);
      },
    );
  });

  group('Given an immutable class with extends and non-constant default', () {
    test(
      'when a child immutable class has a field with default=now then an error is generated.',
      () {
        var modelSources = [
          ModelSourceBuilder().withYaml(
            '''
          class: ImmutableBase
          immutable: true
          fields:
            name: String
          ''',
          ).build(),
          ModelSourceBuilder().withFileName('immutable_extends').withYaml(
            '''
          class: ImmutableExtends
          immutable: true
          extends: ImmutableBase
          fields:
            version: String
            when: DateTime, default=now
          ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          modelSources,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isNotEmpty);

        var firstError = collector.errors.first as SourceSpanSeverityException;
        expect(
          firstError.message,
          contains('not allowed for immutable classes'),
        );
      },
    );

    test(
      'when a child class extending an immutable parent has default=now then an error is generated.',
      () {
        var modelSources = [
          ModelSourceBuilder().withYaml(
            '''
          class: ImmutableBase
          immutable: true
          fields:
            name: String
          ''',
          ).build(),
          ModelSourceBuilder().withFileName('mutable_extends').withYaml(
            '''
          class: MutableExtends
          extends: ImmutableBase
          fields:
            version: String
            when: DateTime, default=now
          ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          modelSources,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isNotEmpty);

        var firstError = collector.errors.first as SourceSpanSeverityException;
        expect(
          firstError.message,
          contains('not allowed for immutable classes'),
        );
      },
    );

    test(
      'when the base immutable class has a field with default=now then an error is generated.',
      () {
        var modelSources = [
          ModelSourceBuilder().withYaml(
            '''
          class: ImmutableBase
          immutable: true
          fields:
            name: String
            when: DateTime, default=now
          ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          modelSources,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isNotEmpty);

        var firstError = collector.errors.first as SourceSpanSeverityException;
        expect(
          firstError.message,
          contains('not allowed for immutable classes'),
        );
      },
    );
  });

  group('Given a non-immutable class with non-constant default values', () {
    test(
      'when a DateTime field has default=now then no error is generated.',
      () {
        var modelSources = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            name: String
            when: DateTime, default=now
          ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          modelSources,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isEmpty);
      },
    );

    test(
      'when a UuidValue field has default=random then no error is generated.',
      () {
        var modelSources = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          table: example
          fields:
            name: String
            uuid: UuidValue, default=random
          ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          modelSources,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isEmpty);
      },
    );
  });

  group(
      'Given an immutable class with table and non-constant default for defaultPersist',
      () {
    test(
      'when a DateTime field has defaultPersist=now then no error is generated.',
      () {
        var modelSources = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          immutable: true
          table: example
          fields:
            name: String
            when: DateTime?, defaultPersist=now
          ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          modelSources,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isEmpty);
      },
    );

    test(
      'when a UuidValue field has defaultPersist=random then no error is generated.',
      () {
        var modelSources = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          immutable: true
          table: example
          fields:
            name: String
            uuid: UuidValue?, defaultPersist=random
          ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          modelSources,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isEmpty);
      },
    );
  });
}
