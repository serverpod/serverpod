import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/analyzer/entities/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/protocol_source_builder.dart';
import 'package:test/test.dart';

void main() {
  group('Given a class referencing a module class with a relation.', () {
    var protocols = [
      ProtocolSourceBuilder()
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
      ProtocolSourceBuilder().withFileName('profile').withYaml(
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
      protocols,
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
}
