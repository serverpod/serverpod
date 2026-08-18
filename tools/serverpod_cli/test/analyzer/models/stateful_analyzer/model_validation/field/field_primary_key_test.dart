import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group('Given a class with a table defined,', () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
        class: Example
        table: example
        fields:
          name: String
        ''',
      ).build(),
    ];

    var collector = CodeGenerationCollector();
    var definitions = StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    ).validateAll();

    test('then no errors are collected.', () {
      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors but some were generated.',
      );
    });

    test('then the id field is marked as the primary key.', () {
      var definition = definitions.first as ClassDefinition;

      expect(definition.findField('id')?.isPrimaryKey, isTrue);
    });

    test('then other fields are not marked as the primary key.', () {
      var definition = definitions.first as ClassDefinition;

      expect(definition.findField('name')?.isPrimaryKey, isFalse);
    });
  });

  test(
    'Given a class with a UuidValue id field '
    'then the id field is marked as the primary key.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            id: UuidValue?, defaultPersist=random
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var definitions = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors but some were generated.',
      );

      var definition = definitions.first as ClassDefinition;

      expect(definition.findField('id')?.isPrimaryKey, isTrue);
    },
  );

  test(
    'Given a class that extends a class with a table defined '
    'then the inherited id field is marked as the primary key.',
    () {
      var models = [
        ModelSourceBuilder().withFileName('parent').withYaml(
          '''
          class: Parent
          table: parent
          fields:
            name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('child').withYaml(
          '''
          class: Child
          extends: Parent
          fields:
            nickname: String
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var definitions = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors but some were generated.',
      );

      var definition = definitions.last as ClassDefinition;

      var idField = definition.fieldsIncludingInherited.firstWhere(
        (field) => field.name == 'id',
      );

      expect(idField.isPrimaryKey, isTrue);
    },
  );

  test(
    'Given a class without a table defined '
    'then no field is marked as the primary key.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields:
            name: String
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var definitions = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors but some were generated.',
      );

      var definition = definitions.first as ClassDefinition;

      expect(definition.fields.any((field) => field.isPrimaryKey), isFalse);
    },
  );

  test(
    'Given a class without a table defined that declares an id field '
    'then the id field is not marked as the primary key.',
    () {
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields:
            id: int?
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var definitions = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors but some were generated.',
      );

      var definition = definitions.first as ClassDefinition;

      expect(definition.findField('id')?.isPrimaryKey, isFalse);
    },
  );

  test(
    'Given a class with an object relation '
    'then the implicit foreign key field is not marked as the primary key.',
    () {
      var models = [
        ModelSourceBuilder().withFileName('company').withYaml(
          '''
          class: Company
          table: company
          fields:
            name: String
          ''',
        ).build(),
        ModelSourceBuilder().withFileName('employee').withYaml(
          '''
          class: Employee
          table: employee
          fields:
            company: Company?, relation
          ''',
        ).build(),
      ];

      var collector = CodeGenerationCollector();
      var definitions = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      ).validateAll();

      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors but some were generated.',
      );

      var definition = definitions.last as ClassDefinition;

      expect(definition.findField('companyId')?.isPrimaryKey, isFalse);
    },
  );
}
