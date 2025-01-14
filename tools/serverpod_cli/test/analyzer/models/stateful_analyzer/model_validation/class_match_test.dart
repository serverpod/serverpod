import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  test(
      'Given multiple enums with the same name in different modules '
      'when an enum is referenced '
      'then the enum is resolved to the correct module', () {
    var modelSources = [
      ModelSourceBuilder()
          .withYaml(
            '''
        enum: CommonEnum
        values:
          - value1
          - value2
        ''',
          )
          .withModuleAlias('module1')
          .build(),
      ModelSourceBuilder()
          .withYaml(
            '''
        enum: CommonEnum
        values:
          - value1
          - value2
        ''',
          )
          .withModuleAlias('module2')
          .build(),
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        fields:
          enumField: module:module2:CommonEnum
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    var models =
        StatefulAnalyzer(config, modelSources, onErrorsCollector(collector))
            .validateAll();

    var model = models.last as ClassDefinition;
    var enumField = model.fields.first;

    expect(enumField.type.moduleAlias, 'module2');
  });

  test(
      'Given multiple classes with the same name in different modules '
      'when a class has a relation to another class '
      'then the relation is resolved to the correct module', () {
    var modelSources = [
      ModelSourceBuilder()
          .withYaml(
            '''
        class: CommonClass
        table: common_class
        fields:
          name: String
        ''',
          )
          .withModuleAlias('module1')
          .build(),
      ModelSourceBuilder()
          .withYaml(
            '''
        class: CommonClass
        table: common_class
        fields:
          name: String
        ''',
          )
          .withModuleAlias('module2')
          .build(),
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          objectRelation: module:module2:CommonClass?, relation
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    var models =
        StatefulAnalyzer(config, modelSources, onErrorsCollector(collector))
            .validateAll();

    var model = models.last as ClassDefinition;
    var relationField = model.fields.last;
    expect(relationField.type.moduleAlias, 'module2');
  });

  test(
      'Given multiple classes with the same name in different modules '
      'when a class has a list of another class '
      'then the list field is resolved to the correct module', () {
    var modelSources = [
      ModelSourceBuilder()
          .withYaml(
            '''
        class: CommonClass
        fields:
          name: String
        ''',
          )
          .withModuleAlias('module1')
          .build(),
      ModelSourceBuilder()
          .withYaml(
            '''
        class: CommonClass
        fields:
          name: String
        ''',
          )
          .withModuleAlias('module2')
          .build(),
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        fields:
          listField: List<module:module2:CommonClass>
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    var models =
        StatefulAnalyzer(config, modelSources, onErrorsCollector(collector))
            .validateAll();

    var model = models.last as ClassDefinition;
    var listField = model.fields.first;
    expect(listField.type.generics.first.moduleAlias, 'module2');
  });
}
