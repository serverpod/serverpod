import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group('Given a class with serverOnly scoped fields with default values', () {
    test(
      'when the field is serverOnly with default value, then no validation errors are generated',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          fields:
            serverOnlyField: int?, scope=serverOnly, default=-1
          ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        var definitions =
            StatefulAnalyzer(config, models, onErrorsCollector(collector))
                .validateAll();

        expect(collector.errors, isEmpty);

        var definition = definitions.first as ClassDefinition;
        expect(
          definition.fields.last.defaultModelValue,
          '-1',
        );
        expect(
          definition.fields.last.scope,
          ModelFieldScopeDefinition.serverOnly,
        );
      },
    );

    test(
      'when the field is serverOnly with string default value, then the field should have the correct default value',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          fields:
            serverMessage: String?, scope=serverOnly, default='Server only message'
          ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        var definitions =
            StatefulAnalyzer(config, models, onErrorsCollector(collector))
                .validateAll();

        expect(collector.errors, isEmpty);

        var definition = definitions.first as ClassDefinition;
        expect(
          definition.fields.last.defaultModelValue,
          "'Server only message'",
        );
      },
    );

    test(
      'when multiple fields have different scopes and defaults, then all are validated correctly',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          fields:
            normalField: String, default='Normal message'
            serverOnlyField: int?, scope=serverOnly, default=42
            allScopeField: bool?, scope=all, default=true
          ''',
          ).build()
        ];

        var collector = CodeGenerationCollector();
        var definitions =
            StatefulAnalyzer(config, models, onErrorsCollector(collector))
                .validateAll();

        expect(collector.errors, isEmpty);

        var definition = definitions.first as ClassDefinition;
        expect(definition.fields.length, 3);

        // Check normal field
        expect(definition.fields[0].defaultModelValue, "'Normal message'");
        expect(definition.fields[0].scope, ModelFieldScopeDefinition.all);

        // Check serverOnly field
        expect(definition.fields[1].defaultModelValue, '42');
        expect(
            definition.fields[1].scope, ModelFieldScopeDefinition.serverOnly);

        // Check all scope field
        expect(definition.fields[2].defaultModelValue, 'true');
        expect(definition.fields[2].scope, ModelFieldScopeDefinition.all);
      },
    );
  });
}
