import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
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
  Invalid-Field-Name: String
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        ['lib', 'src', 'protocol'],
      );

      var definition =
          SerializableEntityAnalyzer.extractEntityDefinition(protocol);
      SerializableEntityAnalyzer.validateYamlDefinition(protocol.yaml,
          protocol.yamlSourceUri.path, collector, definition, [definition!]);

      expect(collector.errors.length, greaterThan(0));

      var error = collector.errors.first as SourceSpanSeverityException;

      expect(error.message,
          'Field names must be valid Dart variable names (e.g. camelCaseString).');

      expect(error.severity, SourceSpanSeverity.error);
    });

    test(
        'Given a class with a field key that is in UPPERCASE format, collect an info that the keys needs to follow the dart convention.',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
fields:
  UPPERCASE: String
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        ['lib', 'src', 'protocol'],
      );

      var definition =
          SerializableEntityAnalyzer.extractEntityDefinition(protocol);
      SerializableEntityAnalyzer.validateYamlDefinition(protocol.yaml,
          protocol.yamlSourceUri.path, collector, definition, [definition!]);

      expect(collector.errors.length, greaterThan(0));

      var error = collector.errors.first as SourceSpanSeverityException;

      expect(error.message,
          'Field names should be valid Dart variable names (e.g. camelCaseString).');

      expect(error.severity, SourceSpanSeverity.info);
    });

    test(
        'Given a class with a field key that is in PascalCase format, collect an info that the keys needs to follow the dart convention.',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
fields:
  PascalCase: String
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        ['lib', 'src', 'protocol'],
      );

      var definition =
          SerializableEntityAnalyzer.extractEntityDefinition(protocol);
      SerializableEntityAnalyzer.validateYamlDefinition(protocol.yaml,
          protocol.yamlSourceUri.path, collector, definition, [definition!]);

      expect(collector.errors.length, greaterThan(0));

      var error = collector.errors.first as SourceSpanSeverityException;

      expect(error.message,
          'Field names should be valid Dart variable names (e.g. camelCaseString).');

      expect(error.severity, SourceSpanSeverity.info);
    });

    test(
        'Given a class with a field key that is in snake_case format, collect an info that the keys needs to follow the dart convention.',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
fields:
  snake_case: String
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        ['lib', 'src', 'protocol'],
      );

      var definition =
          SerializableEntityAnalyzer.extractEntityDefinition(protocol);
      SerializableEntityAnalyzer.validateYamlDefinition(protocol.yaml,
          protocol.yamlSourceUri.path, collector, definition, [definition!]);

      expect(collector.errors.length, greaterThan(0));

      var error = collector.errors.first as SourceSpanSeverityException;

      expect(error.message,
          'Field names should be valid Dart variable names (e.g. camelCaseString).');

      expect(error.severity, SourceSpanSeverity.info);
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
        'Given a class with a field with the nullable type String, then a class with that field type set to String? is generated.',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
fields:
  name: String?
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
          'String?');
      expect(
        definition.fields.first.type.nullable,
        true,
        reason: 'Expected the type to be nullable.',
      );
      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors, but found some.',
      );
    });

    test(
        'Given a class with a field with the nullable type List<String>, then a class with that field type set to List<String>? is generated.',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
fields:
  name: List<String>?
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
          'List<String>?');
      expect(
        definition.fields.first.type.nullable,
        true,
        reason: 'Expected the type to be nullable.',
      );
      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors, but found some.',
      );
    });

    test(
        'Given a class with a field with a nested nullable type, then a class with that field type set.',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
fields:
  name: List<String?>?
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
          'List<String?>?');
      expect(
        definition.fields.first.type.nullable,
        true,
        reason: 'Expected the type to be nullable.',
      );
      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors, but found some.',
      );
    });

    test(
        'Given a class with a field with a only ??? as the type, then collect an error that it is an invalid type.',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
fields:
  name: ???
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
        collector.errors.length,
        greaterThan(0),
        reason: 'Expected an error, but none was found.',
      );

      var error = collector.errors.first;

      expect(
        error.message,
        'The field has an invalid datatype "???".',
      );
    });

    test(
        'Given a class with a field with a type of String???, then collect an error that it is an invalid type.',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
fields:
  name: String???
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
        collector.errors.length,
        greaterThan(0),
        reason: 'Expected an error, but none was found.',
      );

      var error = collector.errors.first;

      expect(
        error.message,
        'The field has an invalid datatype "String???".',
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

      expect((definition as ClassDefinition).fields.first.type.toString(),
          'Map<String,String>');
      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors, but found some.',
      );
    });

    test(
        'Given a class with a complex nested field datatype, then a class with that field type is generated.',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
fields:
  name: List<List<Map<String, int>>>
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
          'List<List<Map<String,int>>>');
      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors, but found some.',
      );
    });

    test(
        'Given a class with a complex nested field datatype, then a class with that field type is generated.',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
fields:
  name: module:auth:UserInfo
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
          'module:auth:UserInfo');
      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors, but found some.',
      );
    });

    test(
        'Given a class with a field with an invalid dart syntax for the type, then collect an error that the type is invalid.',
        () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
class: Example
fields:
  name: invalid-type
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

      expect(collector.errors.length, greaterThan(0),
          reason: 'Expected an error, but none was found.');
      expect(collector.errors.first.message,
          'The field has an invalid datatype "invalid-type".');
    });

    test(
        'Given a class with a field with a nested invalid dart syntax for the type, then collect an error that the type is invalid.',
        () {
      var collector = CodeGenerationCollector();

      var protocol = ProtocolSource(
        '''
class: Example
fields:
  parent: Map<int, invalid-type>
''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
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

      expect(
        collector.errors.length,
        greaterThan(0),
        reason: 'Expected an error',
      );

      expect(
        collector.errors.first.message,
        'The field has an invalid datatype "Map<int, invalid-type>".',
      );
    });
  });

  group('Parent table tests', () {
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

      expect(
        error.message,
        'The parent must reference a valid table name (e.g. parent=table_name). "" is not a valid parent name.',
      );
    });

    test(
      'Given a class with a field with a parent, then the generated entity has a parentTable property set to the parent table name.',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
        class: Example
        table: example
        fields:
          parentId: int, parent=example
        ''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          ['lib', 'src', 'protocol'],
        );

        var definition =
            SerializableEntityAnalyzer.extractEntityDefinition(protocol)
                as ClassDefinition;
        var entities = [definition];
        SerializableEntityAnalyzer.resolveEntityDependencies(entities);
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition],
        );

        var relation = definition.fields.last.relation;

        expect(relation.runtimeType, ForeignRelationDefinition);
        expect((relation as ForeignRelationDefinition).parentTable, 'example');
      },
    );

    test(
      'Given a class with a field with a parent with whitespace in the syntax, then the generated entity has a parentTable property set to the parent table name.',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
        class: Example
        table: example
        fields:
          parentId: int, parent = example
        ''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          ['lib', 'src', 'protocol'],
        );

        var definition =
            SerializableEntityAnalyzer.extractEntityDefinition(protocol)
                as ClassDefinition;
        var entities = [definition];
        SerializableEntityAnalyzer.resolveEntityDependencies(entities);
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition],
        );

        var relation = definition.fields.last.relation;

        expect(relation.runtimeType, ForeignRelationDefinition);
        expect((relation as ForeignRelationDefinition).parentTable, 'example');
      },
    );

    test(
      'Given a class with a field with a parent, then a deprecated info is generated.',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
        class: Example
        table: example
        fields:
          parentId: int, parent=example
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

        expect(collector.errors, isNotEmpty);

        var error = collector.errors.first;

        expect(
          error.message,
          'The "parent" property is deprecated. Use the relation keyword instead. E.g. relation(parent=parent_table)',
        );
      },
    );

    test(
      'Given a class with a field with a parent that do not exist, then collect an error that the parent table is not found.',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
        class: Example
        table: example
        fields:
          name: int, parent=unknown_table
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
            'The parent table "unknown_table" was not found in any protocol.');
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
          parentId: int, parent=example, parent=example
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

    test(
      'Given a class without a table definition but with a field with a parent, then collect an error that the table needs to be defined.',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
        class: Example
        fields:
          parentId: int, parent=example
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
          'The "table" property must be defined in the class to set a parent on a field.',
        );
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

    test(
      'Given a class with a field with the scope set to api and a parent table, then report an error that the parent keyword and api scope is not valid together.',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
      class: Example
      table: example
      fields:
        nextId: int, parent=example, api
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
          collector.errors.length,
          greaterThan(0),
          reason: 'Expected an error, none was found.',
        );
        expect(
          collector.errors.last.message,
          'The "api" property is mutually exclusive with the "parent" property.',
        );
      },
    );
  });

  group('Test id field.', () {
    test(
      'Given a class with a table and a field called "id" defined, then collect an error that the id field is not allowed.',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
        class: Example
        table: example
        fields:
          id: int
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

        expect(collector.errors.length, greaterThan(0),
            reason: 'Expected an error, but got none.');

        expect(
          collector.errors.first.message,
          'The field name "id" is not allowed when a table is defined (the "id" field will be auto generated).',
        );
      },
    );
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
