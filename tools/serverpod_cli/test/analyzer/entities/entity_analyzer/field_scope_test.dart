import 'package:serverpod_cli/src/analyzer/code_analysis_collector.dart';
import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/analyzer/entities/entity_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/protocol_helper.dart';
import 'package:test/test.dart';

void main() {
  group('Database and api keyword tests', () {
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
          [],
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
          [],
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
      'Given a class with a field with a negated api keyword, then the generated entity should be persisted.',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
        class: Example
        fields:
          name: String, !api
        ''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition =
            SerializableEntityAnalyzer.extractEntityDefinition(protocol)
                as ClassDefinition;
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition],
        );

        expect(
          definition.fields.last.shouldPersist,
          isTrue,
        );
      },
    );

    test(
      'Given a class with a field with a negated database keyword, then the generated entity has the scope all.',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
        class: Example
        fields:
          name: String, !database
        ''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
        );

        var definition =
            SerializableEntityAnalyzer.extractEntityDefinition(protocol)
                as ClassDefinition;
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition],
        );

        expect(
          definition.fields.last.scope,
          EntityFieldScopeDefinition.all,
        );
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
          [],
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

        var message1 = 'The "api" property is mutually exclusive with the '
            '"database" property.';
        var message2 = 'The "database" property is mutually exclusive with the '
            '"api" property.';

        var hasDatabaseError = collector.errors.any(
          (error) => error.message == message1,
        );

        var hasApiError = collector.errors.any(
          (error) => error.message == message2,
        );

        expect(
          hasDatabaseError,
          isTrue,
          reason: 'Expected error message: $message1',
        );
        expect(
          hasApiError,
          isTrue,
          reason: 'Expected error message: $message2',
        );
      },
    );

    group(
      'Given a class with a field with the scope set to database',
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
          [],
        );

        var definition =
            SerializableEntityAnalyzer.extractEntityDefinition(protocol)
                as ClassDefinition;
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition],
        );

        test('then an error is reported', () {
          expect(collector.errors, isNotEmpty);
        });

        test('then an deprecated error message is reported.', () {
          var error = collector.errors.first as SourceSpanSeverityException;
          expect(
            error.message,
            'The "database" property is deprecated. Use "scope=serverOnly" instead.',
          );

          expect(error.severity, SourceSpanSeverity.info);
        }, skip: collector.errors.isEmpty);

        test('then the generated entity has the serverOnly scope.', () {
          expect(
            definition.fields.last.scope,
            EntityFieldScopeDefinition.serverOnly,
          );
        });
      },
    );

    group(
      'Given a class with a field with the scope set to api',
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
          [],
        );

        var definition =
            SerializableEntityAnalyzer.extractEntityDefinition(protocol)
                as ClassDefinition;
        SerializableEntityAnalyzer.validateYamlDefinition(
          protocol.yaml,
          protocol.yamlSourceUri.path,
          collector,
          definition,
          [definition],
        );

        test('then an error is reported', () {
          expect(collector.errors, isNotEmpty);
        });

        test('then an deprecated error message is reported.', () {
          var error = collector.errors.first as SourceSpanSeverityException;
          expect(
            error.message,
            'The "api" property is deprecated. Use "!persist" instead.',
          );

          expect(error.severity, SourceSpanSeverity.info);
        }, skip: collector.errors.isEmpty);

        test('then the generated entity should not be persisted.', () {
          expect(
            definition.fields.last.shouldPersist,
            isFalse,
          );
        });
      },
    );

    test(
      'Given a class with a field with database set to an invalid value, then collect an error that the value must be a bool.',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
        class: Example
        fields:
          name: String, database=INVALID
        ''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
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

        expect(error.message, 'The value must be a boolean.');
      },
    );

    test(
      'Given a class with a field with api set to an invalid value, then collect an error that the value must be a bool.',
      () {
        var collector = CodeGenerationCollector();
        var protocol = ProtocolSource(
          '''
        class: Example
        fields:
          name: String, api=INVALID
        ''',
          Uri(path: 'lib/src/protocol/example.yaml'),
          [],
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

        expect(error.message, 'The value must be a boolean.');
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
          [],
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

        var message =
            'The "api" property is mutually exclusive with the "parent" property.';

        var hasError = collector.errors.any(
          (error) => error.message == message,
        );

        expect(hasError, isTrue, reason: 'Expected error message: $message');
      },
    );
  });

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
        [],
      );

      var definition = SerializableEntityAnalyzer.extractEntityDefinition(
        protocol,
      ) as ClassDefinition;
      SerializableEntityAnalyzer.resolveEntityDependencies([definition]);
      SerializableEntityAnalyzer.validateYamlDefinition(
        protocol.yaml,
        protocol.yamlSourceUri.path,
        collector,
        definition,
        [definition],
      );

      expect(definition.fields.last.scope, EntityFieldScopeDefinition.all);
    },
  );

  group('Given a class with a field with the scope set', () {
    var collector = CodeGenerationCollector();
    var protocol = ProtocolSource(
      '''
      class: Example
      fields:
        name: String, scope=serverOnly
        example: String, scope=all
        town: String, scope=none
      ''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var definition = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol,
    ) as ClassDefinition;
    SerializableEntityAnalyzer.resolveEntityDependencies([definition]);
    SerializableEntityAnalyzer.validateYamlDefinition(
      protocol.yaml,
      protocol.yamlSourceUri.path,
      collector,
      definition,
      [definition],
    );

    test('then no errors are collected.', () {
      expect(collector.errors, isEmpty);
    });

    test('then the generated entity has the scope.', () {
      expect(
        definition.fields[0].scope,
        EntityFieldScopeDefinition.serverOnly,
      );
    });

    test('then the generated entity has the scope.', () {
      expect(
        definition.fields[1].scope,
        EntityFieldScopeDefinition.all,
      );
    });

    test('then the generated entity has the scope.', () {
      expect(
        definition.fields[2].scope,
        EntityFieldScopeDefinition.none,
      );
    });
  });

  test(
      'Given a class with a field with the scope set to null, then collect an error informing the user about the correct types.',
      () {
    var collector = CodeGenerationCollector();
    var protocol = ProtocolSource(
      '''
      class: Example
      fields:
        name: String, scope=
      ''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var definition = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol,
    ) as ClassDefinition;
    SerializableEntityAnalyzer.resolveEntityDependencies([definition]);
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
      reason: 'Expected an error for invalid scope name, none was found.',
    );

    expect(
      collector.errors.first.message,
      '"" is not a valid property. Valid properties are (all, serverOnly, none).',
    );
  });

  test(
      'Given a class with a field with the scope set to an invalid value, then collect an error informing the user about the correct types.',
      () {
    var collector = CodeGenerationCollector();
    var protocol = ProtocolSource(
      '''
      class: Example
      fields:
        name: String, scope=InvalidScope
      ''',
      Uri(path: 'lib/src/protocol/example.yaml'),
      [],
    );

    var definition = SerializableEntityAnalyzer.extractEntityDefinition(
      protocol,
    ) as ClassDefinition;
    SerializableEntityAnalyzer.resolveEntityDependencies([definition]);
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
      reason: 'Expected an error for invalid scope name, none was found.',
    );

    expect(
      collector.errors.first.message,
      '"InvalidScope" is not a valid property. Valid properties are (all, serverOnly, none).',
    );
  });

  test(
    'Given a class with a field with both the scope and database keywords, then collect an error that only one of them is allowed.',
    () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
        class: Example
        fields:
          name: String, scope=serverOnly, database
        ''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
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
          'The "scope" property is mutually exclusive with the "database" property.');
      expect(error2.message,
          'The "database" property is mutually exclusive with the "scope" property.');
    },
  );

  test(
    'Given a class with a field with both the scope and api keywords, then collect an error that only one of them is allowed.',
    () {
      var collector = CodeGenerationCollector();
      var protocol = ProtocolSource(
        '''
        class: Example
        fields:
          name: String, scope=serverOnly, api
        ''',
        Uri(path: 'lib/src/protocol/example.yaml'),
        [],
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
          'The "scope" property is mutually exclusive with the "api" property.');
      expect(error2.message,
          'The "api" property is mutually exclusive with the "scope" property.');
    },
  );
}
