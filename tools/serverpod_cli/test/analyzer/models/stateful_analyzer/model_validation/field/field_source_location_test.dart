import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  var config = GeneratorConfigBuilder().build();
  test(
    'Given a class with a field with an invalid key, then collect an error that locates the invalid key in the comma separated string.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
class: Example
fields:
  nameId: int, invalid
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(config, models, onErrorsCollector(collector))
          .validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(error.span, isNotNull);
      expect(error.span!.start.line, 2);
      expect(error.span!.start.column, 15);
      expect(error.span!.end.line, 2);
      expect(error.span!.end.column, 22);
    },
  );


  test(
    'Given a class with a field with an empty string entry at the end, then no errors was generated.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
class: Example
table: example
fields:
  nameId: int, !persist,
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(config, models, onErrorsCollector(collector))
          .validateAll();

      expect(
        collector.errors,
        isEmpty,
      );
    },
  );

  test(
    'Given a class with a field with an invalid dart syntax for the type, then collect an error that locates the invalid type in the comma separated string.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
class: Example
table: example
fields:
  nameId: Invalid-Type, !persist
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(config, models, onErrorsCollector(collector))
          .validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.last;
      expect(error.span, isNotNull);
      expect(error.span!.start.line, 3);
      expect(error.span!.start.column, 10);
      expect(error.span!.end.line, 3);
      expect(error.span!.end.column, 22);
    },
  );
}
