import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/util/protocol_helper.dart';
import 'package:test/test.dart';
import 'package:serverpod_cli/src/analyzer/entities/stateful_analyzer.dart';

void main() {
  test(
      'Given that no initial validation was done, then an empty list is returned when validating all files.',
      () {
    var statefulAnalyzer = StatefulAnalyzer([]);

    var entities = statefulAnalyzer.validateAll();

    expect(entities, []);
  });

  test(
      'When we add and remove a protocol, then an empty list is returned when validating all files.',
      () {
    var statefulAnalyzer = StatefulAnalyzer([]);

    var protocolUri = Uri(path: 'lib/src/protocol/example.yaml');
    var yamlSource = ProtocolSource(
      '''
class: Example
fields:
  name: String
''',
      protocolUri,
      [],
    );
    statefulAnalyzer.addYamlProtocol(yamlSource);
    statefulAnalyzer.removeYamlProtocol(protocolUri);

    var entities = statefulAnalyzer.validateAll();

    expect(entities, []);
  });

  test(
      'Given an empty state, when removing a protocol that does not exist and validating all, then an empty list is returned',
      () {
    var statefulAnalyzer = StatefulAnalyzer([]);

    var protocolUri = Uri(path: 'lib/src/protocol/example.yaml');
    statefulAnalyzer.removeYamlProtocol(protocolUri);

    var entities = statefulAnalyzer.validateAll();

    expect(entities, []);
  });

  test(
      'Given an empty state, when validating a single protocol, then an empty list is returned',
      () {
    var statefulAnalyzer = StatefulAnalyzer([]);

    var protocolUri = Uri(path: 'lib/src/protocol/example.yaml');
    var yaml = '''
class: Example
fields:
  name: String
''';

    var entities = statefulAnalyzer.validateProtocol(yaml, protocolUri);

    expect(entities, []);
  });
  test(
      'Given a valid protocol class as the initial state, when validating all, then the class is serialized.',
      () {
    var protocolUri = Uri(path: 'lib/src/protocol/example.yaml');
    var yamlSource = ProtocolSource(
      '''
class: Example
fields:
  name: String
''',
      protocolUri,
      [],
    );

    var statefulAnalyzer = StatefulAnalyzer([yamlSource]);

    var entities = statefulAnalyzer.validateAll();

    expect(entities.length, 1);
    expect(entities.first.className, 'Example');
  });

  test(
      'Given a valid protocol class and an error callback is registered, when validating all, then the callback is triggered.',
      () {
    var protocolUri = Uri(path: 'lib/src/protocol/example.yaml');
    var yamlSource = ProtocolSource(
      '''
class: Example
fields:
  name: String
''',
      protocolUri,
      [],
    );

    var wasCalled = false;
    var statefulAnalyzer = StatefulAnalyzer([yamlSource], (uri, errors) {
      wasCalled = true;
    });

    statefulAnalyzer.validateAll();
    expect(wasCalled, true, reason: 'The error callback was not triggered.');
  });

  test(
      'Given a protocol with invalid syntax and an error callback is registered, when validating all, then the callback is triggered.',
      () {
    var protocolUri = Uri(path: 'lib/src/protocol/example.yaml');
    var yamlSource = ProtocolSource(
      '''''',
      protocolUri,
      [],
    );

    var wasCalled = false;
    var statefulAnalyzer = StatefulAnalyzer([yamlSource], (uri, errors) {
      wasCalled = true;
    });

    statefulAnalyzer.validateAll();
    expect(wasCalled, true, reason: 'The error callback was not triggered.');
  });

  test(
      'Given a protocol that was invalid on first validation, when validating the same protocol with an updated valid syntax, then the previous errors are cleared.',
      () {
    var protocolUri = Uri(path: 'lib/src/protocol/example.yaml');
    var invalidSource = ProtocolSource(
      '''
class: 
fields:
  name: String
''',
      protocolUri,
      [],
    );

    var validSource = ProtocolSource(
      '''
class: Example
fields:
  name: String
''',
      protocolUri,
      [],
    );

    CodeGenerationCollector? reportedErrors;
    var statefulAnalyzer = StatefulAnalyzer([invalidSource], (uri, errors) {
      reportedErrors = errors;
    });

    statefulAnalyzer.validateAll();

    expect(reportedErrors?.errors, hasLength(1),
        reason: 'Expected an error to be reported.');

    statefulAnalyzer.validateProtocol(validSource.yaml, protocolUri);

    expect(reportedErrors?.errors, hasLength(0),
        reason: 'Expected the error to be cleared.');
  });

  test(
      'Given two yaml protocols with the same class name, when validating all, then an error is reported.',
      () {
    var yamlSource1 = ProtocolSource(
      '''
class: Example
fields:
  name: String
''',
      Uri(path: 'lib/src/protocol/example1.yaml'),
      [],
    );

    var yamlSource2 = ProtocolSource(
      '''
class: Example
fields:
  name: String
''',
      Uri(path: 'lib/src/protocol/example2.yaml'),
      [],
    );

    CodeGenerationCollector? reportedErrors;

    var statefulAnalyzer =
        StatefulAnalyzer([yamlSource1, yamlSource2], (uri, errors) {
      reportedErrors = errors;
    });

    statefulAnalyzer.validateAll();

    expect(reportedErrors?.errors, hasLength(1),
        reason: 'Expected an error to be reported.');
  });

  test(
      'Given two yaml protocols with the same class name, when removing and revalidating, then the previous error is cleared.',
      () {
    var yamlSource1 = ProtocolSource(
      '''
class: Example
fields:
  name: String
''',
      Uri(path: 'lib/src/protocol/example1.yaml'),
      [],
    );

    var yamlSource2 = ProtocolSource(
      '''
class: Example
fields:
  name: String
''',
      Uri(path: 'lib/src/protocol/example2.yaml'),
      [],
    );

    CodeGenerationCollector? reportedErrors;
    var statefulAnalyzer =
        StatefulAnalyzer([yamlSource1, yamlSource2], (uri, errors) {
      reportedErrors = errors;
    });

    statefulAnalyzer.validateAll();

    expect(reportedErrors?.errors, hasLength(1),
        reason: 'Expected an error to be reported.');

    statefulAnalyzer.removeYamlProtocol(yamlSource2.yamlSourceUri);

    statefulAnalyzer.validateAll();

    expect(reportedErrors?.errors, hasLength(0),
        reason: 'Expected the error to be cleared.');
  });

  test(
      'Given an initial validation with one valid protocol, when adding a second protocol with the same class and revalidating, then an error is reported.',
      () {
    var yamlSource1 = ProtocolSource(
      '''
class: Example
fields:
  name: String
''',
      Uri(path: 'lib/src/protocol/example1.yaml'),
      [],
    );

    var yamlSource2 = ProtocolSource(
      '''
class: Example
fields:
  name: String
''',
      Uri(path: 'lib/src/protocol/example2.yaml'),
      [],
    );

    CodeGenerationCollector? reportedErrors;
    var statefulAnalyzer = StatefulAnalyzer([yamlSource1], (uri, errors) {
      reportedErrors = errors;
    });

    statefulAnalyzer.validateAll();

    expect(reportedErrors?.errors, hasLength(0),
        reason: 'Expected no errors to be reported.');

    statefulAnalyzer.addYamlProtocol(yamlSource2);

    statefulAnalyzer.validateProtocol(
        yamlSource2.yaml, yamlSource2.yamlSourceUri);

    expect(reportedErrors?.errors, hasLength(1),
        reason: 'Expected an error to be reported.');
  });
}
