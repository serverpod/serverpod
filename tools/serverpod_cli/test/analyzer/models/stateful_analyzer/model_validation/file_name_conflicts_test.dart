import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group('Given two models with the same generated file path when analyzing',
      () {
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
          .withYamlSourcePathParts(['lib', 'src', 'protocol']).withYaml(
        '''
        class: MySecondModel
        fields:
          name: String
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer(config, modelSources, onErrorsCollector(collector))
        .validateAll();

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
        'File collision with "MySecondModel" was detected for the generated model, please provide a unique path or filename for the model.',
      );
    });
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
      ).build(),
      ModelSourceBuilder().withFileName('example').withYaml(
        '''
        class: ModuleModel
        fields:
          name: String
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer(config, modelSources, onErrorsCollector(collector))
        .validateAll();

    test('then no error is collected.', () {
      expect(
        collector.errors,
        isEmpty,
      );
    });
  });
}
