import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/protocol_definition.dart';
import 'package:serverpod_cli/src/generator/yaml/endpoint_description_generator.dart';
import 'package:test/test.dart';

import '../../test_util/builders/endpoint_definition_builder.dart';
import '../../test_util/builders/generator_config_builder.dart';
import '../../test_util/builders/method_definition_builder.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = EndpointDescriptionGenerator();

void main() {
  var expectedFileName = path.join(
    'lib',
    'src',
    'generated',
    'protocol.yaml',
  );
  test(
    'Given an empty protocol definition when generating protocol files then an empty protocol.yaml file is created.',
    () {
      var protocolDefinition = const ProtocolDefinition(
        endpoints: [],
        models: [],
      );

      var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      expect(codeMap, contains(expectedFileName));
      expect(codeMap[expectedFileName], equals(''));
    },
  );

  test(
    'Given an endpoint without any methods when generating protocol files then the protocol.yaml has only the endpoint defined',
    () {
      var protocolDefinition = ProtocolDefinition(
        endpoints: [
          EndpointDefinitionBuilder()
              .withClassName('ExampleEndpoint')
              .withName('example')
              .withMethods([])
              .build(),
        ],
        models: [],
      );

      var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      expect(codeMap[expectedFileName], equals('example:\n'));
    },
  );

  test(
    'Given two endpoint without any methods when generating protocol files then the protocol.yaml has both the endpoints defined',
    () {
      var protocolDefinition = ProtocolDefinition(
        endpoints: [
          EndpointDefinitionBuilder()
              .withClassName('ExampleEndpoint')
              .withName('example')
              .withMethods([])
              .build(),
          EndpointDefinitionBuilder()
              .withClassName('ExampleEndpoint2')
              .withName('example2')
              .withMethods([])
              .build(),
        ],
        models: [],
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
    },
  );

  test(
    'Given one endpoint with a method when generating protocol files then the protocol.yaml has the endpoint defined with the method as a list entry',
    () {
      var protocolDefinition = ProtocolDefinition(
        endpoints: [
          EndpointDefinitionBuilder()
              .withClassName('ExampleEndpoint')
              .withName('example')
              .withMethods([
                MethodDefinitionBuilder()
                    .withName('method')
                    .buildMethodCallDefinition(),
              ])
              .build(),
        ],
        models: [],
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
    },
  );

  test(
    'Given one endpoint with two methods when generating protocol files then the protocol.yaml has the endpoint defined with the methods as list entry',
    () {
      var protocolDefinition = ProtocolDefinition(
        endpoints: [
          EndpointDefinitionBuilder()
              .withClassName('ExampleEndpoint')
              .withName('example')
              .withMethods([
                MethodDefinitionBuilder()
                    .withName('method')
                    .buildMethodCallDefinition(),
                MethodDefinitionBuilder()
                    .withName('method2')
                    .buildMethodCallDefinition(),
              ])
              .build(),
        ],
        models: [],
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
    },
  );

  test(
    'Given multiple endpoints with multiple methods when generating protocol files then the protocol.yaml has all endpoints and methods defined',
    () {
      var protocolDefinition = ProtocolDefinition(
        endpoints: [
          EndpointDefinitionBuilder()
              .withClassName('ExampleEndpoint')
              .withName('example')
              .withMethods([
                MethodDefinitionBuilder()
                    .withName('method')
                    .buildMethodCallDefinition(),
                MethodDefinitionBuilder()
                    .withName('method2')
                    .buildMethodCallDefinition(),
              ])
              .build(),
          EndpointDefinitionBuilder()
              .withClassName('ExampleEndpoint2')
              .withName('example2')
              .withMethods([])
              .build(),
          EndpointDefinitionBuilder()
              .withClassName('ExampleEndpoint3')
              .withName('example3')
              .withMethods([
                MethodDefinitionBuilder()
                    .withName('method')
                    .buildMethodCallDefinition(),
              ])
              .build(),
        ],
        models: [],
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
    },
  );

  test(
    'Given protocol definition with abstract endpoint when generating protocol files then the protocol.yaml does not contain the abstract endpoint',
    () {
      var protocolDefinition = ProtocolDefinition(
        endpoints: [
          EndpointDefinitionBuilder()
              .withClassName('BaseAbstractEndpoint')
              .withName('baseAbstract')
              .withIsAbstract()
              .withMethods([
                MethodDefinitionBuilder()
                    .withName('testMethod')
                    .buildMethodCallDefinition(),
              ])
              .build(),
        ],
        models: [],
      );

      var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      expect(codeMap[expectedFileName], isEmpty);
    },
  );

  test(
    'Given protocol definition with abstract endpoint and concrete implementation when generating protocol files then the protocol.yaml only contains concrete endpoint',
    () {
      var abstractEndpoint = EndpointDefinitionBuilder()
          .withClassName('BaseAbstractEndpoint')
          .withName('baseAbstract')
          .withIsAbstract()
          .withMethods([
            MethodDefinitionBuilder()
                .withName('testMethod')
                .buildMethodCallDefinition(),
          ])
          .build();

      var protocolDefinition = ProtocolDefinition(
        endpoints: [
          abstractEndpoint,
          EndpointDefinitionBuilder()
              .withClassName('ConcreteEndpoint')
              .withName('concrete')
              .withExtends(abstractEndpoint)
              .withMethods([
                MethodDefinitionBuilder()
                    .withName('testMethod')
                    .buildMethodCallDefinition(),
              ])
              .build(),
        ],
        models: [],
      );

      var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      expect(
        codeMap[expectedFileName],
        equals('''
concrete:
  - testMethod:
'''),
      );
    },
  );

  test(
    'Given protocol definition with concrete endpoint that extends another concrete endpoint when generating protocol files then the protocol.yaml contains both endpoints',
    () {
      var baseEndpoint = EndpointDefinitionBuilder()
          .withClassName('BaseEndpoint')
          .withName('base')
          .withMethods([
            MethodDefinitionBuilder()
                .withName('baseMethod')
                .buildMethodCallDefinition(),
          ])
          .build();

      var protocolDefinition = ProtocolDefinition(
        endpoints: [
          baseEndpoint,
          EndpointDefinitionBuilder()
              .withClassName('SubclassEndpoint')
              .withName('subclass')
              .withExtends(baseEndpoint)
              .withMethods([
                MethodDefinitionBuilder()
                    .withName('subclassMethod')
                    .buildMethodCallDefinition(),
              ])
              .build(),
        ],
        models: [],
      );

      var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      expect(
        codeMap[expectedFileName],
        equals('''
base:
  - baseMethod:
subclass:
  - subclassMethod:
'''),
      );
    },
  );

  test(
    'Given protocol definition with abstract > concrete > abstract subclass > concrete subclass endpoint hierarchy when generating protocol files then the protocol.yaml contains only concrete endpoints and methods',
    () {
      var abstractBaseEndpoint = EndpointDefinitionBuilder()
          .withClassName('BaseAbstractEndpoint')
          .withName('abstractBase')
          .withIsAbstract()
          .withMethods([
            MethodDefinitionBuilder()
                .withName('abstractBaseMethod')
                .buildMethodCallDefinition(),
          ])
          .build();

      var concreteBaseEndpoint = EndpointDefinitionBuilder()
          .withClassName('BaseEndpoint')
          .withName('concreteBase')
          .withExtends(abstractBaseEndpoint)
          .withMethods([
            MethodDefinitionBuilder()
                .withName('concreteBaseMethod')
                .buildMethodCallDefinition(),
          ])
          .build();

      var abstractSubClassEndpoint = EndpointDefinitionBuilder()
          .withClassName('AbstractSubClassEndpoint')
          .withName('abstractSubClass')
          .withIsAbstract()
          .withExtends(concreteBaseEndpoint)
          .withMethods([
            MethodDefinitionBuilder()
                .withName('abstractSubClassMethod')
                .buildMethodCallDefinition(),
          ])
          .build();

      var concreteSubclassEndpoint = EndpointDefinitionBuilder()
          .withClassName('SubclassEndpoint')
          .withName('concreteSubclass')
          .withExtends(abstractSubClassEndpoint)
          .withMethods([
            MethodDefinitionBuilder()
                .withName('concreteSubclassMethod')
                .buildMethodCallDefinition(),
          ])
          .build();

      var protocolDefinition = ProtocolDefinition(
        endpoints: [
          abstractBaseEndpoint,
          concreteBaseEndpoint,
          abstractSubClassEndpoint,
          concreteSubclassEndpoint,
        ],
        models: [],
      );

      var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      expect(
        codeMap[expectedFileName],
        equals('''
concreteBase:
  - concreteBaseMethod:
concreteSubclass:
  - concreteSubclassMethod:
'''),
      );
    },
  );
}
