import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/analyzer/entities/entity_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given a class with the index property defined but without any index, then collect an error that at least one index has to be added.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
class: Example
table: example
fields:
  name: String
indexes:
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      outFileName: 'example.yateriml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    analyzer.analyze();

    expect(collector.errors.length, greaterThan(0));

    var error = collector.errors.first;

    expect(
        error.message, 'The "indexes" property must have at least one value.');
  });

  test(
      'Given a class with an index that does not define the fields keyword, then collect an error that fields are required.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
class: Example
table: example
fields:
  name: String
indexes:
  example_index:
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      outFileName: 'example.yateriml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    analyzer.analyze();

    expect(collector.errors.length, greaterThan(0));

    var error = collector.errors.first;

    expect(error.message,
        'The "example_index" property is missing required keys (fields).');
  });

  test(
      'Given a class with an index key that is not a string, then collect an error that the index name has to be defined as a string.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
class: Example
table: example
fields:
  name: String
indexes:
  1:
    fields: name
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      outFileName: 'example.yateriml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    analyzer.analyze();

    expect(collector.errors.length, greaterThan(0));

    var error = collector.errors.first;

    expect(error.message, 'Key must be of type String.');
  });

  test(
      'Given a class with an index key that is not a string in snake_case_format, then collect an error that the index name is using an invalid format.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
class: Example
table: example
fields:
  name: String
indexes:
  PascalCaseIndex:
    fields: name
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      outFileName: 'example.yateriml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    analyzer.analyze();

    expect(collector.errors.length, greaterThan(0));

    var error = collector.errors.first;

    expect(error.message,
        'Invalid format for index "PascalCaseIndex", must follow the format lower_snake_case.');
  });
  test(
      'Given a class with an index without any fields, then collect an error that at least one field has to be added.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
class: Example
table: example
fields:
  name: String
indexes:
  example_index:
    fields:
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      outFileName: 'example.yateriml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    analyzer.analyze();

    expect(collector.errors.length, greaterThan(0));

    var error = collector.errors.first;

    expect(error.message,
        'The "fields" property must have at least one field, (e.g. fields: fieldName).');
  });

  test(
      'Given a class with an index with a field that does not exist, then collect an error that the field is missing in the class.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
class: Example
table: example
fields:
  name: String
indexes:
  example_index:
    fields: missingField
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      outFileName: 'example.yateriml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    analyzer.analyze();

    expect(collector.errors.length, greaterThan(0));

    var error = collector.errors.first;

    expect(error.message,
        'The field name "missingField" is not added to the class or has an api scope.');
  });

  test(
      'Given a class with an index with a field that has an api scope, then collect an error that the field is missing in the class.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
class: Example
table: example
fields:
  name: String
  apiField: String, api
indexes:
  example_index:
    fields: apiField
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      outFileName: 'example.yateriml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    analyzer.analyze();

    expect(collector.errors.length, greaterThan(0));

    var error = collector.errors.first;

    expect(error.message,
        'The field name "apiField" is not added to the class or has an api scope.');
  });

  test(
      'Given a class with an index with two fields where the second is null, then collect an error that the field must be defined.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
class: Example
table: example
fields:
  name: String
indexes:
  example_index:
    fields: name,
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      outFileName: 'example.yateriml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    analyzer.analyze();

    expect(collector.errors.length, greaterThan(0));

    var error = collector.errors.first;

    expect(error.message,
        'The field name "" is not added to the class or has an api scope.');
  });

  //Given a class with an index with a defined field, then the definition contains the index field.

  test(
      'Given a class with an index with a defined field, then the definition contains the index.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
class: Example
table: example
fields:
  name: String
indexes:
  example_index:
    fields: name
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      outFileName: 'example.yateriml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    ClassDefinition entityDefinition = analyzer.analyze() as ClassDefinition;

    var index = entityDefinition.indexes?.first;

    expect(index!.name, 'example_index');
  });

  test(
      'Given a class with an index with a defined field, then the definition contains the fields of the index.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
class: Example
table: example
fields:
  name: String
indexes:
  example_index:
    fields: name
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      outFileName: 'example.yateriml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    ClassDefinition entityDefinition = analyzer.analyze() as ClassDefinition;

    var index = entityDefinition.indexes?.first;

    var field = index?.fields.first;

    expect(field, 'name');
  });

  test(
      'Given a class with an index with two defined fields, then the definition contains the fields of the index.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
class: Example
table: example
fields:
  name: String
  foo: String
indexes:
  example_index:
    fields: name, foo
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      outFileName: 'example.yateriml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    ClassDefinition entityDefinition = analyzer.analyze() as ClassDefinition;

    var index = entityDefinition.indexes?.first;

    var field1 = index?.fields.first;
    var field2 = index?.fields.last;

    expect(field1, 'name');
    expect(field2, 'foo');
  });

  test(
      'Given a class with two indexes, then the definition contains both the index names.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
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
      sourceFileName: 'lib/src/protocol/example.yaml',
      outFileName: 'example.yateriml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    ClassDefinition entityDefinition = analyzer.analyze() as ClassDefinition;

    var index1 = entityDefinition.indexes?.first;
    var index2 = entityDefinition.indexes?.last;

    expect(index1!.name, 'example_index');
    expect(index2!.name, 'example_index2');
  });

  test(
      'Given a class with an index with a unique key that is not a bool, then collect an error that the unique key has to be defined as a bool.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
class: Example
table: example
fields:
  name: String
indexes:
  example_index:
    fields: name
    unique: InvalidValue
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      outFileName: 'example.yateriml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    analyzer.analyze();

    expect(collector.errors.length, greaterThan(0));

    var error = collector.errors.first;

    expect(error.message, 'The property value must be a bool.');
  });

  test(
      'Given a class with an index with an undefined unique key, then return a definition where unique is set to false.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
class: Example
table: example
fields:
  name: String
indexes:
  example_index:
    fields: name
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      outFileName: 'example.yateriml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    ClassDefinition entityDefinition = analyzer.analyze() as ClassDefinition;

    var index = entityDefinition.indexes?.first;

    expect(index!.unique, false);
  });

  test(
      'Given a class with an index with a unique key set to false, then return a definition where unique is set to false.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
class: Example
table: example
fields:
  name: String
indexes:
  example_index:
    fields: name
    unique: false
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      outFileName: 'example.yateriml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    ClassDefinition entityDefinition = analyzer.analyze() as ClassDefinition;

    var index = entityDefinition.indexes?.first;

    expect(index!.unique, false);
  });

  test(
      'Given a class with an index with a unique key set to true, then return a definition where unique is set to true.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
class: Example
table: example
fields:
  name: String
indexes:
  example_index:
    fields: name
    unique: true
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      outFileName: 'example.yateriml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    ClassDefinition entityDefinition = analyzer.analyze() as ClassDefinition;

    var index = entityDefinition.indexes?.first;

    expect(index!.unique, true);
  });

  test(
      'Given a class with an index with a an invalid key, then collect an error indicating that the key is invalid.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
class: Example
table: example
fields:
  name: String
indexes:
  example_index:
    fields: name
    invalidKey: true
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      outFileName: 'example.yateriml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    analyzer.analyze();

    expect(collector.errors.length, greaterThan(0));

    var error = collector.errors.first;

    expect(error.message,
        'The "invalidKey" property is not allowed for example_index type. Valid keys are {fields, type, unique}.');
  });
}
