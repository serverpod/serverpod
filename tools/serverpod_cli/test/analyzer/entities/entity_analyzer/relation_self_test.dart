import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/analyzer/entities/entity_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/protocol_helper.dart';
import 'package:test/test.dart';


void main() {
  group(
      'Given a class with a named object relation on both sides with a field references',
      () {
    var collector = CodeGenerationCollector();

    var protocol1 = ProtocolSource(
      '''
      class: Post
      table: post
      fields:
        content: String
        previous: Post?, relation(name=next_previous_post)
        nextId: int?
        next: Post?, relation(name=next_previous_post, field=nextId)
      ''',
      Uri(path: 'lib/src/protocol/user.yaml'),
      [],
    );

    var definition1 = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol1,
    );

    var entities = [definition1!];

    SerializableEntityAnalyzer.resolveEntityDependencies(entities);

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol1.yaml,
      protocol1.yamlSourceUri.path,
      collector,
      definition1,
      entities,
    );

    var userDefinition = definition1 as ClassDefinition;

    var errors = collector.errors;

    test('then no errors are collected.', () {
      expect(errors, isEmpty);
    });

    group('then the successor field relation', () {
      var field = userDefinition.findField('next');
      var relation = field?.relation;

      test('is of type ObjectRelationDefinition', () {
        expect(relation.runtimeType, ObjectRelationDefinition);
      });

      test('name is null', () {
        expect(relation?.name, isNull);
      });

      // todo fill out
    });

    group('then the predecessor field relation', () {
      var field = userDefinition.findField('previous');
      var relation = field?.relation;

      test('is of type ObjectRelationDefinition', () {
        expect(relation.runtimeType, ObjectRelationDefinition);
      });

      test('name is defined', () {
        expect(relation?.name, 'next_previous_post');
      });

      // todo fill out
    });

    group('then the successorId field relation', () {
      var field = userDefinition.findField('nextId');
      var relation = field?.relation;

      test('is of type ForeignRelationDefinition', () {
        expect(relation.runtimeType, ForeignRelationDefinition);
      });

      test('name is defined', () {
        expect(relation?.name, 'next_previous_post');
      });

      // todo fill out
    });
  });


  group(
      'Given a class with a named object relation on both sides with a field references',
      () {
    var collector = CodeGenerationCollector();

    var protocol1 = ProtocolSource(
      '''
      class: User
      table: user
      fields:
        name: String
        successorId: int?
        successor: User?, relation(name=user_predecessor, field=successorId)
        predecessor: User?, relation(name=user_predecessor)
      ''',
      Uri(path: 'lib/src/protocol/user.yaml'),
      [],
    );

    var definition1 = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol1,
    );

    var entities = [definition1!];

    SerializableEntityAnalyzer.resolveEntityDependencies(entities);

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol1.yaml,
      protocol1.yamlSourceUri.path,
      collector,
      definition1,
      entities,
    );

    var userDefinition = definition1 as ClassDefinition;

    var errors = collector.errors;

    test('then no errors are collected.', () {
      expect(errors, isEmpty);
    });

    group('then the successor field relation', () {
      var field = userDefinition.findField('successor');
      var relation = field?.relation;

      test('is of type ObjectRelationDefinition', () {
        expect(relation.runtimeType, ObjectRelationDefinition);
      });

      test('name is null', () {
        expect(relation?.name, isNull);
      });

      // todo fill out
    });

    group('then the predecessor field relation', () {
      var field = userDefinition.findField('predecessor');
      var relation = field?.relation;

      test('is of type ObjectRelationDefinition', () {
        expect(relation.runtimeType, ObjectRelationDefinition);
      });

      test('name is defined', () {
        expect(relation?.name, 'user_predecessor');
      });

      // todo fill out
    });

    group('then the successorId field relation', () {
      var field = userDefinition.findField('successorId');
      var relation = field?.relation;

      test('is of type ForeignRelationDefinition', () {
        expect(relation.runtimeType, ForeignRelationDefinition);
      });

      test('name is defined', () {
        expect(relation?.name, 'user_predecessor');
      });

      // todo fill out
    });
  });
}
