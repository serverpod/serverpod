import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/analyzer/entities/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/protocol_source_builder.dart';
import 'package:test/test.dart';

void main() {
  group(
      'Given a class with a named object self relation on both sides with a field references where the side without the foreign key is declared first',
      () {
    var protocols = [
      ProtocolSourceBuilder().withFileName('post').withYaml(
        '''
        class: Post
        table: post
        fields:
          content: String
          previous: Post?, relation(name=next_previous_post)
          nextId: int?
          next: Post?, relation(name=next_previous_post, field=nextId)
        indexes:
          next_index_idx:
            fields: nextId
            unique: true
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();

    var errors = collector.errors;

    test('then no errors are collected.', () {
      expect(errors, isEmpty);
    });

    var postDefinition = definitions.firstOrNull as ClassDefinition?;

    group('then the successor field relation', () {
      var field = postDefinition?.findField('next');
      var relation = field?.relation;

      test('name is null.', () {
        expect(relation?.name, isNull);
      });

      test('is foreign key origin.', () {
        expect(relation?.isForeignKeyOrigin, isTrue);
      });

      test('is of type ObjectRelationDefinition.', () {
        expect(relation.runtimeType, ObjectRelationDefinition);
      });

      test('has the parent table set to it self.', () {
        relation as ObjectRelationDefinition;

        expect(relation.parentTable, 'post');
      });

      test(
          'has the local foreign key holder set to the manually defined value.',
          () {
        relation as ObjectRelationDefinition;

        expect(relation.fieldName, 'nextId');
      });

      test('has the foreign key field set to the id.', () {
        relation as ObjectRelationDefinition;

        expect(relation.foreignFieldName, 'id');
      });
    }, skip: errors.isNotEmpty);

    group('then the predecessor field relation', () {
      var field = postDefinition?.findField('previous');
      var relation = field?.relation;

      test('name is defined', () {
        expect(relation?.name, 'next_previous_post');
      });

      test('is not foreign key origin', () {
        expect(relation?.isForeignKeyOrigin, isFalse);
      });

      test('is of type ObjectRelationDefinition', () {
        expect(relation.runtimeType, ObjectRelationDefinition);
      });

      test('has the parent table set to it self.', () {
        relation as ObjectRelationDefinition;

        expect(relation.parentTable, 'post');
      });

      test('has the local foreign key holder set to local id.', () {
        relation as ObjectRelationDefinition;

        expect(relation.fieldName, 'id');
      }, skip: definitions.isEmpty);

      test(
          'has the foreign key field set to manually defined foreign key on the other side.',
          () {
        relation as ObjectRelationDefinition;

        expect(relation.foreignFieldName, 'nextId');
      });
    }, skip: errors.isNotEmpty);

    group('then the successorId field relation', () {
      var field = postDefinition?.findField('nextId');
      var relation = field?.relation;

      test('name is defined', () {
        expect(relation?.name, 'next_previous_post');
      });

      test('is not foreign key origin', () {
        expect(relation?.isForeignKeyOrigin, isTrue);
      });

      test('is of type ForeignRelationDefinition', () {
        expect(relation.runtimeType, ForeignRelationDefinition);
      });

      test('has the parent table set to it self.', () {
        relation as ForeignRelationDefinition;

        expect(relation.parentTable, 'post');
      });

      test('has the foreign key field set to the id.', () {
        relation as ForeignRelationDefinition;

        expect(relation.foreignFieldName, 'id');
      });
    }, skip: errors.isNotEmpty);
  });

  group(
      'Given a class with a named object self relation on both sides with a field references where the side without the foreign key is declared last',
      () {
    var protocols = [
      ProtocolSourceBuilder().withFileName('user').withYaml(
        '''
        class: User
        table: user
        fields:
          name: String
          successorId: int?
          successor: User?, relation(name=user_predecessor, field=successorId)
          predecessor: User?, relation(name=user_predecessor)
        indexes:
          successor_index_idx:
            fields: successorId
            unique: true
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();

    var errors = collector.errors;

    test('then no errors are collected.', () {
      expect(errors, isEmpty);
    });

    var userDefinition = definitions.firstOrNull as ClassDefinition?;

    group('then the successor field relation', () {
      var field = userDefinition?.findField('successor');
      var relation = field?.relation;

      test('name is null', () {
        expect(relation?.name, isNull);
      });

      test('is foreign key origin', () {
        expect(relation?.isForeignKeyOrigin, isTrue);
      });

      test('is of type ObjectRelationDefinition', () {
        expect(relation.runtimeType, ObjectRelationDefinition);
      });

      test('has the parent table set to it self.', () {
        relation as ObjectRelationDefinition;

        expect(relation.parentTable, 'user');
      });

      test(
          'has the local foreign key holder set to the manually defined value.',
          () {
        relation as ObjectRelationDefinition;

        expect(relation.fieldName, 'successorId');
      });

      test('has the foreign key field set to the id.', () {
        relation as ObjectRelationDefinition;

        expect(relation.foreignFieldName, 'id');
      });
    }, skip: errors.isNotEmpty);

    group('then the predecessor field relation', () {
      var field = userDefinition?.findField('predecessor');
      var relation = field?.relation;

      test('name is defined', () {
        expect(relation?.name, 'user_predecessor');
      });

      test('is not foreign key origin', () {
        expect(relation?.isForeignKeyOrigin, isFalse);
      });

      test('is of type ObjectRelationDefinition', () {
        expect(relation.runtimeType, ObjectRelationDefinition);
      });

      test('has the parent table set to it self.', () {
        relation as ObjectRelationDefinition;

        expect(relation.parentTable, 'user');
      });

      test('has the local foreign key holder set to local id.', () {
        relation as ObjectRelationDefinition;

        expect(relation.fieldName, 'id');
      });

      test(
          'has the foreign key field set to manually defined foreign key on the other side.',
          () {
        relation as ObjectRelationDefinition;

        expect(relation.foreignFieldName, 'successorId');
      });
    }, skip: errors.isNotEmpty);

    group('then the successorId field relation', () {
      var field = userDefinition?.findField('successorId');
      var relation = field?.relation;

      test('name is defined', () {
        expect(relation?.name, 'user_predecessor');
      });

      test('is foreign key origin', () {
        expect(relation?.isForeignKeyOrigin, isTrue);
      });

      test('is of type ForeignRelationDefinition', () {
        expect(relation.runtimeType, ForeignRelationDefinition);
      });

      test('has the parent table set to it self.', () {
        relation as ForeignRelationDefinition;

        expect(relation.parentTable, 'user');
      });

      test('has the foreign key field set to the id.', () {
        relation as ForeignRelationDefinition;

        expect(relation.foreignFieldName, 'id');
      });
    }, skip: errors.isNotEmpty);
  });

  group(
      'Given a class with a named object self relation on both sides with a field references where the side without the foreign key is declared last',
      () {
    var protocols = [
      ProtocolSourceBuilder().withFileName('user').withYaml(
        '''
        class: User
        table: user
        fields:
          name: String
          parent: User?, relation(name=parent_child, optional)
          children: List<User>?, relation(name=parent_child)
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();

    var userDefinition = definitions.first as ClassDefinition;

    var errors = collector.errors;

    test('then no errors are collected.', () {
      expect(errors, isEmpty);
    });

    group('then the parent field relation', () {
      var field = userDefinition.findField('parent');
      var relation = field?.relation;

      test('name is null', () {
        expect(relation?.name, isNull);
      });

      test('is foreign key origin', () {
        expect(relation?.isForeignKeyOrigin, isTrue);
      });

      test('is of type ObjectRelationDefinition', () {
        expect(relation.runtimeType, ObjectRelationDefinition);
      });

      test('has the parent table set to it self.', () {
        relation as ObjectRelationDefinition;

        expect(relation.parentTable, 'user');
      });

      test(
          'has the local foreign key holder set to the manually defined value.',
          () {
        relation as ObjectRelationDefinition;

        expect(relation.fieldName, 'parentId');
      });

      test('has the foreign key field set to the id.', () {
        relation as ObjectRelationDefinition;

        expect(relation.foreignFieldName, 'id');
      });
    });

    group('then the predecessor field relation', () {
      var field = userDefinition.findField('children');
      var relation = field?.relation;

      test('name is defined', () {
        expect(relation?.name, 'parent_child');
      });

      test('is not foreign key origin', () {
        expect(relation?.isForeignKeyOrigin, isFalse);
      });

      test('is of type ObjectRelationDefinition', () {
        expect(relation.runtimeType, ListRelationDefinition);
      });

      test('has the foreign key field set to the foreign key field holder.',
          () {
        relation as ListRelationDefinition;

        expect(relation.foreignFieldName, 'parentId');
      });
    });

    group('then the successorId field relation', () {
      var field = userDefinition.findField('parentId');
      var relation = field?.relation;

      test('name is defined', () {
        expect(relation?.name, 'parent_child');
      });

      test('is foreign key origin', () {
        expect(relation?.isForeignKeyOrigin, isTrue);
      });

      test('is of type ForeignRelationDefinition', () {
        expect(relation.runtimeType, ForeignRelationDefinition);
      });

      test('has the parent table set to it self.', () {
        relation as ForeignRelationDefinition;

        expect(relation.parentTable, 'user');
      });

      test('has the foreign key field set to the id.', () {
        relation as ForeignRelationDefinition;

        expect(relation.foreignFieldName, 'id');
      });
    });
  });
}
