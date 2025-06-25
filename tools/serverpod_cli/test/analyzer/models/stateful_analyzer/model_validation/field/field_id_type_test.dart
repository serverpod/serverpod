import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group('Given a class with a table defined and no id field', () {
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
    late final definitions = analyzer.validateAll();

    late final definition = definitions.first as ClassDefinition;

    test('then an id field is added to the generated model.', () {
      expect(definition.fields.first.name, 'id');
    });

    test('then the id type is "int".', () {
      expect(definition.fields.first.type.className, 'int');
    });

    test('then the id type is nullable.', () {
      expect(definition.fields.first.type.nullable, true);
    });

    test('then the default model value is null.', () {
      expect(definition.fields.first.defaultModelValue, isNull);
    });

    test('then the default persist is "serial".', () {
      expect(definition.fields.first.defaultPersistValue, defaultIntSerial);
    });
  });

  test(
      'Given a class with the int id type set as non-nullable then an error is collected',
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

    expect(
      collector.errors.first.message,
      'The type "int" must be nullable for the field "id". Use the "?" '
      'operator to make it nullable (e.g. id: int?).',
    );
  });

  group(
      'Given a class with the int id type set as nullable with no default value',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          id: int?
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    late final definitions =
        StatefulAnalyzer(config, models, onErrorsCollector(collector))
            .validateAll();
    late final definition = definitions.first as ModelClassDefinition;

    test('then the id of the table is "int".', () {
      expect(definition.idField.type.className, 'int');
    });

    test('then the id type is nullable.', () {
      expect(definition.idField.type.nullable, true);
    });
  });

  test(
      'Given a class with the UUID id type and no default value, then an error is collected.',
      () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          id: UuidValue
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer(config, models, onErrorsCollector(collector))
        .validateAll();

    expect(
      collector.errors.first.message,
      'The type "UuidValue" must have a default value. Use either the '
      '"defaultModel" key or the "defaultPersist" key to set it.',
    );
  });

  group('Given a class with the UUID id type correctly set', () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          id: UuidValue?, defaultModel=random
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    late final definitions =
        StatefulAnalyzer(config, models, onErrorsCollector(collector))
            .validateAll();
    late final definition = definitions.first as ModelClassDefinition;

    test('then the id of the table is "UuidValue".', () {
      expect(definition.idField.type.className, 'UuidValue');
    });

    test('then the id type is nullable.', () {
      expect(definition.idField.type.nullable, true);
    });
  });

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
