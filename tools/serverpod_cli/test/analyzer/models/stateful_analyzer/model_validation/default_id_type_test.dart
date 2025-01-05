import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

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
    var model = statefulAnalyzer.validateAll().first as ClassDefinition;

    expect(model.idField.type.isIntIdType, true);
  });

  for (var idType in TypeDefinition.validIdTypes) {
    var idClassName = idType.className;

    test(
        'Given the default id type is $idClassName, the id of the table is $idClassName.',
        () {
      var yamlSource = ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          name: String
        ''',
      ).build();

      var config = GeneratorConfigBuilder().withDefaultIdType(idType).build();
      var statefulAnalyzer = StatefulAnalyzer(config, [yamlSource]);
      var model = statefulAnalyzer.validateAll().first as ClassDefinition;

      expect(model.idField.type.className, idClassName);
    });
  }
}
