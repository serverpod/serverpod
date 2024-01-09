import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/model_source_builder.dart';
import 'package:test/test.dart';

void main() {
  group('Given a class with a one to many relation', () {
    var models = [
      ModelSourceBuilder().withFileName('cat').withYaml(
        '''
        class: Cat
        table: cat
        fields:
          mother: Cat?, relation(name=mother_kittens)
          kittens: List<Cat>?, relation(name=mother_kittens)
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      models,
      onErrorsCollector(collector),
    );
    var definitions = analyzer.validateAll();
    var classDefinition = definitions
        .whereType<ClassDefinition>()
        .firstWhere((d) => d.className == 'Cat');

    var errors = collector.errors;

    test('then no errors are collected.', () {
      expect(errors, isEmpty);
    });

    test('then no id field was created for the many side.', () {
      expect(
        classDefinition.findField('kittensId'),
        isNull,
        reason: 'Expected kittensId to not exist as a field, but it did.',
      );
    }, skip: errors.isNotEmpty);

    var relation = classDefinition.findField('kittens')?.relation;
    test('then the reference field is set on the list relation.', () {
      expect(relation.runtimeType, ListRelationDefinition);
      expect(
        (relation as ListRelationDefinition).foreignFieldName,
        'motherId',
        reason: 'Expected the reference field to be set to "motherId".',
      );
    }, skip: errors.isNotEmpty);

    test('then the foreign field name is set on the list relation.', () {
      expect(relation.runtimeType, ListRelationDefinition);
      expect(
        (relation as ListRelationDefinition).fieldName,
        'id',
        reason: 'Expected the reference field to be set to "id".',
      );
    }, skip: errors.isNotEmpty);

    test('then the implicit field is false.', () {
      expect(relation.runtimeType, ListRelationDefinition);
      expect(
        (relation as ListRelationDefinition).implicitForeignField,
        isFalse,
        reason: 'Expected implicit field to be false.',
      );
    }, skip: errors.isNotEmpty);

    test('has the nullableRelation set to false', () {
      expect((relation as ListRelationDefinition).nullableRelation, false);
    }, skip: relation is! ListRelationDefinition);
  });

  test(
      'Given a list relation with an invalid type then the only error reported is that the type is invalid.',
      () {
    var models = [
      ModelSourceBuilder().withFileName('example').withYaml(
        '''
        class: Example
        table: example
        fields:
          list: List<InvalidType>?, relation
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    StatefulAnalyzer analyzer = StatefulAnalyzer(
      models,
      onErrorsCollector(collector),
    );

    analyzer.validateAll();

    expect(collector.errors, hasLength(1));

    expect(
      collector.errors.first.message,
      'The field has an invalid datatype "InvalidType".',
    );
  });
}
