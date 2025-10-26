import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  group('Given a class with an explicit column name', () {
    const noColumnFieldName = 'name';
    const columnFieldName = 'userName';
    const columnName = 'user_name';
    const fieldType = 'String';
    var models = [
      ModelSourceBuilder().withYaml(
        '''
          class: Example
          fields:
            $noColumnFieldName: $fieldType
            $columnFieldName: $fieldType, column=$columnName
          ''',
      ).build()
    ];
    var collector = CodeGenerationCollector();
    var definitions =
        StatefulAnalyzer(config, models, onErrorsCollector(collector))
            .validateAll();

    test('then no errors are collected.', () {
      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors but some were generated.',
      );
      expect(definitions, isNotEmpty);
    });
  });

  test(
    'Given a class with a duplicated column name, then an error is collected.',
    () {
      const columnName = 'field_one';
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields:
            fieldOne: String, column=$columnName
            fieldTwo: String, column=$columnName
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error to be collected, but none was generated.',
      );

      var error = collector.errors.first;

      expect(
        error.message,
        'The column "$columnName" should only be used for a single field.',
        reason:
            'Expected the error message to indicate a column should only be '
            'used for a single field.',
      );
    },
  );
}
