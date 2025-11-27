import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';
import 'package:serverpod_cli/src/analyzer/protocol_definition.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/endpoint_definition_builder.dart';
import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/method_definition_builder.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  var expectedEndpointsFileName = path.join(
    'lib',
    'src',
    'generated',
    'endpoints.dart',
  );

  group(
    'Given protocol definition with an abstract endpoint when generating server files',
    () {
      var abstractEndpointName = 'abstractTest';
      var methodName = 'testMethod';

      // Create abstract endpoint
      var abstractEndpoint = EndpointDefinitionBuilder()
          .withClassName('${abstractEndpointName.pascalCase}Endpoint')
          .withName(abstractEndpointName)
          .withIsAbstract()
          .withMethods([
            MethodDefinitionBuilder()
                .withName(methodName)
                .buildMethodCallDefinition(),
          ])
          .build();

      var protocolDefinition = ProtocolDefinition(
        endpoints: [abstractEndpoint],
        models: [],
      );

      late var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      test('then endpoints file is created.', () {
        expect(codeMap, contains(expectedEndpointsFileName));
      });

      group('then generated endpoints file', () {
        late var endpointsFileContent = codeMap[expectedEndpointsFileName]!;

        test('does not contain abstract endpoint in endpoints map.', () {
          expect(
            endpointsFileContent,
            isNot(contains("'$abstractEndpointName'")),
          );
        });

        test('does not contain abstract endpoint in connectors.', () {
          expect(
            endpointsFileContent,
            isNot(contains('connectors[\'$abstractEndpointName\']')),
          );
        });
      });
    },
  );

  group(
    'Given protocol definition with a concrete endpoint that extends an abstract base endpoint when generating server files',
    () {
      var abstractEndpointName = 'abstractTest';
      var concreteEndpointName = 'concreteTest';
      var methodName = 'testMethod';

      // Create abstract endpoint
      var abstractEndpoint = EndpointDefinitionBuilder()
          .withClassName('${abstractEndpointName.pascalCase}Endpoint')
          .withName(abstractEndpointName)
          .withIsAbstract()
          .withMethods([
            MethodDefinitionBuilder()
                .withName(methodName)
                .buildMethodCallDefinition(),
          ])
          .build();

      // Create concrete endpoint
      var concreteEndpoint = EndpointDefinitionBuilder()
          .withClassName('${concreteEndpointName.pascalCase}Endpoint')
          .withName(concreteEndpointName)
          .withExtends(abstractEndpoint)
          .withMethods([
            MethodDefinitionBuilder()
                .withName(methodName)
                .buildMethodCallDefinition(),
          ])
          .build();

      var protocolDefinition = ProtocolDefinition(
        endpoints: [abstractEndpoint, concreteEndpoint],
        models: [],
      );

      late var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      test('then endpoints file is created.', () {
        expect(codeMap, contains(expectedEndpointsFileName));
      });

      group('then generated endpoints file', () {
        late var endpointsFileContent = codeMap[expectedEndpointsFileName]!;

        test('contains concrete endpoint in endpoints map.', () {
          expect(endpointsFileContent, contains("'$concreteEndpointName'"));
        });

        test('does not contain abstract endpoint in connectors.', () {
          expect(
            endpointsFileContent,
            isNot(contains('connectors[\'$abstractEndpointName\']')),
          );
        });

        test('contains concrete endpoint in connectors.', () {
          expect(
            endpointsFileContent,
            contains('connectors[\'$concreteEndpointName\']'),
          );
        });
      });
    },
  );

  group(
    'Given protocol definition with abstract > concrete > abstract subclass > concrete subclass endpoint hierarchy when generating server files',
    () {
      var abstractBaseEndpointName = 'baseAbstract';
      var concreteBaseEndpointName = 'base';
      var abstractSubClassEndpointName = 'abstractSubClass';
      var concreteSubclassEndpointName = 'subclass';

      var abstractBaseEndpoint = EndpointDefinitionBuilder()
          .withClassName('BaseAbstractEndpoint')
          .withName(abstractBaseEndpointName)
          .withIsAbstract()
          .withMethods([
            MethodDefinitionBuilder()
                .withName('baseMethod')
                .buildMethodCallDefinition(),
          ])
          .build();

      var concreteBaseEndpoint = EndpointDefinitionBuilder()
          .withClassName('BaseEndpoint')
          .withName(concreteBaseEndpointName)
          .withExtends(abstractBaseEndpoint)
          .withMethods([
            MethodDefinitionBuilder()
                .withName('baseMethod')
                .buildMethodCallDefinition(),
          ])
          .build();

      var abstractSubClassEndpoint = EndpointDefinitionBuilder()
          .withClassName('AbstractSubClassEndpoint')
          .withName(abstractSubClassEndpointName)
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
          .withName(concreteSubclassEndpointName)
          .withExtends(abstractSubClassEndpoint)
          .withMethods([
            MethodDefinitionBuilder()
                .withName('subclassMethod')
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

      late var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      test('then endpoints file is created.', () {
        expect(codeMap, contains(expectedEndpointsFileName));
      });

      group('then generated endpoints file', () {
        late var endpointsFileContent = codeMap[expectedEndpointsFileName]!;

        test('does not contain abstract endpoints in endpoints map.', () {
          expect(
            endpointsFileContent,
            isNot(contains("'$abstractBaseEndpointName'")),
          );
          expect(
            endpointsFileContent,
            isNot(contains("'$abstractSubClassEndpointName'")),
          );
        });

        test('contains all concrete endpoints in endpoints map.', () {
          expect(endpointsFileContent, contains("'$concreteBaseEndpointName'"));
          expect(
            endpointsFileContent,
            contains("'$concreteSubclassEndpointName'"),
          );
        });

        test('does not contain abstract endpoints in connectors.', () {
          expect(
            endpointsFileContent,
            isNot(contains('connectors[\'$abstractBaseEndpointName\']')),
          );
          expect(
            endpointsFileContent,
            isNot(contains('connectors[\'$abstractSubClassEndpointName\']')),
          );
        });

        test('contains all concrete endpoints in connectors.', () {
          expect(
            endpointsFileContent,
            contains('connectors[\'$concreteBaseEndpointName\']'),
          );
          expect(
            endpointsFileContent,
            contains('connectors[\'$concreteSubclassEndpointName\']'),
          );
        });
      });
    },
  );
}
