import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group('Given two models with the same generated file path when analyzing', () {
    var modelSources = [
      ModelSourceBuilder()
          .withFileName('example')
          .withYamlSourcePathParts(['lib', 'src'])
          .withFileExtension('.spy.yaml')
          .withYaml(
            '''
        class: MyFirstModel
        fields:
          name: String
        ''',
          )
          .build(),
      ModelSourceBuilder()
          .withFileName('example')
          .withYamlSourcePathParts(['lib', 'src', 'protocol'])
          .withYaml(
            '''
        class: MySecondModel
        fields:
          name: String
        ''',
          )
          .build(),
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer(
      config,
      modelSources,
      onErrorsCollector(collector),
    ).validateAll();

    test('then errors are collected for each file.', () {
      expect(
        collector.errors,
        hasLength(2),
        reason: 'Expected an error but none was generated.',
      );
    });

    test(
      'then error informs the user that there is a generated file collision.',
      () {
        var error = collector.errors.first;
        expect(
          error.message,
          'File path collision detected: This model and "module/protocol/lib/src/protocol/example.yaml" would generate files at the same location. Please modify the path or filename to ensure each model generates to a unique location.',
        );
      },
    );
  });

  group(
    'Given a project model and a module model with the same generated file path when analyzing',
    () {
      var modelSources = [
        ModelSourceBuilder()
            .withModuleAlias('my_module')
            .withFileName('example')
            .withYaml(
              '''
        class: ProjectModel
        fields:
          name: String
        ''',
            )
            .build(),
        ModelSourceBuilder().withFileName('example').withYaml(
          '''
        class: ModuleModel
        fields:
          name: String
        ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        modelSources,
        onErrorsCollector(collector),
      ).validateAll();

      test('then no error is collected.', () {
        expect(
          collector.errors,
          isEmpty,
        );
      });
    },
  );

  for (var fileName in ['client', 'endpoints', 'protocol']) {
    group(
      'Given a model with the reserved file name "$fileName" when analyzing',
      () {
        late final modelSources = [
          ModelSourceBuilder().withFileName(fileName).withYaml(
            '''
        class: Whatever
        fields:
          name: String
        ''',
          ).build(),
        ];

        late final collector = CodeGenerationCollector();

        setUp(() {
          StatefulAnalyzer(
            config,
            modelSources,
            onErrorsCollector(collector),
          ).validateAll();
        });

        test(
          'then an error informs the user that there is a generated file collision.',
          () {
            var error = collector.errors.first;
            expect(
              error.message,
              'The file name "$fileName" is reserved and cannot be used.',
            );
          },
        );
      },
    );
  }
}
