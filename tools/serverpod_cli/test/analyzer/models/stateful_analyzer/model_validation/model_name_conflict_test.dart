import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:test/test.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  test(
      'Given an enum with the same name defined in a module and then '
      'the project (order matters) '
      'when that enum is referenced '
      'then the type is resolved to the correct module', () {
    var commonEnumName = 'CommonEnum';
    var firstModuleAlias = 'module1';
    var modelSources = [
      ModelSourceBuilder()
          .withYaml(
            '''
        enum: $commonEnumName
        values:
          - value1
          - value2
        ''',
          )
          .withFileName('common_enum.yaml')
          .withModuleAlias(firstModuleAlias)
          .build(),
      ModelSourceBuilder()
          .withYaml(
            '''
        enum: $commonEnumName
        values:
          - value1
          - value2
        ''',
          )
          .withFileName('common_enum.yaml')
          .withModuleAlias(defaultModuleAlias)
          .build(),
      ModelSourceBuilder()
          .withYaml(
            '''
        class: Example
        fields:
          enumField: $commonEnumName
        ''',
          )
          .withModuleAlias(defaultModuleAlias)
          .build(),
    ];

    var collector = CodeGenerationCollector();
    var models =
        StatefulAnalyzer(config, modelSources, onErrorsCollector(collector))
            .validateAll();

    var model = models.last as ClassDefinition;
    var enumField = model.fields.first;

    expect(enumField.type.enumDefinition, isA<EnumDefinition>());

    expect(enumField.type.enumDefinition?.moduleAlias, defaultModuleAlias);
  });

  test(
      'Given a class with the same name defined in a module and then '
      'the project (order matters) '
      'when that class is referenced in a relation '
      'then the relation is resolved to the correct module', () {
    var commonClassName = 'CommonClass';
    var firstModuleAlias = 'module1';
    var modelSources = [
      ModelSourceBuilder()
          .withYaml(
            '''
        class: $commonClassName
        table: common_class_$firstModuleAlias
        fields:
          name: String
        ''',
          )
          .withFileName('common_class.yaml')
          .withModuleAlias(firstModuleAlias)
          .build(),
      ModelSourceBuilder()
          .withYaml(
            '''
        class: $commonClassName
        table: common_class_$defaultModuleAlias
        fields:
          name: String
        ''',
          )
          .withFileName('common_class.yaml')
          .withModuleAlias(defaultModuleAlias)
          .build(),
      ModelSourceBuilder()
          .withYaml(
            '''
        class: Example
        table: example
        fields:
          objectRelation: $commonClassName?, relation
        ''',
          )
          .withModuleAlias(defaultModuleAlias)
          .build(),
    ];

    var collector = CodeGenerationCollector();
    var models =
        StatefulAnalyzer(config, modelSources, onErrorsCollector(collector))
            .validateAll();

    var model = models.last as ClassDefinition;
    var fieldType = model.fields.last.relation as ObjectRelationDefinition;
    expect(fieldType.parentTable, 'common_class_$defaultModuleAlias');
  });

  test(
      'Given an enum with the same name defined in different modules (order matters)'
      'when that enum is referenced '
      'then the type is resolved to the correct module', () {
    var commonEnumName = 'CommonEnum';
    var firstModuleAlias = 'module1';
    var secondModuleAlias = 'module2';
    var modelSources = [
      ModelSourceBuilder()
          .withYaml(
            '''
        enum: $commonEnumName
        values:
          - value1
          - value2
        ''',
          )
          .withFileName('common_enum.yaml')
          .withModuleAlias(firstModuleAlias)
          .build(),
      ModelSourceBuilder()
          .withYaml(
            '''
        enum: $commonEnumName
        values:
          - value1
          - value2
        ''',
          )
          .withFileName('common_enum.yaml')
          .withModuleAlias(secondModuleAlias)
          .build(),
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        fields:
          enumField: module:$secondModuleAlias:$commonEnumName
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    var models =
        StatefulAnalyzer(config, modelSources, onErrorsCollector(collector))
            .validateAll();

    var model = models.last as ClassDefinition;
    var enumField = model.fields.first;

    expect(enumField.type.enumDefinition, isA<EnumDefinition>());

    expect(enumField.type.enumDefinition?.moduleAlias, secondModuleAlias);
  });

  test(
      'Given a class with the same name defined in different modules (order matters) '
      'when that class is referenced in a relation '
      'then the relation is resolved to the correct module', () {
    var commonClassName = 'CommonClass';
    var firstModuleAlias = 'module1';
    var secondModuleAlias = 'module2';
    var modelSources = [
      ModelSourceBuilder()
          .withYaml(
            '''
        class: $commonClassName
        table: common_class_$firstModuleAlias
        fields:
          name: String
        ''',
          )
          .withFileName('common_class.yaml')
          .withModuleAlias(firstModuleAlias)
          .build(),
      ModelSourceBuilder()
          .withYaml(
            '''
        class: $commonClassName
        table: common_class_$secondModuleAlias
        fields:
          name: String
        ''',
          )
          .withFileName('common_class.yaml')
          .withModuleAlias(secondModuleAlias)
          .build(),
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          objectRelation: module:$secondModuleAlias:$commonClassName?, relation
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    var models =
        StatefulAnalyzer(config, modelSources, onErrorsCollector(collector))
            .validateAll();

    var model = models.last as ClassDefinition;
    var fieldType = model.fields.last.relation as ObjectRelationDefinition;
    expect(fieldType.parentTable, 'common_class_$secondModuleAlias');
  });
}
