import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/annotation_definition_builder.dart';
import '../../../test_util/builders/endpoint_definition_builder.dart';
import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/method_definition_builder.dart';
import '../../../test_util/builders/type_definition_builder.dart';

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
              ])
              .build(),
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

      test(
        'then client file contains endpoint method for the streaming endpoint.',
        () {
          expect(endpointsFile, contains('_i2.Stream<String> $methodName()'));
          expect(
            endpointsFile,
            contains(
              'caller.callStreamingServerEndpoint<_i2.Stream<String>, String',
            ),
          );
        },
      );
    },
  );

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
              ])
              .build(),
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

      test('then client file endpoint method for the streaming endpoint.', () {
        expect(
          endpointsFile,
          contains(
            'Future<String> $methodName(_i2.Stream<String> streamParam)',
          ),
        );
        expect(
          endpointsFile,
          contains('caller.callStreamingServerEndpoint<Future<String>, String'),
        );
      });
    },
  );

  group(
    'Given a protocol definition with a method with "@Deprecated(..)" annotation when generating client file',
    () {
      var endpointName = 'testing';
      var methodName = 'deprecatedMethod';
      var protocolDefinition = ProtocolDefinition(
        endpoints: [
          EndpointDefinitionBuilder()
              .withClassName('${endpointName.pascalCase}Endpoint')
              .withName(endpointName)
              .withMethods([
                MethodDefinitionBuilder().withName(methodName).withAnnotations([
                  AnnotationDefinitionBuilder()
                      .withName('Deprecated')
                      .withArguments(["'This method is deprecated.'"])
                      .build(),
                ]).buildMethodCallDefinition(),
              ])
              .build(),
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

      test(
        'then client file contains "@Deprecated(..)" annotation for method.',
        () {
          expect(
            endpointsFile,
            contains(
              "@Deprecated('This method is deprecated.')",
            ),
          );
        },
      );
    },
  );

  group(
    'Given a protocol definition with a method with "@deprecated" annotation when generating client file',
    () {
      var endpointName = 'testing';
      var methodName = 'deprecatedMethod';
      var protocolDefinition = ProtocolDefinition(
        endpoints: [
          EndpointDefinitionBuilder()
              .withClassName('${endpointName.pascalCase}Endpoint')
              .withName(endpointName)
              .withMethods([
                MethodDefinitionBuilder().withName(methodName).withAnnotations([
                  AnnotationDefinitionBuilder().withName('deprecated').build(),
                ]).buildMethodCallDefinition(),
              ])
              .build(),
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

      test(
        'then client file contains "@deprecated" annotation for method.',
        () {
          expect(
            endpointsFile,
            contains(
              '@deprecated\n',
            ),
          );
        },
      );
    },
  );

  group(
    'Given a protocol definition with a method with "@TestCustomAnnotation(.., ..)" annotation when generating client file',
    () {
      var endpointName = 'testing';
      var methodName = 'customAnnotatedMethod';
      var protocolDefinition = ProtocolDefinition(
        endpoints: [
          EndpointDefinitionBuilder()
              .withClassName('${endpointName.pascalCase}Endpoint')
              .withName(endpointName)
              .withMethods([
                MethodDefinitionBuilder().withName(methodName).withAnnotations([
                  AnnotationDefinitionBuilder()
                      .withName('TestCustomAnnotation')
                      .withArguments(["'a string literal argument'", '42'])
                      .build(),
                ]).buildMethodCallDefinition(),
              ])
              .build(),
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

      test(
        'then client file contains "@TestCustomAnnotation(.., ..)" annotation for method.',
        () {
          expect(
            endpointsFile,
            contains(
              "@TestCustomAnnotation('a string literal argument', 42)",
            ),
          );
        },
      );
    },
  );
}
