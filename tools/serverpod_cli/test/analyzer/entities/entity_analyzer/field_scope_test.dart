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

        var error1 = collector.errors[0];
        var error2 = collector.errors[1];

        expect(error1.message,
            'The "database" property is mutually exclusive with the "api" property.');
        expect(error2.message,
            'The "api" property is mutually exclusive with the "database" property.');
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

        expect((definition as ClassDefinition).fields.last.scope,
            EntityFieldScopeDefinition.all);
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

        /*test('then a deprecated info is collected.', () {
          expect(collector.errors.length, greaterThan(0));
          var error = collector.errors.first;

          expect(error.message, 'Api is deprecated, use "!persist" instead');
        });*/

        test('then the generated entity should not be persisted.', () {
          expect(
            definition.fields.last.shouldPersist,
            false,
          );
        });
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
        expect(
          collector.errors.last.message,
          'The "api" property is mutually exclusive with the "parent" property.',
        );
      },
    );
  });
}
