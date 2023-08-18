import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/analyzer/entities/entity_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/protocol_helper.dart';
import 'package:test/test.dart';

void main() {
  group(
      'Given a class with a relation with a defined field name that holds the relation',
      () {
    var collector = CodeGenerationCollector();

    var protocol1 = ProtocolSource(
      '''
class: Example
table: example
fields:
  myParentId: int
  parent: ExampleParent?, relation(field=myParentId)
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var protocol2 = ProtocolSource(
      '''
class: ExampleParent
table: example_parent
fields:
  name: String
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var definition1 = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol1,
    );

    var definition2 = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol2,
    );

    var entities = [definition1!, definition2!];
    SerializableEntityAnalyzer.resolveEntityDependencies(entities);

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol1.yaml,
      protocol1.yamlSourceUri.path,
      collector,
      definition1,
      entities,
    );

    var exampleClass = definition1 as ClassDefinition;

    test('then no errors were collected', () {
      expect(
        collector.errors,
        isEmpty,
      );
    });

    test('then the implicit parentId field is NOT created', () {
      var field = exampleClass.findField('parentId');
      expect(field, isNull);
    });

    test('then the relation field pointer is set on the object relation.', () {
      var relation = exampleClass.findField('parent')?.relation;
      expect(relation.runtimeType, ObjectRelationDefinition);
      expect(
        (relation as ObjectRelationDefinition).fieldName,
        'myParentId',
      );
    });

    test('then the parent field is set to NOT persist.', () {
      var field = exampleClass.findField('parent');
      expect(field?.shouldPersist, isFalse);
    });
  });

  group('Given a class with a relation pointing to a field that does not exist',
      () {
    var collector = CodeGenerationCollector();

    var protocol1 = ProtocolSource(
      '''
class: Example
table: example
fields:
  parent: Example?, relation(field=myParentId)
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var definition1 = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol1,
    );

    var entities = [definition1!];
    SerializableEntityAnalyzer.resolveEntityDependencies(entities);

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol1.yaml,
      protocol1.yamlSourceUri.path,
      collector,
      definition1,
      entities,
    );

    var errors = collector.errors;

    test('then an error was collected.', () {
      expect(errors, isNotEmpty);
    });

    test('then the error message reports that the field is missing.', () {
      var error = collector.errors.first;
      expect(
        error.message,
        'The field "myParentId" was not found in the class.',
      );
    }, skip: errors.isEmpty);

    test('then the error is reported at the field value location.', () {
      var span = collector.errors.first.span;

      expect(span?.start.line, 3);
      expect(span?.start.column, 35);

      expect(span?.end.line, 3);
      expect(span?.end.column, 35 + 'myParentId'.length);
    }, skip: errors.isEmpty);
  });

  group('Given a class with a List relation with a field pointer defined', () {
    var collector = CodeGenerationCollector();

    var protocol1 = ProtocolSource(
      '''
class: Example
table: example
fields:
  myChildId: int
  child: List<ExampleChild>?, relation(field=myChildId)
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var protocol2 = ProtocolSource(
      '''
class: ExampleChild
table: example_child
fields:
  name: String
  exampleId: int, relation(parent=example)
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var definition1 = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol1,
    );

    var definition2 = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol2,
    );

    var entities = [definition1!, definition2!];
    SerializableEntityAnalyzer.resolveEntityDependencies(entities);

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol1.yaml,
      protocol1.yamlSourceUri.path,
      collector,
      definition1,
      entities,
    );

    var errors = collector.errors;

    test('then an error was collected.', () {
      expect(errors, isNotEmpty);
    });

    test(
        'then the error message reports that the field keyword cannot be used on a List relation.',
        () {
      var error = collector.errors.first;
      expect(
        error.message,
        'The "field" property can only be used on an object relation.',
      );
    }, skip: errors.isEmpty);

    test('then the error is reported at the field key location.', () {
      var span = collector.errors.first.span;

      expect(span?.start.line, 4);
      expect(span?.start.column, 39);

      expect(span?.end.line, 4);
      expect(span?.end.column, 39 + 'field'.length);
    }, skip: errors.isEmpty);
  });

  group('Given a class with an id relation with a field pointer defined', () {
    var collector = CodeGenerationCollector();

    var protocol1 = ProtocolSource(
      '''
class: Example
table: example
fields:
  otherId: int
  exampleChildId: int, relation(parent=example_child, field=otherId)
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var protocol2 = ProtocolSource(
      '''
class: ExampleChild
table: example_child
fields:
  name: String
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var definition1 = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol1,
    );

    var definition2 = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol2,
    );

    var entities = [definition1!, definition2!];
    SerializableEntityAnalyzer.resolveEntityDependencies(entities);

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol1.yaml,
      protocol1.yamlSourceUri.path,
      collector,
      definition1,
      entities,
    );

    var errors = collector.errors;

    test('then an error was collected.', () {
      expect(errors, isNotEmpty);
    });

    test(
        'then the error message reports that the field keyword cannot be used on an id relation.',
        () {
      var error = collector.errors.first;
      expect(
        error.message,
        'The "field" property can only be used on an object relation.',
      );
    }, skip: errors.isEmpty);

    test('then the error is reported at the field key location.', () {
      var span = collector.errors.first.span;

      expect(span?.start.line, 4);
      expect(span?.start.column, 54);

      expect(span?.end.line, 4);
      expect(span?.end.column, 54 + 'field'.length);
    }, skip: errors.isEmpty);
  });

  group(
      'Given a class with a relation pointing to a field with a mismatching type to the reference',
      () {
    var collector = CodeGenerationCollector();

    var protocol1 = ProtocolSource(
      '''
class: Example
table: example
fields:
  myParentId: String
  parent: Example?, relation(field=myParentId)
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var definition1 = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol1,
    );

    var entities = [definition1!];
    SerializableEntityAnalyzer.resolveEntityDependencies(entities);

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol1.yaml,
      protocol1.yamlSourceUri.path,
      collector,
      definition1,
      entities,
    );

    var errors = collector.errors;

    test('then an error was collected.', () {
      expect(errors, isNotEmpty);
    });

    test(
        'then the error message reports that the field has a mismatching type to the reference.',
        () {
      var error = collector.errors.first;
      expect(
        error.message,
        'The field "myParentId" is of type "String" but reference field "id" is of type "int".',
      );
    }, skip: errors.isEmpty);

    test('then the error is reported at the field key location.', () {
      var span = collector.errors.first.span;

      expect(span?.start.line, 4);
      expect(span?.start.column, 35);

      expect(span?.end.line, 4);
      expect(span?.end.column, 35 + 'myParentId'.length);
    }, skip: errors.isEmpty);
  });

  group(
      'Given a class with a relation pointing to a field that is set to not persist',
      () {
    var collector = CodeGenerationCollector();

    var protocol1 = ProtocolSource(
      '''
class: Example
table: example
fields:
  myParentId: int, !persist
  parent: Example?, relation(field=myParentId)
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var definition1 = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol1,
    );

    var entities = [definition1!];
    SerializableEntityAnalyzer.resolveEntityDependencies(entities);

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol1.yaml,
      protocol1.yamlSourceUri.path,
      collector,
      definition1,
      entities,
    );

    var errors = collector.errors;

    test('then an error was collected.', () {
      expect(errors, isNotEmpty);
    });

    test(
        'then the error message reports that the field has a mismatching type to the reference.',
        () {
      var error = collector.errors.first;
      expect(
        error.message,
        'The field "myParentId" is not persisted and cannot be used in a relation.',
      );
    }, skip: errors.isEmpty);

    test('then the error is reported at the field key location.', () {
      var span = collector.errors.first.span;

      expect(span?.start.line, 4);
      expect(span?.start.column, 35);

      expect(span?.end.line, 4);
      expect(span?.end.column, 35 + 'myParentId'.length);
    }, skip: errors.isEmpty);
  });
}
