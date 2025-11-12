import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/protocol_definition.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/endpoint_definition_builder.dart';
import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/method_definition_builder.dart';
import '../../../test_util/builders/type_definition_builder.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  var expectedFileName = path.join(
    'lib',
    'src',
    'generated',
    'endpoints.dart',
  );
  group(
    'Given protocol definition without endpoints when generating endpoints file',
    () {
      late Map<String, String> codeMap;
      late String? endpointsFile;
      setUpAll(() {
        var protocolDefinition = const ProtocolDefinition(
          endpoints: [],
          models: [],
        );

        codeMap = generator.generateProtocolCode(
          protocolDefinition: protocolDefinition,
          config: config,
        );
        endpointsFile = codeMap[expectedFileName];
      });

      test('then endpoints file is created.', () {
        expect(codeMap, contains(expectedFileName));
      });

      group(
        'then endpoints file',
        () {
          test('has no endpoints defined.', () {
            expect(endpointsFile, isNot(contains('var endpoints =')));
          });

          test('has no endpoint connectors defined.', () {
            expect(endpointsFile, isNot(contains('connectors')));
          });
        },
      );
    },
  );

  group(
    'Given protocol definition with endpoint when generating endpoints file',
    () {
      var endpointName = 'testing';
      late Map<String, String> codeMap;
      late String? endpointsFile;
      setUpAll(() {
        var protocolDefinition = ProtocolDefinition(
          endpoints: [
            EndpointDefinitionBuilder()
                .withClassName('${endpointName.pascalCase}Endpoint')
                .withName(endpointName)
                .build(),
          ],
          models: [],
        );

        codeMap = generator.generateProtocolCode(
          protocolDefinition: protocolDefinition,
          config: config,
        );

        endpointsFile = codeMap[expectedFileName];
      });

      test('then endpoints file is created.', () {
        expect(codeMap, contains(expectedFileName));
      });

      group(
        'then endpoints file',
        () {
          test('has endpoints map defined.', () {
            expect(endpointsFile, contains('var endpoints ='));
          });

          test('has endpoint connectors for endpoint defined defined.', () {
            expect(endpointsFile, contains('connectors[\'$endpointName\']'));
          });
        },
      );
    },
  );

  group(
    'Given protocol definition with multiple endpoints when generating endpoints file',
    () {
      var firstEndpointName = 'testing1';
      var secondEndpointName = 'testing2';
      late Map<String, String> codeMap;
      late String? endpointsFile;

      setUpAll(() {
        var protocolDefinition = ProtocolDefinition(
          endpoints: [
            EndpointDefinitionBuilder()
                .withClassName('${firstEndpointName.pascalCase}Endpoint')
                .withName(firstEndpointName)
                .build(),
            EndpointDefinitionBuilder()
                .withClassName('${secondEndpointName.pascalCase}Endpoint')
                .withName(secondEndpointName)
                .build(),
          ],
          models: [],
        );

        codeMap = generator.generateProtocolCode(
          protocolDefinition: protocolDefinition,
          config: config,
        );
        endpointsFile = codeMap[expectedFileName];
      });

      test('then endpoints file is created.', () {
        expect(codeMap, contains(expectedFileName));
      });

      group(
        'then endpoints file',
        () {
          test('has endpoint defined.', () {
            expect(endpointsFile, contains('var endpoints ='));
          });

          test(
            'has endpoint connectors for both endpoints defined defined.',
            () {
              expect(
                endpointsFile,
                contains('connectors[\'$firstEndpointName\']'),
              );
              expect(
                endpointsFile,
                contains('connectors[\'$secondEndpointName\']'),
              );
            },
          );
        },
      );
    },
  );

  group(
    'Given a protocol definition with a method with Stream return value when generating endpoints file',
    () {
      var endpointName = 'testing';
      var methodName = 'streamMethod';
      late Map<String, String> codeMap;
      late String? endpointsFile;

      setUpAll(() {
        var protocolDefinition = ProtocolDefinition(
          endpoints: [
            EndpointDefinitionBuilder()
                .withClassName('${endpointName.pascalCase}Endpoint')
                .withName(endpointName)
                .withMethods([
                  MethodDefinitionBuilder()
                      .withName(methodName)
                      .withReturnType(
                        TypeDefinitionBuilder().withStreamOf('String').build(),
                      )
                      .buildMethodStreamDefinition(),
                ])
                .build(),
          ],
          models: [],
        );

        codeMap = generator.generateProtocolCode(
          protocolDefinition: protocolDefinition,
          config: config,
        );

        endpointsFile = codeMap[expectedFileName];
      });

      test('then endpoints file is created.', () {
        expect(codeMap, contains(expectedFileName));
      });

      test(
        'then endpoints file contains MethodStreamConnector for method.',
        () {
          expect(
            endpointsFile,
            contains("'$methodName': _i1.MethodStreamConnector("),
          );
        },
      );

      test('then endpoint file contains empty streamParams.', () {
        expect(endpointsFile, contains('streamParams: {}'));
      });

      test('then endpoint file contains streamParams map in method call', () {
        expect(endpointsFile, contains('Map<String, Stream> streamParams'));
      });
    },
  );

  group(
    'Given a protocol definition with a method with only a Stream parameter when generating endpoints file',
    () {
      var endpointName = 'testing';
      var methodName = 'streamMethod';
      late Map<String, String> codeMap;
      late String? endpointsFile;
      setUpAll(() {
        var protocolDefinition = ProtocolDefinition(
          endpoints: [
            EndpointDefinitionBuilder()
                .withClassName('${endpointName.pascalCase}Endpoint')
                .withName(endpointName)
                .withMethods([
                  MethodDefinitionBuilder().withName(methodName).withParameters(
                    [
                      ParameterDefinition(
                        name: 'streamParam',
                        type: TypeDefinitionBuilder()
                            .withStreamOf('String')
                            .build(),
                        required: false,
                      ),
                    ],
                  ).buildMethodStreamDefinition(),
                ])
                .build(),
          ],
          models: [],
        );

        codeMap = generator.generateProtocolCode(
          protocolDefinition: protocolDefinition,
          config: config,
        );
        endpointsFile = codeMap[expectedFileName];
      });

      test('then endpoints file is created.', () {
        expect(codeMap, contains(expectedFileName));
      });

      test(
        'then endpoints file contains MethodStreamConnector for method.',
        () {
          expect(
            endpointsFile,
            contains("'$methodName': _i1.MethodStreamConnector("),
          );
        },
      );

      test('then endpoint file contains empty params for method.', () {
        expect(endpointsFile, contains('params: {}'));
      });

      test(
        'then endpoint file contains streamParams with streaming parameter.',
        () {
          expect(
            endpointsFile,
            contains(
              ' streamParams: {\n'
              '            \'streamParam\': _i1.StreamParameterDescription<String>(\n ',
            ),
          );
        },
      );

      test(
        'then endpoint file contains parameter passing from streamParams in method call',
        () {
          expect(
            endpointsFile,
            contains('streamParams[\'streamParam\']!.cast<String>()'),
          );
        },
      );
    },
  );

  group(
    'Given a protocol definition with a method with "@Deprecated(..)" annotation when generating endpoints file',
    () {
      var endpointName = 'testing';
      var methodName = 'deprecatedMethod';
      late Map<String, String> codeMap;
      late String? endpointsFile;
      setUpAll(() {
        var protocolDefinition = ProtocolDefinition(
          endpoints: [
            EndpointDefinitionBuilder()
                .withClassName('${endpointName.pascalCase}Endpoint')
                .withName(endpointName)
                .withMethods([
                  MethodDefinitionBuilder()
                      .withName(methodName)
                      .withAnnotations([
                        const AnnotationDefinition(
                          name: 'Deprecated',
                          arguments: ["'This method is deprecated.'"],
                          methodCallAnalyzerIgnoreRule:
                              'deprecated_member_use_from_same_package',
                        ),
                      ])
                      .buildMethodCallDefinition(),
                ])
                .build(),
          ],
          models: [],
        );

        codeMap = generator.generateProtocolCode(
          protocolDefinition: protocolDefinition,
          config: config,
        );
        endpointsFile = codeMap[expectedFileName];
      });

      test('then endpoint file is created.', () {
        expect(codeMap, contains(expectedFileName));
      });

      test(
        'then endpoint file contains "ignore: deprecated_member_use_from_same_package" comment for method.',
        () {
          expect(
            endpointsFile,
            contains(
              '\n// ignore: deprecated_member_use_from_same_package\n',
            ),
          );
        },
      );
    },
  );

  group(
    'Given a protocol definition with an endpoint defined in the lib folder',
    () {
      var protocolDefinition = ProtocolDefinition(
        endpoints: [
          EndpointDefinitionBuilder()
              .withClassName('MyEndpoint')
              .withName('myEndpoint')
              .withFilePath(
                path.joinAll([
                  ...config.serverPackageDirectoryPathParts,
                  'lib',
                  'my_endpoint.dart',
                ]),
              )
              .build(),
        ],
        models: [],
      );

      late var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      test('then endpoint file is created.', () {
        expect(codeMap, contains(expectedFileName));
      });

      late var endpointsFile = codeMap[expectedFileName];

      test('then import path is correct.', () {
        var importPath = [
          '..',
          '..',
          'my_endpoint.dart',
        ].join('/');
        expect(endpointsFile, contains("import '$importPath' as "));
      });
    },
  );
}
