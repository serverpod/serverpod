import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/analyzer/entities/entity_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given a class without the fields key, then collect an error that the fields key is required',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
class: Example
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      outFileName: 'example.yaml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    analyzer.analyze();

    expect(collector.errors.length, greaterThan(0));

    var error = collector.errors.first;

    expect(error.message, 'No "fields" property is defined.');
  });

  test(
      'Given an exception without the fields key, then collect an error that the fields key is required',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
exception: Example
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      outFileName: 'example.yaml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    analyzer.analyze();

    expect(collector.errors.length, greaterThan(0));

    var error = collector.errors.first;

    expect(error.message, 'No "fields" property is defined.');
  });
  group('Testing key of fields.', () {
    test(
        'Given a class with a field key that is not a string, then collect an error that field keys have to be of the type string.',
        () {
      var collector = CodeGenerationCollector();
      var analyzer = SerializableEntityAnalyzer(
        yaml: '''
class: Example
fields:
  1: String
''',
        sourceFileName: 'lib/src/protocol/example.yaml',
        outFileName: 'example.yaml',
        subDirectoryParts: ['lib', 'src', 'protocol'],
        collector: collector,
      );

      analyzer.analyze();

      expect(collector.errors.length, greaterThan(0));

      var error = collector.errors.first;

      expect(error.message, 'Key must be of type String.');
    });

    test(
        'Given a class with a field key that is not a valid dart variable name style, collect an error that the keys needs to follow the dart convention.',
        () {
      var collector = CodeGenerationCollector();
      var analyzer = SerializableEntityAnalyzer(
        yaml: '''
class: Example
fields:
  InvalidFieldName: String
''',
        sourceFileName: 'lib/src/protocol/example.yaml',
        outFileName: 'example.yaml',
        subDirectoryParts: ['lib', 'src', 'protocol'],
        collector: collector,
      );

      analyzer.analyze();

      expect(collector.errors.length, greaterThan(0));

      var error = collector.errors.first;

      expect(error.message,
          'Keys of "fields" Map must be valid Dart variable names (e.g. camelCaseString).');
    });

    test(
        'Given a class with a valid field key, then an entity with that field is generated.',
        () {
      var collector = CodeGenerationCollector();
      var analyzer = SerializableEntityAnalyzer(
        yaml: '''
class: Example
fields:
  name: String
''',
        sourceFileName: 'lib/src/protocol/example.yaml',
        outFileName: 'example.yaml',
        subDirectoryParts: ['lib', 'src', 'protocol'],
        collector: collector,
      );

      ClassDefinition entities = analyzer.analyze() as ClassDefinition;

      expect(entities.fields.first.name, 'name');
    });
  });

  group('Field datatype tests.', () {
    test(
        'Given a class with a field without a datatype defined, then collect an error that defining a datatype is required.',
        () {
      var collector = CodeGenerationCollector();
      var analyzer = SerializableEntityAnalyzer(
        yaml: '''
class: Example
fields:
  name:
''',
        sourceFileName: 'lib/src/protocol/example.yaml',
        outFileName: 'example.yaml',
        subDirectoryParts: ['lib', 'src', 'protocol'],
        collector: collector,
      );

      analyzer.analyze();

      expect(collector.errors.length, greaterThan(0));

      var error = collector.errors.first;

      expect(error.message,
          'The field must have a datatype defined (e.g. field: String).');
    });

    test(
        'Given a class with a field with the parent keyword but without a value, then collect an error that the parent has to have a valid table name.',
        () {
      var collector = CodeGenerationCollector();
      var analyzer = SerializableEntityAnalyzer(
        yaml: '''
class: Example
table: example
fields:
  nameId: int, parent=
''',
        sourceFileName: 'lib/src/protocol/example.yaml',
        outFileName: 'example.yaml',
        subDirectoryParts: ['lib', 'src', 'protocol'],
        collector: collector,
      );

      analyzer.analyze();

      expect(collector.errors.length, greaterThan(0));

      var error = collector.errors.first;

      expect(error.message,
          'The parent must reference a valid table name (e.g. parent=table_name). "" is not a valid parent name.');
    });

    test(
        'Given a class with a field with the type String, then a class with that field type set to String is generated.',
        () {
      var collector = CodeGenerationCollector();
      var analyzer = SerializableEntityAnalyzer(
        yaml: '''
class: Example
fields:
  name: String
''',
        sourceFileName: 'lib/src/protocol/example.yaml',
        outFileName: 'example.yaml',
        subDirectoryParts: ['lib', 'src', 'protocol'],
        collector: collector,
      );

      ClassDefinition entities = analyzer.analyze() as ClassDefinition;

      expect(entities.fields.first.type.toString(), 'String');
    });

    test(
        'Given a class with a field with the type int, then a class with that field type is generated.',
        () {
      var collector = CodeGenerationCollector();
      var analyzer = SerializableEntityAnalyzer(
        yaml: '''
class: Example
fields:
  name: int
''',
        sourceFileName: 'lib/src/protocol/example.yaml',
        outFileName: 'example.yaml',
        subDirectoryParts: ['lib', 'src', 'protocol'],
        collector: collector,
      );

      ClassDefinition entities = analyzer.analyze() as ClassDefinition;

      expect(entities.fields.first.type.toString(), 'int');
    });

    test(
        'Given a class with a field with the type int, then a class with that field type is generated.',
        () {
      var collector = CodeGenerationCollector();
      var analyzer = SerializableEntityAnalyzer(
        yaml: '''
class: Example
fields:
  name: bool
''',
        sourceFileName: 'lib/src/protocol/example.yaml',
        outFileName: 'example.yaml',
        subDirectoryParts: ['lib', 'src', 'protocol'],
        collector: collector,
      );

      ClassDefinition entities = analyzer.analyze() as ClassDefinition;

      expect(entities.fields.first.type.toString(), 'bool');
    });

    test(
        'Given a class with a field with the type double, then a class with that field type is generated.',
        () {
      var collector = CodeGenerationCollector();
      var analyzer = SerializableEntityAnalyzer(
        yaml: '''
class: Example
fields:
  name: double
''',
        sourceFileName: 'lib/src/protocol/example.yaml',
        outFileName: 'example.yaml',
        subDirectoryParts: ['lib', 'src', 'protocol'],
        collector: collector,
      );

      ClassDefinition entities = analyzer.analyze() as ClassDefinition;

      expect(entities.fields.first.type.toString(), 'double');
    });

    test(
        'Given a class with a field with the type DateTime, then a class with that field type is generated.',
        () {
      var collector = CodeGenerationCollector();
      var analyzer = SerializableEntityAnalyzer(
        yaml: '''
class: Example
fields:
  name: DateTime
''',
        sourceFileName: 'lib/src/protocol/example.yaml',
        outFileName: 'example.yaml',
        subDirectoryParts: ['lib', 'src', 'protocol'],
        collector: collector,
      );

      ClassDefinition entities = analyzer.analyze() as ClassDefinition;

      expect(entities.fields.first.type.toString(), 'DateTime');
    });

    test(
        'Given a class with a field with the type Uuid, then a class with that field type is generated.',
        () {
      var collector = CodeGenerationCollector();
      var analyzer = SerializableEntityAnalyzer(
        yaml: '''
class: Example
fields:
  name: Uuid
''',
        sourceFileName: 'lib/src/protocol/example.yaml',
        outFileName: 'example.yaml',
        subDirectoryParts: ['lib', 'src', 'protocol'],
        collector: collector,
      );

      ClassDefinition entities = analyzer.analyze() as ClassDefinition;

      expect(entities.fields.first.type.toString(), 'Uuid');
    });

    test(
        'Given a class with a field with the type ByteData, then a class with that field type is generated.',
        () {
      var collector = CodeGenerationCollector();
      var analyzer = SerializableEntityAnalyzer(
        yaml: '''
class: Example
fields:
  name: ByteData
''',
        sourceFileName: 'lib/src/protocol/example.yaml',
        outFileName: 'example.yaml',
        subDirectoryParts: ['lib', 'src', 'protocol'],
        collector: collector,
      );

      ClassDefinition entities = analyzer.analyze() as ClassDefinition;

      expect(entities.fields.first.type.toString(), 'dart:typed_data:ByteData');
    });

    test(
        'Given a class with a field with the type List, then a class with that field type is generated.',
        () {
      var collector = CodeGenerationCollector();
      var analyzer = SerializableEntityAnalyzer(
        yaml: '''
class: Example
fields:
  name: List<String>
''',
        sourceFileName: 'lib/src/protocol/example.yaml',
        outFileName: 'example.yaml',
        subDirectoryParts: ['lib', 'src', 'protocol'],
        collector: collector,
      );

      ClassDefinition entities = analyzer.analyze() as ClassDefinition;

      expect(entities.fields.first.type.toString(), 'List<String>');
    });

    test(
        'Given a class with a field with the type Map, then a class with that field type is generated.',
        () {
      var collector = CodeGenerationCollector();
      var analyzer = SerializableEntityAnalyzer(
        yaml: '''
class: Example
fields:
  name: Map<String,String>
''',
        sourceFileName: 'lib/src/protocol/example.yaml',
        outFileName: 'example.yaml',
        subDirectoryParts: ['lib', 'src', 'protocol'],
        collector: collector,
      );

      ClassDefinition entities = analyzer.analyze() as ClassDefinition;

      expect(entities.fields.first.type.toString(), 'Map<String,String>');
    });
  });

  group('Parent table tests', () {
    test(
        'Given a class with a field with a parent, then the generated entity has a parentTable property set to the parent table name.',
        () {
      var collector = CodeGenerationCollector();
      var analyzer = SerializableEntityAnalyzer(
        yaml: '''
class: Example
table: example
fields:
  parentId: int, parent=parent_table
''',
        sourceFileName: 'lib/src/protocol/example.yaml',
        outFileName: 'example.yaml',
        subDirectoryParts: ['lib', 'src', 'protocol'],
        collector: collector,
      );

      analyzer.analyze();

      ClassDefinition entities = analyzer.analyze() as ClassDefinition;

      expect(entities.fields.last.parentTable, 'parent_table');
    });
    test(
        'Given a class with a field with two parent keywords, then collect an error that only one parent is allowed.',
        () {
      var collector = CodeGenerationCollector();
      var analyzer = SerializableEntityAnalyzer(
        yaml: '''
class: Example
table: example
fields:
  name: String, parent=first, parent=second
''',
        sourceFileName: 'lib/src/protocol/example.yaml',
        outFileName: 'example.yaml',
        subDirectoryParts: ['lib', 'src', 'protocol'],
        collector: collector,
      );

      analyzer.analyze();

      expect(collector.errors.length, greaterThan(0));

      var error = collector.errors.first;

      expect(error.message,
          'The field option "parent" is defined more than once.');
    });
  });

  group('Field scope tests', () {
    test(
        'Given a class with a field with two database keywords, then collect an error that only one database is allowed.',
        () {
      var collector = CodeGenerationCollector();
      var analyzer = SerializableEntityAnalyzer(
        yaml: '''
class: Example
fields:
  name: String, database, database
''',
        sourceFileName: 'lib/src/protocol/example.yaml',
        outFileName: 'example.yaml',
        subDirectoryParts: ['lib', 'src', 'protocol'],
        collector: collector,
      );

      analyzer.analyze();

      expect(collector.errors.length, greaterThan(0));

      var error = collector.errors.first;

      expect(error.message,
          'The field option "database" is defined more than once.');
    });

    test(
        'Given a class with a field with two api keywords, then collect an error that only one api is allowed.',
        () {
      var collector = CodeGenerationCollector();
      var analyzer = SerializableEntityAnalyzer(
        yaml: '''
class: Example
fields:
  name: String, api, api
''',
        sourceFileName: 'lib/src/protocol/example.yaml',
        outFileName: 'example.yaml',
        subDirectoryParts: ['lib', 'src', 'protocol'],
        collector: collector,
      );

      analyzer.analyze();

      expect(collector.errors.length, greaterThan(0));

      var error = collector.errors.first;

      expect(
          error.message, 'The field option "api" is defined more than once.');
    });

    test(
        'Given a class with a field with both the api and database keywords, then collect an error that only one of them is allowed.',
        () {
      var collector = CodeGenerationCollector();
      var analyzer = SerializableEntityAnalyzer(
        yaml: '''
class: Example
fields:
  name: String, api, database
''',
        sourceFileName: 'lib/src/protocol/example.yaml',
        outFileName: 'example.yaml',
        subDirectoryParts: ['lib', 'src', 'protocol'],
        collector: collector,
      );

      analyzer.analyze();

      expect(collector.errors.length, greaterThan(1));

      var error1 = collector.errors[0];
      var error2 = collector.errors[1];

      expect(error1.message,
          'The "database" property is mutually exclusive with the "api" property.');
      expect(error2.message,
          'The "api" property is mutually exclusive with the "database" property.');
    });

    test(
        'Given a class with a field with a complex datatype, then generate an entity with that datatype.',
        () {
      var collector = CodeGenerationCollector();
      var analyzer = SerializableEntityAnalyzer(
        yaml: '''
class: Example
fields:
  name: Map<String, String>
''',
        sourceFileName: 'lib/src/protocol/example.yaml',
        outFileName: 'example.yaml',
        subDirectoryParts: ['lib', 'src', 'protocol'],
        collector: collector,
      );

      ClassDefinition entities = analyzer.analyze() as ClassDefinition;

      expect(entities.fields.first.type.className, 'Map');
    });

    test(
        'Given a class with a field with no scope set, then the generated entity has the all scope.',
        () {
      var collector = CodeGenerationCollector();
      var analyzer = SerializableEntityAnalyzer(
        yaml: '''
class: Example
table: example
fields:
  name: String
''',
        sourceFileName: 'lib/src/protocol/example.yaml',
        outFileName: 'example.yaml',
        subDirectoryParts: ['lib', 'src', 'protocol'],
        collector: collector,
      );

      ClassDefinition entities = analyzer.analyze() as ClassDefinition;

      expect(entities.fields.last.scope, SerializableEntityFieldScope.all);
    });

    test(
        'Given a class with a field with the scope set to database, then the generated entity has the database scope.',
        () {
      var collector = CodeGenerationCollector();
      var analyzer = SerializableEntityAnalyzer(
        yaml: '''
class: Example
table: example
fields:
  name: String, database
''',
        sourceFileName: 'lib/src/protocol/example.yaml',
        outFileName: 'example.yaml',
        subDirectoryParts: ['lib', 'src', 'protocol'],
        collector: collector,
      );

      ClassDefinition entities = analyzer.analyze() as ClassDefinition;

      expect(entities.fields.last.scope, SerializableEntityFieldScope.database);
    });

    test(
        'Given a class with a field with the scope set to api, then the generated entity has the api scope.',
        () {
      var collector = CodeGenerationCollector();
      var analyzer = SerializableEntityAnalyzer(
        yaml: '''
class: Example
table: example
fields:
  name: String, api
''',
        sourceFileName: 'lib/src/protocol/example.yaml',
        outFileName: 'example.yaml',
        subDirectoryParts: ['lib', 'src', 'protocol'],
        collector: collector,
      );

      ClassDefinition entities = analyzer.analyze() as ClassDefinition;

      expect(entities.fields.last.scope, SerializableEntityFieldScope.api);
    });
  });

  group('Test id field.', () {
    test(
        'Given a class with a table defined, then add an id field to the generated entity.',
        () {
      var collector = CodeGenerationCollector();
      var analyzer = SerializableEntityAnalyzer(
        yaml: '''
class: Example
table: example
fields:
  name: String
''',
        sourceFileName: 'lib/src/protocol/example.yaml',
        outFileName: 'example.yaml',
        subDirectoryParts: ['lib', 'src', 'protocol'],
        collector: collector,
      );

      ClassDefinition entities = analyzer.analyze() as ClassDefinition;

      expect(entities.fields.first.name, 'id');
      expect(entities.fields.first.type.className, 'int');
      expect(entities.fields.first.type.nullable, true);
    });

    test('Given a class without a table defined, then no id field is added.',
        () {
      var collector = CodeGenerationCollector();
      var analyzer = SerializableEntityAnalyzer(
        yaml: '''
class: Example
fields:
  name: String
''',
        sourceFileName: 'lib/src/protocol/example.yaml',
        outFileName: 'example.yaml',
        subDirectoryParts: ['lib', 'src', 'protocol'],
        collector: collector,
      );

      ClassDefinition entities = analyzer.analyze() as ClassDefinition;

      expect(entities.fields.first.name, isNot('id'));
      expect(entities.fields, hasLength(1));
    });
  });
}
