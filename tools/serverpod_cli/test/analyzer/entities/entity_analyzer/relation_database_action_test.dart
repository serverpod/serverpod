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

    test('then onUpdate is set to default.', () {
      var field = entity.fields.last;
      expect(field.relation?.onUpdate, ForeignKeyAction.noAction);
    });

    test('then onDelete is set to default.', () {
      var field = entity.fields.last;
      expect(field.relation?.onUpdate, ForeignKeyAction.cascade);
    });
  });
}
