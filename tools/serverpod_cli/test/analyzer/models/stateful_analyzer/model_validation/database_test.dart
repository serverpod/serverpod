import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/config/experimental_feature.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  test('Given a class with a table level database keyword '
      'when validating '
      'then no error is generated.', () {
    var models = [
      ModelSourceBuilder().withYaml('''
          class: Example
          table: example
          database: client
          fields:
            name: String
          ''').build(),
    ];
    var collector = CodeGenerationCollector();
    StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    ).validateAll();

    expect(collector.errors, isEmpty);
  });

  test('Given a class without a table and a database keyword '
      'when validating '
      'then an error is generated.', () {
    var models = [
      ModelSourceBuilder().withYaml('''
          class: Example
          database: client
          fields:
            name: String
          ''').build(),
    ];
    var collector = CodeGenerationCollector();
    StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    ).validateAll();

    expect(collector.errors, isNotEmpty);

    var error = collector.errors.first as SourceSpanSeverityException;
    expect(error.severity, SourceSpanSeverity.error);
    expect(
      error.message,
      'The "database" property can only be used on classes with a "table" property.',
    );
  });

  group('Given a class with "database: sync"', () {
    var syncModels = [
      ModelSourceBuilder().withFileName('crdt_scope').withYaml('''
        class: CrdtScope
        table: crdt_scopes
        database: all
        fields:
          name: String
        ''').build(),
      ModelSourceBuilder().withYaml('''
        class: Example
        table: example
        database: sync
        fields:
          id: UuidValue?, defaultPersist=random_v7
          scopeId: int?, relation(parent=crdt_scopes, onDelete=Cascade)
          name: String
        ''').build(),
    ];

    test('when validating with the databaseSync experimental feature disabled '
        'then an error is generated.', () {
      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        syncModels,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, hasLength(1));

      var error = collector.errors.first as SourceSpanSeverityException;
      expect(error.severity, SourceSpanSeverity.error);
      expect(
        error.message,
        'The "database: sync" option is experimental. Enable it with the '
        '"databaseSync" experimental feature, either through the '
        '"--experimental-features databaseSync" command line flag or by '
        'setting "databaseSync: true" under "experimental_features" in the '
        'generator.yaml file.',
      );
    });

    test('when validating with the databaseSync experimental feature enabled '
        'then no error is generated.', () {
      var config = GeneratorConfigBuilder().withEnabledExperimentalFeatures([
        ExperimentalFeature.databaseSync,
      ]).build();

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        syncModels,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, isEmpty);
    });

    test('when validating with all experimental features enabled '
        'then no error is generated.', () {
      var config = GeneratorConfigBuilder().withEnabledExperimentalFeatures([
        ExperimentalFeature.all,
      ]).build();

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(
        config,
        syncModels,
        onErrorsCollector(collector),
      ).validateAll();

      expect(collector.errors, isEmpty);
    });
  });
}
