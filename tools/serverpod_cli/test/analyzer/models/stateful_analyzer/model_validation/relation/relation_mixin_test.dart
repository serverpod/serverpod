import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group(
    'Given a tableBase class that declares an unnamed relation(field=...)',
    () {
      test(
        'when a single concrete child class extends it '
        'then no errors are collected.',
        () {
          var models = [
            ModelSourceBuilder().withYaml(
              '''
              class: Base
              tableBase: true
              fields:
                parentId: int
                parent: Parent?, relation(field=parentId)
              ''',
            ).build(),
            ModelSourceBuilder().withFileName('child').withYaml(
              '''
              class: Child
              table: child
              extends: Base
              fields:
                name: String
              ''',
            ).build(),
            ModelSourceBuilder().withFileName('parent').withYaml(
              '''
              class: Parent
              table: parent
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

          expect(collector.errors, isEmpty);
        },
      );

      test(
        'when two concrete child classes extend the same tableBase class '
        'then no errors are collected.',
        () {
          var models = [
            ModelSourceBuilder().withYaml(
              '''
              class: Base
              tableBase: true
              fields:
                parentId: int
                parent: Parent?, relation(field=parentId)
              ''',
            ).build(),
            ModelSourceBuilder().withFileName('child_one').withYaml(
              '''
              class: ChildOne
              table: child_one
              extends: Base
              fields:
                name: String
              ''',
            ).build(),
            ModelSourceBuilder().withFileName('child_two').withYaml(
              '''
              class: ChildTwo
              table: child_two
              extends: Base
              fields:
                name: String
              ''',
            ).build(),
            ModelSourceBuilder().withFileName('parent').withYaml(
              '''
              class: Parent
              table: parent
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

          expect(collector.errors, isEmpty);
        },
      );

      test(
        'when no concrete child class exists '
        'then a warning is collected.',
        () {
          var models = [
            ModelSourceBuilder().withYaml(
              '''
              class: Base
              tableBase: true
              fields:
                parentId: int
                parent: Parent?, relation(field=parentId)
              ''',
            ).build(),
            ModelSourceBuilder().withFileName('parent').withYaml(
              '''
              class: Parent
              table: parent
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
            collector.errors.whereType<SourceSpanSeverityException>().where(
              (e) => e.severity == SourceSpanSeverity.warning,
            ),
            isNotEmpty,
            reason:
                'Expected a warning — a tableBase class with no concrete '
                'table-backed subclass will never generate foreign keys.',
          );
        },
      );
    },
  );

  group(
    'Given a concrete child class that declares relation(field=inheritedFieldName)',
    () {
      test(
        'when the FK field is declared in the base class (not the child) '
        'then no errors are collected.',
        () {
          var models = [
            ModelSourceBuilder().withYaml(
              '''
              class: Base
              fields:
                parentId: int
              ''',
            ).build(),
            ModelSourceBuilder().withFileName('child').withYaml(
              '''
              class: Child
              table: child
              extends: Base
              fields:
                name: String
                parent: Parent?, relation(field=parentId)
              ''',
            ).build(),
            ModelSourceBuilder().withFileName('parent').withYaml(
              '''
              class: Parent
              table: parent
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

          expect(collector.errors, isEmpty);
        },
      );
    },
  );
}
