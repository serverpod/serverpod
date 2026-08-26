import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:serverpod_database/serverpod_database.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_source_builder.dart';

/// An error message together with the source text it is reported on.
typedef LocatedError = ({String message, String? span});

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

  ModelSource companyModel(String fields) {
    return ModelSourceBuilder().withFileName('company').withYaml(
      '''
class: Company
table: company
database: all
fields:
  name: String
$fields
''',
    ).build();
  }

  ModelSource personModel({
    String? fields =
        '  id: UuidValue?, defaultPersist=random_v7\n'
        '  scopeId: int?, relation(parent=crdt_scopes, onDelete=Cascade)\n'
        '  name: String',
    String extraFields = '',
    Map<String, String> uniqueIndexes = const {},
  }) {
    var indexes = [
      if (uniqueIndexes.isNotEmpty) 'indexes:',
      for (var MapEntry(key: name, value: indexFields) in uniqueIndexes.entries)
        '  $name:\n    fields: $indexFields\n    unique: true',
    ].join('\n');

    return ModelSourceBuilder().withFileName('person').withYaml(
      '''
class: Person
table: person
database: sync
${fields == null ? '' : 'fields:\n$fields'}
$extraFields
$indexes
''',
    ).build();
  }

  List<LocatedError> validate(List<ModelSource> models) {
    var collector = CodeGenerationCollector();
    StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    ).validateAll();
    return [
      for (var error in collector.errors)
        (message: error.message, span: error.span?.text),
    ];
  }

  ModelClassDefinition analyzePerson(List<ModelSource> models) {
    var definitions = StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(CodeGenerationCollector()),
    ).validateAll();
    return definitions.whereType<ModelClassDefinition>().singleWhere(
      (model) => model.className == 'Person',
    );
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
                '  parent: Person?, relation(optional, onDelete=Cascade, deferred)',
            uniqueIndexes: {'person_name_idx': 'scopeId, name'},
          ),
        ]);

        expect(errors, isEmpty);
      },
    );

    test(
      'with an int primary key when validating then an error is generated '
      'on the id type.',
      () {
        var errors = validate([
          crdtScopeModel,
          personModel(
            fields:
                '  id: int?, defaultPersist=serial\n'
                '  scopeId: int?, relation(parent=crdt_scopes, onDelete=Cascade)',
          ),
        ]);

        expect(errors, [
          (
            message:
                'Tables with "database: sync" must have a UUID primary key. '
                'Declare the id field as '
                '"id: UuidValue?, defaultPersist=random_v7".',
            span: 'int?',
          ),
        ]);
      },
    );

    test(
      'with an implicit primary key when validating then an error is '
      'generated on the database key.',
      () {
        var errors = validate([
          crdtScopeModel,
          personModel(
            fields:
                '  scopeId: int?, relation(parent=crdt_scopes, onDelete=Cascade)',
          ),
        ]);

        expect(errors, [
          (
            message:
                'Tables with "database: sync" must have a UUID primary key. '
                'Declare the id field as '
                '"id: UuidValue?, defaultPersist=random_v7".',
            span: 'sync',
          ),
        ]);
      },
    );

    test(
      'without any fields when validating then an error is generated on '
      'the database key.',
      () {
        var errors = validate([crdtScopeModel, personModel(fields: null)]);

        expect(errors, [
          (
            message:
                'Tables with "database: sync" must have a UUID primary key. '
                'Declare the id field as '
                '"id: UuidValue?, defaultPersist=random_v7".',
            span: 'sync',
          ),
        ]);
      },
    );

    test(
      'without the crdt_scopes table when validating then an error is '
      'generated on the database key.',
      () {
        var errors = validate([personModel()]);

        expect(errors, [
          (
            message:
                'The "database: sync" option requires the '
                '"serverpod_offline_sync" module. Add it to the "modules" '
                'section of the generator.yaml file.',
            span: 'sync',
          ),
          (
            message:
                'The parent table "crdt_scopes" was not found in any model.',
            span: 'crdt_scopes',
          ),
        ]);
      },
    );
  });

  group('Given a model with "database: sync" without a scopeId field', () {
    var models = [
      crdtScopeModel,
      personModel(
        fields:
            '  id: UuidValue?, defaultPersist=random_v7\n'
            '  name: String, unique(per=scopeId)',
      ),
    ];
    var scopeId = analyzePerson(models).findField('scopeId');

    test('when validating then no error is generated.', () {
      expect(validate(models), isEmpty);
    });

    test('when analyzing then the scopeId field is injected.', () {
      expect(scopeId, isNotNull);
    });

    test('when analyzing then the injected field is a nullable int.', () {
      expect(scopeId?.type.className, 'int');
      expect(scopeId?.type.nullable, isTrue);
    });

    test('when analyzing then the injected field has scope all.', () {
      expect(scopeId?.scope, ModelFieldScopeDefinition.all);
    });

    test('when analyzing then the injected field is persisted.', () {
      expect(scopeId?.shouldPersist, isTrue);
    });

    test(
      'when analyzing then the injected field cascades from crdt_scopes.',
      () {
        var relation = scopeId?.relation;
        expect(relation, isA<ForeignRelationDefinition>());
        relation as ForeignRelationDefinition;
        expect(relation.parentTable, 'crdt_scopes');
        expect(relation.foreignFieldName, 'id');
        expect(relation.onDelete, ForeignKeyAction.cascade);
        expect(relation.deferrable, isNull);
      },
    );

    test('when analyzing then the injected field is documented.', () {
      expect(scopeId?.documentation, isNotEmpty);
    });

    test(
      'when analyzing then the indexes referencing scopeId are resolved on '
      'the injected field.',
      () {
        expect(scopeId?.indexes.map((i) => i.name), [
          'person__scopeId__name__unique_idx',
        ]);
      },
    );
  });

  group('Given a model with "database: sync" with a CrdtScope relation', () {
    var models = [
      crdtScopeModel,
      personModel(
        fields:
            '  id: UuidValue?, defaultPersist=random_v7\n'
            '  scope: CrdtScope?, relation(onDelete=Cascade)',
      ),
    ];

    test('when validating then no error is generated.', () {
      expect(validate(models), isEmpty);
    });

    test('when analyzing then the implicit scopeId field is used.', () {
      var person = analyzePerson(models);
      var scopeId = person.findField('scopeId');
      expect(scopeId?.relation, isA<ForeignRelationDefinition>());
      expect(person.fields.where((f) => f.name == 'scopeId'), hasLength(1));
    });
  });

  group('Given a model with "database: sync" with a scopeId field', () {
    test(
      'that is not nullable when validating then an error is generated on '
      'the scopeId type.',
      () {
        var errors = validate([
          crdtScopeModel,
          personModel(
            fields:
                '  id: UuidValue?, defaultPersist=random_v7\n'
                '  scopeId: int, relation(parent=crdt_scopes, onDelete=Cascade)',
          ),
        ]);

        expect(errors, [
          (
            message:
                'The "scopeId" field must be of type "int?" on tables with '
                '"database: sync".',
            span: 'int',
          ),
        ]);
      },
    );

    test(
      'without a relation when validating then an error is generated on the '
      'scopeId key.',
      () {
        var errors = validate([
          crdtScopeModel,
          personModel(
            fields:
                '  id: UuidValue?, defaultPersist=random_v7\n'
                '  scopeId: int?',
          ),
        ]);

        expect(errors, [
          (
            message:
                'The "scopeId" field must declare the relation '
                '"relation(parent=crdt_scopes, onDelete=Cascade)" on tables '
                'with "database: sync".',
            span: 'scopeId',
          ),
        ]);
      },
    );

    test(
      'referencing another table when validating then an error is generated '
      'on the parent name.',
      () {
        var errors = validate([
          crdtScopeModel,
          personModel(
            fields:
                '  id: UuidValue?, defaultPersist=random_v7\n'
                '  scopeId: int?, relation(parent=person, onDelete=Cascade)',
          ),
        ]);

        expect(errors, [
          (
            message:
                'The "scopeId" field must reference the "crdt_scopes" table '
                'on tables with "database: sync".',
            span: 'person',
          ),
        ]);
      },
    );

    test(
      'overriding the column name when validating then an error is generated '
      'on the column name.',
      () {
        var errors = validate([
          crdtScopeModel,
          personModel(
            fields:
                '  id: UuidValue?, defaultPersist=random_v7\n'
                '  scopeId: int?, relation(parent=crdt_scopes, onDelete=Cascade), column=scope_id',
          ),
        ]);

        expect(errors, [
          (
            message:
                'The "scopeId" field must not override its column name on '
                'tables with "database: sync".',
            span: 'scope_id',
          ),
        ]);
      },
    );

    test(
      'with a relation that does not cascade on delete when validating then '
      'an error is generated on the onDelete key.',
      () {
        var errors = validate([
          crdtScopeModel,
          personModel(
            fields:
                '  id: UuidValue?, defaultPersist=random_v7\n'
                '  scopeId: int?, relation(parent=crdt_scopes, onDelete=NoAction)',
          ),
        ]);

        expect(errors, [
          (
            message: 'The "scopeId" relation must use "onDelete=Cascade".',
            span: 'onDelete',
          ),
        ]);
      },
    );

    test(
      'with a relation without an onDelete action when validating then an '
      'error is generated on the relation.',
      () {
        var errors = validate([
          crdtScopeModel,
          personModel(
            fields:
                '  id: UuidValue?, defaultPersist=random_v7\n'
                '  scopeId: int?, relation(parent=crdt_scopes)',
          ),
        ]);

        expect(errors, [
          (
            message: 'The "scopeId" relation must use "onDelete=Cascade".',
            span: 'parent=crdt_scopes',
          ),
        ]);
      },
    );

    test(
      'with a deferred relation when validating then an error is generated '
      'on the deferred key.',
      () {
        var errors = validate([
          crdtScopeModel,
          personModel(
            fields:
                '  id: UuidValue?, defaultPersist=random_v7\n'
                '  scopeId: int?, relation(parent=crdt_scopes, onDelete=Cascade, deferred)',
          ),
        ]);

        expect(errors, [
          (
            message:
                'The "scopeId" relation must not be deferrable or deferred.',
            span: 'deferred',
          ),
        ]);
      },
    );
  });

  group('Given a model with "database: sync" with a relation', () {
    test(
      'to another sync table that is not deferred when validating then an '
      'error is generated on the relation.',
      () {
        var errors = validate([
          crdtScopeModel,
          personModel(extraFields: '  parent: Person?, relation(optional)'),
        ]);

        expect(errors, [
          (
            message:
                'Relations on tables with "database: sync" must be deferred. '
                'Add the "deferred" keyword to the relation.',
            span: 'optional',
          ),
        ]);
      },
    );

    test(
      'to another sync table that is only deferrable when validating then an '
      'error is generated on the deferrable key.',
      () {
        var errors = validate([
          crdtScopeModel,
          personModel(
            extraFields: '  parent: Person?, relation(optional, deferrable)',
          ),
        ]);

        expect(errors, [
          (
            message:
                'Relations on tables with "database: sync" must be deferred. '
                'Add the "deferred" keyword to the relation.',
            span: 'deferrable',
          ),
        ]);
      },
    );

    test(
      'declared on an id field to another sync table that is not deferred '
      'when validating then an error is generated on the relation.',
      () {
        var errors = validate([
          crdtScopeModel,
          personModel(
            extraFields: '  parentId: UuidValue?, relation(parent=person)',
          ),
        ]);

        expect(errors, [
          (
            message:
                'Relations on tables with "database: sync" must be deferred. '
                'Add the "deferred" keyword to the relation.',
            span: 'parent=person',
          ),
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
                '  parentId: UuidValue?, relation(parent=person, deferred)',
          ),
        ]);

        expect(errors, isEmpty);
      },
    );

    test(
      'to a table without "database: sync" when validating then an error is '
      'generated on the field type.',
      () {
        var errors = validate([
          crdtScopeModel,
          companyModel(''),
          personModel(
            extraFields: '  company: Company?, relation(optional, deferred)',
          ),
        ]);

        expect(errors, [
          (
            message:
                'Tables with "database: sync" can only have relations to '
                'other tables with "database: sync". The related class '
                '"Company" has "database: all".',
            span: 'Company?',
          ),
        ]);
      },
    );

    test(
      'declared on an id field to a table without "database: sync" when '
      'validating then an error is generated on the parent name.',
      () {
        var errors = validate([
          crdtScopeModel,
          companyModel(''),
          personModel(
            extraFields:
                '  companyId: int?, relation(parent=company, deferred)',
          ),
        ]);

        expect(errors, [
          (
            message:
                'Tables with "database: sync" can only have relations to '
                'other tables with "database: sync". The related class '
                '"Company" has "database: all".',
            span: 'company',
          ),
        ]);
      },
    );
  });

  group('Given a model without "database: sync" with a relation', () {
    test(
      'to a sync table when validating then an error is generated on the '
      'field type.',
      () {
        var errors = validate([
          crdtScopeModel,
          personModel(),
          companyModel('  owner: Person?, relation(optional)'),
        ]);

        expect(errors, [
          (
            message:
                'Tables without "database: sync" cannot have relations to '
                'tables with "database: sync". The related class "Person" '
                'has "database: sync".',
            span: 'Person?',
          ),
        ]);
      },
    );

    test(
      'declared on an id field to a sync table when validating then an error '
      'is generated on the parent name.',
      () {
        var errors = validate([
          crdtScopeModel,
          personModel(),
          companyModel('  ownerId: UuidValue?, relation(parent=person)'),
        ]);

        expect(errors, [
          (
            message:
                'Tables without "database: sync" cannot have relations to '
                'tables with "database: sync". The related class "Person" '
                'has "database: sync".',
            span: 'person',
          ),
        ]);
      },
    );
  });

  group('Given a model with "database: sync" with a unique index', () {
    test(
      'that does not include scopeId when validating then an error is '
      'generated on the unique key.',
      () {
        var errors = validate([
          crdtScopeModel,
          personModel(uniqueIndexes: {'person_name_idx': 'name'}),
        ]);

        expect(errors, [
          (
            message:
                'The unique index "person_name_idx" must include the '
                '"scopeId" field on tables with "database: sync". Only unique '
                'indexes composed exclusively of relations to other tables '
                'with "database: sync" can be global.',
            span: 'unique',
          ),
        ]);
      },
    );

    test(
      'that includes scopeId but no releasable field when validating then an '
      'error is generated on the unique key.',
      () {
        var errors = validate([
          crdtScopeModel,
          personModel(
            extraFields: '  age: int',
            uniqueIndexes: {'person_age_idx': 'scopeId, age'},
          ),
        ]);

        expect(errors, [
          (
            message:
                'The unique index "person_age_idx" must include at least one '
                'field besides "scopeId" that is nullable, a String, or a '
                'UuidValue without a relation, so the sync engine can resolve '
                'conflicts.',
            span: 'unique',
          ),
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
                '  spouse: Person?, relation(optional, onDelete=SetNull, deferred)',
            uniqueIndexes: {'person_spouse_idx': 'spouseId'},
          ),
        ]);

        expect(errors, isEmpty);
      },
    );

    test(
      'composed only of a required relation to a sync table when validating '
      'then an error is generated on the unique key.',
      () {
        var errors = validate([
          crdtScopeModel,
          personModel(
            extraFields: '  spouse: Person?, relation(deferred)',
            uniqueIndexes: {'person_spouse_idx': 'spouseId'},
          ),
        ]);

        expect(errors, [
          (
            message:
                'The unique index "person_spouse_idx" requires the relation '
                'fields "spouseId" to be nullable on tables with '
                '"database: sync". Make the relations optional.',
            span: 'unique',
          ),
        ]);
      },
    );

    test(
      'declared inline on a field without scopeId when validating then an '
      'error is generated on the unique modifier.',
      () {
        var errors = validate([
          crdtScopeModel,
          personModel(extraFields: '  email: String, unique'),
        ]);

        expect(errors, [
          (
            message:
                'The unique index "person__email__unique_idx" must include '
                'the "scopeId" field on tables with "database: sync". Only '
                'unique indexes composed exclusively of relations to other '
                'tables with "database: sync" can be global.',
            span: 'unique',
          ),
        ]);
      },
    );

    test(
      'declared inline on a field per scopeId when validating then no error '
      'is generated.',
      () {
        var errors = validate([
          crdtScopeModel,
          personModel(extraFields: '  email: String, unique(per=scopeId)'),
        ]);

        expect(errors, isEmpty);
      },
    );
  });

  group('Given a child model with "database: sync"', () {
    test(
      'inheriting a unique index without scopeId when validating then an '
      'error is generated on the table key.',
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
          (
            message:
                'The unique index "child_code_idx" must include the "scopeId" '
                'field on tables with "database: sync". Only unique indexes '
                'composed exclusively of relations to other tables with '
                '"database: sync" can be global.',
            span: 'child',
          ),
        ]);
      },
    );
  });
}
