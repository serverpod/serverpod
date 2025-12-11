import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
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
    group('When column override experimental feature is NOT enabled', () {
      var config = GeneratorConfigBuilder().withName(projectName).build();

      test(
        'Given a class with a field with a column name override, then an error is collected.',
        () {
          var models = [
            ModelSourceBuilder().withYaml(
              '''
          class: Example
          table: example
          fields:
            name: String, column=user_name
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
            reason: 'Expected an error but none was generated.',
          );

          var error = collector.errors.first;
          expect(
            error.message,
            'The "column" property is not allowed for name type. Valid keys are {type, parent, relation, scope, persist, required, database, api, default, defaultModel, defaultPersist}.',
          );
        },
      );
    });

    group('When column override experimental feature IS enabled', () {
      var config = GeneratorConfigBuilder()
          .withName(projectName)
          .withEnabledExperimentalFeatures([
            ExperimentalFeature.columnOverride,
          ])
          .build();
      const noColumnFieldName = 'name';
      const columnFieldName = 'userName';
      const columnName = 'user_name';
      const fieldType = 'String';
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            $noColumnFieldName: $fieldType
            $columnFieldName: $fieldType, column=$columnName
          ''',
        ).build(),
      ];
      var collector = CodeGenerationCollector();
      var definitions = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      test('then no errors are collected.', () {
        expect(
          collector.errors,
          isEmpty,
          reason: 'Expected no errors but some were generated.',
        );
        expect(definitions, isNotEmpty);
      });

      test(
        'Given a class with a duplicated column name, then an error is collected.',
        () {
          const columnName = 'field_one';
          var models = [
            ModelSourceBuilder().withYaml(
              '''
          class: Example
          table: example
          fields:
            fieldOne: String, column=$columnName
            fieldTwo: String, column=$columnName
          ''',
            ).build(),
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
            reason:
                'Expected an error to be collected, but none was generated.',
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

      test(
        'Given a class with an explicit column name matching a field name, '
        'then an error is collected.',
        () {
          const columnName = 'user';
          var models = [
            ModelSourceBuilder().withYaml(
              '''
          class: Example
          table: example
          fields:
            $columnName: String
            ${columnName}Name: String, column=$columnName
          ''',
            ).build(),
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
            reason:
                'Expected an error to be collected, but none was generated.',
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

      test('Given a class with an explicit column name longer than 61 characters, '
          'then an error is collected.', () {
        const column =
            'thisNameIsExactly62CharsLongAndThereforeInvalidAsTheColumnName';
        var models = [
          ModelSourceBuilder().withYaml(
            '''
        class: Example
        table: example
        fields:
          longField: String, column=$column
        ''',
          ).build(),
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
          'The column name "$column" exceeds the 61 character column name limitation.',
          reason:
              'Expected the error message to indicate an explicit column name is too long.',
        );
      });

      test(
        'Given a class without a table definition but with a field with a column name override, '
        'then no error is collected.',
        () {
          var models = [
            ModelSourceBuilder().withYaml(
              '''
          class: Example
          fields:
            name: String, column=user_name
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
        'Given a class with a declared id field with a column name override, '
        'then an error is collected.',
        () {
          var models = [
            ModelSourceBuilder().withYaml(
              '''
          class: Example
          table: example
          fields:
            id: int?, column=user_id
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
                'Expected an error to be collected when column used on id field, '
                'but none was generated.',
          );

          expect(
            collector.errors.first.message,
            'The "column" key is not allowed on the "id" field.',
          );
        },
      );

      test(
        'Given a class with a symbolic relationship with a column name override, '
        'then an error is collected.',
        () {
          var models = [
            ModelSourceBuilder().withFileName('example').withYaml(
              '''
          class: Example
          table: example
          fields:
            id: int?
            company: Company?, relation, column=company_id
          ''',
            ).build(),
            ModelSourceBuilder().withFileName('company').withYaml(
              '''
        class: Company
        table: company
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
            collector.errors,
            isNotEmpty,
            reason:
                'Expected an error to be collected when column used on symbolic relation field, '
                'but none was generated.',
          );

          expect(
            collector.errors.first.message,
            'The "column" key is only allowed on a foreign key relation field.',
          );
        },
      );
    });
  });
}
