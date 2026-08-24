import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().withEnabledExperimentalFeatures([
    ExperimentalFeature.databaseSync,
  ]).build();

  var crdtScopeModel = ModelSourceBuilder().withFileName('crdt_scope').withYaml(
    '''
    class: CrdtScope
    table: crdt_scopes
    database: all
    fields:
      name: String
    ''',
  ).build();

  ModelSource personModel({
    String id = 'id: UuidValue?, defaultPersist=random_v7',
    String scopeId =
        'scopeId: int?, relation(parent=crdt_scopes, onDelete=Cascade)',
    String extraFields = '',
    Map<String, String> uniqueIndexes = const {},
  }) {
    var indexes = [
      if (uniqueIndexes.isNotEmpty) 'indexes:',
      for (var MapEntry(key: name, value: fields) in uniqueIndexes.entries)
        '  $name:\n    fields: $fields\n    unique: true',
    ].join('\n');

    return ModelSourceBuilder().withFileName('person').withYaml(
      '''
class: Person
table: person
database: sync
fields:
  $id
  $scopeId
  name: String
  $extraFields
$indexes
''',
    ).build();
  }

  List<String> validate(List<ModelSource> models) {
    var collector = CodeGenerationCollector();
    StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    ).validateAll();
    return collector.errors.map((e) => e.message).toList();
  }

  group('Given a model with "database: sync"', () {
    test(
      'that satisfies all sync restrictions when validating then no error is '
      'generated.',
      () {
        var errors = validate([
          crdtScopeModel,
          personModel(
            extraFields:
                'parent: Person?, relation(optional, onDelete=Cascade, deferred)',
            uniqueIndexes: {'person_name_idx': 'scopeId, name'},
          ),
        ]);

        expect(errors, isEmpty);
      },
    );

    test(
      'with an int primary key when validating then an error is generated.',
      () {
        var errors = validate([
          crdtScopeModel,
          personModel(id: 'id: int?, defaultPersist=serial'),
        ]);

        expect(errors, [
          'Tables with "database: sync" must have a UUID primary key. '
              'Declare the id field as '
              '"id: UuidValue?, defaultPersist=random_v7".',
        ]);
      },
    );

    test(
      'without a scopeId field when validating then an error is generated.',
      () {
        var errors = validate([crdtScopeModel, personModel(scopeId: '')]);

        expect(errors, [
          'Tables with "database: sync" must declare the field '
              '"scopeId: int?, relation(parent=crdt_scopes, onDelete=Cascade)".',
        ]);
      },
    );

    test(
      'with a non-nullable scopeId field when validating then an error is '
      'generated.',
      () {
        var errors = validate([
          crdtScopeModel,
          personModel(
            scopeId:
                'scopeId: int, relation(parent=crdt_scopes, onDelete=Cascade)',
          ),
        ]);

        expect(errors, [
          'The "scopeId" field must be of type "int?" on tables with '
              '"database: sync".',
        ]);
      },
    );

    test(
      'with a scopeId field without a relation when validating then an error '
      'is generated.',
      () {
        var errors = validate([
          crdtScopeModel,
          personModel(scopeId: 'scopeId: int?'),
        ]);

        expect(errors, [
          'The "scopeId" field must declare the relation '
              '"relation(parent=crdt_scopes, onDelete=Cascade)" on tables '
              'with "database: sync".',
        ]);
      },
    );

    test(
      'with a scopeId relation that does not cascade on delete when validating '
      'then an error is generated.',
      () {
        var errors = validate([
          crdtScopeModel,
          personModel(
            scopeId:
                'scopeId: int?, relation(parent=crdt_scopes, onDelete=NoAction)',
          ),
        ]);

        expect(errors, [
          'The "scopeId" relation must use "onDelete=Cascade".',
        ]);
      },
    );

    test(
      'with a deferred scopeId relation when validating then an error is '
      'generated.',
      () {
        var errors = validate([
          crdtScopeModel,
          personModel(
            scopeId:
                'scopeId: int?, relation(parent=crdt_scopes, onDelete=Cascade, deferred)',
          ),
        ]);

        expect(errors, [
          'The "scopeId" relation must not be deferrable or deferred.',
        ]);
      },
    );
  });

  group('Given a model with "database: sync" with a relation', () {
    test(
      'to another sync table that is not deferred when validating then an '
      'error is generated.',
      () {
        var errors = validate([
          crdtScopeModel,
          personModel(extraFields: 'parent: Person?, relation(optional)'),
        ]);

        expect(errors, [
          'Relations on tables with "database: sync" must be deferred. Add '
              'the "deferred" keyword to the relation.',
        ]);
      },
    );

    test(
      'to another sync table that is only deferrable when validating then an '
      'error is generated.',
      () {
        var errors = validate([
          crdtScopeModel,
          personModel(
            extraFields: 'parent: Person?, relation(optional, deferrable)',
          ),
        ]);

        expect(errors, [
          'Relations on tables with "database: sync" must be deferred. Add '
              'the "deferred" keyword to the relation.',
        ]);
      },
    );

    test(
      'declared on an id field to another sync table that is not deferred '
      'when validating then an error is generated.',
      () {
        var errors = validate([
          crdtScopeModel,
          personModel(
            extraFields: 'parentId: UuidValue?, relation(parent=person)',
          ),
        ]);

        expect(errors, [
          'Relations on tables with "database: sync" must be deferred. Add '
              'the "deferred" keyword to the relation.',
        ]);
      },
    );

    test(
      'declared on an id field to another sync table that is deferred when '
      'validating then no error is generated.',
      () {
        var errors = validate([
          crdtScopeModel,
          personModel(
            extraFields:
                'parentId: UuidValue?, relation(parent=person, deferred)',
          ),
        ]);

        expect(errors, isEmpty);
      },
    );

    test(
      'to a table without "database: sync" when validating then an error is '
      'generated.',
      () {
        var errors = validate([
          crdtScopeModel,
          ModelSourceBuilder().withFileName('company').withYaml(
            '''
            class: Company
            table: company
            database: all
            fields:
              name: String
            ''',
          ).build(),
          personModel(
            extraFields: 'company: Company?, relation(optional, deferred)',
          ),
        ]);

        expect(errors, [
          'Tables with "database: sync" can only have relations to other '
              'tables with "database: sync". The related class "Company" '
              'has "database: all".',
        ]);
      },
    );

    test(
      'declared on an id field to a table without "database: sync" when '
      'validating then an error is generated.',
      () {
        var errors = validate([
          crdtScopeModel,
          ModelSourceBuilder().withFileName('company').withYaml(
            '''
            class: Company
            table: company
            database: all
            fields:
              name: String
            ''',
          ).build(),
          personModel(
            extraFields: 'companyId: int?, relation(parent=company, deferred)',
          ),
        ]);

        expect(errors, [
          'Tables with "database: sync" can only have relations to other '
              'tables with "database: sync". The related class "Company" '
              'has "database: all".',
        ]);
      },
    );
  });

  group('Given a model without "database: sync" with a relation', () {
    test(
      'to a sync table when validating then an error is generated.',
      () {
        var errors = validate([
          crdtScopeModel,
          personModel(),
          ModelSourceBuilder().withFileName('company').withYaml(
            '''
            class: Company
            table: company
            database: all
            fields:
              name: String
              owner: Person?, relation(optional)
            ''',
          ).build(),
        ]);

        expect(errors, [
          'Tables without "database: sync" cannot have relations to tables '
              'with "database: sync". The related class "Person" has '
              '"database: sync".',
        ]);
      },
    );

    test(
      'declared on an id field to a sync table when validating then an error '
      'is generated.',
      () {
        var errors = validate([
          crdtScopeModel,
          personModel(),
          ModelSourceBuilder().withFileName('company').withYaml(
            '''
            class: Company
            table: company
            database: all
            fields:
              name: String
              ownerId: UuidValue?, relation(parent=person)
            ''',
          ).build(),
        ]);

        expect(errors, [
          'Tables without "database: sync" cannot have relations to tables '
              'with "database: sync". The related class "Person" has '
              '"database: sync".',
        ]);
      },
    );
  });

  group('Given a model with "database: sync" with a unique index', () {
    test(
      'that does not include scopeId when validating then an error is '
      'generated.',
      () {
        var errors = validate([
          crdtScopeModel,
          personModel(
            uniqueIndexes: {'person_name_idx': 'name'},
          ),
        ]);

        expect(errors, [
          'The unique index "person_name_idx" must include the "scopeId" '
              'field on tables with "database: sync". Only unique indexes '
              'composed exclusively of relations to other tables with '
              '"database: sync" can be global.',
        ]);
      },
    );

    test(
      'that includes scopeId but no releasable field when validating then an '
      'error is generated.',
      () {
        var errors = validate([
          crdtScopeModel,
          personModel(
            extraFields: 'age: int',
            uniqueIndexes: {'person_age_idx': 'scopeId, age'},
          ),
        ]);

        expect(errors, [
          'The unique index "person_age_idx" must include at least one '
              'field besides "scopeId" that is nullable, a String, or a '
              'UuidValue without a relation, so the sync engine can resolve '
              'conflicts.',
        ]);
      },
    );

    test(
      'composed only of an optional relation to a sync table when validating '
      'then no error is generated.',
      () {
        var errors = validate([
          crdtScopeModel,
          personModel(
            extraFields:
                'spouse: Person?, relation(optional, onDelete=SetNull, deferred)',
            uniqueIndexes: {'person_spouse_idx': 'spouseId'},
          ),
        ]);

        expect(errors, isEmpty);
      },
    );

    test(
      'composed only of a required relation to a sync table when validating '
      'then an error is generated.',
      () {
        var errors = validate([
          crdtScopeModel,
          personModel(
            extraFields: 'spouse: Person?, relation(deferred)',
            uniqueIndexes: {'person_spouse_idx': 'spouseId'},
          ),
        ]);

        expect(errors, [
          'The unique index "person_spouse_idx" requires the relation fields '
              '"spouseId" to be nullable on tables with "database: sync". '
              'Make the relations optional.',
        ]);
      },
    );

    test(
      'declared inline on a field without scopeId when validating then an '
      'error is generated.',
      () {
        var errors = validate([
          crdtScopeModel,
          personModel(extraFields: 'email: String, unique'),
        ]);

        expect(errors, [
          'The unique index "person__email__unique_idx" must include the '
              '"scopeId" field on tables with "database: sync". Only unique '
              'indexes composed exclusively of relations to other tables '
              'with "database: sync" can be global.',
        ]);
      },
    );

    test(
      'declared inline on a field per scopeId when validating then no error '
      'is generated.',
      () {
        var errors = validate([
          crdtScopeModel,
          personModel(extraFields: 'email: String, unique(per=scopeId)'),
        ]);

        expect(errors, isEmpty);
      },
    );
  });

  group('Given a child model with "database: sync"', () {
    test(
      'inheriting a unique index without scopeId when validating then an '
      'error is generated.',
      () {
        var errors = validate([
          crdtScopeModel,
          ModelSourceBuilder().withFileName('base').withYaml(
            '''
            class: Base
            fields:
              code: String
            indexes:
              code_idx:
                fields: code
                unique: true
            ''',
          ).build(),
          ModelSourceBuilder().withFileName('child').withYaml(
            '''
            class: Child
            extends: Base
            table: child
            database: sync
            fields:
              id: UuidValue?, defaultPersist=random_v7
              scopeId: int?, relation(parent=crdt_scopes, onDelete=Cascade)
            ''',
          ).build(),
        ]);

        expect(errors, [
          'The unique index "child_code_idx" must include the "scopeId" '
              'field on tables with "database: sync". Only unique indexes '
              'composed exclusively of relations to other tables with '
              '"database: sync" can be global.',
        ]);
      },
    );
  });
}
