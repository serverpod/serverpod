import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/analyzer/entities/entity_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/protocol_helper.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given a class with the index property defined but without any index, then collect an error that at least one index has to be added.',
    () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
table: example
fields:
  name: String
indexes:
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        ['lib', 'src', 'protocol'],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors.length, greaterThan(0));

      var error = collector.errors.first;

      expect(
        error.message,
        'The "indexes" property must have at least one value.',
      );
    },
  );

  test(
    'Given a class with an index that does not define the fields keyword, then collect an error that fields are required.',
    () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
table: example
fields:
  name: String
indexes:
  example_index:
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        ['lib', 'src', 'protocol'],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors.length, greaterThan(0));

      var error = collector.errors.first;

      expect(
        error.message,
        'The "example_index" property is missing required keys (fields).',
      );
    },
  );

  test(
    'Given a class with an index key that is not a string, then collect an error that the index name has to be defined as a string.',
    () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
table: example
fields:
  name: String
indexes:
  1:
    fields: name
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        ['lib', 'src', 'protocol'],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors.length, greaterThan(0));

      var error = collector.errors.first;

      expect(error.message, 'Key must be of type String.');
    },
  );

  test(
    'Given a class with an index key that is not a string in snake_case_format, then collect an error that the index name is using an invalid format.',
    () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
table: example
fields:
  name: String
indexes:
  PascalCaseIndex:
    fields: name
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        ['lib', 'src', 'protocol'],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors.length, greaterThan(0));

      var error = collector.errors.first;

      expect(
        error.message,
        'Invalid format for index "PascalCaseIndex", must follow the format lower_snake_case.',
      );
    },
  );

  test(
    'Given a class with an index without any fields, then collect an error that at least one field has to be added.',
    () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
table: example
fields:
  name: String
indexes:
  example_index:
    fields:
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        ['lib', 'src', 'protocol'],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors.length, greaterThan(0));

      var error = collector.errors.first;

      expect(
        error.message,
        'The "fields" property must have at least one field, (e.g. fields: fieldName).',
      );
    },
  );

  test(
    'Given a class with an index with a field that does not exist, then collect an error that the field is missing in the class.',
    () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
table: example
fields:
  name: String
indexes:
  example_index:
    fields: missingField
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        ['lib', 'src', 'protocol'],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors.length, greaterThan(0));

      var error = collector.errors.first;

      expect(
        error.message,
        'The field name "missingField" is not added to the class or has an api scope.',
      );
    },
  );

  test(
    'Given a class with an index with a field that has an api scope, then collect an error that the field is missing in the class.',
    () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
table: example
fields:
  name: String
  apiField: String, api
indexes:
  example_index:
    fields: apiField
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        ['lib', 'src', 'protocol'],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors.length, greaterThan(0));

      var error = collector.errors.first;

      expect(
        error.message,
        'The field name "apiField" is not added to the class or has an api scope.',
      );
    },
  );

  test(
    'Given a class with an index with two fields where the second is null, then collect an error that the field must be defined.',
    () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
table: example
fields:
  name: String
indexes:
  example_index:
    fields: name,
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        ['lib', 'src', 'protocol'],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      );
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors.length, greaterThan(0));

      var error = collector.errors.first;

      expect(
        error.message,
        'The field name "" is not added to the class or has an api scope.',
      );
    },
  );

  test(
    'Given a class with an index with a defined field, then the definition contains the index.',
    () {
      var protocol = ProtocolSource(
        '''
class: Example
table: example
fields:
  name: String
indexes:
  example_index:
    fields: name
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        ['lib', 'src', 'protocol'],
      );

      var entityDefinition =
          SerializableEntityAnalyzer.extractEntityDefinition(protocol);

      var index = (entityDefinition as ClassDefinition).indexes?.first;

      expect(index!.name, 'example_index');
    },
  );
  test(
    'Given a class with an index with a defined field, then the definition contains the fields of the index.',
    () {
      var protocol = ProtocolSource(
        '''
class: Example
table: example
fields:
  name: String
indexes:
  example_index:
    fields: name
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        ['lib', 'src', 'protocol'],
      );

      var entityDefinition =
          SerializableEntityAnalyzer.extractEntityDefinition(protocol);

      var index = (entityDefinition as ClassDefinition).indexes?.first;

      var field = index?.fields.first;

      expect(field, 'name');
    },
  );

  test(
    'Given a class with an index with two defined fields, then the definition contains the fields of the index.',
    () {
      var protocol = ProtocolSource(
        '''
class: Example
table: example
fields:
  name: String
  foo: String
indexes:
  example_index:
    fields: name, foo
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        ['lib', 'src', 'protocol'],
      );

      var entityDefinition =
          SerializableEntityAnalyzer.extractEntityDefinition(protocol);

      var index = (entityDefinition as ClassDefinition).indexes?.first;

      var field1 = index?.fields.first;
      var field2 = index?.fields.last;

      expect(field1, 'name');
      expect(field2, 'foo');
    },
  );

  test(
    'Given a class with two indexes, then the definition contains both the index names.',
    () {
      var protocol = ProtocolSource(
        '''
class: Example
table: example
fields:
  name: String
  foo: String
indexes:
  example_index:
    fields: name
  example_index2:
    fields: foo
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        ['lib', 'src', 'protocol'],
      );

      var entityDefinition =
          SerializableEntityAnalyzer.extractEntityDefinition(protocol);

      var index1 = (entityDefinition as ClassDefinition).indexes?.first;
      var index2 = entityDefinition.indexes?.last;

      expect(index1!.name, 'example_index');
      expect(index2!.name, 'example_index2');
    },
  );

  // todo convert!!
  test(
      'Given a class with an index with a unique key that is not a bool, then collect an error that the unique key has to be defined as a bool.',
      () {
    var collector = CodeGenerationCollector();
    var protocol = ProtocolSource(
      '''
class: Example
table: example
fields:
  name: String
indexes:
  example_index:
    fields: name
    unique: InvalidValue
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var definition =
        SerializableEntityAnalyzer.extractEntityDefinition(protocol);
    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      definition,
      [definition!],
    );

    expect(collector.errors.length, greaterThan(0));
    var error = collector.errors.first;
    expect(error.message, 'The property value must be a bool.');
  });

  test(
      'Given a class with an index with an undefined unique key, then return a definition where unique is set to false.',
      () {
    var collector = CodeGenerationCollector();
    var protocol = ProtocolSource(
      '''
class: Example
table: example
fields:
  name: String
indexes:
  example_index:
    fields: name
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var definition =
        SerializableEntityAnalyzer.extractEntityDefinition(protocol)
            as ClassDefinition;
    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      definition,
      [definition],
    );

    var index = definition.indexes?.first;
    expect(index!.unique, false);
  });

  test(
      'Given a class with an index with a unique key set to false, then return a definition where unique is set to false.',
      () {
    var collector = CodeGenerationCollector();
    var protocol = ProtocolSource(
      '''
class: Example
table: example
fields:
  name: String
indexes:
  example_index:
    fields: name
    unique: false
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var definition =
        SerializableEntityAnalyzer.extractEntityDefinition(protocol)
            as ClassDefinition;
    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      definition,
      [definition],
    );

    var index = definition.indexes?.first;
    expect(index!.unique, false);
  });

  test(
      'Given a class with an index with a unique key set to true, then return a definition where unique is set to true.',
      () {
    var collector = CodeGenerationCollector();
    var protocol = ProtocolSource(
      '''
class: Example
table: example
fields:
  name: String
indexes:
  example_index:
    fields: name
    unique: true
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var definition =
        SerializableEntityAnalyzer.extractEntityDefinition(protocol)
            as ClassDefinition;
    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      definition,
      [definition],
    );

    var index = definition.indexes?.first;
    expect(index!.unique, true);
  });

  test(
      'Given a class with an index with an invalid key, then collect an error indicating that the key is invalid.',
      () {
    var collector = CodeGenerationCollector();

    var protocol = ProtocolSource(
      '''
class: Example
table: example
fields:
  name: String
indexes:
  example_index:
    fields: name
    invalidKey: true
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var definition =
        SerializableEntityAnalyzer.extractEntityDefinition(protocol);

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      definition,
      [definition!],
    );

    expect(collector.errors.length, greaterThan(0));

    var error = collector.errors.first;

    expect(error.message,
        'The "invalidKey" property is not allowed for example_index type. Valid keys are {fields, type, unique}.');
  });

  group('Index type tests.', () {
    test(
        'Given a class with an index without a type set, then default to type btree',
        () {
      var collector = CodeGenerationCollector();

      var protocol = ProtocolSource(
        '''
class: Example
table: example
fields:
  name: String
indexes:
  example_index:
    fields: name
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        ['lib', 'src', 'protocol'],
      );

      var definition =
          SerializableEntityAnalyzer.extractEntityDefinition(protocol)
              as ClassDefinition;

      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition],
      );

      var index = definition.indexes?.first;

      expect(index?.type, 'btree');
    });

    test(
        'Given a class with an index type explicitly set to btree, then use that type',
        () {
      var collector = CodeGenerationCollector();

      var protocol = ProtocolSource(
        '''
class: Example
table: example
fields:
  name: String
indexes:
  example_index:
    fields: name
    type: btree
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        ['lib', 'src', 'protocol'],
      );

      var definition =
          SerializableEntityAnalyzer.extractEntityDefinition(protocol)
              as ClassDefinition;

      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition],
      );

      var index = definition.indexes?.first;

      expect(index?.type, 'btree');
    });

    test(
        'Given a class with an index with an invalid type, then collect an error indicating that the type is invalid.',
        () {
      var collector = CodeGenerationCollector();

      var protocol = ProtocolSource(
        '''
class: Example
table: example
fields:
  name: String
indexes:
  example_index:
    fields: name
    type: 1
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        ['lib', 'src', 'protocol'],
      );

      var definition =
          SerializableEntityAnalyzer.extractEntityDefinition(protocol);

      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition!],
      );

      expect(collector.errors.length, greaterThan(0));

      var error = collector.errors.first;

      // todo validate the explicit list of valid types
      expect(error.message, 'The "type" property must be of type String.');
    });
  });
}
