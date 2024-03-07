import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  var config = GeneratorConfigBuilder().withAuthModule().build();
  group('Given a class referencing a module class with a relation.', () {
    var models = [
      ModelSourceBuilder()
          .withModuleAlias('auth')
          .withFileName('user_info')
          .withYaml(
        '''
        class: UserInfo
        table: serverpod_user_info
        fields:
          nickname: String
        ''',
      ).build(),
      ModelSourceBuilder().withFileName('profile').withYaml(
        '''
        class: Profile
        table: profile
        fields:
          name: String
          user: module:auth:UserInfo?, relation
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    );
    var entities = analyzer.validateAll();
    var errors = collector.errors;

    test('then no errors are collected.', () {
      expect(errors, isEmpty);
    });

    test('then a relation is created on the local module', () {
      var classDefinition = entities.firstWhere((e) => e.className == 'Profile')
          as ClassDefinition;

      var relation = classDefinition.fields.last.relation;

      expect(relation.runtimeType, ObjectRelationDefinition);
    });
  });

  test(
      'Given a class referencing a module class with a relation then an error is reported that direct list relations are not allowed.',
      () {
    var models = [
      ModelSourceBuilder()
          .withModuleAlias('auth')
          .withFileName('user_info')
          .withYaml(
        '''
        class: UserInfo
        table: serverpod_user_info
        fields:
          nickname: String
        ''',
      ).build(),
      ModelSourceBuilder().withFileName('profile').withYaml(
        '''
        class: Profile
        table: profile
        fields:
          name: String
          user: List<module:auth:UserInfo>?, relation
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
    var errors = collector.errors;

    expect(errors, isNotEmpty);

    expect(
      errors.first.message,
      'A List relation is not allowed on module tables.',
    );
  });

  group('Given a class referencing a module table with a parent relation.', () {
    var models = [
      ModelSourceBuilder()
          .withModuleAlias('auth')
          .withFileName('user_info')
          .withYaml(
        '''
        class: UserInfo
        table: serverpod_user_info
        fields:
          nickname: String
        ''',
      ).build(),
      ModelSourceBuilder().withFileName('profile').withYaml(
        '''
        class: Profile
        table: profile
        fields:
          name: String
          userId: int, relation(parent=serverpod_user_info)
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    );
    var entities = analyzer.validateAll();
    var errors = collector.errors;

    test('then no errors are collected.', () {
      expect(errors, isEmpty);
    });

    test('then a foreign relation is created to the module', () {
      var classDefinition = entities.firstWhere((e) => e.className == 'Profile')
          as ClassDefinition;

      var relation = classDefinition.fields.last.relation;

      expect(relation.runtimeType, ForeignRelationDefinition);
    });
  });
}
