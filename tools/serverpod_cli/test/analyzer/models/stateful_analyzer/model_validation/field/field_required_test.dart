import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';

void main() {
  var config = GeneratorConfigBuilder().build();

  group('Given a class with mixed required nullable fields', () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
          class: Example
          fields:
            name: String
            email: String?, required
            phone: String?
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

    test('then nullable required field is marked as required.', () {
      var definition = definitions.firstOrNull as ClassDefinition?;
      expect(definition?.className, 'Example');

      var emailField = definition?.findField('email');
      expect(emailField?.isRequired, isTrue);
      expect(emailField?.type.nullable, isTrue);
    });

    test('then nullable field is not marked as required.', () {
      var definition = definitions.firstOrNull as ClassDefinition?;
      var phoneField = definition?.findField('phone');
      expect(phoneField?.isRequired, isFalse);
      expect(phoneField?.type.nullable, isTrue);
    });

    test('then non-nullable field is not marked as required.', () {
      var definition = definitions.firstOrNull as ClassDefinition?;
      var nameField = definition?.findField('name');
      expect(nameField?.isRequired, isFalse);
      expect(nameField?.type.nullable, isFalse);
    });
  });

  group('Given a class with required on non-nullable field', () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
          class: Example
          fields:
            name: String, required
          ''',
      ).build(),
    ];
    var collector = CodeGenerationCollector();
    StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    ).validateAll();

    test('then a validation error is collected.', () {
      expect(
        collector.errors,
        isNotEmpty,
        reason:
            'Expected a validation error for required on non-nullable field.',
      );

      expect(
        collector.errors.first.message,
        'The "required" keyword can only be used with nullable fields. Non-nullable fields are already required by default.',
        reason: 'Error message should match the exact validation message.',
      );
    });
  });

  group('Given an exception with mixed required nullable fields', () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
          exception: Example
          fields:
            name: String
            email: String?, required
            phone: String?
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

    test('then nullable required field is marked as required.', () {
      var definition = definitions.firstOrNull as ClassDefinition?;
      expect(definition?.className, 'Example');

      var emailField = definition?.findField('email');
      expect(emailField?.isRequired, isTrue);
      expect(emailField?.type.nullable, isTrue);
    });

    test('then nullable field is not marked as required.', () {
      var definition = definitions.firstOrNull as ClassDefinition?;
      var phoneField = definition?.findField('phone');
      expect(phoneField?.isRequired, isFalse);
      expect(phoneField?.type.nullable, isTrue);
    });

    test('then non-nullable field is not marked as required.', () {
      var definition = definitions.firstOrNull as ClassDefinition?;
      var nameField = definition?.findField('name');
      expect(nameField?.isRequired, isFalse);
      expect(nameField?.type.nullable, isFalse);
    });
  });

  group('Given a exception with required on non-nullable field', () {
    var models = [
      ModelSourceBuilder().withYaml(
        '''
          exception: Example
          fields:
            name: String, required
          ''',
      ).build(),
    ];
    var collector = CodeGenerationCollector();
    StatefulAnalyzer(
      config,
      models,
      onErrorsCollector(collector),
    ).validateAll();

    test('then a validation error is collected.', () {
      expect(
        collector.errors,
        isNotEmpty,
        reason:
            'Expected a validation error for required on non-nullable field.',
      );

      expect(
        collector.errors.first.message,
        'The "required" keyword can only be used with nullable fields. Non-nullable fields are already required by default.',
        reason: 'Error message should match the exact validation message.',
      );
    });
  });
}
