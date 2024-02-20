import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  var config = GeneratorConfigBuilder().build();
  test(
    'Given a class with a field with the parent keyword but without a value, then collect an error that the parent has to have a valid table name.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
            class: Example
            table: example
            fields:
              nameId: int, parent=
            ''',
        ).build()
      ];
      var collector = CodeGenerationCollector();
      StatefulAnalyzer(config, models, onErrorsCollector(collector))
          .validateAll();

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;
      expect(
        error.message,
        'The parent must reference a valid table name (e.g. parent=table_name). "" is not a valid parent name.',
      );
    },
  );

  test(
    'Given a class with a field with a parent, then the generated model has a parentTable property set to the parent table name.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
            class: Example
            table: example
            fields:
              parentId: int, parent=example
            ''',
        ).build()
      ];
      StatefulAnalyzer analyzer = StatefulAnalyzer(config, models);
      var definitions = analyzer.validateAll();

      var definition = definitions.first as ClassDefinition;
      var relation = definition.fields.last.relation;

      expect(relation.runtimeType, ForeignRelationDefinition);
      expect((relation as ForeignRelationDefinition).parentTable, 'example');
    },
  );

  test(
    'Given a class with a field with a parent with whitespace in the syntax, then the generated model has a parentTable property set to the parent table name.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
            class: Example
            table: example
            fields:
              parentId: int, parent = example
            ''',
        ).build()
      ];
      StatefulAnalyzer analyzer = StatefulAnalyzer(config, models);

      var definitions = analyzer.validateAll();
      var definition = definitions.first as ClassDefinition;

      var relation = definition.fields.last.relation;
      expect(relation.runtimeType, ForeignRelationDefinition);
      expect((relation as ForeignRelationDefinition).parentTable, 'example');
    },
  );

  test(
    'Given a class with a field with a parent, then a deprecated info is generated.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            parentId: int, parent=example
          ''',
        ).build()
      ];
      var collector = CodeGenerationCollector();
      StatefulAnalyzer(config, models, onErrorsCollector(collector))
          .validateAll();

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;
      expect(
        error.message,
        'The "parent" property is deprecated. Use the relation keyword instead. E.g. relation(parent=parent_table). Note that the default onDelete action changes from "Cascade" to "NoAction" when using the relation keyword.',
      );
    },
  );

  test(
    'Given a class with a field with a parent that do not exist, then collect an error that the parent table is not found.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            name: int, parent=unknown_table
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer(config, models, onErrorsCollector(collector))
          .validateAll();

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;
      expect(
        error.message,
        'The parent table "unknown_table" was not found in any model.',
      );
    },
  );

  test(
    'Given a class with a field with two parent keywords, then collect an error that only one parent is allowed.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            parentId: int, parent=example, parent=example
          ''',
        ).build()
      ];
      var collector = CodeGenerationCollector();
      StatefulAnalyzer(config, models, onErrorsCollector(collector))
          .validateAll();

      expect(collector.errors, isNotEmpty);

      var error = collector.errors.first;
      expect(
        error.message,
        'The field option "parent" is defined more than once.',
      );
    },
  );

  test(
    'Given a class without a table definition but with a field with a parent, then collect an error that the table needs to be defined.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields:
            parentId: int, parent=example
          ''',
        ).build()
      ];
      var collector = CodeGenerationCollector();
      StatefulAnalyzer(config, models, onErrorsCollector(collector))
          .validateAll();

      expect(collector.errors, isNotEmpty);
      var error = collector.errors.first;

      expect(
        error.message,
        'The "table" property must be defined in the class to set a parent on a field.',
      );
    },
  );

  test(
    'Given a class with the parent keyword with a nested value then an error is collected that the parent ...',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            parentId: int, parent(relation=example)
          ''',
        ).build()
      ];
      var collector = CodeGenerationCollector();
      StatefulAnalyzer(config, models, onErrorsCollector(collector))
          .validateAll();

      expect(collector.errors, isNotEmpty);
      var error = collector.errors.first;

      expect(
        error.message,
        'The "parent" value must be a String.',
      );
    },
  );
}
