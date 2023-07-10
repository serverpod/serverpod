import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/analyzer/entities/entity_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/protocol_helper.dart';
import 'package:test/test.dart';

void main() {
  group('Test invalid top level fields key values', () {
    test(
        'Given a class without the fields key, then collect an error that the fields key is required',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        ['lib', 'src', 'protocol'],
      );

      var definition =
          SerializableEntityAnalyzer.extractEntityDefinition(protocol);
      SerializableEntityAnalyzer.validateYamlDefinition(protocol.yaml,
          protocol.yamlSourceUri.path, collector, definition, [definition!]);

      expect(collector.errors.length, greaterThan(0));

      var error = collector.errors.first;

      expect(error.message, 'No "fields" property is defined.');
    });

    test(
        'Given an exception without the fields key, then collect an error that the fields key is required',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
exception: Example
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        ['lib', 'src', 'protocol'],
      );

      var definition =
          SerializableEntityAnalyzer.extractEntityDefinition(protocol);
      SerializableEntityAnalyzer.validateYamlDefinition(protocol.yaml,
          protocol.yamlSourceUri.path, collector, definition, [definition!]);

      expect(collector.errors.length, greaterThan(0));

      var error = collector.errors.first;

      expect(error.message, 'No "fields" property is defined.');
    });

    test(
        'Given a class with the fields key defined but without any field, then collect an error that at least one field has to be added.',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
fields:
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        ['lib', 'src', 'protocol'],
      );

      var definition =
          SerializableEntityAnalyzer.extractEntityDefinition(protocol);
      SerializableEntityAnalyzer.validateYamlDefinition(protocol.yaml,
          protocol.yamlSourceUri.path, collector, definition, [definition!]);

      expect(collector.errors.length, greaterThan(0));

      var error = collector.errors.first;

      expect(
          error.message, 'The "fields" property must have at least one value.');
    });

    test(
        'Given an exception with the fields key defined but without any field, then collect an error that at least one field has to be added.',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
exception: Example
fields:
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        ['lib', 'src', 'protocol'],
      );

      var definition =
          SerializableEntityAnalyzer.extractEntityDefinition(protocol);
      SerializableEntityAnalyzer.validateYamlDefinition(protocol.yaml,
          protocol.yamlSourceUri.path, collector, definition, [definition!]);

      expect(collector.errors.length, greaterThan(0));

      var error = collector.errors.first;

      expect(
          error.message, 'The "fields" property must have at least one value.');
    });

    test(
        'Given an class with the fields key defined as a primitive datatype instead of a Map, then collect an error that at least one field has to be added.',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
fields: int
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        ['lib', 'src', 'protocol'],
      );

      var definition =
          SerializableEntityAnalyzer.extractEntityDefinition(protocol);
      SerializableEntityAnalyzer.validateYamlDefinition(protocol.yaml,
          protocol.yamlSourceUri.path, collector, definition, [definition!]);

      expect(collector.errors.length, greaterThan(0));

      var error = collector.errors.first;

      expect(
          error.message, 'The "fields" property must have at least one value.');
    });

    test(
        'Given an enum with the fields key defined, then collect an error that fields are not allowed.',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
enum: Example
fields:
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        ['lib', 'src', 'protocol'],
      );

      var definition =
          SerializableEntityAnalyzer.extractEntityDefinition(protocol);
      SerializableEntityAnalyzer.validateYamlDefinition(protocol.yaml,
          protocol.yamlSourceUri.path, collector, definition, [definition!]);

      expect(collector.errors.length, greaterThan(0));

      var error = collector.errors.first;

      expect(error.message,
          'The "fields" property is not allowed for enum type. Valid keys are {enum, serverOnly, values}.');
    });
  });

  group('Testing key of fields.', () {
    test(
        'Given a class with a field key that is not a string, then collect an error that field keys have to be of the type string.',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
fields:
  1: String
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        ['lib', 'src', 'protocol'],
      );

      var definition =
          SerializableEntityAnalyzer.extractEntityDefinition(protocol);
      SerializableEntityAnalyzer.validateYamlDefinition(protocol.yaml,
          protocol.yamlSourceUri.path, collector, definition, [definition!]);

      expect(collector.errors.length, greaterThan(0));

      var error = collector.errors.first;

      expect(error.message, 'Key must be of type String.');
    });

    test(
        'Given a class with a field key that is not a valid dart variable name style, collect an error that the keys needs to follow the dart convention.',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
fields:
  InvalidFieldName: String
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        ['lib', 'src', 'protocol'],
      );

      var definition =
          SerializableEntityAnalyzer.extractEntityDefinition(protocol);
      SerializableEntityAnalyzer.validateYamlDefinition(protocol.yaml,
          protocol.yamlSourceUri.path, collector, definition, [definition!]);

      expect(collector.errors.length, greaterThan(0));

      var error = collector.errors.first;

      expect(error.message,
          'Keys of "fields" Map must be valid Dart variable names (e.g. camelCaseString).');
    });

    test(
        'Given a class with a valid field key, then an entity with that field is generated.',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
fields:
  name: String
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        ['lib', 'src', 'protocol'],
      );

      var definition =
          SerializableEntityAnalyzer.extractEntityDefinition(protocol);
      SerializableEntityAnalyzer.validateYamlDefinition(protocol.yaml,
          protocol.yamlSourceUri.path, collector, definition, [definition!]);

      var entities = definition as ClassDefinition;

      expect(entities.fields.first.name, 'name');
    });
  });

  group('Field datatype tests.', () {
    test(
        'Given a class with a field without a datatype defined, then collect an error that defining a datatype is required.',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
fields:
  name:
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

      expect(
        error.message,
        'The field must have a datatype defined (e.g. field: String).',
      );
    });

    test(
        'Given an exception with a field without a datatype defined, then collect an error that defining a datatype is required.',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
exception: Example
fields:
  name:
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

      expect(
        error.message,
        'The field must have a datatype defined (e.g. field: String).',
      );
    });

    test(
        'Given an exception with a field with the type String, then a class with that field type set to String is generated.',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
exception: Example
fields:
  name: String
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

      expect((definition as ClassDefinition).fields.first.type.toString(),
          'String');
    });

    test(
        'Given a class with a field with the parent keyword but without a value, then collect an error that the parent has to have a valid table name.',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
table: example
fields:
  nameId: int, parent=
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

      print(collector.errors);

      expect(
        error.message,
        'The parent must reference a valid table name (e.g. parent=table_name). "" is not a valid parent name.',
      );
    });

    test(
        'Given a class with a field with the type String, then a class with that field type set to String is generated.',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
fields:
  name: String
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

      expect((definition as ClassDefinition).fields.first.type.toString(),
          'String');
      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors, but found some.',
      );
    });

    test(
        'Given a class with a field with the type int, then a class with that field type is generated.',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
fields:
  name: int
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

      expect(
          (definition as ClassDefinition).fields.first.type.toString(), 'int');
      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors, but found some.',
      );
    });

    test(
        'Given a class with a field with the type bool, then a class with that field type is generated.',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
fields:
  name: bool
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

      expect(
          (definition as ClassDefinition).fields.first.type.toString(), 'bool');
      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors, but found some.',
      );
    });

    test(
        'Given a class with a field with the type double, then a class with that field type is generated.',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
fields:
  name: double
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

      expect((definition as ClassDefinition).fields.first.type.toString(),
          'double');
      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors, but found some.',
      );
    });

    test(
        'Given a class with a field with the type DateTime, then a class with that field type is generated.',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
fields:
  name: DateTime
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

      expect((definition as ClassDefinition).fields.first.type.toString(),
          'DateTime');
      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors, but found some.',
      );
    });

    test(
        'Given a class with a field with the type Uuid, then a class with that field type is generated.',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
fields:
  name: Uuid
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

      expect(
          (definition as ClassDefinition).fields.first.type.toString(), 'Uuid');
      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors, but found some.',
      );
    });

    test(
        'Given a class with a field with the type ByteData, then a class with that field type is generated.',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
fields:
  name: ByteData
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

      expect((definition as ClassDefinition).fields.first.type.toString(),
          'dart:typed_data:ByteData');
      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors, but found some.',
      );
    });

    test(
        'Given a class with a field with the type List, then a class with that field type is generated.',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
fields:
  name: List<String>
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

      expect((definition as ClassDefinition).fields.first.type.toString(),
          'List<String>');
      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors, but found some.',
      );
    });

    test(
        'Given a class with a field with the type Map, then a class with that field type is generated.',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
fields:
  name: Map<String,String>
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

      expect((definition as ClassDefinition).fields.first.type.toString(),
          'Map<String,String>');
      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors, but found some.',
      );
    });
  });

  group('Parent table tests', () {
    test(
      'Given a class with a field with a parent, then the generated entity has a parentTable property set to the parent table name.',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
        class: Example
        table: example
        fields:
          parentId: int, parent=parent_table
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

        expect((definition as ClassDefinition).fields.last.parentTable,
            'parent_table');
      },
    );

    test(
      'Given a class with a field with two parent keywords, then collect an error that only one parent is allowed.',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
        class: Example
        table: example
        fields:
          name: String, parent=my_table, parent=second
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
            'The field option "parent" is defined more than once.');
      },
    );
  });

  group('Field scope tests', () {
    test(
      'Given a class with a field with two database keywords, then collect an error that only one database is allowed.',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
        class: Example
        fields:
          name: String, database, database
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
            'The field option "database" is defined more than once.');
      },
    );

    test(
      'Given a class with a field with two api keywords, then collect an error that only one api is allowed.',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
        class: Example
        fields:
          name: String, api, api
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

        expect(
            error.message, 'The field option "api" is defined more than once.');
      },
    );

    test(
      'Given a class with a field with both the api and database keywords, then collect an error that only one of them is allowed.',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
        class: Example
        fields:
          name: String, api, database
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

        expect(collector.errors.length, greaterThan(1));

        var error1 = collector.errors[0];
        var error2 = collector.errors[1];

        expect(error1.message,
            'The "database" property is mutually exclusive with the "api" property.');
        expect(error2.message,
            'The "api" property is mutually exclusive with the "database" property.');
      },
    );

    test(
      'Given a class with a field with a complex datatype, then generate an entity with that datatype.',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
        class: Example
        fields:
          name: Map<String, String>
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

        expect(
            (definition as ClassDefinition).fields.first.type.className, 'Map');
      },
    );

    test(
      'Given a class with a field with no scope set, then the generated entity has the all scope.',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
        class: Example
        table: example
        fields:
          name: String
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

        expect((definition as ClassDefinition).fields.last.scope,
            SerializableEntityFieldScope.all);
      },
    );

    test(
      'Given a class with a field with the scope set to database, then the generated entity has the database scope.',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
        class: Example
        table: example
        fields:
          name: String, database
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

        expect((definition as ClassDefinition).fields.last.scope,
            SerializableEntityFieldScope.database);
      },
    );
  });

  test(
    'Given a class with a field with the scope set to api, then the generated entity has the api scope.',
    () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
      class: Example
      table: example
      fields:
        name: String, api
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

      expect((definition as ClassDefinition).fields.last.scope,
          SerializableEntityFieldScope.api);
    },
  );

  group('Test id field.', () {
    test(
      'Given a class with a table defined, then add an id field to the generated entity.',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
        class: Example
        table: example
        fields:
          name: String
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

        expect((definition as ClassDefinition).fields.first.name, 'id');
        expect(definition.fields.first.type.className, 'int');
        expect(definition.fields.first.type.nullable, true);
      },
    );

    test(
      'Given a class without a table defined, then no id field is added.',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
        class: Example
        fields:
          name: String
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

        expect((definition as ClassDefinition).fields.first.name, isNot('id'));
        expect(definition.fields, hasLength(1));
      },
    );
  });

  test(
    'Given a class with a field of a Map type, then all the data types components are extracted.',
    () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
      class: Example
      fields:
        customField: Map<String, CustomClass>
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

      expect(
        (definition as ClassDefinition).fields.first.type.className,
        'Map',
      );

      expect(
        definition.fields.first.type.generics.first.className,
        'String',
      );

      expect(
        definition.fields.first.type.generics.last.className,
        'CustomClass',
      );
    },
  );
}
