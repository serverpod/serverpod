import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  test(
    'Given a class without an explicit managed migration flag set then the internal state for the flag is true',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields:
            name: String
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      var analyzer =
          StatefulAnalyzer(config, models, onErrorsCollector(collector));
      var definitions = analyzer.validateAll();

      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors but there was one.',
      );

      var classDefinition = definitions.first as ClassDefinition;

      expect(classDefinition.manageMigration, isTrue);
    },
  );

  test(
    'Given a class with the managedMigration flag set to true then the internal state for the flag is true',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          managedMigration: true
          fields:
            name: String
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      var analyzer =
          StatefulAnalyzer(config, models, onErrorsCollector(collector));
      var definitions = analyzer.validateAll();

      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors but there was one.',
      );

      var classDefinition = definitions.first as ClassDefinition;

      expect(classDefinition.manageMigration, isTrue);
    },
  );

  test(
    'Given a class with the managedMigration flag set to false then the internal state for the flag is false',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          managedMigration: false
          fields:
            name: String
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      var analyzer =
          StatefulAnalyzer(config, models, onErrorsCollector(collector));
      var definitions = analyzer.validateAll();

      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors but there was one.',
      );

      var classDefinition = definitions.first as ClassDefinition;

      expect(classDefinition.manageMigration, isFalse);
    },
  );

  test(
    'Given a class with the managedMigration flag set none boolean value then an error is reported',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          managedMigration: yes
          fields:
            name: String
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      var analyzer =
          StatefulAnalyzer(config, models, onErrorsCollector(collector));
      analyzer.validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      expect(
        collector.errors.first.message,
        contains('The value must be a boolean.'),
      );
    },
  );
}
