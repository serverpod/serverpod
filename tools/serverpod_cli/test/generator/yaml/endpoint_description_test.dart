import 'package:serverpod_cli/src/analyzer/protocol_definition.dart';
import 'package:serverpod_cli/src/generator/yaml/endpoint_description_generator.dart';
import 'package:serverpod_cli/src/test_util/builders/endpoint_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/method_definition_builder.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = EndpointDescriptionGenerator();

void main() {
  var expectedFileName = path.join(
    'generated',
    'protocol.yaml',
  );
  test(
      'Given an empty protocol definition when generating protocol files then an empty protocol.yaml file is created.',
      () {
    var protocolDefinition = const ProtocolDefinition(
      endpoints: [],
      entities: [],
    );

    var codeMap = generator.generateProtocolCode(
      protocolDefinition: protocolDefinition,
      config: config,
    );

    expect(codeMap, contains(expectedFileName));
    expect(codeMap[expectedFileName], equals(''));
  });

  test(
      'Given an endpoint without any methods when generating protocol files then the protocol.yaml has only the endpoint defined',
      () {
    var protocolDefinition = ProtocolDefinition(
      endpoints: [
        EndpointDefinitionBuilder()
            .withClassName('ExampleEndpoint')
            .withName('example')
            .withMethods([]).build()
      ],
      entities: [],
    );

    var codeMap = generator.generateProtocolCode(
      protocolDefinition: protocolDefinition,
      config: config,
    );

    expect(codeMap[expectedFileName], equals('example:\n'));
  });

  test(
      'Given two endpoint without any methods when generating protocol files then the protocol.yaml has both the endpoints defined',
      () {
    var protocolDefinition = ProtocolDefinition(
      endpoints: [
        EndpointDefinitionBuilder()
            .withClassName('ExampleEndpoint')
            .withName('example')
            .withMethods([]).build(),
        EndpointDefinitionBuilder()
            .withClassName('ExampleEndpoint2')
            .withName('example2')
            .withMethods([]).build()
      ],
      entities: [],
    );

    var codeMap = generator.generateProtocolCode(
      protocolDefinition: protocolDefinition,
      config: config,
    );

    expect(
      codeMap[expectedFileName],
      equals('''
example:
example2:
'''),
    );
  });

  test(
      'Given one endpoint with a method when generating protocol files then the protocol.yaml has the endpoint defined with the method as a list entry',
      () {
    var protocolDefinition = ProtocolDefinition(
      endpoints: [
        EndpointDefinitionBuilder()
            .withClassName('ExampleEndpoint')
            .withName('example')
            .withMethods([
          MethodDefinitionBuilder().withName('method').build(),
        ]).build(),
      ],
      entities: [],
    );

    var codeMap = generator.generateProtocolCode(
      protocolDefinition: protocolDefinition,
      config: config,
    );

    expect(
      codeMap[expectedFileName],
      equals('''
example:
  - method:
'''),
    );
  });

  test(
      'Given one endpoint with two methods when generating protocol files then the protocol.yaml has the endpoint defined with the methods as list entry',
      () {
    var protocolDefinition = ProtocolDefinition(
      endpoints: [
        EndpointDefinitionBuilder()
            .withClassName('ExampleEndpoint')
            .withName('example')
            .withMethods([
          MethodDefinitionBuilder().withName('method').build(),
          MethodDefinitionBuilder().withName('method2').build(),
        ]).build(),
      ],
      entities: [],
    );

    var codeMap = generator.generateProtocolCode(
      protocolDefinition: protocolDefinition,
      config: config,
    );

    expect(
      codeMap[expectedFileName],
      equals('''
example:
  - method:
  - method2:
'''),
    );
  });

  test(
      'Given multiple endpoints with multiple methods when generating protocol files then the protocol.yaml then all endpoints and methods are defined',
      () {
    var protocolDefinition = ProtocolDefinition(
      endpoints: [
        EndpointDefinitionBuilder()
            .withClassName('ExampleEndpoint')
            .withName('example')
            .withMethods([
          MethodDefinitionBuilder().withName('method').build(),
          MethodDefinitionBuilder().withName('method2').build(),
        ]).build(),
        EndpointDefinitionBuilder()
            .withClassName('ExampleEndpoint2')
            .withName('example2')
            .withMethods([]).build(),
        EndpointDefinitionBuilder()
            .withClassName('ExampleEndpoint3')
            .withName('example3')
            .withMethods([
          MethodDefinitionBuilder().withName('method').build(),
        ]).build(),
      ],
      entities: [],
    );

    var codeMap = generator.generateProtocolCode(
      protocolDefinition: protocolDefinition,
      config: config,
    );

    expect(
      codeMap[expectedFileName],
      equals('''
example:
  - method:
  - method2:
example2:
example3:
  - method:
'''),
    );
  });
}
