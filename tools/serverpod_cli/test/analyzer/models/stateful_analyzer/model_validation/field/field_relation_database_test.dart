import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  test(
    'Given a relation from a client-scoped table to a related table with database all '
    'when validating '
    'then no error is generated.',
    () {
      var models = [
        ModelSourceBuilder().withFileName('parent').withYaml(
          '''
          class: Parent
          table: parent
          database: all
          fields:
            name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('child').withYaml(
          '''
          class: Child
          table: child
          database: client
          fields:
            parent: Parent?, relation
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
    'Given a relation between two table classes that both use the same database scope '
    'when validating '
    'then no error is generated.',
    () {
      var models = [
        ModelSourceBuilder().withFileName('parent').withYaml(
          '''
          class: Parent
          table: parent
          database: client
          fields:
            name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('child').withYaml(
          '''
          class: Child
          table: child
          database: client
          fields:
            parent: Parent?, relation
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
    'Given a relation between a table classes with database client and a table classes with database server '
    'when validating '
    'then an error is generated that the database scopes must be the same.',
    () {
      var models = [
        ModelSourceBuilder().withFileName('parent').withYaml(
          '''
          class: Parent
          table: parent
          database: client
          fields:
            name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('child').withYaml(
          '''
          class: Child
          table: child
          database: server
          fields:
            parent: Parent?, relation
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
      expect(
        collector.errors.first.message,
        'The class "Child" has database "server" but the related class "Parent" '
        'has database "client". Relations can only be defined between tables '
        'with the same database scope. Either use "database: all" or the same '
        '"database" for both tables.',
      );
    },
  );
}
