import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/analyzer/entities/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/protocol_source_builder.dart';
import 'package:test/test.dart';

void main() {
  group(
      'Given a class with a relation with a defined field name that holds the relation',
      () {
    var protocols = [
      ProtocolSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          myParentId: int
          parent: ExampleParent?, relation(field=myParentId)
        ''',
      ).build(),
      ProtocolSourceBuilder().withFileName('example_parent').withYaml(
        '''
        class: ExampleParent
        table: example_parent
        fields:
          name: String
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    var analyzer = StatefulAnalyzer(protocols, onErrorsCollector(collector));
    var definitions = analyzer.validateAll();

    var exampleClass = definitions.first as ClassDefinition;

    test('then no errors were collected', () {
      expect(collector.errors, isEmpty);
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
    var protocols = [
      ProtocolSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          parent: Example?, relation(field=myParentId)
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer =
        StatefulAnalyzer(protocols, onErrorsCollector(collector));
    analyzer.validateAll();

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
    var protocols = [
      ProtocolSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          myChildId: int
          child: List<ExampleChild>?, relation(field=myChildId)
        ''',
      ).build(),
      ProtocolSourceBuilder().withFileName('example_child').withYaml(
        '''
        class: ExampleChild
        table: example_child
        fields:
          name: String
          exampleId: int, relation(parent=example)
        ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer =
        StatefulAnalyzer(protocols, onErrorsCollector(collector));
    analyzer.validateAll();

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
    var protocols = [
      ProtocolSourceBuilder().withYaml(
        '''
          class: Example
          table: example
          fields:
            otherId: int
            exampleChildId: int, relation(parent=example_child, field=otherId)
          ''',
      ).build(),
      ProtocolSourceBuilder().withFileName('example_child').withYaml(
        '''
          class: ExampleChild
          table: example_child
          fields:
            name: String
          ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer(protocols, onErrorsCollector(collector)).validateAll();
    var errors = collector.errors;

    test('then an error was collected.', () {
      expect(errors, isNotEmpty);
    });

    test(
        'then the error message reports that the field keyword cannot be used on an id relation.',
        () {
      var error = errors.first;
      expect(
        error.message,
        'The "field" property can only be used on an object relation.',
      );
    }, skip: errors.isEmpty);

    test('then the error is reported at the field key location.', () {
      var span = errors.first.span;
      expect(span?.start.line, 4);
      expect(span?.start.column, 54);
      expect(span?.end.line, 4);
      expect(span?.end.column, 54 + 'field'.length);
    }, skip: errors.isEmpty);
  });

  group(
      'Given a class with a relation pointing to a field with a mismatching type to the reference',
      () {
    var protocols = [
      ProtocolSourceBuilder().withYaml(
        '''
          class: Example
          table: example
          fields:
            myParentId: String
            parent: Example?, relation(field=myParentId)
          ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer(protocols, onErrorsCollector(collector)).validateAll();
    var errors = collector.errors;

    test('then an error was collected.', () {
      expect(errors, isNotEmpty);
    });

    test(
        'then the error message reports that the field has a mismatching type to the reference.',
        () {
      var error = errors.first;
      expect(
        error.message,
        'The field "myParentId" is of type "String" but reference field "id" is of type "int".',
      );
    }, skip: errors.isEmpty);

    test('then the error is reported at the field key location.', () {
      var span = errors.first.span;
      expect(span?.start.line, 4);
      expect(span?.start.column, 35);
      expect(span?.end.line, 4);
      expect(span?.end.column, 35 + 'myParentId'.length);
    }, skip: errors.isEmpty);
  });

  group(
      'Given a class with a relation pointing to a field that is set to not persist',
      () {
    var protocols = [
      ProtocolSourceBuilder().withYaml(
        '''
          class: Example
          table: example
          fields:
            myParentId: int, !persist
            parent: Example?, relation(field=myParentId)
          ''',
      ).build()
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer(protocols, onErrorsCollector(collector)).validateAll();
    var errors = collector.errors;

    test('then an error was collected.', () {
      expect(errors, isNotEmpty);
    });

    test(
        'then the error message reports that the field is not persisted and cannot be used in a relation.',
        () {
      var error = errors.first;
      expect(
        error.message,
        'The field "myParentId" is not persisted and cannot be used in a relation.',
      );
    }, skip: errors.isEmpty);

    test('then the error is reported at the field key location.', () {
      var span = errors.first.span;
      expect(span?.start.line, 4);
      expect(span?.start.column, 35);
      expect(span?.end.line, 4);
      expect(span?.end.column, 35 + 'myParentId'.length);
    }, skip: errors.isEmpty);
  });
}
