import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/analyzer/entities/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/test_util/builders/protocol_source_builder.dart';
import 'package:test/test.dart';

void main() {
  group('serverOnly property tests', () {
    test(
        'Given a class defined to serverOnly, then the serverOnly property is set to true.',
        () {
      var protocols = [
        ProtocolSourceBuilder().withYaml(
          '''
        class: Example
        serverOnly: true
        fields:
          name: String
        ''',
        ).build()
      ];

      var entities = StatefulAnalyzer(protocols).validateAll();

      expect(entities.first.serverOnly, isTrue);
    });

    test(
        'Given a class explicitly setting serverOnly to false, then the serverOnly property is set to false.',
        () {
      var protocols = [
        ProtocolSourceBuilder().withYaml(
          '''
        class: Example
        serverOnly: false
        fields:
          name: String
        ''',
        ).build()
      ];

      var entities = StatefulAnalyzer(protocols).validateAll();

      expect(entities.first.serverOnly, isFalse);
    });

    test(
        'Given a class without the serverOnly property, then the default "false" value is used.',
        () {
      var protocols = [
        ProtocolSourceBuilder().withYaml(
          '''
        class: Example
        fields:
          name: String
        ''',
        ).build()
      ];

      var entities = StatefulAnalyzer(protocols).validateAll();

      expect(entities.first.serverOnly, isFalse);
    });

    test(
        'Given a class with the serverOnly property set to another datatype than bool, then an error is collected notifying that the serverOnly must be a bool.',
        () {
      var protocols = [
        ProtocolSourceBuilder().withYaml(
          '''
        class: Example
        serverOnly: Yes
        fields:
          name: String
        ''',
        ).build()
      ];

      CodeGenerationCollector collector = CodeGenerationCollector();
      StatefulAnalyzer(protocols, onErrorsCollector(collector)).validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(error.message, 'The value must be a boolean.');
    });

    test(
        'Given an exception with the serverOnly property set to another datatype than bool, then an error is collected notifying that the serverOnly must be a bool.',
        () {
      var protocols = [
        ProtocolSourceBuilder().withYaml(
          '''
          exception: Example
          serverOnly: Yes
          fields:
            name: String
          ''',
        ).build()
      ];

      CodeGenerationCollector collector = CodeGenerationCollector();
      StatefulAnalyzer(protocols, onErrorsCollector(collector)).validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error but none was generated.',
      );

      var error = collector.errors.first;
      expect(error.message, 'The value must be a boolean.');
    });
  });

  group('table property tests', () {
    test(
        'Given a class with a table defined, then the tableName is set in the definition.',
        () {
      var protocols = [
        ProtocolSourceBuilder().withYaml(
          '''
          class: Example
          table: example
          fields:
            name: String
          ''',
        ).build()
      ];

      CodeGenerationCollector collector = CodeGenerationCollector();
      var entities = StatefulAnalyzer(protocols, onErrorsCollector(collector))
          .validateAll();

      var entity = entities.first as ClassDefinition;
      expect(entity.tableName, 'example');
    });

    test(
      'Given a class with a table name in a none snake_case_format, then collect an error that snake_case must be used.',
      () {
        var protocols = [
          ProtocolSourceBuilder().withYaml(
            '''
            class: Example
            table: camelCaseTable
            fields:
              name: String
            ''',
          ).build()
        ];

        CodeGenerationCollector collector = CodeGenerationCollector();
        StatefulAnalyzer(protocols, onErrorsCollector(collector)).validateAll();

        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error but none was generated.',
        );

        var error = collector.errors.first;

        expect(
          error.message,
          'The "table" property must be a snake_case_string.',
        );
      },
    );

    test(
      'Given a class with a table name is not a string, then collect an error',
      () {
        var protocols = [
          ProtocolSourceBuilder().withYaml(
            '''
            class: Example
            table: true
            fields:
              name: String
            ''',
          ).build()
        ];

        CodeGenerationCollector collector = CodeGenerationCollector();
        StatefulAnalyzer(protocols, onErrorsCollector(collector)).validateAll();

        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error but none was generated.',
        );

        var error = collector.errors.first;
        expect(
          error.message,
          'The "table" property must be a snake_case_string.',
        );
      },
    );

    test(
      'Given an exception with a table defined, then collect an error',
      () {
        var protocols = [
          ProtocolSourceBuilder().withYaml(
            '''
            exception: Example
            table: example
            fields:
              name: String
            ''',
          ).build()
        ];

        CodeGenerationCollector collector = CodeGenerationCollector();
        StatefulAnalyzer(protocols, onErrorsCollector(collector)).validateAll();

        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error but none was generated.',
        );

        var error = collector.errors.first;
        expect(
          error.message,
          'The "table" property is not allowed for exception type. Valid keys are {exception, serverOnly, fields}.',
        );
      },
    );

    test(
      'Given two classes with the same table name defined, then collect an error',
      () {
        var protocols = [
          ProtocolSourceBuilder().withYaml(
            '''
            class: Example
            table: example
            fields:
              name: String
            ''',
          ).build(),
          ProtocolSourceBuilder().withFileName('example2').withYaml(
            '''
            class: Example2
            table: example
            fields:
              name: String
            ''',
          ).build()
        ];

        CodeGenerationCollector collector = CodeGenerationCollector();
        StatefulAnalyzer(protocols, onErrorsCollector(collector)).validateAll();

        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error but none was generated.',
        );

        var error = collector.errors.first;
        expect(
          error.message,
          'The table name "example" is already in use by the class "Example2".',
        );
      },
    );
  });

  group('Invalid properties', () {
    test(
      'Given a class with an invalid property, then collect an error that such a property is not allowed.',
      () {
        var protocols = [
          ProtocolSourceBuilder().withYaml(
            '''
            class: Example
            invalidProperty: true
            fields:
              name: String
            ''',
          ).build()
        ];

        CodeGenerationCollector collector = CodeGenerationCollector();
        StatefulAnalyzer(protocols, onErrorsCollector(collector)).validateAll();

        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error but none was generated.',
        );

        var error = collector.errors.first;
        expect(
          error.message,
          'The "invalidProperty" property is not allowed for class type. Valid keys are {class, table, serverOnly, fields, indexes}.',
        );
      },
    );

    test(
      'Given an exception with indexes defined, then collect an error that indexes cannot be used together with exceptions.',
      () {
        var protocols = [
          ProtocolSourceBuilder().withYaml(
            '''
            exception: ExampleException
            fields:
              name: String
            indexes:
              example_exception_idx: 
                fields: name
                unique: true
            ''',
          ).build()
        ];

        CodeGenerationCollector collector = CodeGenerationCollector();
        StatefulAnalyzer(protocols, onErrorsCollector(collector)).validateAll();

        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error but none was generated.',
        );

        var error = collector.errors.first;
        expect(
          error.message,
          'The "indexes" property is not allowed for exception type. Valid keys are {exception, serverOnly, fields}.',
        );
      },
    );

    test(
      'Given an enum with a table defined, then collect an error that table cannot be used together with enums.',
      () {
        var protocols = [
          ProtocolSourceBuilder().withYaml(
            '''
            enum: Example
            table: example
            values:
              - yes
              - no
            ''',
          ).build()
        ];

        CodeGenerationCollector collector = CodeGenerationCollector();
        StatefulAnalyzer(protocols, onErrorsCollector(collector)).validateAll();

        expect(
          collector.errors,
          isNotEmpty,
          reason: 'Expected an error but none was generated.',
        );

        var error = collector.errors.first;
        expect(
          error.message,
          'The "table" property is not allowed for enum type. Valid keys are {enum, serverOnly, values}.',
        );
      },
    );
  });
}
