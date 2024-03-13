import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  test(
    'Given a class with a class documentation comment then an model with the class documentation set is generated.',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          ### This is a comment.
          class: Example
          fields:
            name: String
          ''',
        ).build(),
      ];

      StatefulAnalyzer analyzer = StatefulAnalyzer(config, modelSources);
      var definitions = analyzer.validateAll();
      var definition = definitions.first as ClassDefinition;

      expect(definition.documentation, ['/// This is a comment.']);
    },
  );

  test(
    'Given a class with a multiline class documentation comment then an model with the class documentation set is generated.',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          ### This is a...
          ### multiline comment.
          class: Example
          fields:
            name: String
          ''',
        ).build(),
      ];

      StatefulAnalyzer analyzer = StatefulAnalyzer(config, modelSources);
      var definitions = analyzer.validateAll();
      var definition = definitions.first as ClassDefinition;

      expect(
        definition.documentation,
        ['/// This is a...', '/// multiline comment.'],
      );
    },
  );

  test(
    'Given a class with a normal class comment, then the model that is generated has no documentation set.',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          # This is a normal comment.
          class: Example
          fields:
            name: String
          ''',
        ).build(),
      ];

      StatefulAnalyzer analyzer = StatefulAnalyzer(config, modelSources);
      var definitions = analyzer.validateAll();
      var definition = definitions.first as ClassDefinition;

      expect(definition.documentation, null);
    },
  );

  test(
    'Given a class with a field documentation comment then the model that is generated has the documentation set for that specific field.',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
        class: Example
        fields:
          ### This is a field comment.
          name: String
        ''',
        ).build(),
      ];

      StatefulAnalyzer analyzer = StatefulAnalyzer(config, modelSources);
      var definitions = analyzer.validateAll();
      var definition = definitions.first as ClassDefinition;

      expect(
        definition.fields.first.documentation,
        ['/// This is a field comment.'],
      );
    },
  );

  test(
    'Given a class with a multiline field documentation comment then the model that is generated has the documentation set for that specific field.',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
        class: Example
        fields:
          ### This is a multiline
          ### field comment.
          name: String
        ''',
        ).build(),
      ];

      StatefulAnalyzer analyzer = StatefulAnalyzer(config, modelSources);
      var definitions = analyzer.validateAll();
      var definition = definitions.first as ClassDefinition;

      expect(definition.fields.first.documentation,
          ['/// This is a multiline', '/// field comment.']);
    },
  );

  test(
    'Given a class with multiple fields but only one has a documentation comment then the model that is generated has the documentation set for that specific field.',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields:
            name: String
            ### This is a multiline
            ### field comment.
            age: int
          ''',
        ).build(),
      ];

      StatefulAnalyzer analyzer = StatefulAnalyzer(config, modelSources);
      var definitions = analyzer.validateAll();
      var definition = definitions.first as ClassDefinition;

      expect(definition.fields.first.documentation, null);
      expect(
        definition.fields.last.documentation,
        ['/// This is a multiline', '/// field comment.'],
      );
    },
  );

  test(
    'Given a class with a field with a normal comment, then the model that is generated has no documentation set.',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields:
            # This is a normal comment.
            name: String
          ''',
        ).build(),
      ];

      StatefulAnalyzer analyzer = StatefulAnalyzer(config, modelSources);
      var definitions = analyzer.validateAll();
      var definition = definitions.first as ClassDefinition;

      expect(definition.fields.first.documentation, null);
    },
  );

  test(
    'Given an enum with a multiline class documentation comment then an model with the class documentation set is generated.',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          ### This is a...
          ### multiline comment.
          enum: Example
          values:
            - first
          ''',
        ).build(),
      ];

      StatefulAnalyzer analyzer = StatefulAnalyzer(config, modelSources);
      var definitions = analyzer.validateAll();
      var definition = definitions.first as EnumDefinition;

      expect(
        definition.documentation,
        ['/// This is a...', '/// multiline comment.'],
      );
    },
  );

  test(
    'Given an enum with a multiline value documentation comment then the model that is generated has the documentation set for that specific field.',
    () {
      var modelSources = [
        ModelSourceBuilder().withYaml(
          '''
          enum: Example
          values:
            ### This is a multiline
            ### field comment.
            - first
          ''',
        ).build(),
      ];

      StatefulAnalyzer analyzer = StatefulAnalyzer(config, modelSources);
      var definitions = analyzer.validateAll();
      var definition = definitions.first as EnumDefinition;

      expect(
        definition.values.first.documentation,
        ['/// This is a multiline', '/// field comment.'],
      );
    },
  );
}
