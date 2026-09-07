import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/database/create_definition.dart';
import 'package:test/test.dart';

import '../../test_util/builders/model_class_definition_builder.dart';

void main() {
  group(
    'Given a model with a schema-qualified table name when creating the '
    'database definition',
    () {
      var model = ModelClassDefinitionBuilder()
          .withClassName('User')
          .withTableName('auth.user')
          .withSimpleField('name', 'String')
          .build();

      var table = createDatabaseDefinitionFromModels(
        [model],
        'example',
        [],
      ).tables.single;

      test('then the table name is the bare name.', () {
        expect(table.name, 'user');
      });

      test('then the schema is the qualifier.', () {
        expect(table.schema, 'auth');
      });
    },
  );

  group(
    'Given a model with an unqualified table name when creating the '
    'database definition',
    () {
      var model = ModelClassDefinitionBuilder()
          .withClassName('User')
          .withTableName('user')
          .withSimpleField('name', 'String')
          .build();

      var table = createDatabaseDefinitionFromModels(
        [model],
        'example',
        [],
      ).tables.single;

      test('then the table name is kept.', () {
        expect(table.name, 'user');
      });

      test('then the schema is public.', () {
        expect(table.schema, 'public');
      });
    },
  );

  group(
    'Given a model with a schema-qualified table name when creating the '
    'client-side database definition',
    () {
      var model = ModelClassDefinitionBuilder()
          .withClassName('User')
          .withTableName('auth.user')
          .withDatabase(ModelDatabaseDefinition.all)
          .withSimpleField('name', 'String')
          .build();

      var table = createDatabaseDefinitionFromModels(
        [model],
        'example',
        [],
        serverCode: false,
      ).tables.single;

      test('then the table name is the bare name.', () {
        expect(table.name, 'user');
      });

      test('then the schema is public.', () {
        expect(table.schema, 'public');
      });
    },
  );

  group(
    'Given a model with a schema-qualified table name and a relation to a '
    'table in another schema when creating the database definition',
    () {
      var user = ModelClassDefinitionBuilder()
          .withClassName('User')
          .withTableName('auth.user')
          .withSimpleField('name', 'String')
          .build();
      var post = ModelClassDefinitionBuilder()
          .withClassName('Post')
          .withTableName('app.post')
          .withObjectRelationField('author', 'User', 'auth.user')
          .build();

      var foreignKey = createDatabaseDefinitionFromModels(
        [user, post],
        'example',
        [],
      ).tables.singleWhere((t) => t.name == 'post').foreignKeys.single;

      test('then the constraint name uses the bare table name.', () {
        expect(foreignKey.constraintName, 'post_fk_0');
      });

      test('then the reference table is the bare name.', () {
        expect(foreignKey.referenceTable, 'user');
      });

      test('then the reference table schema is the qualifier.', () {
        expect(foreignKey.referenceTableSchema, 'auth');
      });
    },
  );

  group(
    'Given a model with a relation to an unqualified table when creating '
    'the database definition',
    () {
      var user = ModelClassDefinitionBuilder()
          .withClassName('User')
          .withTableName('user')
          .withSimpleField('name', 'String')
          .build();
      var post = ModelClassDefinitionBuilder()
          .withClassName('Post')
          .withTableName('post')
          .withObjectRelationField('author', 'User', 'user')
          .build();

      var foreignKey = createDatabaseDefinitionFromModels(
        [user, post],
        'example',
        [],
      ).tables.singleWhere((t) => t.name == 'post').foreignKeys.single;

      test('then the reference table schema is public.', () {
        expect(foreignKey.referenceTableSchema, 'public');
      });
    },
  );

  group(
    'Given a model with a schema-qualified relation when creating the '
    'client-side database definition',
    () {
      var user = ModelClassDefinitionBuilder()
          .withClassName('User')
          .withTableName('auth.user')
          .withDatabase(ModelDatabaseDefinition.all)
          .withSimpleField('name', 'String')
          .build();
      var post = ModelClassDefinitionBuilder()
          .withClassName('Post')
          .withTableName('app.post')
          .withDatabase(ModelDatabaseDefinition.all)
          .withObjectRelationField('author', 'User', 'auth.user')
          .build();

      var foreignKey = createDatabaseDefinitionFromModels(
        [user, post],
        'example',
        [],
        serverCode: false,
      ).tables.singleWhere((t) => t.name == 'post').foreignKeys.single;

      test('then the reference table is the bare name.', () {
        expect(foreignKey.referenceTable, 'user');
      });

      test('then the reference table schema is public.', () {
        expect(foreignKey.referenceTableSchema, 'public');
      });
    },
  );

  test(
    'Given models in several schemas when creating the database definition '
    'then the tables are sorted by schema, then name.',
    () {
      var models = [
        for (var tableName in ['b.beta', 'alpha', 'b.alpha', 'a.zeta'])
          ModelClassDefinitionBuilder()
              .withClassName(tableName.replaceAll('.', '_'))
              .withTableName(tableName)
              .withSimpleField('name', 'String')
              .build(),
      ];

      var tables = createDatabaseDefinitionFromModels(
        models,
        'example',
        [],
      ).tables;

      expect(
        tables.map((t) => '${t.schema}.${t.name}'),
        ['a.zeta', 'b.alpha', 'b.beta', 'public.alpha'],
      );
    },
  );
}
