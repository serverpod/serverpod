import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/protocol_definition.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/util/custom_allocators.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/endpoint_definition_builder.dart';
import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/method_definition_builder.dart';
import '../../../test_util/builders/module_config_builder.dart';
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
          futureCalls: [],
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

  test(
    'Given a protocol definition without endpoints, '
    'when generating the endpoints file, '
    'then initializeOwnEndpoints is overridden with an empty body.',
    () {
      final endpointsFile = generator.generateProtocolCode(
        protocolDefinition: const ProtocolDefinition(
          endpoints: [],
          models: [],
          futureCalls: [],
        ),
        config: config,
      )[expectedFileName];

      expect(
        endpointsFile,
        contains(
          '  @override\n'
          '  void initializeOwnEndpoints(_is.Server server) {}\n',
        ),
      );
    },
  );

  group(
    'Given a project with a testing endpoint and the modules module_a and module_b, '
    'when generating the endpoints file,',
    () {
      late String endpointsFile;

      setUpAll(() {
        final modulesConfig = GeneratorConfigBuilder()
            .withName(projectName)
            .withModules([
              ModuleConfigBuilder('module_a').build(),
              ModuleConfigBuilder('module_b').build(),
            ])
            .build();
        final protocolDefinition = ProtocolDefinition(
          endpoints: [
            EndpointDefinitionBuilder()
                .withClassName('TestingEndpoint')
                .withName('testing')
                .build(),
          ],
          models: [],
          futureCalls: [],
        );

        endpointsFile = generator.generateProtocolCode(
          protocolDefinition: protocolDefinition,
          config: modulesConfig,
        )[expectedFileName]!;
      });

      test(
        'then initializeEndpoints initializes the own endpoints of the project and of each module.',
        () {
          final moduleA = importPrefixFor(
            'package:module_a_server/module_a_server.dart',
          );
          final moduleB = importPrefixFor(
            'package:module_b_server/module_b_server.dart',
          );

          expect(
            endpointsFile,
            contains(
              '  void initializeEndpoints(_is.Server server) {\n'
              '    initializeOwnEndpoints(server);\n'
              "    modules['module_a'] = $moduleA.Endpoints()..initializeOwnEndpoints(server);\n"
              "    modules['module_b'] = $moduleB.Endpoints()..initializeOwnEndpoints(server);\n"
              '  }\n',
            ),
          );
        },
      );

      test(
        'then no module endpoints are initialized with their own modules.',
        () {
          expect(
            endpointsFile,
            isNot(contains('..initializeEndpoints(server)')),
          );
        },
      );

      test(
        'then initializeOwnEndpoints connects the testing endpoint.',
        () {
          expect(
            endpointsFile,
            contains(
              '  void initializeOwnEndpoints(_is.Server server) {\n'
              '    var endpoints = <String, _is.Endpoint>{\n'
              "      'testing':",
            ),
          );
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
          futureCalls: [],
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
          futureCalls: [],
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
          futureCalls: [],
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
            contains("'$methodName': _is.MethodStreamConnector("),
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
                        annotations: const [],
                      ),
                    ],
                  ).buildMethodStreamDefinition(),
                ])
                .build(),
          ],
          models: [],
          futureCalls: [],
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
            contains("'$methodName': _is.MethodStreamConnector("),
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
              '            \'streamParam\': _is.StreamParameterDescription<String>(\n ',
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
          futureCalls: [],
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
        'then endpoint file contains "ignore_for_file: deprecated_member_use_from_same_package" directive.',
        () {
          expect(
            endpointsFile,
            contains(
              '// ignore_for_file: deprecated_member_use_from_same_package',
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
        futureCalls: [],
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
