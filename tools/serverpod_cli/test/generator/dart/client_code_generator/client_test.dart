import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:serverpod_cli/src/test_util/builders/endpoint_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/method_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/type_definition_builder.dart';
import 'package:test/test.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartClientCodeGenerator();

void main() {
  var expectedFileName = path.join(
    '..',
    'example_project_client',
    'lib',
    'src',
    'protocol',
    'client.dart',
  );

  group(
      'Given a protocol definition with a method with Stream return value when generating client file',
      () {
    var endpointName = 'testing';
    var methodName = 'streamMethod';
    var protocolDefinition = ProtocolDefinition(
      endpoints: [
        EndpointDefinitionBuilder()
            .withClassName('${endpointName.pascalCase}Endpoint')
            .withName(endpointName)
            .withMethods([
          MethodDefinitionBuilder()
              .withName(methodName)
              .withReturnType(
                TypeDefinitionBuilder()
                    .withStreamOf('String')
                    .withUrl('dart:async')
                    .build(),
              )
              .buildMethodStreamDefinition(),
        ]).build(),
      ],
      models: [],
    );

    var codeMap = generator.generateProtocolCode(
      protocolDefinition: protocolDefinition,
      config: config,
    );

    test('then client file is created.', () {
      expect(codeMap, contains(expectedFileName));
    });
    var endpointsFile = codeMap[expectedFileName];

    test('then client file contains experimental warning for method.', () {
      expect(
        endpointsFile,
        contains(
          '/// Warning: Streaming methods are still experimental.',
        ),
      );
    });
    test(
        'then client file contains endpoint method for the streaming endpoint.',
        () {
      expect(endpointsFile, contains('_i2.Stream<String> $methodName()'));
      expect(
          endpointsFile,
          contains(
              'caller.callStreamingServerEndpoint<_i2.Stream<String>, String'));
    });
  });

  group(
      'Given a protocol definition with a method with only a Stream parameter when generating client file',
      () {
    var endpointName = 'testing';
    var methodName = 'streamMethod';
    var protocolDefinition = ProtocolDefinition(
      endpoints: [
        EndpointDefinitionBuilder()
            .withClassName('${endpointName.pascalCase}Endpoint')
            .withName(endpointName)
            .withMethods([
          MethodDefinitionBuilder().withName(methodName).withParameters([
            ParameterDefinition(
              name: 'streamParam',
              type: TypeDefinitionBuilder()
                  .withStreamOf('String')
                  .withUrl('dart:async')
                  .build(),
              required: true,
            ),
          ]).buildMethodStreamDefinition(),
        ]).build(),
      ],
      models: [],
    );

    var codeMap = generator.generateProtocolCode(
      protocolDefinition: protocolDefinition,
      config: config,
    );

    test('then client file is created.', () {
      expect(codeMap, contains(expectedFileName));
    });
    var endpointsFile = codeMap[expectedFileName];

    test('then client file contains experimental warning for method.', () {
      expect(
        endpointsFile,
        contains(
          '/// Warning: Streaming methods are still experimental.',
        ),
      );
    });

    test('then client file endpoint method for the streaming endpoint.', () {
      expect(
          endpointsFile,
          contains(
              'Future<String> $methodName(_i2.Stream<String> streamParam)'));
      expect(
          endpointsFile,
          contains(
              'caller.callStreamingServerEndpoint<Future<String>, String'));
    });
  });
}
