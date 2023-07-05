import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/analyzer/entities/entity_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:test/test.dart';

void main() {
  test(
      'Given two protocols with the same class name, then an error is collected that there is a collision in the class names.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
class: Example
fields:
  name: String
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      outFileName: 'example.yaml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    var entity1 = analyzer.analyze();

    var analyzer2 = SerializableEntityAnalyzer(
      yaml: '''
class: Example
fields:
  differentName: String
''',
      sourceFileName: 'lib/src/protocol/example2.yaml',
      outFileName: 'example2.yaml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    var entity2 = analyzer2.analyze();

    analyzer.analyze(
      protocolEntities: [entity1, entity2].cast<SerializableEntityDefinition>(),
    );

    expect(collector.errors.length, greaterThan(0));

    expect(collector.errors.first.message,
        'The class name "Example" is already used by another protocol class.');
  });

  test(
      'Given a single valid protocol, then there is no error collected for the class name.',
      () {
    var collector = CodeGenerationCollector();
    var analyzer = SerializableEntityAnalyzer(
      yaml: '''
class: Example
fields:
  name: String
''',
      sourceFileName: 'lib/src/protocol/example.yaml',
      outFileName: 'example.yaml',
      subDirectoryParts: ['lib', 'src', 'protocol'],
      collector: collector,
    );

    var entity = analyzer.analyze();

    analyzer.analyze(
      protocolEntities: [entity].cast<SerializableEntityDefinition>(),
    );

    expect(collector.errors, isEmpty);
  });
}
