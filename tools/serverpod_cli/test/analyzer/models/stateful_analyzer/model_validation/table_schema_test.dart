import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:serverpod_shared/serverpod_shared.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  ({
    List<SerializableModelDefinition> models,
    CodeGenerationCollector collector,
  })
  analyze(List<ModelSource> sources, {GeneratorConfig? withConfig}) {
    var collector = CodeGenerationCollector();
    var models = StatefulAnalyzer(
      withConfig ?? config,
      sources,
      onErrorsCollector(collector),
    ).validateAll();
    return (models: models, collector: collector);
  }

  group('Given a model with a schema-qualified table name', () {
    var result = analyze([
      ModelSourceBuilder().withYaml('''
        class: User
        table: auth.user
        fields:
          name: String
        ''').build(),
    ]);

    test('then no error is generated.', () {
      expect(result.collector.errors, isEmpty);
    });

    test('then the table name keeps the schema.', () {
      var model = result.models.first as ModelClassDefinition;
      expect(model.tableName, 'auth.user');
    });
  });

  test(
    'Given a model with a schema that is not snake case when analyzing '
    'then an error is generated.',
    () {
      var result = analyze([
        ModelSourceBuilder().withYaml('''
        class: User
        table: Auth.user
        fields:
          name: String
        ''').build(),
      ]);

      expect(result.collector.errors, hasLength(1));
      expect(
        result.collector.errors.first.message,
        'The schema in the "table" property must be a snake_case_string.',
      );
    },
  );

  test(
    'Given a model with a schema-qualified name whose table part is not snake '
    'case when analyzing then an error is generated.',
    () {
      var result = analyze([
        ModelSourceBuilder().withYaml('''
        class: User
        table: auth.User
        fields:
          name: String
        ''').build(),
      ]);

      expect(result.collector.errors, hasLength(1));
      expect(
        result.collector.errors.first.message,
        'The "table" property must be a snake_case_string.',
      );
    },
  );

  test(
    'Given a model with more than one dot in the table name when analyzing '
    'then an error is generated.',
    () {
      var result = analyze([
        ModelSourceBuilder().withYaml('''
        class: User
        table: auth.core.user
        fields:
          name: String
        ''').build(),
      ]);

      expect(result.collector.errors, hasLength(1));
      expect(
        result.collector.errors.first.message,
        'The "table" property must be a snake_case_string.',
      );
    },
  );

  test(
    'Given a model with a schema name longer than 63 characters when '
    'analyzing then an error is generated.',
    () {
      var schema = 'a' * 64;
      var result = analyze([
        ModelSourceBuilder().withYaml('''
        class: User
        table: $schema.user
        fields:
          name: String
        ''').build(),
      ]);

      expect(result.collector.errors, hasLength(1));
      expect(
        result.collector.errors.first.message,
        'The schema name "$schema" exceeds the 63 character limitation.',
      );
    },
  );

  test(
    'Given a model with a schema-qualified name whose table part is longer '
    'than 56 characters when analyzing then the error names the table part.',
    () {
      var name = 'a' * 57;
      var result = analyze([
        ModelSourceBuilder().withYaml('''
        class: User
        table: auth.$name
        fields:
          name: String
        ''').build(),
      ]);

      expect(result.collector.errors, hasLength(1));
      expect(
        result.collector.errors.first.message,
        'The table name "$name" exceeds the 56 character table name '
        'limitation.',
      );
    },
  );

  test(
    'Given a model with a schema-qualified table name and the sqlite dialect '
    'when analyzing then an error is generated.',
    () {
      var result = analyze(
        [
          ModelSourceBuilder().withYaml('''
        class: User
        table: auth.user
        fields:
          name: String
        ''').build(),
        ],
        withConfig: GeneratorConfigBuilder()
            .withDatabaseDialect(DatabaseDialect.sqlite)
            .build(),
      );

      expect(result.collector.errors, hasLength(1));
      expect(
        result.collector.errors.first.message,
        'Schema-qualified table names are not supported with the "sqlite" '
        'database dialect.',
      );
    },
  );

  test(
    'Given a model with a schema-qualified table name and "database: client" '
    'when analyzing then an error is generated.',
    () {
      var result = analyze([
        ModelSourceBuilder().withYaml('''
        class: User
        table: auth.user
        database: client
        fields:
          name: String
        ''').build(),
      ]);

      expect(result.collector.errors, hasLength(1));
      expect(
        result.collector.errors.first.message,
        'Schema-qualified table names are not supported for tables with '
        '"database: client".',
      );
    },
  );

  test(
    'Given a model with a schema-qualified table name and "database: sync" '
    'when analyzing then an error is generated.',
    () {
      var result = analyze(
        [
          ModelSourceBuilder().withCrdtScopeModel().build(),
          ModelSourceBuilder().withYaml('''
        class: User
        table: auth.user
        database: sync
        fields:
          name: String
        ''').build(),
        ],
        withConfig: GeneratorConfigBuilder().withEnabledExperimentalFeatures([
          ExperimentalFeature.databaseSync,
        ]).build(),
      );

      expect(result.collector.errors, hasLength(1));
      expect(
        result.collector.errors.first.message,
        'Schema-qualified table names are not supported for tables with '
        '"database: sync".',
      );
    },
  );

  test(
    'Given a model with a schema-qualified table name and "database: all" '
    'when analyzing then no error is generated.',
    () {
      var result = analyze([
        ModelSourceBuilder().withYaml('''
        class: User
        table: auth.user
        database: all
        fields:
          name: String
        ''').build(),
      ]);

      expect(result.collector.errors, isEmpty);
    },
  );

  test(
    'Given two models with the same table name in different schemas when '
    'analyzing then no error is generated.',
    () {
      var result = analyze([
        ModelSourceBuilder().withFileName('auth_user').withYaml('''
        class: AuthUser
        table: auth.user
        fields:
          name: String
        ''').build(),
        ModelSourceBuilder().withFileName('app_user').withYaml('''
        class: AppUser
        table: app.user
        fields:
          name: String
        ''').build(),
      ]);

      expect(result.collector.errors, isEmpty);
    },
  );

  test(
    'Given two models with the same schema-qualified table name when '
    'analyzing then an error is generated.',
    () {
      var result = analyze([
        ModelSourceBuilder().withFileName('auth_user').withYaml('''
        class: AuthUser
        table: auth.user
        fields:
          name: String
        ''').build(),
        ModelSourceBuilder().withFileName('app_user').withYaml('''
        class: AppUser
        table: auth.user
        fields:
          name: String
        ''').build(),
      ]);

      expect(result.collector.errors, hasLength(2));
      expect(
        result.collector.errors.first.message,
        'The table name "auth.user" is already in use by the class '
        '"AppUser".',
      );
    },
  );

  test(
    'Given a model with an index named like the unqualified table name when '
    'analyzing then an error is generated.',
    () {
      var result = analyze([
        ModelSourceBuilder().withYaml('''
        class: User
        table: auth.user
        fields:
          name: String
        indexes:
          user:
            fields: name
        ''').build(),
      ]);

      expect(result.collector.errors, hasLength(1));
      expect(
        result.collector.errors.first.message,
        'The index name "user" cannot be the same as the table name. Use a '
        'unique name for the index.',
      );
    },
  );

  test(
    'Given a model with a schema-qualified table name and a unique field '
    'when analyzing then the auto-generated index name uses the bare table '
    'name.',
    () {
      var result = analyze([
        ModelSourceBuilder().withYaml('''
        class: User
        table: auth.user
        fields:
          email: String, unique
        ''').build(),
      ]);

      expect(result.collector.errors, isEmpty);
      var model = result.models.first as ModelClassDefinition;
      expect(model.indexes.single.name, 'user__email__unique_idx');
    },
  );

  test(
    'Given a model with a schema-qualified table name that inherits an index '
    'when analyzing then the inherited index is prefixed with the bare table '
    'name.',
    () {
      var result = analyze([
        ModelSourceBuilder().withFileName('base').withYaml('''
        class: Base
        fields:
          indexed: int
        indexes:
          base_index:
            fields: indexed
        ''').build(),
        ModelSourceBuilder().withFileName('user').withYaml('''
        class: User
        extends: Base
        table: auth.user
        fields:
          name: String
        ''').build(),
      ]);

      expect(result.collector.errors, isEmpty);
      var model = result.models.last as ModelClassDefinition;
      expect(
        model.indexesIncludingInherited.map((i) => i.name),
        ['user_base_index'],
      );
    },
  );

  group('Given a project config with a default schema', () {
    var schemaConfig = GeneratorConfigBuilder()
        .withDefaultSchema('app')
        .withEnabledExperimentalFeatures([ExperimentalFeature.databaseSync])
        .build();

    test(
      'when analyzing a model with an unqualified table name then the '
      'default schema is applied.',
      () {
        var result = analyze(
          [
            ModelSourceBuilder().withYaml('''
        class: User
        table: user
        fields:
          name: String
        ''').build(),
          ],
          withConfig: schemaConfig,
        );

        expect(result.collector.errors, isEmpty);
        var model = result.models.first as ModelClassDefinition;
        expect(model.tableName, 'app.user');
      },
    );

    test(
      'when analyzing a model with a schema-qualified table name then the '
      'explicit schema is kept.',
      () {
        var result = analyze(
          [
            ModelSourceBuilder().withYaml('''
        class: User
        table: auth.user
        fields:
          name: String
        ''').build(),
          ],
          withConfig: schemaConfig,
        );

        expect(result.collector.errors, isEmpty);
        var model = result.models.first as ModelClassDefinition;
        expect(model.tableName, 'auth.user');
      },
    );

    test(
      'when analyzing a model with "database: all" then the default schema '
      'is applied.',
      () {
        var result = analyze(
          [
            ModelSourceBuilder().withYaml('''
        class: User
        table: user
        database: all
        fields:
          name: String
        ''').build(),
          ],
          withConfig: schemaConfig,
        );

        expect(result.collector.errors, isEmpty);
        var model = result.models.first as ModelClassDefinition;
        expect(model.tableName, 'app.user');
      },
    );

    test(
      'when analyzing a model with "database: client" then the table name '
      'stays unqualified.',
      () {
        var result = analyze(
          [
            ModelSourceBuilder().withYaml('''
        class: User
        table: user
        database: client
        fields:
          name: String
        ''').build(),
          ],
          withConfig: schemaConfig,
        );

        expect(result.collector.errors, isEmpty);
        var model = result.models.first as ModelClassDefinition;
        expect(model.tableName, 'user');
      },
    );

    test(
      'when analyzing a model with "database: sync" then the table name '
      'stays unqualified.',
      () {
        var result = analyze(
          [
            ModelSourceBuilder().withCrdtScopeModel().build(),
            ModelSourceBuilder().withYaml('''
        class: User
        table: user
        database: sync
        fields:
          name: String
        ''').build(),
          ],
          withConfig: schemaConfig,
        );

        expect(result.collector.errors, isEmpty);
        var model = result.models.last as ModelClassDefinition;
        expect(model.tableName, 'user');
      },
    );

    test(
      'when analyzing a module model then the table name stays unqualified.',
      () {
        var collector = CodeGenerationCollector();
        var analyzer = StatefulAnalyzer(
          GeneratorConfigBuilder()
              .withDefaultSchema('app')
              .withAuthModule()
              .build(),
          [
            ModelSourceBuilder()
                .withModuleAlias('auth')
                .withFileName('user_info')
                .withYaml('''
        class: UserInfo
        table: serverpod_user_info
        fields:
          name: String
        ''')
                .build(),
          ],
          onErrorsCollector(collector),
        );
        analyzer.validateAll();

        expect(collector.errors, isEmpty);
        var model =
            analyzer.findModelByName('UserInfo', moduleAlias: 'auth')
                as ModelClassDefinition;
        expect(model.tableName, 'serverpod_user_info');
      },
    );

    test(
      'when analyzing a project model and a module model with the same '
      'unqualified table name then no error is generated.',
      () {
        var result = analyze(
          [
            ModelSourceBuilder()
                .withModuleAlias('auth')
                .withFileName('user_info')
                .withYaml('''
        class: UserInfo
        table: user
        fields:
          name: String
        ''')
                .build(),
            ModelSourceBuilder().withYaml('''
        class: User
        table: user
        fields:
          name: String
        ''').build(),
          ],
          withConfig: GeneratorConfigBuilder()
              .withDefaultSchema('app')
              .withAuthModule()
              .build(),
        );

        expect(result.collector.errors, isEmpty);
      },
    );

    test(
      'when analyzing two project models whose names collide after the '
      'default schema is applied then the error names the qualified table.',
      () {
        var result = analyze(
          [
            ModelSourceBuilder().withFileName('user').withYaml('''
        class: User
        table: user
        fields:
          name: String
        ''').build(),
            ModelSourceBuilder().withFileName('app_user').withYaml('''
        class: AppUser
        table: app.user
        fields:
          name: String
        ''').build(),
          ],
          withConfig: schemaConfig,
        );

        expect(result.collector.errors, hasLength(2));
        expect(
          result.collector.errors.first.message,
          'The table name "app.user" is already in use by the class '
          '"AppUser".',
        );
      },
    );
  });
}
