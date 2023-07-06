import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/analyzer/entities/entity_analyzer.dart';
import 'package:serverpod_cli/src/util/protocol_helper.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given a class with a class documentation comment then an entity with the class documentation set is generated.',
      () {
    var protocol = ProtocolSource(
      '''
### This is a comment.
class: Example
fields:
  name: String
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var entities = SerializableEntityAnalyzer.extractEntityDefinition(protocol)
        as ClassDefinition?;

    expect(entities?.documentation, ['/// This is a comment.']);
  });

  test(
      'Given a class with a multiline class documentation comment then an entity with the class documentation set is generated.',
      () {
    var protocol = ProtocolSource(
      '''
### This is a...
### multiline comment.
class: Example
fields:
  name: String
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var entities = SerializableEntityAnalyzer.extractEntityDefinition(protocol)
        as ClassDefinition?;

    expect(entities?.documentation,
        ['/// This is a...', '/// multiline comment.']);
  });

  test(
      'Given a class with a normal class comment, then the entity that is generated has no documentation set.',
      () {
    var protocol = ProtocolSource(
      '''
# This is a normal comment.
class: Example
fields:
  name: String
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var entities = SerializableEntityAnalyzer.extractEntityDefinition(protocol)
        as ClassDefinition?;

    expect(entities?.documentation, null);
  });

  test(
      'Given a class with a field documentation comment then the entity that is generated has the documentation set for that specific field.',
      () {
    var protocol = ProtocolSource(
      '''
class: Example
fields:
  ### This is a field comment.
  name: String
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var entities = SerializableEntityAnalyzer.extractEntityDefinition(protocol)
        as ClassDefinition?;

    expect(
        entities?.fields.first.documentation, ['/// This is a field comment.']);
  });

  test(
      'Given a class with a multiline field documentation comment then the entity that is generated has the documentation set for that specific field.',
      () {
    var protocol = ProtocolSource(
      '''
class: Example
fields:
  ### This is a multiline
  ### field comment.
  name: String
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var entities = SerializableEntityAnalyzer.extractEntityDefinition(protocol)
        as ClassDefinition?;

    expect(entities?.fields.first.documentation,
        ['/// This is a multiline', '/// field comment.']);
  });

  test(
      'Given a class with multiple fields but only one has a documentation comment then the entity that is generated has the documentation set for that specific field.',
      () {
    var protocol = ProtocolSource(
      '''
class: Example
fields:
  name: String
  ### This is a multiline
  ### field comment.
  age: int
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var entities = SerializableEntityAnalyzer.extractEntityDefinition(protocol)
        as ClassDefinition?;

    expect(entities?.fields.first.documentation, null);
    expect(entities?.fields.last.documentation,
        ['/// This is a multiline', '/// field comment.']);
  });

  test(
      'Given a class with a field with a normal comment, then the entity that is generated has no documentation set.',
      () {
    var protocol = ProtocolSource(
      '''
class: Example
fields:
  # This is a normal comment.
  name: String
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var entities = SerializableEntityAnalyzer.extractEntityDefinition(protocol)
        as ClassDefinition?;

    expect(entities?.fields.first.documentation, null);
  });

  test(
      'Given an enum with a multiline class documentation comment then an entity with the class documentation set is generated.',
      () {
    var protocol = ProtocolSource(
      '''
### This is a...
### multiline comment.
enum: Example
values:
  - first
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var entities = SerializableEntityAnalyzer.extractEntityDefinition(protocol)
        as EnumDefinition?;

    expect(entities?.documentation,
        ['/// This is a...', '/// multiline comment.']);
  });

  test(
      'Given an enum with a multiline value documentation comment then the entity that is generated has the documentation set for that specific field.',
      () {
    var protocol = ProtocolSource(
      '''
enum: Example
values:
  ### This is a multiline
  ### field comment.
  - first
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var entities = SerializableEntityAnalyzer.extractEntityDefinition(protocol)
        as EnumDefinition?;

    expect(entities?.values.first.documentation,
        ['/// This is a multiline', '/// field comment.']);
  });
}
