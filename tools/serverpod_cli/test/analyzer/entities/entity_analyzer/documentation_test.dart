import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/analyzer/entities/entity_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given a class with a class documentation comment then an entity with the class documentation set is generated.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
### This is a comment.
class: Example
fields:
  name: String
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    ClassDefinition entities = analyzer.analyze() as ClassDefinition;

    expect(entities.documentation, ['/// This is a comment.']);
  });

  test(
      'Given a class with a multiline class documentation comment then an entity with the class documentation set is generated.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
### This is a...
### multiline comment.
class: Example
fields:
  name: String
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    ClassDefinition entities = analyzer.analyze() as ClassDefinition;

    expect(
        entities.documentation, ['/// This is a...', '/// multiline comment.']);
  });

  test(
      'Given a class with a normal class comment, then the entity that is generated has no documentation set.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
# This is a normal comment.
class: Example
fields:
  name: String
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    ClassDefinition entities = analyzer.analyze() as ClassDefinition;
    expect(entities.documentation, null);
  });

  test(
      'Given a class with a field documentation comment then the entity that is generated has the documentation set for that specific field.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
class: Example
fields:
  ### This is a field comment.
  name: String
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    ClassDefinition entities = analyzer.analyze() as ClassDefinition;

    expect(
        entities.fields.first.documentation, ['/// This is a field comment.']);
  });

  test(
      'Given a class with a multiline field documentation comment then the entity that is generated has the documentation set for that specific field.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
class: Example
fields:
  ### This is a multiline
  ### field comment.
  name: String
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    ClassDefinition entities = analyzer.analyze() as ClassDefinition;

    expect(entities.fields.first.documentation,
        ['/// This is a multiline', '/// field comment.']);
  });

  test(
      'Given a class with multiple fields but only one has a documentation comment then the entity that is generated has the documentation set for that specific field.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
class: Example
fields:
  name: String
  ### This is a multiline
  ### field comment.
  age: int
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    ClassDefinition entities = analyzer.analyze() as ClassDefinition;
    expect(entities.fields.first.documentation, null);
    expect(entities.fields.last.documentation,
        ['/// This is a multiline', '/// field comment.']);
  });

  test(
      'Given a class with a field with a normal comment, then the entity that is generated has no documentation set.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
class: Example
fields:
  # This is a normal comment.
  name: String
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    ClassDefinition entities = analyzer.analyze() as ClassDefinition;
    expect(entities.fields.first.documentation, null);
  });

  test(
      'Given an enum with a multiline class documentation comment then an entity with the class documentation set is generated.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
### This is a...
### multiline comment.
enum: Example
values:
  - first
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    EnumDefinition entities = analyzer.analyze() as EnumDefinition;

    expect(
        entities.documentation, ['/// This is a...', '/// multiline comment.']);
  });

  test(
      'Given an enum with a multiline value documentation comment then the entity that is generated has the documentation set for that specific field.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
enum: Example
values:
  ### This is a multiline
  ### field comment.
  - first
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    EnumDefinition entities = analyzer.analyze() as EnumDefinition;

    expect(entities.values.first.documentation,
        ['/// This is a multiline', '/// field comment.']);
  });
}
