import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  var config = GeneratorConfigBuilder().withEnabledExperimentalFeatures(
      [ExperimentalFeature.changeIdType]).build();

  test('Given a model with no id type clause, then the id of the table is int.',
      () {
    var yamlSource = ModelSourceBuilder().withYaml(
      '''
      class: Example
      table: example
      fields:
        name: String
      ''',
    ).build();
    var statefulAnalyzer = StatefulAnalyzer(config, [yamlSource]);
    var model = statefulAnalyzer.validateAll().first as ClassDefinition;

    expect(model.idField.type.className, 'int');
  });

  for (var idType in SupportedIdType.all) {
    var idClassName = idType.className;
    var idTypeAlias = idType.aliases.first;

    group('Given a class with the id type set to $idClassName', () {
      var yamlSource = ModelSourceBuilder().withYaml(
        '''
        class: Example
        idType: $idTypeAlias
        table: example
        fields:
          name: String
        ''',
      ).build();

      var collector = CodeGenerationCollector();
      var statefulAnalyzer = StatefulAnalyzer(config, [yamlSource]);
      var model = statefulAnalyzer.validateAll().first as ClassDefinition;
      var errors = collector.errors;

      test('then no errors are collected.', () {
        expect(errors, isEmpty);
      });

      test("then the id of the table is '$idClassName'.", () {
        expect(model.idField.type.className, idClassName);
      }, skip: errors.isNotEmpty);

      var expectedDefaultValue = idType.dbColumnDefaultBuilder('example');
      test("then the default persist value is '$expectedDefaultValue'", () {
        expect(model.idField.defaultPersistValue, expectedDefaultValue);
      }, skip: errors.isNotEmpty);
    });
  }
}
