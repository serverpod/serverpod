import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_source_builder.dart';


void main() {
  test('Given no change in default id type, the id of the table is int.', () {
    var yamlSource = ModelSourceBuilder().withYaml(
      '''
      class: Example
      table: example
      fields:
        name: String
      ''',
    ).build();

    var config = GeneratorConfigBuilder().build();
    var statefulAnalyzer = StatefulAnalyzer(config, [yamlSource]);
    var model = statefulAnalyzer.validateAll().first as ModelClassDefinition;

    expect(model.idField.type.className, 'int');
  });

  for (var idType in SupportedIdType.all) {
    var idClassName = idType.className;
    var idTypeAlias = idType.aliases.first;

    group('Given the default id type is $idTypeAlias', () {
      var yamlSource = ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          name: String
        ''',
      ).build();

      var collector = CodeGenerationCollector();
      var config = GeneratorConfigBuilder().withDefaultIdType(idType).build();
      var statefulAnalyzer = StatefulAnalyzer(config, [yamlSource]);
      var model = statefulAnalyzer.validateAll().first as ModelClassDefinition;
      var errors = collector.errors;

      test('then no errors are collected.', () {
        expect(errors, isEmpty);
      });

      test("then the id of the table is '$idClassName'.", () {
        expect(model.idField.type.className, idClassName);
      }, skip: errors.isNotEmpty);

      var expectedDefaultValue = idType.defaultValue;
      test("then the default model value is '$expectedDefaultValue'", () {
        expect(model.idField.defaultModelValue, expectedDefaultValue);
      }, skip: errors.isNotEmpty);

      test("then the default persist value is '$expectedDefaultValue'", () {
        expect(model.idField.defaultPersistValue, expectedDefaultValue);
      }, skip: errors.isNotEmpty);
    });
  }
}
