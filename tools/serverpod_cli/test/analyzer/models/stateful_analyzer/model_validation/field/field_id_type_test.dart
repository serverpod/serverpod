import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  var config = GeneratorConfigBuilder().build();
  test(
    'Given a class with a table and a field called "id" defined, then collect an error that the id field is not allowed.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
        class: Example
        table: example
        fields:
          id: int
        ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(config, models, onErrorsCollector(collector))
          .validateAll();

      var error = collector.errors.first;

      expect(
        error.message,
        'The field name "id" is not allowed when a table is defined (the "id" field will be auto generated).',
      );
    },
  );

  test(
    'Given a class with a table defined, then add an id field to the generated model.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
        class: Example
        table: example
        fields:
          name: String
        ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      var analyzer =
          StatefulAnalyzer(config, models, onErrorsCollector(collector));
      var definitions = analyzer.validateAll();

      var definition = definitions.first as ClassDefinition;

      expect(definition.fields.first.name, 'id');
      expect(definition.fields.first.type.className, 'int');
      expect(definition.fields.first.type.nullable, true);
    },
  );

  test(
    'Given a class without a table defined, then no id field is added.',
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

      var definition = definitions.first as ClassDefinition;

      expect(definition.fields.first.name, isNot('id'));
      expect(definition.fields, hasLength(1));
    },
  );
}
