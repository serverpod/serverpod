import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var schemaConfig = GeneratorConfigBuilder().withDefaultSchema('app').build();

  ({
    List<SerializableModelDefinition> models,
    CodeGenerationCollector collector,
  })
  analyze(List<ModelSource> sources, {GeneratorConfig? withConfig}) {
    var collector = CodeGenerationCollector();
    var models = StatefulAnalyzer(
      withConfig ?? schemaConfig,
      sources,
      onErrorsCollector(collector),
    ).validateAll();
    return (models: models, collector: collector);
  }

  ForeignRelationDefinition parentRelation(
    List<SerializableModelDefinition> models,
    String className,
  ) {
    var model = models.firstWhere((m) => m.className == className);
    return (model as ModelClassDefinition).findField('userId')!.relation
        as ForeignRelationDefinition;
  }

  ModelSource userModel = ModelSourceBuilder().withFileName('user').withYaml('''
    class: User
    table: user
    fields:
      name: String
    ''').build();

  ModelSource postModel(String parent) =>
      ModelSourceBuilder().withFileName('post').withYaml('''
    class: Post
    table: post
    fields:
      userId: int, relation(parent=$parent)
    ''').build();

  group('Given a default schema and a parent reference to an unqualified '
      'table name that only exists with the default schema applied', () {
    var result = analyze([userModel, postModel('user')]);

    test('then no error is generated.', () {
      expect(result.collector.errors, isEmpty);
    });

    test('then the parent table resolves to the qualified name.', () {
      expect(parentRelation(result.models, 'Post').parentTable, 'app.user');
    });
  });

  group('Given a default schema and a parent reference written with the '
      'default schema', () {
    var result = analyze([userModel, postModel('app.user')]);

    test('then no error is generated.', () {
      expect(result.collector.errors, isEmpty);
    });

    test('then the parent table keeps the qualified name.', () {
      expect(parentRelation(result.models, 'Post').parentTable, 'app.user');
    });
  });

  group('Given a parent reference to a table in another schema', () {
    var result = analyze([
      ModelSourceBuilder().withFileName('user').withYaml('''
      class: User
      table: auth.user
      fields:
        name: String
      ''').build(),
      postModel('auth.user'),
    ]);

    test('then no error is generated.', () {
      expect(result.collector.errors, isEmpty);
    });

    test('then the parent table keeps the qualified name.', () {
      expect(parentRelation(result.models, 'Post').parentTable, 'auth.user');
    });
  });

  group('Given a default schema and a parent reference to an unqualified '
      'name that matches both a module table and a project table', () {
    var collector = CodeGenerationCollector();
    var analyzer = StatefulAnalyzer(
      GeneratorConfigBuilder()
          .withDefaultSchema('app')
          .withAuthModule()
          .build(),
      [
        ModelSourceBuilder()
            .withModuleAlias('auth')
            .withFileName('user')
            .withYaml('''
      class: AuthUser
      table: user
      fields:
        name: String
      ''')
            .build(),
        userModel,
        postModel('user'),
      ],
      onErrorsCollector(collector),
    );
    analyzer.validateAll();

    test('then an ambiguity error is generated.', () {
      expect(collector.errors, hasLength(1));
      expect(
        collector.errors.first.message,
        'The parent table "user" is ambiguous, it matches both "user" and '
        '"app.user". Qualify the name with its schema.',
      );
    });

    test('then the parent table is left as written.', () {
      var post = analyzer.findModelByName('Post') as ModelClassDefinition;
      var relation =
          post.findField('userId')!.relation as ForeignRelationDefinition;
      expect(relation.parentTable, 'user');
    });
  });

  test(
    'Given a default schema and a parent reference to a table that does not '
    'exist when analyzing then a not found error is generated.',
    () {
      var result = analyze([userModel, postModel('missing')]);

      expect(result.collector.errors, hasLength(1));
      expect(
        result.collector.errors.first.message,
        'The parent table "missing" was not found in any model.',
      );
    },
  );

  test(
    'Given a parent reference with a schema that is not snake case when '
    'analyzing then an invalid name error is generated.',
    () {
      var result = analyze([userModel, postModel('Auth.user')]);

      expect(result.collector.errors, hasLength(1));
      expect(
        result.collector.errors.first.message,
        'The parent must reference a valid table name (e.g. '
        'parent=table_name). "Auth.user" is not a valid parent name.',
      );
    },
  );

  test(
    'Given no default schema and a parent reference to an unqualified table '
    'when analyzing then the parent table is unchanged.',
    () {
      var result = analyze(
        [userModel, postModel('user')],
        withConfig: GeneratorConfigBuilder().build(),
      );

      expect(result.collector.errors, isEmpty);
      expect(parentRelation(result.models, 'Post').parentTable, 'user');
    },
  );
}
