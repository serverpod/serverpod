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
    'Given protocol definition with a concrete endpoint that extends another concrete endpoint when generating server files',
    () {
      var baseEndpointName = 'base';
      var concreteEndpointName = 'subclass';
      var baseMethodName = 'baseMethod';
      var concreteMethodName = 'subclassMethod';

      // Create base endpoint
      var baseEndpoint = EndpointDefinitionBuilder()
          .withClassName('${baseEndpointName.pascalCase}Endpoint')
          .withName(baseEndpointName)
          .withMethods([
            MethodDefinitionBuilder()
                .withName(baseMethodName)
                .buildMethodCallDefinition(),
          ])
          .build();

      // Create endpoint that extends base endpoint
      var concreteEndpoint = EndpointDefinitionBuilder()
          .withClassName('${concreteEndpointName.pascalCase}Endpoint')
          .withName(concreteEndpointName)
          .withExtends(baseEndpoint)
          .withMethods([
            MethodDefinitionBuilder()
                .withName(baseMethodName)
                .buildMethodCallDefinition(),
            MethodDefinitionBuilder()
                .withName(concreteMethodName)
                .buildMethodCallDefinition(),
          ])
          .build();

      var protocolDefinition = ProtocolDefinition(
        endpoints: [baseEndpoint, concreteEndpoint],
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

        test('contains both endpoints in endpoints map.', () {
          expect(endpointsFileContent, contains("'$baseEndpointName'"));
          expect(endpointsFileContent, contains("'$concreteEndpointName'"));
        });

        test('contains both endpoints in connectors.', () {
          expect(
            endpointsFileContent,
            contains('connectors[\'$baseEndpointName\']'),
          );
          expect(
            endpointsFileContent,
            contains('connectors[\'$concreteEndpointName\']'),
          );
        });

        test('contains both endpoints in endpoint dispatch map.', () {
          expect(endpointsFileContent, contains(baseEndpointName));
          expect(endpointsFileContent, contains(concreteEndpointName));
        });
      });
    },
  );
}
