import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/analyzer/entities/entity_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/protocol_helper.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

void main() {
  group('Given a class with no database action explicitly set', () {
    var collector = CodeGenerationCollector();
    var protocol = ProtocolSource(
      '''
      class: Example
      table: example
      fields:
        example: Example?, relation
      ''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var entity = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol,
    ) as ClassDefinition;
    SerializableEntityAnalyzer.resolveEntityDependencies([entity]);
    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      entity,
      [entity],
    );

    test('then no errors are detected.', () {
      expect(collector.errors, isEmpty);
    });

    var field = entity.findField('exampleId');

    var noneFieldRelation =
        field == null || field.relation is! ForeignRelationDefinition;
    test('then onUpdate is set to the default.', () {
      var relation = field?.relation as ForeignRelationDefinition;
      expect(relation.onUpdate, onUpdateDefault);
    }, skip: noneFieldRelation);

    test('then onDelete is set to the default.', () {
      var relation = field?.relation as ForeignRelationDefinition;
      expect(relation.onDelete, onDeleteDefault);
    }, skip: noneFieldRelation);
  });

  group('Given a class with onUpdate database action explicitly set to Cascade',
      () {
    var collector = CodeGenerationCollector();
    var protocol = ProtocolSource(
      '''
      class: Example
      table: example
      fields:
        example: Example?, relation(onUpdate=Cascade)
      ''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var entity = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol,
    ) as ClassDefinition;
    SerializableEntityAnalyzer.resolveEntityDependencies([entity]);
    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      entity,
      [entity],
    );

    test('then no errors are detected.', () {
      expect(collector.errors, isEmpty);
    });

    var field = entity.findField('exampleId');

    var noneFieldRelation =
        field == null || field.relation is! ForeignRelationDefinition;
    test('then onUpdate is set to cascade.', () {
      var relation = field?.relation as ForeignRelationDefinition;
      expect(relation.onUpdate, ForeignKeyAction.cascade);
    }, skip: noneFieldRelation);
  });

  group(
      'Given a class with onUpdate database action explicitly set to NoAction',
      () {
    var collector = CodeGenerationCollector();
    var protocol = ProtocolSource(
      '''
      class: Example
      table: example
      fields:
        example: Example?, relation(onUpdate=NoAction)
      ''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var entity = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol,
    ) as ClassDefinition;
    SerializableEntityAnalyzer.resolveEntityDependencies([entity]);
    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      entity,
      [entity],
    );

    test('then no errors are detected.', () {
      expect(collector.errors, isEmpty);
    });

    var field = entity.findField('exampleId');

    var noneFieldRelation =
        field == null || field.relation is! ForeignRelationDefinition;
    test('then onUpdate is set to no action.', () {
      var relation = field?.relation as ForeignRelationDefinition;

      expect(relation.onUpdate, ForeignKeyAction.noAction);
    }, skip: noneFieldRelation);
  });

  group(
      'Given a class with onUpdate database action explicitly set to Restrict',
      () {
    var collector = CodeGenerationCollector();
    var protocol = ProtocolSource(
      '''
      class: Example
      table: example
      fields:
        example: Example?, relation(onUpdate=Restrict)
      ''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var entity = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol,
    ) as ClassDefinition;
    SerializableEntityAnalyzer.resolveEntityDependencies([entity]);
    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      entity,
      [entity],
    );

    test('then no errors are detected.', () {
      expect(collector.errors, isEmpty);
    });

    var field = entity.findField('exampleId');

    var noneFieldRelation =
        field == null || field.relation is! ForeignRelationDefinition;
    test('then onUpdate is set to restrict.', () {
      var relation = field?.relation as ForeignRelationDefinition;
      expect(relation.onUpdate, ForeignKeyAction.restrict);
    }, skip: noneFieldRelation);
  });

  group('Given a class with onUpdate database action explicitly set to SetNull',
      () {
    var collector = CodeGenerationCollector();
    var protocol = ProtocolSource(
      '''
      class: Example
      table: example
      fields:
        example: Example?, relation(onUpdate=SetNull)
      ''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var entity = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol,
    ) as ClassDefinition;
    SerializableEntityAnalyzer.resolveEntityDependencies([entity]);
    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      entity,
      [entity],
    );

    test('then no errors are detected.', () {
      expect(collector.errors, isEmpty);
    });

    var field = entity.findField('exampleId');

    var noneFieldRelation =
        field == null || field.relation is! ForeignRelationDefinition;
    test('then onUpdate is set to set null.', () {
      var relation = field?.relation as ForeignRelationDefinition;
      expect(relation.onUpdate, ForeignKeyAction.setNull);
    }, skip: noneFieldRelation);
  });

  group(
      'Given a class with onUpdate database action explicitly set to SetDefault',
      () {
    var collector = CodeGenerationCollector();
    var protocol = ProtocolSource(
      '''
      class: Example
      table: example
      fields:
        example: Example?, relation(onUpdate=SetDefault)
      ''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var entity = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol,
    ) as ClassDefinition;
    SerializableEntityAnalyzer.resolveEntityDependencies([entity]);
    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      entity,
      [entity],
    );

    test('then no errors are detected.', () {
      expect(collector.errors, isEmpty);
    });

    var field = entity.findField('exampleId');

    var noneFieldRelation =
        field == null || field.relation is! ForeignRelationDefinition;
    test('then onUpdate is set to set default.', () {
      var relation = field?.relation as ForeignRelationDefinition;
      expect(relation.onUpdate, ForeignKeyAction.setDefault);
    }, skip: noneFieldRelation);
  });

  test(
      'Given a class with onUpdate database action set to an invalid value, then collect an error.',
      () {
    var collector = CodeGenerationCollector();
    var protocol = ProtocolSource(
      '''
      class: Example
      table: example
      fields:
        example: Example?, relation(onUpdate=Invalid)
      ''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var entity = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol,
    ) as ClassDefinition;
    SerializableEntityAnalyzer.resolveEntityDependencies([entity]);
    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      entity,
      [entity],
    );

    expect(collector.errors, isNotEmpty);

    var error = collector.errors.first;

    expect(
      error.message,
      '"Invalid" is not a valid property. Valid properties are (setNull, setDefault, restrict, noAction, cascade).',
    );
  });

  group('Given a class with onDelete database action explicitly set to Cascade',
      () {
    var collector = CodeGenerationCollector();
    var protocol = ProtocolSource(
      '''
    class: Example
    table: example
    fields:
      example: Example?, relation(onDelete=Cascade)
    ''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var entity = SerializableEntityAnalyzer.extractEntityDefinition(protocol)
        as ClassDefinition;
    SerializableEntityAnalyzer.resolveEntityDependencies([entity]);
    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      entity,
      [entity],
    );

    test('then no errors are detected.', () {
      expect(collector.errors, isEmpty);
    });

    var field = entity.findField('exampleId');

    var noneFieldRelation =
        field == null || field.relation is! ForeignRelationDefinition;
    test('then onDelete is set to cascade.', () {
      var relation = field?.relation as ForeignRelationDefinition;
      expect(relation.onDelete, ForeignKeyAction.cascade);
    }, skip: noneFieldRelation);
  });

  group(
      'Given a class with onDelete database action explicitly set to NoAction',
      () {
    var collector = CodeGenerationCollector();
    var protocol = ProtocolSource(
      '''
    class: Example
    table: example
    fields:
      example: Example?, relation(onDelete=NoAction)
    ''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var entity = SerializableEntityAnalyzer.extractEntityDefinition(protocol)
        as ClassDefinition;
    SerializableEntityAnalyzer.resolveEntityDependencies([entity]);
    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      entity,
      [entity],
    );

    test('then no errors are detected.', () {
      expect(collector.errors, isEmpty);
    });

    var field = entity.findField('exampleId');

    var noneFieldRelation =
        field == null || field.relation is! ForeignRelationDefinition;
    test('then onDelete is set to no action.', () {
      var relation = field?.relation as ForeignRelationDefinition;

      expect(relation.onDelete, ForeignKeyAction.noAction);
    }, skip: noneFieldRelation);
  });

  group(
      'Given a class with onDelete database action explicitly set to Restrict',
      () {
    var collector = CodeGenerationCollector();
    var protocol = ProtocolSource(
      '''
    class: Example
    table: example
    fields:
      example: Example?, relation(onDelete=Restrict)
    ''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var entity = SerializableEntityAnalyzer.extractEntityDefinition(protocol)
        as ClassDefinition;
    SerializableEntityAnalyzer.resolveEntityDependencies([entity]);
    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      entity,
      [entity],
    );

    test('then no errors are detected.', () {
      expect(collector.errors, isEmpty);
    });

    var field = entity.findField('exampleId');

    var noneFieldRelation =
        field == null || field.relation is! ForeignRelationDefinition;
    test('then onDelete is set to restrict.', () {
      var relation = field?.relation as ForeignRelationDefinition;
      expect(relation.onDelete, ForeignKeyAction.restrict);
    }, skip: noneFieldRelation);
  });

  group('Given a class with onDelete database action explicitly set to SetNull',
      () {
    var collector = CodeGenerationCollector();
    var protocol = ProtocolSource(
      '''
    class: Example
    table: example
    fields:
      example: Example?, relation(onDelete=SetNull)
    ''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var entity = SerializableEntityAnalyzer.extractEntityDefinition(protocol)
        as ClassDefinition;
    SerializableEntityAnalyzer.resolveEntityDependencies([entity]);
    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      entity,
      [entity],
    );

    test('then no errors are detected.', () {
      expect(collector.errors, isEmpty);
    });

    var field = entity.findField('exampleId');

    var noneFieldRelation =
        field == null || field.relation is! ForeignRelationDefinition;
    test('then onDelete is set to set null.', () {
      var relation = field?.relation as ForeignRelationDefinition;
      expect(relation.onDelete, ForeignKeyAction.setNull);
    }, skip: noneFieldRelation);
  });

  group(
      'Given a class with onDelete database action explicitly set to SetDefault',
      () {
    var collector = CodeGenerationCollector();
    var protocol = ProtocolSource(
      '''
    class: Example
    table: example
    fields:
      example: Example?, relation(onDelete=SetDefault)
    ''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var entity = SerializableEntityAnalyzer.extractEntityDefinition(protocol)
        as ClassDefinition;
    SerializableEntityAnalyzer.resolveEntityDependencies([entity]);
    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      entity,
      [entity],
    );

    test('then no errors are detected.', () {
      expect(collector.errors, isEmpty);
    });

    var field = entity.findField('exampleId');

    var noneFieldRelation =
        field == null || field.relation is! ForeignRelationDefinition;
    test('then onDelete is set to set default.', () {
      var relation = field?.relation as ForeignRelationDefinition;
      expect(relation.onDelete, ForeignKeyAction.setDefault);
    }, skip: noneFieldRelation);
  });

  test(
      'Given a class with onDelete database action set to an invalid value, then collect an error.',
      () {
    var collector = CodeGenerationCollector();
    var protocol = ProtocolSource(
      '''
    class: Example
    table: example
    fields:
      example: Example?, relation(onDelete=Invalid)
    ''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      ['lib', 'src', 'protocol'],
    );

    var entity = SerializableEntityAnalyzer.extractEntityDefinition(protocol)
        as ClassDefinition;
    SerializableEntityAnalyzer.resolveEntityDependencies([entity]);
    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      entity,
      [entity],
    );

    expect(collector.errors, isNotEmpty);

    var error = collector.errors.first;

    expect(
      error.message,
      '"Invalid" is not a valid property. Valid properties are (setNull, setDefault, restrict, noAction, cascade).',
    );
  });
}
