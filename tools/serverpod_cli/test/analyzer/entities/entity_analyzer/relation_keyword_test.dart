import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/analyzer/entities/entity_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/protocol_helper.dart';
import 'package:test/test.dart';

void main() {
  group('Given a class with a self relation on a field with the class datatype',
      () {
    var collector = CodeGenerationCollector();

    var protocol = ProtocolSource(
      '''
class: Example
table: example
fields:
  parent: Example?, relation
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var definition = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol,
    );
    SerializableEntityAnalyzer.resolveEntityDependencies([definition!]);

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      definition,
      [definition],
    );

    var classDefinition = definition as ClassDefinition;

    test('then no errors are collected.', () {
      expect(collector.errors, isEmpty);
    });
    test('then the table is not set on relation field.', () {
      var parent = classDefinition.findField('parent');
      expect(parent?.parentTable, null);
    });

    test('then the scope is set to api on the relation field.', () {
      var parent = classDefinition.findField('parent');
      expect(parent?.scope, SerializableEntityFieldScope.api);
    });

    test(
        'then a scalar field with the same name appended with Id is set on the relation field.',
        () {
      var parent = classDefinition.findField('parent');
      expect(parent?.scalarFieldName, 'parentId');
    });

    test('then the class has a scalar field for the id.', () {
      var parentIdField = classDefinition.findField('parentId');

      expect(
        parentIdField,
        isNotNull,
        reason: 'Expected to find a field named parentId.',
      );
    });

    test('then the scalar field has the global scope.', () {
      var parent = classDefinition.findField('parentId');
      expect(parent?.scope, SerializableEntityFieldScope.all);
    });

    test('then the scalar field type defaults to none nullable.', () {
      var parent = classDefinition.findField('parentId');
      expect(
        parent?.type.nullable,
        isFalse,
        reason: 'Expected to be non-nullable.',
      );
    });

    test(
        'then the scalar field has the parent table set from the object reference.',
        () {
      var parent = classDefinition.findField('parentId');
      expect(parent?.parentTable, 'example');
    });
  });

  group(
      'Given a class with a field with a self relation, then the parent table is set to the specified table name.',
      () {
    var collector = CodeGenerationCollector();

    var protocol = ProtocolSource(
      '''
class: Example
table: example
fields:
  parent: Example?, relation
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var definition = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol,
    );
    SerializableEntityAnalyzer.resolveEntityDependencies([definition!]);

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      definition,
      [definition],
    );

    var classDefinition = definition as ClassDefinition;

    test('then no errors are collected.', () {
      expect(collector.errors, isEmpty);
    });
    test('then the table is not set on relation field.', () {
      var parent = classDefinition.findField('parent');
      expect(parent?.parentTable, null);
    });

    test('then the scope is set to api on the relation field.', () {
      var parent = classDefinition.findField('parent');
      expect(parent?.scope, SerializableEntityFieldScope.api);
    });

    test(
        'then a scalar field with the same name appended with Id is set on the relation field.',
        () {
      var parent = classDefinition.findField('parent');
      expect(parent?.scalarFieldName, 'parentId');
    });

    test('then the class has a scalar field for the id.', () {
      var parentIdField = classDefinition.findField('parentId');

      expect(
        parentIdField,
        isNotNull,
        reason: 'Expected to find a field named parentId.',
      );
    });

    test('then the scalar field has the global scope.', () {
      var parent = classDefinition.findField('parentId');
      expect(parent?.scope, SerializableEntityFieldScope.all);
    });

    test('then the scalar field type defaults to none nullable.', () {
      var parent = classDefinition.findField('parentId');
      expect(
        parent?.type.nullable,
        isFalse,
        reason: 'Expected to be non-nullable.',
      );
    });

    test(
        'then the scalar field has the parent table set from the object reference.',
        () {
      var parent = classDefinition.findField('parentId');
      expect(parent?.parentTable, 'example');
    });
  });

  group(
      'Given a class with a self relation on a field with the class datatype where the relation is optional',
      () {
    var collector = CodeGenerationCollector();

    var protocol = ProtocolSource(
      '''
class: Example
table: example
fields:
  parent: Example?, relation(optional)
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var definition = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol,
    );
    SerializableEntityAnalyzer.resolveEntityDependencies([definition!]);

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      definition,
      [definition],
    );

    var classDefinition = definition as ClassDefinition;

    test('then no errors are collected.', () {
      expect(collector.errors, isEmpty);
    });
    test('then scalar field is nullable.', () {
      var parent = classDefinition.findField('parentId');
      expect(parent?.type.nullable, isTrue, reason: 'Expected to be nullable.');
    });
  });

  test(
      'Given a class with a self relation without any nested rules, then no errors are collected.',
      () {
    var collector = CodeGenerationCollector();

    var protocol = ProtocolSource(
      '''
class: Example
table: example
fields:
  parent: Example?, relation()
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var definition = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol,
    );
    SerializableEntityAnalyzer.resolveEntityDependencies([definition!]);

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      definition,
      [definition],
    );

    expect(collector.errors, isEmpty);
  });

  test(
      'Given a class with a field without a relation, then no scalar field reference is set.',
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
      [],
    );

    var definition = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol,
    );
    SerializableEntityAnalyzer.resolveEntityDependencies([definition!]);

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      definition,
      [definition],
    );

    expect(collector.errors, isEmpty);

    expect((definition as ClassDefinition).fields.last.scalarFieldName, null);
  });

  test(
      'Given a class with a field with a self reference without a relation, then no scalar field reference is set.',
      () {
    var collector = CodeGenerationCollector();

    var protocol = ProtocolSource(
      '''
class: Example
table: example
fields:
  example: Example?
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var definition = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol,
    );
    SerializableEntityAnalyzer.resolveEntityDependencies([definition!]);

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      definition,
      [definition],
    );

    expect(collector.errors, isEmpty);

    expect((definition as ClassDefinition).fields.last.scalarFieldName, null);
  });

  group('Given a class with a field with a self relation', () {
    var collector = CodeGenerationCollector();

    var protocol = ProtocolSource(
      '''
class: Example
table: example
fields:
  parentId: int, relation(parent=example)
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var definition = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol,
    );
    SerializableEntityAnalyzer.resolveEntityDependencies([definition!]);

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      definition,
      [definition],
    );

    var classDefinition = definition as ClassDefinition;

    test('then no errors are collected.', () {
      expect(collector.errors, isEmpty);
    });
    test('then the parent table is set to the specified table name.', () {
      expect(
        classDefinition.fields.last.parentTable,
        'example',
      );
    });

    test('then no scalar field is added', () {
      expect(classDefinition.findField('parentIdId'), isNull);
    });
  });

  test(
      'Given a class with a field with a relation, but the parent keyword defined twice, then an error is collected that there is a duplicated key.',
      () {
    var collector = CodeGenerationCollector();

    var protocol = ProtocolSource(
      '''
class: Example
table: example
fields:
  parentId: int, relation(parent=example, parent=example)
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var definition = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol,
    );
    SerializableEntityAnalyzer.resolveEntityDependencies([definition!]);

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      definition,
      [definition],
    );

    expect(
      collector.errors.length,
      greaterThan(0),
      reason: 'Expected an error',
    );

    expect(
      collector.errors.first.message,
      'The field option "parent" is defined more than once.',
    );
  });

  test(
      'Given a class with a field with a relation and parent keyword, then an error is collected that they are mutually exclusive key.',
      () {
    var collector = CodeGenerationCollector();

    var protocol = ProtocolSource(
      '''
class: Example
table: example
fields:
  parentId: int, relation(parent=example), parent=example
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var definition = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol,
    );
    SerializableEntityAnalyzer.resolveEntityDependencies([definition!]);

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      definition,
      [definition],
    );

    expect(
      collector.errors.length,
      greaterThan(0),
      reason: 'Expected an error',
    );

    expect(
      collector.errors.first.message,
      'The "parent" property is mutually exclusive with the "relation" property.',
    );
  });

  test(
      'Given a class with a field with a relation, but the parent keyword defined twice, then an error is collected that locates the second parent key.',
      () {
    var collector = CodeGenerationCollector();

    var protocol = ProtocolSource(
      '''
class: Example
table: example
fields:
  parentId: int, relation(parent=example, parent=example)
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var definition = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol,
    );
    SerializableEntityAnalyzer.resolveEntityDependencies([definition!]);

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      definition,
      [definition],
    );

    expect(
      collector.errors.length,
      greaterThan(0),
      reason: 'Expected an error',
    );

    var error = collector.errors.first;

    expect(error.span, isNotNull,
        reason: 'Expected error to have a source span.');

    var startSpan = error.span!.start;
    expect(startSpan.line, 3);
    expect(startSpan.column, 42);

    var endSpan = error.span!.end;
    expect(endSpan.line, 3);
    expect(endSpan.column, 48);
  });

  test(
      'Given a class with a self relation but without a table defined, then collect an error that the relation keyword cannot be used unless the class has a table.',
      () {
    var collector = CodeGenerationCollector();

    var protocol = ProtocolSource(
      '''
class: Example
fields:
  parentId: int, relation(parent=example)
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

    expect(
      collector.errors.length,
      greaterThan(0),
      reason: 'Expected an error',
    );

    expect(
      collector.errors.first.message,
      'The "table" property must be defined in the class to set a relation on a field.',
    );
  });

  test(
      'Given a class with a field with a relation on a complex datatype that is not nullable, then an error is collected that the datatype must be nullable.',
      () {
    var collector = CodeGenerationCollector();

    var protocol = ProtocolSource(
      '''
class: Example
table: example
fields:
  parent: Example, relation
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var definition = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol,
    );
    SerializableEntityAnalyzer.resolveEntityDependencies([definition!]);

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      definition,
      [definition],
    );

    expect(
      collector.errors.length,
      greaterThan(0),
      reason: 'Expected an error',
    );

    expect(
      collector.errors.first.message,
      'Fields with a protocol relations must be nullable (e.g. parent: Example?).',
    );
  });

  test(
      'Given a class with a field with a relation on a complex datatype and the parent table is defined, then an error is collected that the parent table is redundant.',
      () {
    var collector = CodeGenerationCollector();

    var protocol = ProtocolSource(
      '''
class: Example
table: example
fields:
  parent: Example?, relation(parent=example)
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var definition = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol,
    );
    SerializableEntityAnalyzer.resolveEntityDependencies([definition!]);

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      definition,
      [definition],
    );

    expect(
      collector.errors.length,
      greaterThan(0),
      reason: 'Expected an error',
    );

    var error = collector.errors.first;

    expect(
      error.message,
      'The "parent" property should be omitted on protocol relations.',
    );
  });

  test(
      'Given a class with a field with a relation on a an id field and the relation is defined as optional, then collect a warning that the optional keyword should not be used.',
      () {
    var collector = CodeGenerationCollector();

    var protocol = ProtocolSource(
      '''
class: Example
table: example
fields:
  parent: int, relation(optional, parent=example)
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var definition = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol,
    );
    SerializableEntityAnalyzer.resolveEntityDependencies([definition!]);

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      definition,
      [definition],
    );

    expect(
      collector.errors.length,
      greaterThan(0),
      reason: 'Expected an error',
    );

    expect(
      collector.errors.first.message,
      'The "optional" property should be omitted on id fields.',
    );
  });

  test(
      'Given a class with a field with a relation on a an id field but is missing a parent table definition, then collect an error that the parent table is required.',
      () {
    var collector = CodeGenerationCollector();

    var protocol = ProtocolSource(
      '''
class: Example
table: example
fields:
  parent: int, relation
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var definition = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol,
    );
    SerializableEntityAnalyzer.resolveEntityDependencies([definition!]);

    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      definition,
      [definition],
    );

    expect(
      collector.errors.length,
      greaterThan(0),
      reason: 'Expected an error',
    );

    expect(
      collector.errors.first.message,
      'The "parent" property must be defined on id fields.',
    );
  });

  group(
      'Given a class with a relation to a protocol class with a table defined',
      () {
    var collector = CodeGenerationCollector();

    var protocol1 = ProtocolSource(
      '''
class: Example
table: example
fields:
  parent: ExampleParent?, relation
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

    var classDefinition = definition1 as ClassDefinition;

    test('then no errors were detected.', () {
      expect(collector.errors, isEmpty);
    });

    test('then the parent table was set on the scalar field.', () {
      expect(
          classDefinition.findField('parentId')?.parentTable, 'example_parent');
    });
  });

  test(
      'Given a class with a relation referencing a none existent class then collect an error that the class was not found',
      () {
    var collector = CodeGenerationCollector();

    var protocol1 = ProtocolSource(
      '''
class: Example
table: example
fields:
  parent: InvalidClass?, relation
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

    expect(
      collector.errors.length,
      greaterThan(0),
      reason: 'Expected an error',
    );

    expect(
      collector.errors.first.message,
      'The class "InvalidClass" was not found in any protocol.',
    );
  });

  test(
      'Given a class with a relation to a protocol class without a table defined, then collect an error that the class does not have a table.',
      () {
    var collector = CodeGenerationCollector();

    var protocol1 = ProtocolSource(
      '''
class: Example
table: example
fields:
  parent: ExampleParent?, relation
''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var protocol2 = ProtocolSource(
      '''
class: ExampleParent
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

    expect(
      collector.errors.length,
      greaterThan(0),
      reason: 'Expected an error',
    );

    expect(
      collector.errors.first.message,
      'The class "ExampleParent" must have a "table" property defined to be used in a relation.',
    );
  });
}
