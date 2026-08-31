import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/validation/restrictions/sync.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_database/serverpod_database.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().withEnabledExperimentalFeatures([
    ExperimentalFeature.databaseSync,
  ]).build();

  group(
    'Given a model with "database: sync" without any fields, '
    'when validating,',
    () {
      late CodeGenerationCollector collector;
      late List<SerializableModelDefinition> definitions;

      setUp(() {
        var models = [
          ModelSourceBuilder().withCrdtScopeModel().build(),
          ModelSourceBuilder().withFileName('person').withYaml(
            '''
class: Person
table: person
database: sync
''',
          ).build(),
        ];

        collector = CodeGenerationCollector();
        definitions = StatefulAnalyzer(
          config,
          models,
          onErrorsCollector(collector),
        ).validateAll();
      });

      test('then no error is generated.', () {
        expect(collector.errors, isEmpty);
      });

      test(
        'then the id field is of type UuidValue? with defaultPersist=random_v7.',
        () {
          var definition = definitions.last as ModelClassDefinition;
          expect(definition.idField.type.className, 'UuidValue');
          expect(definition.idField.type.nullable, isTrue);
          expect(
            definition.idField.defaultPersistValue,
            defaultUuidValueRandomV7,
          );
        },
      );

      test('then the scopeId field is present with the correct relation.', () {
        var definition = definitions.last as ModelClassDefinition;
        var relation =
            definition.findField(syncScopeIdFieldName)!.relation
                as ForeignRelationDefinition;
        expect(relation.parentTable, syncScopesTableName);
        expect(relation.onDelete, ForeignKeyAction.cascade);
      });
    },
  );

  test(
    'Given a model with "database: sync" with an implicit primary key '
    'when validating '
    'then it is of type UuidValue? with defaultPersist=random_v7.',
    () {
      var models = [
        ModelSourceBuilder().withCrdtScopeModel().build(),
        ModelSourceBuilder().withFileName('person').withYaml(
          '''
class: Person
table: person
database: sync
fields:
  scopeId: int?, relation(parent=crdt_scopes, onDelete=Cascade)
''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var definitions = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, isEmpty);

      var definition = definitions.last as ModelClassDefinition;
      expect(definition.idField.type.className, 'UuidValue');
      expect(definition.idField.type.nullable, isTrue);
      expect(definition.idField.defaultPersistValue, defaultUuidValueRandomV7);
    },
  );

  test(
    'Given a model with "database: sync" without a scopeId field '
    'when analyzing '
    'then no error is generated and the scopeId field is injected below the id field.',
    () {
      var models = [
        ModelSourceBuilder().withCrdtScopeModel().build(),
        ModelSourceBuilder().withFileName('person').withYaml(
          '''
class: Person
table: person
database: sync
fields:
  id: UuidValue?, defaultPersist=random_v7
  name: String, unique(per=scopeId)
''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var definitions = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();
      var person = definitions.whereType<ModelClassDefinition>().singleWhere(
        (model) => model.className == 'Person',
      );

      expect(collector.errors, isEmpty);
      expect(person.fields.map((f) => f.name), ['id', 'scopeId', 'name']);
    },
  );

  test(
    'Given a model with "database: sync" without a scopeId field '
    'when analyzing '
    'then the injected scopeId field is a persisted nullable int with scope all.',
    () {
      var models = [
        ModelSourceBuilder().withCrdtScopeModel().build(),
        ModelSourceBuilder().withFileName('person').withYaml(
          '''
class: Person
table: person
database: sync
fields:
  id: UuidValue?, defaultPersist=random_v7
  name: String, unique(per=scopeId)
''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var definitions = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();
      var person = definitions.whereType<ModelClassDefinition>().singleWhere(
        (model) => model.className == 'Person',
      );

      var scopeId = person.findField('scopeId')!;
      expect(scopeId.type.className, 'int');
      expect(scopeId.type.nullable, isTrue);
      expect(scopeId.scope, ModelFieldScopeDefinition.all);
      expect(scopeId.shouldPersist, isTrue);
      expect(scopeId.documentation, isNotEmpty);
    },
  );

  test(
    'Given a model with "database: sync" without a scopeId field '
    'when analyzing '
    'then the injected scopeId field cascades from crdt_scopes.',
    () {
      var models = [
        ModelSourceBuilder().withCrdtScopeModel().build(),
        ModelSourceBuilder().withFileName('person').withYaml(
          '''
class: Person
table: person
database: sync
fields:
  id: UuidValue?, defaultPersist=random_v7
  name: String, unique(per=scopeId)
''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var definitions = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();
      var person = definitions.whereType<ModelClassDefinition>().singleWhere(
        (model) => model.className == 'Person',
      );

      var relation =
          person.findField('scopeId')!.relation as ForeignRelationDefinition;
      expect(relation.parentTable, 'crdt_scopes');
      expect(relation.foreignFieldName, 'id');
      expect(relation.onDelete, ForeignKeyAction.cascade);
      expect(relation.deferrable, isNull);
    },
  );

  test(
    'Given a model with "database: sync" without a scopeId field '
    'when analyzing '
    'then the indexes referencing scopeId are resolved on the injected field.',
    () {
      var models = [
        ModelSourceBuilder().withCrdtScopeModel().build(),
        ModelSourceBuilder().withFileName('person').withYaml(
          '''
class: Person
table: person
database: sync
fields:
  id: UuidValue?, defaultPersist=random_v7
  name: String, unique(per=scopeId)
''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var definitions = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();
      var person = definitions.whereType<ModelClassDefinition>().singleWhere(
        (model) => model.className == 'Person',
      );

      var scopeId = person.findField('scopeId')!;
      expect(scopeId.indexes.map((i) => i.name), [
        'person__scopeId__name__unique_idx',
      ]);
    },
  );

  test(
    'Given a model with "database: sync" with a CrdtScope relation '
    'when analyzing '
    'then no error is generated and the implicit scopeId field is used.',
    () {
      var models = [
        ModelSourceBuilder().withCrdtScopeModel().build(),
        ModelSourceBuilder().withFileName('person').withYaml(
          '''
class: Person
table: person
database: sync
fields:
  id: UuidValue?, defaultPersist=random_v7
  scope: CrdtScope?, relation(onDelete=Cascade)
''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var definitions = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();
      var person = definitions.whereType<ModelClassDefinition>().singleWhere(
        (model) => model.className == 'Person',
      );

      expect(collector.errors, isEmpty);
      var scopeId = person.findField('scopeId');
      expect(scopeId?.relation, isA<ForeignRelationDefinition>());
      expect(person.fields.where((f) => f.name == 'scopeId'), hasLength(1));
    },
  );

  test(
    'Given a model with "database: sync" with an int primary key '
    'when validating '
    'then an error is generated on the id type.',
    () {
      var models = [
        ModelSourceBuilder().withCrdtScopeModel().build(),
        ModelSourceBuilder().withFileName('person').withYaml(
          '''
class: Person
table: person
database: sync
fields:
  id: int?, defaultPersist=serial
  scopeId: int?, relation(parent=crdt_scopes, onDelete=Cascade)
''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, hasLength(1));

      var error = collector.errors.first;
      expect(
        error.message,
        'Tables with "database: sync" must have a UUID primary key. '
        'Declare the id field as '
        '"id: UuidValue?, defaultPersist=random_v7".',
      );
      expect(error.span?.text, 'int?');
    },
  );

  test(
    'Given a model with "database: sync" and no crdt_scopes table '
    'when validating '
    'then an error is generated on the database key.',
    () {
      var models = [
        ModelSourceBuilder().withFileName('person').withYaml(
          '''
class: Person
table: person
database: sync
fields:
  id: UuidValue?, defaultPersist=random_v7
  scopeId: int?, relation(parent=crdt_scopes, onDelete=Cascade)
  name: String
''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, hasLength(2));

      var error0 = collector.errors[0];
      expect(
        error0.message,
        'The "database: sync" option requires the '
        '"serverpod_offline_sync" module. Add it to the "modules" '
        'section of the generator.yaml file.',
      );
      expect(error0.span?.text, 'sync');

      var error1 = collector.errors[1];
      expect(
        error1.message,
        'The parent table "crdt_scopes" was not found in any model.',
      );
      expect(error1.span?.text, 'crdt_scopes');
    },
  );

  test(
    'Given a model with "database: sync" with a scopeId field with a deferred relation '
    'when validating '
    'then no error is generated.',
    () {
      var models = [
        ModelSourceBuilder().withCrdtScopeModel().build(),
        ModelSourceBuilder().withFileName('person').withYaml(
          '''
class: Person
table: person
database: sync
fields:
  id: UuidValue?, defaultPersist=random_v7
  scopeId: int?, relation(parent=crdt_scopes, onDelete=Cascade, deferred)
''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, isEmpty);
    },
  );

  test(
    'Given a model with "database: sync" with a scopeId field without a relation '
    'when validating '
    'then an error is generated on the scopeId key.',
    () {
      var models = [
        ModelSourceBuilder().withCrdtScopeModel().build(),
        ModelSourceBuilder().withFileName('person').withYaml(
          '''
class: Person
table: person
database: sync
fields:
  id: UuidValue?, defaultPersist=random_v7
  scopeId: int?
''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, hasLength(1));

      var error = collector.errors.first;
      expect(
        error.message,
        'The "scopeId" field must declare the relation '
        '"relation(parent=crdt_scopes, onDelete=Cascade)" on tables with '
        '"database: sync".',
      );
      expect(error.span?.text, 'scopeId');
    },
  );

  test(
    'Given a model with "database: sync" with a scopeId field that is not nullable '
    'when validating '
    'then an error is generated on the scopeId type.',
    () {
      var models = [
        ModelSourceBuilder().withCrdtScopeModel().build(),
        ModelSourceBuilder().withFileName('person').withYaml(
          '''
class: Person
table: person
database: sync
fields:
  id: UuidValue?, defaultPersist=random_v7
  scopeId: int, relation(parent=crdt_scopes, onDelete=Cascade)
''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, hasLength(1));

      var error = collector.errors.first;
      expect(
        error.message,
        'The "scopeId" field must be of type "int?" on tables with '
        '"database: sync".',
      );
      expect(error.span?.text, 'int');
    },
  );

  test(
    'Given a model with "database: sync" with a scopeId field referencing another table '
    'when validating '
    'then an error is generated on the parent name.',
    () {
      var models = [
        ModelSourceBuilder().withCrdtScopeModel().build(),
        ModelSourceBuilder().withFileName('person').withYaml(
          '''
class: Person
table: person
database: sync
fields:
  id: UuidValue?, defaultPersist=random_v7
  scopeId: int?, relation(parent=person, onDelete=Cascade)
''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, hasLength(1));

      var error = collector.errors.first;
      expect(
        error.message,
        'The "scopeId" field must reference the "crdt_scopes" table on '
        'tables with "database: sync".',
      );
      expect(error.span?.text, 'person');
    },
  );

  test(
    'Given a model with "database: sync" with a scopeId field overriding the column name '
    'when validating '
    'then an error is generated on the column name.',
    () {
      var models = [
        ModelSourceBuilder().withCrdtScopeModel().build(),
        ModelSourceBuilder().withFileName('person').withYaml(
          '''
class: Person
table: person
database: sync
fields:
  id: UuidValue?, defaultPersist=random_v7
  scopeId: int?, relation(parent=crdt_scopes, onDelete=Cascade), column=scope_id
''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, hasLength(1));

      var error = collector.errors.first;
      expect(
        error.message,
        'The "scopeId" field must not override its column name on tables '
        'with "database: sync".',
      );
      expect(error.span?.text, 'scope_id');
    },
  );

  test(
    'Given a model with "database: sync" with a scopeId field with a relation without an onDelete action '
    'when validating '
    'then an error is generated on the relation.',
    () {
      var models = [
        ModelSourceBuilder().withCrdtScopeModel().build(),
        ModelSourceBuilder().withFileName('person').withYaml(
          '''
class: Person
table: person
database: sync
fields:
  id: UuidValue?, defaultPersist=random_v7
  scopeId: int?, relation(parent=crdt_scopes)
''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, hasLength(1));

      var error = collector.errors.first;
      expect(
        error.message,
        'The "scopeId" relation must use "onDelete=Cascade".',
      );
      expect(error.span?.text, 'parent=crdt_scopes');
    },
  );

  test(
    'Given a model with "database: sync" with a scopeId field with a relation that does not cascade on delete '
    'when validating '
    'then an error is generated on the onDelete value.',
    () {
      var models = [
        ModelSourceBuilder().withCrdtScopeModel().build(),
        ModelSourceBuilder().withFileName('person').withYaml(
          '''
class: Person
table: person
database: sync
fields:
  id: UuidValue?, defaultPersist=random_v7
  scopeId: int?, relation(parent=crdt_scopes, onDelete=NoAction)
''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, hasLength(1));

      var error = collector.errors.first;
      expect(
        error.message,
        'The "scopeId" relation must use "onDelete=Cascade".',
      );
      expect(error.span?.text, 'NoAction');
    },
  );

  test(
    'Given a model with "database: sync" with a relation that is optional and not deferred '
    'when validating '
    'then no error is generated.',
    () {
      var models = [
        ModelSourceBuilder().withCrdtScopeModel().build(),
        ModelSourceBuilder().withFileName('person').withYaml(
          '''
class: Person
table: person
database: sync
fields:
  id: UuidValue?, defaultPersist=random_v7
  scopeId: int?, relation(parent=crdt_scopes, onDelete=Cascade)
  name: String
  parent: Person?, relation(optional)
''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, isEmpty);
    },
  );

  test(
    'Given a model with "database: sync" with a relation that is required and not deferred '
    'when validating '
    'then an error is generated on the relation.',
    () {
      var models = [
        ModelSourceBuilder().withCrdtScopeModel().build(),
        ModelSourceBuilder().withFileName('person').withYaml(
          '''
class: Person
table: person
database: sync
fields:
  id: UuidValue?, defaultPersist=random_v7
  scopeId: int?, relation(parent=crdt_scopes, onDelete=Cascade)
  name: String
  parent: Person?, relation(onDelete=Cascade)
''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, hasLength(1));

      var error = collector.errors.first;
      expect(
        error.message,
        'Non-optional relations on tables with "database: sync" must be '
        'deferred. Add the "deferred" keyword to the relation.',
      );
      expect(error.span?.text, 'onDelete=Cascade');
    },
  );

  test(
    'Given a model with "database: sync" with a relation that is required and deferred with a false value '
    'when validating '
    'then an error is generated on the deferred value.',
    () {
      var models = [
        ModelSourceBuilder().withCrdtScopeModel().build(),
        ModelSourceBuilder().withFileName('person').withYaml(
          '''
class: Person
table: person
database: sync
fields:
  id: UuidValue?, defaultPersist=random_v7
  scopeId: int?, relation(parent=crdt_scopes, onDelete=Cascade)
  name: String
  parent: Person?, relation(deferred=false)
''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, hasLength(1));

      var error = collector.errors.first;
      expect(
        error.message,
        'Non-optional relations on tables with "database: sync" must be '
        'deferred. Add the "deferred" keyword to the relation.',
      );
      expect(error.span?.text, 'false');
    },
  );

  test(
    'Given a model with "database: sync" with a relation that is required and only deferrable '
    'when validating '
    'then an error is generated on the deferrable key.',
    () {
      var models = [
        ModelSourceBuilder().withCrdtScopeModel().build(),
        ModelSourceBuilder().withFileName('person').withYaml(
          '''
class: Person
table: person
database: sync
fields:
  id: UuidValue?, defaultPersist=random_v7
  scopeId: int?, relation(parent=crdt_scopes, onDelete=Cascade)
  name: String
  parent: Person?, relation(deferrable)
''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, hasLength(1));

      var error = collector.errors.first;
      expect(
        error.message,
        'Non-optional relations on tables with "database: sync" must be '
        'deferred. Add the "deferred" keyword to the relation.',
      );
      expect(error.span?.text, 'deferrable');
    },
  );

  test(
    'Given a model with "database: sync" with a relation declared on a nullable id field that is not deferred '
    'when validating '
    'then no error is generated.',
    () {
      var models = [
        ModelSourceBuilder().withCrdtScopeModel().build(),
        ModelSourceBuilder().withFileName('person').withYaml(
          '''
class: Person
table: person
database: sync
fields:
  id: UuidValue?, defaultPersist=random_v7
  scopeId: int?, relation(parent=crdt_scopes, onDelete=Cascade)
  name: String
  parentId: UuidValue?, relation(parent=person)
''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, isEmpty);
    },
  );

  test(
    'Given a model with "database: sync" with a relation declared on an id field that is deferred '
    'when validating '
    'then no error is generated.',
    () {
      var models = [
        ModelSourceBuilder().withCrdtScopeModel().build(),
        ModelSourceBuilder().withFileName('person').withYaml(
          '''
class: Person
table: person
database: sync
fields:
  id: UuidValue?, defaultPersist=random_v7
  scopeId: int?, relation(parent=crdt_scopes, onDelete=Cascade)
  name: String
  parentId: UuidValue?, relation(parent=person, deferred)
''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, isEmpty);
    },
  );

  test(
    'Given a model with "database: sync" with a relation declared on a required id field that is not deferred '
    'when validating '
    'then an error is generated on the relation.',
    () {
      var models = [
        ModelSourceBuilder().withCrdtScopeModel().build(),
        ModelSourceBuilder().withFileName('person').withYaml(
          '''
class: Person
table: person
database: sync
fields:
  id: UuidValue?, defaultPersist=random_v7
  scopeId: int?, relation(parent=crdt_scopes, onDelete=Cascade)
  name: String
  parentId: UuidValue, relation(parent=person)
''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, hasLength(1));

      var error = collector.errors.first;
      expect(
        error.message,
        'Non-optional relations on tables with "database: sync" must be '
        'deferred. Add the "deferred" keyword to the relation.',
      );
      expect(error.span?.text, 'parent=person');
    },
  );

  test(
    'Given a model with "database: sync" with a relation to a table without "database: sync" '
    'when validating '
    'then an error is generated on the field type.',
    () {
      var models = [
        ModelSourceBuilder().withCrdtScopeModel().build(),
        ModelSourceBuilder().withFileName('company').withYaml(
          '''
class: Company
table: company
database: all
fields:
  name: String
''',
        ).build(),
        ModelSourceBuilder().withFileName('person').withYaml(
          '''
class: Person
table: person
database: sync
fields:
  id: UuidValue?, defaultPersist=random_v7
  scopeId: int?, relation(parent=crdt_scopes, onDelete=Cascade)
  name: String
  company: Company?, relation(optional, deferred)
''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, hasLength(1));

      var error = collector.errors.first;
      expect(
        error.message,
        'Tables with "database: sync" can only have relations to other '
        'tables with "database: sync". The related class "Company" has '
        '"database: all".',
      );
      expect(error.span?.text, 'Company?');
    },
  );

  test(
    'Given a model with "database: sync" with a relation declared on an id field to a table without "database: sync" '
    'when validating '
    'then an error is generated on the parent name.',
    () {
      var models = [
        ModelSourceBuilder().withCrdtScopeModel().build(),
        ModelSourceBuilder().withFileName('company').withYaml(
          '''
class: Company
table: company
database: all
fields:
  name: String
''',
        ).build(),
        ModelSourceBuilder().withFileName('person').withYaml(
          '''
class: Person
table: person
database: sync
fields:
  id: UuidValue?, defaultPersist=random_v7
  scopeId: int?, relation(parent=crdt_scopes, onDelete=Cascade)
  name: String
  companyId: int?, relation(parent=company, deferred)
''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, hasLength(1));

      var error = collector.errors.first;
      expect(
        error.message,
        'Tables with "database: sync" can only have relations to other '
        'tables with "database: sync". The related class "Company" has '
        '"database: all".',
      );
      expect(error.span?.text, 'company');
    },
  );

  test(
    'Given a model without "database: sync" with a relation to a sync table '
    'when validating '
    'then an error is generated on the field type.',
    () {
      var models = [
        ModelSourceBuilder().withCrdtScopeModel().build(),
        ModelSourceBuilder().withFileName('person').withYaml(
          '''
class: Person
table: person
database: sync
fields:
  id: UuidValue?, defaultPersist=random_v7
  scopeId: int?, relation(parent=crdt_scopes, onDelete=Cascade)
  name: String
''',
        ).build(),
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
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, hasLength(1));

      var error = collector.errors.first;
      expect(
        error.message,
        'Tables without "database: sync" cannot have relations to tables '
        'with "database: sync". The related class "Person" has '
        '"database: sync".',
      );
      expect(error.span?.text, 'Person?');
    },
  );

  test(
    'Given a model without "database: sync" with a relation declared on an id field to a sync table '
    'when validating '
    'then an error is generated on the parent name.',
    () {
      var models = [
        ModelSourceBuilder().withCrdtScopeModel().build(),
        ModelSourceBuilder().withFileName('person').withYaml(
          '''
class: Person
table: person
database: sync
fields:
  id: UuidValue?, defaultPersist=random_v7
  scopeId: int?, relation(parent=crdt_scopes, onDelete=Cascade)
  name: String
''',
        ).build(),
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
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, hasLength(1));

      var error = collector.errors.first;
      expect(
        error.message,
        'Tables without "database: sync" cannot have relations to tables '
        'with "database: sync". The related class "Person" has '
        '"database: sync".',
      );
      expect(error.span?.text, 'person');
    },
  );

  test(
    'Given a model with "database: sync" with a unique index declared inline on a field per scopeId '
    'when validating '
    'then no error is generated.',
    () {
      var models = [
        ModelSourceBuilder().withCrdtScopeModel().build(),
        ModelSourceBuilder().withFileName('person').withYaml(
          '''
class: Person
table: person
database: sync
fields:
  id: UuidValue?, defaultPersist=random_v7
  scopeId: int?, relation(parent=crdt_scopes, onDelete=Cascade)
  name: String
  email: String, unique(per=scopeId)
''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, isEmpty);
    },
  );

  test(
    'Given a model with "database: sync" with a unique index composed only of an optional relation to a sync table '
    'when validating '
    'then no error is generated.',
    () {
      var models = [
        ModelSourceBuilder().withCrdtScopeModel().build(),
        ModelSourceBuilder().withFileName('person').withYaml(
          '''
class: Person
table: person
database: sync
fields:
  id: UuidValue?, defaultPersist=random_v7
  scopeId: int?, relation(parent=crdt_scopes, onDelete=Cascade)
  name: String
  spouse: Person?, relation(optional, onDelete=SetNull, deferred)
indexes:
  person_spouse_idx:
    fields: spouseId
    unique: true
''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, isEmpty);
    },
  );

  test(
    'Given a model with "database: sync" that satisfies all sync restrictions '
    'when validating '
    'then no error is generated.',
    () {
      var models = [
        ModelSourceBuilder().withCrdtScopeModel().build(),
        ModelSourceBuilder().withFileName('person').withYaml(
          '''
class: Person
table: person
database: sync
fields:
  id: UuidValue?, defaultPersist=random_v7
  scopeId: int?, relation(parent=crdt_scopes, onDelete=Cascade)
  name: String
  parent: Person?, relation(optional, onDelete=Cascade, deferred)
indexes:
  person_name_idx:
    fields: scopeId, name
    unique: true
''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, isEmpty);
    },
  );

  test(
    'Given a model with "database: sync" with a unique index that does not include scopeId '
    'when validating '
    'then an error is generated on the unique key.',
    () {
      var models = [
        ModelSourceBuilder().withCrdtScopeModel().build(),
        ModelSourceBuilder().withFileName('person').withYaml(
          '''
class: Person
table: person
database: sync
fields:
  id: UuidValue?, defaultPersist=random_v7
  scopeId: int?, relation(parent=crdt_scopes, onDelete=Cascade)
  name: String
indexes:
  person_name_idx:
    fields: name
    unique: true
''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, hasLength(1));

      var error = collector.errors.first;
      expect(
        error.message,
        'The unique index "person_name_idx" must include the "scopeId" '
        'field on tables with "database: sync". Only unique indexes '
        'composed exclusively of relations to other tables with '
        '"database: sync" can be global.',
      );
      expect(error.span?.text, 'unique');
    },
  );

  test(
    'Given a model with "database: sync" with a unique index that includes scopeId but no releasable field '
    'when validating '
    'then an error is generated on the unique key.',
    () {
      var models = [
        ModelSourceBuilder().withCrdtScopeModel().build(),
        ModelSourceBuilder().withFileName('person').withYaml(
          '''
class: Person
table: person
database: sync
fields:
  id: UuidValue?, defaultPersist=random_v7
  scopeId: int?, relation(parent=crdt_scopes, onDelete=Cascade)
  name: String
  age: int
indexes:
  person_age_idx:
    fields: scopeId, age
    unique: true
''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, hasLength(1));

      var error = collector.errors.first;
      expect(
        error.message,
        'The unique index "person_age_idx" must include at least one field '
        'besides "scopeId" that is nullable, a String, or a UuidValue '
        'without a relation, so the sync engine can resolve conflicts.',
      );
      expect(error.span?.text, 'unique');
    },
  );

  test(
    'Given a model with "database: sync" with a unique index composed only of a required relation to a sync table '
    'when validating '
    'then an error is generated on the unique key.',
    () {
      var models = [
        ModelSourceBuilder().withCrdtScopeModel().build(),
        ModelSourceBuilder().withFileName('person').withYaml(
          '''
class: Person
table: person
database: sync
fields:
  id: UuidValue?, defaultPersist=random_v7
  scopeId: int?, relation(parent=crdt_scopes, onDelete=Cascade)
  name: String
  spouse: Person?, relation(deferred)
indexes:
  person_spouse_idx:
    fields: spouseId
    unique: true
''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, hasLength(1));

      var error = collector.errors.first;
      expect(
        error.message,
        'The unique index "person_spouse_idx" requires the relation fields '
        '"spouseId" to be nullable on tables with "database: sync". Make '
        'the relations optional.',
      );
      expect(error.span?.text, 'unique');
    },
  );

  test(
    'Given a model with "database: sync" with a unique index declared inline on a field without scopeId '
    'when validating '
    'then an error is generated on the unique modifier.',
    () {
      var models = [
        ModelSourceBuilder().withCrdtScopeModel().build(),
        ModelSourceBuilder().withFileName('person').withYaml(
          '''
class: Person
table: person
database: sync
fields:
  id: UuidValue?, defaultPersist=random_v7
  scopeId: int?, relation(parent=crdt_scopes, onDelete=Cascade)
  name: String
  email: String, unique
''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, hasLength(1));

      var error = collector.errors.first;
      expect(
        error.message,
        'The unique index "person__email__unique_idx" must include the "scopeId" '
        'field on tables with "database: sync". Only unique indexes '
        'composed exclusively of relations to other tables with '
        '"database: sync" can be global.',
      );
      expect(error.span?.text, 'unique');
    },
  );

  test(
    'Given a child model with "database: sync" inheriting a unique index without scopeId '
    'when validating '
    'then an error is generated on the table key.',
    () {
      var models = [
        ModelSourceBuilder().withCrdtScopeModel().build(),
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
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, hasLength(1));

      var error = collector.errors.first;
      expect(
        error.message,
        'The unique index "child_code_idx" must include the "scopeId" '
        'field on tables with "database: sync". Only unique indexes '
        'composed exclusively of relations to other tables with '
        '"database: sync" can be global.',
      );
      expect(error.span?.text, 'child');
    },
  );
}
