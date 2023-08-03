import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/analyzer/entities/entity_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/protocol_helper.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given a class with a field with no persist set but has a table, then the generated entity should be persisted.',
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

      expect(
        (definition as ClassDefinition).fields.last.shouldPersist,
        isTrue,
      );
    },
  );
}
