import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group('Given Decimal type fields when analyzing', () {
    test(
      'Given a class with a Decimal field when analyzing then the field is parsed as Decimal.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          fields:
            amount: Decimal
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
        expect(definition.fields, isNotEmpty);
        expect(definition.fields.first.type.className, 'Decimal');
        expect(definition.fields.first.type.nullable, isFalse);
      },
    );

    test(
      'Given a class with a nullable Decimal field when analyzing then the field is parsed as nullable Decimal.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          fields:
            amount: Decimal?
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
        expect(definition.fields, isNotEmpty);
        expect(definition.fields.first.type.className, 'Decimal');
        expect(definition.fields.first.type.nullable, isTrue);
      },
    );

    test(
      'Given a class with a generic Decimal type when analyzing then an error is reported.',
      () {
        var models = [
          ModelSourceBuilder().withYaml(
            '''
          class: Example
          fields:
            amount: Decimal<String>
          ''',
          ).build(),
        ];

        var collector = CodeGenerationCollector();
        StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();

        expect(collector.errors, isNotEmpty);
        expect(
          collector.errors.first.message,
          'The type "Decimal" cannot have generic types defined.',
        );
      },
    );
  });
}
