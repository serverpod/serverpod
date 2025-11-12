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
final config = GeneratorConfigBuilder()
    .withName(projectName)
    .withRelativeServerTestToolsPathParts(
      [
        'integration_test',
        'test_tools',
      ],
    )
    .build();
const generator = DartServerCodeGenerator();

void main() {
  var expectedFileName = path.join(
    'integration_test',
    'test_tools',
    'serverpod_test_tools.dart',
  );

  group(
    'Given protocol definition without endpoints when generating test tools file',
    () {
      var protocolDefinition = const ProtocolDefinition(
        endpoints: [],
        models: [],
      );

      late var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      test('then test tools file is created.', () {
        expect(codeMap, contains(expectedFileName));
      });

      late var testToolsFile = codeMap[expectedFileName];

      test('then components needed by the end user are exported', () {
        expect(
          testToolsFile,
          contains(
            "export 'package:serverpod_test/serverpod_test_public_exports.dart'",
          ),
        );
      });

      test(
        'then test tools file has `withServerpod` function defined with isTestGroup decorator',
        () {
          expect(
            testToolsFile,
            matches(
              r'@_i\d\.isTestGroup\n'
              r'void withServerpod\(\n'
              r'  String testGroupName,\n'
              r'  _i\d\.TestClosure<TestEndpoints> testClosure, \{\n'
              r'  bool\? applyMigrations,\n'
              r'  bool\? enableSessionLogging,\n'
              r'  _i\d\.ExperimentalFeatures\? experimentalFeatures,\n'
              r'  _i\d\.RollbackDatabase\? rollbackDatabase,\n'
              r'  String\? runMode,\n'
              r'  _i\d\.RuntimeParametersListBuilder\? runtimeParametersBuilder,\n'
              r'  _i\d\.ServerpodLoggingMode\? serverpodLoggingMode,\n'
              r'  Duration\? serverpodStartTimeout,\n'
              r'  List<String>\? testGroupTagsOverride,\n'
              r'  _i\d\.TestServerOutputMode\? testServerOutputMode,\n'
              r'\}\)',
            ),
          );
        },
      );

      test('then doc comment with general description is present', () async {
        expect(
          testToolsFile,
          contains(
            '/// Creates a new test group that takes a callback that can be used to write tests.',
          ),
        );
      });

      test('then configuration options header is present', () async {
        expect(
          testToolsFile,
          contains(
            '**Configuration options**',
          ),
        );
      });

      test(
        'then doc comments with correct spacing exist for each configurable parameter',
        () async {
          expect(
            testToolsFile,
            contains('\n///\n/// [applyMigrations] '),
          );
          expect(
            testToolsFile,
            contains('\n///\n/// [enableSessionLogging] '),
          );
          expect(
            testToolsFile,
            contains('\n///\n/// [rollbackDatabase] '),
          );
          expect(
            testToolsFile,
            contains('\n///\n/// [runMode] '),
          );
          expect(
            testToolsFile,
            contains('\n///\n/// [serverpodLoggingMode] '),
          );
          expect(
            testToolsFile,
            contains('\n///\n/// [serverpodStartTimeout] '),
          );
          expect(
            testToolsFile,
            contains('\n///\n/// [testGroupTagsOverride] '),
          );
          expect(
            testToolsFile,
            contains('\n///\n/// [testServerOutputMode] '),
          );
          expect(
            testToolsFile,
            contains('\n///\n/// [experimentalFeatures] '),
          );
        },
      );

      test('then test tools file has `TestEndpoints` class defined.', () {
        expect(codeMap[expectedFileName], contains('class TestEndpoints {'));
      });

      test(
        'then test tools file has `_InternalTestEndpoints` class defined that extends `TestEndpoints` and implements `InternalTestEndpoints`.',
        () {
          expect(
            testToolsFile,
            matches(
              r'class _InternalTestEndpoints extends TestEndpoints\n\s*implements _i\d\.InternalTestEndpoints \{\n',
            ),
          );
        },
      );

      test('then import path towards project protocol is correct.', () {
        var importPath = [
          'package:example_project_server',
          'src',
          'generated',
          'protocol.dart',
        ].join('/');
        expect(testToolsFile, contains("import '$importPath';"));
      });

      test('then import path towards project endpoints is correct.', () {
        var importPath = [
          'package:example_project_server',
          'src',
          'generated',
          'endpoints.dart',
        ].join('/');
        expect(testToolsFile, contains("import '$importPath';"));
      });
    },
  );

  group(
    'Given protocol definition without endpoints when generating test tools file for Serverpod mini',
    () {
      var serverpodMiniConfig = GeneratorConfigBuilder()
          .withName(projectName)
          .withRelativeServerTestToolsPathParts(
            [
              'integration_test',
              'test_tools',
            ],
          )
          .withEnabledFeatures([])
          .build();
      var protocolDefinition = const ProtocolDefinition(
        endpoints: [],
        models: [],
      );

      late var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: serverpodMiniConfig,
      );

      test('then test tools file is created.', () {
        expect(codeMap, contains(expectedFileName));
      });

      late var testToolsFile = codeMap[expectedFileName];

      test(
        'then test tools file has `withServerpod` function without `rollbackDatabase` and `applyMigrations` parameters',
        () {
          expect(
            testToolsFile,
            matches(
              r'@_i\d\.isTestGroup\n'
              r'void withServerpod\(\n'
              r'  String testGroupName,\n'
              r'  _i\d\.TestClosure<TestEndpoints> testClosure, \{\n'
              r'  bool\? enableSessionLogging,\n'
              r'  _i2.ExperimentalFeatures\? experimentalFeatures,\n'
              r'  String\? runMode,\n'
              r'  _i\d\.ServerpodLoggingMode\? serverpodLoggingMode,\n'
              r'  Duration\? serverpodStartTimeout,\n'
              r'  List<String>\? testGroupTagsOverride,\n'
              r'  _i\d\.TestServerOutputMode\? testServerOutputMode,\n'
              r'\}\)',
            ),
          );
        },
      );

      test('then doc comment with general description is present', () async {
        expect(
          testToolsFile,
          contains(
            '/// Creates a new test group that takes a callback that can be used to write tests.',
          ),
        );
      });

      test('then configuration options header is present', () async {
        expect(
          testToolsFile,
          contains(
            '**Configuration options**',
          ),
        );
      });

      test(
        'then doc comments with correct spacing exist for each configurable parameter',
        () async {
          expect(
            testToolsFile,
            contains('\n/// [enableSessionLogging] '),
          );
          expect(
            testToolsFile,
            contains('\n///\n/// [runMode] '),
          );
          expect(
            testToolsFile,
            contains('\n///\n/// [serverpodLoggingMode] '),
          );
          expect(
            testToolsFile,
            contains('\n///\n/// [serverpodStartTimeout] '),
          );
          expect(
            testToolsFile,
            contains('\n///\n/// [testGroupTagsOverride] '),
          );
          expect(
            testToolsFile,
            contains('\n///\n/// [testServerOutputMode] '),
          );
          expect(
            testToolsFile,
            contains('\n///\n/// [experimentalFeatures] '),
          );
        },
      );

      test(
        'then doc comments for `applyMigrations` and `rollbackDatabase` are not present',
        () async {
          expect(
            testToolsFile,
            isNot(contains('/// [applyMigrations]')),
          );
          expect(
            testToolsFile,
            isNot(contains('/// [rollbackDatabase]')),
          );
        },
      );
    },
  );

  group(
    'Given protocol definition with endpoint when generating test tools file file',
    () {
      var endpointName = 'testing';
      var protocolDefinition = ProtocolDefinition(
        endpoints: [
          EndpointDefinitionBuilder()
              .withClassName('${endpointName.pascalCase}Endpoint')
              .withName(endpointName)
              .build(),
        ],
        models: [],
      );

      late var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      test('then test tools file is created.', () {
        expect(codeMap, contains(expectedFileName));
      });

      late var testToolsFile = codeMap[expectedFileName];

      test(
        'then test tools file has `withServerpod` function defined with isTestGroup decorator',
        () {
          expect(
            testToolsFile,
            matches(
              r'@_i\d\.isTestGroup\n'
              r'void withServerpod\(\n'
              r'  String testGroupName,\n'
              r'  _i\d\.TestClosure<TestEndpoints> testClosure, \{\n'
              r'  bool\? applyMigrations,\n'
              r'  bool\? enableSessionLogging,\n'
              r'  _i\d\.ExperimentalFeatures\? experimentalFeatures,\n'
              r'  _i\d\.RollbackDatabase\? rollbackDatabase,\n'
              r'  String\? runMode,\n'
              r'  _i\d\.RuntimeParametersListBuilder\? runtimeParametersBuilder,\n'
              r'  _i\d\.ServerpodLoggingMode\? serverpodLoggingMode,\n'
              r'  Duration\? serverpodStartTimeout,\n'
              r'  List<String>\? testGroupTagsOverride,\n'
              r'  _i\d\.TestServerOutputMode\? testServerOutputMode,\n'
              r'\}\)',
            ),
          );
        },
      );

      test('then doc comment with general description is present', () async {
        expect(
          testToolsFile,
          contains(
            '/// Creates a new test group that takes a callback that can be used to write tests.',
          ),
        );
      });

      test('then configuration options header is present', () async {
        expect(
          testToolsFile,
          contains(
            '**Configuration options**',
          ),
        );
      });

      test(
        'then doc comments with correct spacing exist for each configurable parameter',
        () async {
          expect(
            testToolsFile,
            contains('\n///\n/// [applyMigrations] '),
          );
          expect(
            testToolsFile,
            contains('\n///\n/// [enableSessionLogging] '),
          );
          expect(
            testToolsFile,
            contains('\n///\n/// [rollbackDatabase] '),
          );
          expect(
            testToolsFile,
            contains('\n///\n/// [runMode] '),
          );
          expect(
            testToolsFile,
            contains('\n///\n/// [serverpodLoggingMode] '),
          );
          expect(
            testToolsFile,
            contains('\n///\n/// [serverpodStartTimeout] '),
          );
          expect(
            testToolsFile,
            contains('\n///\n/// [testGroupTagsOverride] '),
          );
          expect(
            testToolsFile,
            contains('\n///\n/// [testServerOutputMode] '),
          );
          expect(
            testToolsFile,
            contains('\n///\n/// [experimentalFeatures] '),
          );
        },
      );

      test('then test tools file has `TestEndpoints` class defined.', () {
        expect(testToolsFile, contains('class TestEndpoints {'));
      });

      test(
        'then test tools file has `_InternalTestEndpoints` class defined that extends `TestEndpoints` and implements `InternalTestEndpoints`.',
        () {
          expect(
            testToolsFile,
            matches(
              r'class _InternalTestEndpoints extends TestEndpoints\n\s*implements _i\d\.InternalTestEndpoints \{\n',
            ),
          );
        },
      );

      test('then test tools file has private endpoint class defined.', () {
        expect(
          testToolsFile,
          contains('class _${endpointName.pascalCase}Endpoint'),
        );
      });
    },
  );

  group(
    'Given protocol definition with multiple endpoints when generating test tools file',
    () {
      var firstEndpointName = 'testing1';
      var secondEndpointName = 'testing2';
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

      late var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      test('then test tools file is created.', () {
        expect(codeMap, contains(expectedFileName));
      });

      late var testToolsFile = codeMap[expectedFileName];

      test(
        'then test tools file has `withServerpod` function defined with isTestGroup decorator',
        () {
          expect(
            testToolsFile,
            matches(
              r'@_i\d\.isTestGroup\n'
              r'void withServerpod\(\n'
              r'  String testGroupName,\n'
              r'  _i\d\.TestClosure<TestEndpoints> testClosure, \{\n'
              r'  bool\? applyMigrations,\n'
              r'  bool\? enableSessionLogging,\n'
              r'  _i\d\.ExperimentalFeatures\? experimentalFeatures,\n'
              r'  _i\d\.RollbackDatabase\? rollbackDatabase,\n'
              r'  String\? runMode,\n'
              r'  _i\d\.RuntimeParametersListBuilder\? runtimeParametersBuilder,\n'
              r'  _i\d\.ServerpodLoggingMode\? serverpodLoggingMode,\n'
              r'  Duration\? serverpodStartTimeout,\n'
              r'  List<String>\? testGroupTagsOverride,\n'
              r'  _i\d\.TestServerOutputMode\? testServerOutputMode,\n'
              r'\}\)',
            ),
          );
        },
      );

      test('then doc comment with general description is present', () async {
        expect(
          testToolsFile,
          contains(
            '/// Creates a new test group that takes a callback that can be used to write tests.',
          ),
        );
      });

      test('then configuration options header is present', () async {
        expect(
          testToolsFile,
          contains(
            '**Configuration options**',
          ),
        );
      });

      test(
        'then doc comments with correct spacing exist for each configurable parameter',
        () async {
          expect(
            testToolsFile,
            contains('\n///\n/// [applyMigrations] '),
          );
          expect(
            testToolsFile,
            contains('\n///\n/// [enableSessionLogging] '),
          );
          expect(
            testToolsFile,
            contains('\n///\n/// [rollbackDatabase] '),
          );
          expect(
            testToolsFile,
            contains('\n///\n/// [runMode] '),
          );
          expect(
            testToolsFile,
            contains('\n///\n/// [serverpodLoggingMode] '),
          );
          expect(
            testToolsFile,
            contains('\n///\n/// [serverpodStartTimeout] '),
          );
          expect(
            testToolsFile,
            contains('\n///\n/// [testGroupTagsOverride] '),
          );
          expect(
            testToolsFile,
            contains('\n///\n/// [testServerOutputMode] '),
          );
          expect(
            testToolsFile,
            contains('\n///\n/// [testServerOutputMode] '),
          );
          expect(
            testToolsFile,
            contains('\n///\n/// [experimentalFeatures] '),
          );
        },
      );

      test('then test tools file has `TestEndpoints` class defined.', () {
        expect(testToolsFile, contains('class TestEndpoints {'));
      });

      test(
        'then test tools file has `_InternalTestEndpoints` class defined that extends `TestEndpoints` and implements `InternalTestEndpoints`.',
        () {
          expect(
            testToolsFile,
            matches(
              r'class _InternalTestEndpoints extends TestEndpoints\n\s*implements _i\d\.InternalTestEndpoints \{\n',
            ),
          );
        },
      );

      test('then test tools file has private endpoint class defined.', () {
        expect(
          testToolsFile,
          contains('class _${firstEndpointName.pascalCase}Endpoint'),
        );
      });

      test('then test tools file has private endpoint class defined.', () {
        expect(
          testToolsFile,
          contains('class _${secondEndpointName.pascalCase}Endpoint'),
        );
      });
    },
  );

  group(
    'Given a protocol definition with a method with Future return value when generating test tools file',
    () {
      var endpointName = 'testing';
      var protocolDefinition = ProtocolDefinition(
        endpoints: [
          EndpointDefinitionBuilder()
              .withClassName('${endpointName.pascalCase}Endpoint')
              .withName(endpointName)
              .withMethods([
                MethodDefinitionBuilder()
                    .withName('futureMethod')
                    .buildMethodStreamDefinition(),
              ])
              .build(),
        ],
        models: [],
      );

      late var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      test('then test tools file is created.', () {
        expect(codeMap, contains(expectedFileName));
      });
      late var testToolsFile = codeMap[expectedFileName];

      test('then test tools file contains the method definition.', () {
        expect(
          testToolsFile,
          matches(
            r'Future<String> futureMethod\(_i\d\.TestSessionBuilder sessionBuilder\) async \{',
          ),
        );
      });

      test(
        'then the method body contains a call to the correct exception handler function.',
        () {
          expect(
            testToolsFile,
            contains('callAwaitableFunctionAndHandleExceptions('),
          );
        },
      );

      test(
        'then the method body contains a call to the correct endpoint method.',
        () {
          expect(testToolsFile, contains('getMethodCallContext('));
        },
      );
    },
  );

  group(
    'Given a protocol definition with a method with Stream return value when generating test tools file',
    () {
      var endpointName = 'testing';
      var protocolDefinition = ProtocolDefinition(
        endpoints: [
          EndpointDefinitionBuilder()
              .withClassName('${endpointName.pascalCase}Endpoint')
              .withName(endpointName)
              .withMethods([
                MethodDefinitionBuilder()
                    .withName('streamMethod')
                    .withReturnType(
                      TypeDefinitionBuilder().withStreamOf('String').build(),
                    )
                    .buildMethodStreamDefinition(),
              ])
              .build(),
        ],
        models: [],
      );

      late var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      test('then test tools file is created.', () {
        expect(codeMap, contains(expectedFileName));
      });
      late var testToolsFile = codeMap[expectedFileName];

      test('then test tools file contains the method definition.', () {
        expect(
          testToolsFile,
          matches(
            r'Stream<String> streamMethod\(_i\d\.TestSessionBuilder sessionBuilder\) \{',
          ),
        );
      });

      test(
        'then the method body contains a call to the correct exception handler function.',
        () {
          expect(
            testToolsFile,
            contains('callStreamFunctionAndHandleExceptions('),
          );
        },
      );

      test(
        'then the method body contains a call to the correct endpoint method.',
        () {
          expect(testToolsFile, contains('getMethodStreamCallContext('));
        },
      );
    },
  );

  group(
    'Given a protocol definition with a method with a named non-stream parameter when generating test tools file',
    () {
      var endpointName = 'testing';
      var methodName = 'nonStreamMethod';
      var protocolDefinition = ProtocolDefinition(
        endpoints: [
          EndpointDefinitionBuilder()
              .withClassName('${endpointName.pascalCase}Endpoint')
              .withName(endpointName)
              .withMethods([
                MethodDefinitionBuilder()
                    .withName(methodName)
                    .withParametersNamed([
                      ParameterDefinition(
                        name: 'stringParam',
                        type: TypeDefinitionBuilder()
                            .withClassName('String')
                            .build(),
                        required: true,
                      ),
                    ])
                    .buildMethodStreamDefinition(),
              ])
              .build(),
        ],
        models: [],
      );

      late var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      test('then test tools file is created.', () {
        expect(codeMap, contains(expectedFileName));
      });

      late var testToolsFile = codeMap[expectedFileName];

      test('then test tools file contains the method definition.', () {
        expect(
          testToolsFile,
          contains(
            '  Future<String> nonStreamMethod(\n'
            '    _i1.TestSessionBuilder sessionBuilder, {\n'
            '    required String stringParam,\n'
            '  }) async {\n',
          ),
        );
      });

      test(
        'then the method body contains a call to the correct exception handler function.',
        () {
          expect(
            testToolsFile,
            contains('callAwaitableFunctionAndHandleExceptions('),
          );
        },
      );

      test(
        'then the method body contains a call to the correct endpoint method.',
        () {
          expect(testToolsFile, contains('getMethodCallContext('));
        },
      );
    },
  );
  group(
    'Given a protocol definition with a method with optional non-stream parameter when generating test tools file',
    () {
      var endpointName = 'testing';
      var methodName = 'nonStreamMethod';
      var protocolDefinition = ProtocolDefinition(
        endpoints: [
          EndpointDefinitionBuilder()
              .withClassName('${endpointName.pascalCase}Endpoint')
              .withName(endpointName)
              .withMethods([
                MethodDefinitionBuilder()
                    .withName(methodName)
                    .withParametersPositional([
                      ParameterDefinition(
                        name: 'stringParam',
                        type: TypeDefinitionBuilder()
                            .withClassName('String?')
                            .build(),
                        required: false,
                      ),
                    ])
                    .buildMethodStreamDefinition(),
              ])
              .build(),
        ],
        models: [],
      );

      late var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      test('then test tools file is created.', () {
        expect(codeMap, contains(expectedFileName));
      });

      late var testToolsFile = codeMap[expectedFileName];

      test('then test tools file contains the method definition.', () {
        expect(
          testToolsFile,
          contains(
            '  Future<String> nonStreamMethod(\n'
            '    _i1.TestSessionBuilder sessionBuilder, [\n'
            '    String? stringParam,\n'
            '  ]) async {',
          ),
        );
      });

      test(
        'then the method body contains a call to the correct exception handler function.',
        () {
          expect(
            testToolsFile,
            contains('callAwaitableFunctionAndHandleExceptions('),
          );
        },
      );

      test(
        'then the method body contains a call to the correct endpoint method.',
        () {
          expect(testToolsFile, contains('getMethodCallContext('));
        },
      );
    },
  );

  group(
    'Given a protocol definition with a method with a nullable named non-stream parameter when generating test tools file',
    () {
      var endpointName = 'testing';
      var methodName = 'nonStreamMethod';
      var protocolDefinition = ProtocolDefinition(
        endpoints: [
          EndpointDefinitionBuilder()
              .withClassName('${endpointName.pascalCase}Endpoint')
              .withName(endpointName)
              .withMethods([
                MethodDefinitionBuilder()
                    .withName(methodName)
                    .withParametersNamed([
                      ParameterDefinition(
                        name: 'stringParam',
                        type: TypeDefinitionBuilder()
                            .withClassName('String?')
                            .build(),
                        required: false,
                      ),
                    ])
                    .buildMethodStreamDefinition(),
              ])
              .build(),
        ],
        models: [],
      );

      late var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      test('then test tools file is created.', () {
        expect(codeMap, contains(expectedFileName));
      });

      late var testToolsFile = codeMap[expectedFileName];

      test('then test tools file contains the method definition.', () {
        expect(
          testToolsFile,
          contains(
            '  Future<String> nonStreamMethod(\n'
            '    _i1.TestSessionBuilder sessionBuilder, {\n'
            '    String? stringParam,\n'
            '  }) async {\n',
          ),
        );
      });

      test(
        'then the method body contains a call to the correct exception handler function.',
        () {
          expect(
            testToolsFile,
            contains('callAwaitableFunctionAndHandleExceptions('),
          );
        },
      );

      test(
        'then the method body contains a call to the correct endpoint method.',
        () {
          expect(testToolsFile, contains('getMethodCallContext('));
        },
      );
    },
  );

  group(
    'Given a protocol definition with a method with a Stream parameter when generating test tools file',
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
                        .build(),
                    required: false,
                  ),
                ]).buildMethodStreamDefinition(),
              ])
              .build(),
        ],
        models: [],
      );

      late var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      test('then test tools file is created.', () {
        expect(codeMap, contains(expectedFileName));
      });

      late var testToolsFile = codeMap[expectedFileName];

      test('then test tools file contains the method definition.', () {
        expect(
          testToolsFile,
          contains(
            '  Future<String> streamMethod(\n'
            '    _i1.TestSessionBuilder sessionBuilder,\n'
            '    Stream<String> streamParam,\n'
            '  ) async {',
          ),
        );
      });

      test(
        'then the method body contains a call to the correct exception handler function.',
        () {
          expect(
            testToolsFile,
            contains(
              'callAwaitableFunctionWithStreamInputAndHandleExceptions(',
            ),
          );
        },
      );

      test(
        'then the method body contains a call to the correct endpoint method.',
        () {
          expect(testToolsFile, contains('getMethodStreamCallContext('));
        },
      );
    },
  );

  group(
    'Given a protocol definition with a method with a named Stream parameter when generating test tools file',
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
                    .withParametersNamed([
                      ParameterDefinition(
                        name: 'streamParam',
                        type: TypeDefinitionBuilder()
                            .withStreamOf('String')
                            .build(),
                        required: true,
                      ),
                    ])
                    .buildMethodStreamDefinition(),
              ])
              .build(),
        ],
        models: [],
      );

      late var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      test('then test tools file is created.', () {
        expect(codeMap, contains(expectedFileName));
      });

      late var testToolsFile = codeMap[expectedFileName];

      test('then test tools file contains the method definition.', () {
        expect(
          testToolsFile,
          contains(
            '  Future<String> streamMethod(\n'
            '    _i1.TestSessionBuilder sessionBuilder, {\n'
            '    required Stream<String> streamParam,\n'
            '  }) async {',
          ),
        );
      });

      test(
        'then the method body contains a call to the correct exception handler function.',
        () {
          expect(
            testToolsFile,
            contains(
              'callAwaitableFunctionWithStreamInputAndHandleExceptions(',
            ),
          );
        },
      );

      test(
        'then the method body contains a call to the correct endpoint method.',
        () {
          expect(testToolsFile, contains('getMethodStreamCallContext('));
        },
      );
    },
  );
  group(
    'Given a protocol definition with a method with Stream return value and Stream parameter when generating test tools file',
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
                    .withParameters([
                      ParameterDefinition(
                        name: 'streamParam',
                        type: TypeDefinitionBuilder()
                            .withStreamOf('String')
                            .build(),
                        required: false,
                      ),
                    ])
                    .withReturnType(
                      TypeDefinitionBuilder().withStreamOf('String').build(),
                    )
                    .buildMethodStreamDefinition(),
              ])
              .build(),
        ],
        models: [],
      );

      late var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      test('then test tools file is created.', () {
        expect(codeMap, contains(expectedFileName));
      });

      late var testToolsFile = codeMap[expectedFileName];

      test('then test tools file contains the method definition.', () {
        expect(
          testToolsFile,
          contains(
            '  Stream<String> streamMethod(\n'
            '    _i1.TestSessionBuilder sessionBuilder,\n'
            '    Stream<String> streamParam,\n'
            '  ) {',
          ),
        );
      });

      test(
        'then the method body contains a call to the correct exception handler function.',
        () {
          expect(
            testToolsFile,
            contains('callStreamFunctionAndHandleExceptions('),
          );
        },
      );

      test(
        'then the method body contains a call to the correct endpoint method.',
        () {
          expect(testToolsFile, contains('getMethodStreamCallContext('));
        },
      );
    },
  );

  group(
    'Given a protocol definition with an abstract endpoint when generating test tools file',
    () {
      var abstractEndpointName = 'abstractTest';
      var protocolDefinition = ProtocolDefinition(
        endpoints: [
          EndpointDefinitionBuilder()
              .withClassName('${abstractEndpointName.pascalCase}Endpoint')
              .withName(abstractEndpointName)
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

      late var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      test('then test tools file is created.', () {
        expect(codeMap, contains(expectedFileName));
      });

      late var testToolsFile = codeMap[expectedFileName];

      test(
        'then test tools file does not contain abstract endpoint class.',
        () {
          expect(
            testToolsFile,
            isNot(
              contains('class _${abstractEndpointName.pascalCase}Endpoint'),
            ),
          );
        },
      );
    },
  );

  group(
    'Given protocol definition with a concrete endpoint that extends an abstract base endpoint when generating test tools file',
    () {
      var abstractEndpointName = 'abstractTest';
      var concreteEndpointName = 'concreteTest';

      var abstractEndpoint = EndpointDefinitionBuilder()
          .withClassName('${abstractEndpointName.pascalCase}Endpoint')
          .withName(abstractEndpointName)
          .withIsAbstract()
          .withMethods([
            MethodDefinitionBuilder()
                .withName('testMethod')
                .buildMethodCallDefinition(),
          ])
          .build();

      var protocolDefinition = ProtocolDefinition(
        endpoints: [
          EndpointDefinitionBuilder()
              .withClassName('${concreteEndpointName.pascalCase}Endpoint')
              .withName(concreteEndpointName)
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

      late var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      test('then test tools file is created.', () {
        expect(codeMap, contains(expectedFileName));
      });

      late var testToolsFile = codeMap[expectedFileName];

      test(
        'then test tools file does not contain abstract endpoint class.',
        () {
          expect(
            testToolsFile,
            isNot(
              contains('class _${abstractEndpointName.pascalCase}Endpoint'),
            ),
          );
        },
      );

      test('then test tools file contains concrete endpoint class.', () {
        expect(
          testToolsFile,
          contains('class _${concreteEndpointName.pascalCase}Endpoint'),
        );
      });

      test(
        'then TestEndpoints class does not have field for abstract endpoint.',
        () {
          expect(
            testToolsFile,
            isNot(
              contains(
                'late final _${abstractEndpointName.pascalCase}Endpoint $abstractEndpointName;',
              ),
            ),
          );
        },
      );

      test('then TestEndpoints class has field for concrete endpoint.', () {
        expect(
          testToolsFile,
          contains(
            'late final _${concreteEndpointName.pascalCase}Endpoint $concreteEndpointName;',
          ),
        );
      });

      test(
        'then TestEndpoints constructor does not initialize abstract endpoint.',
        () {
          expect(
            testToolsFile,
            isNot(
              contains(
                '$abstractEndpointName = _${abstractEndpointName.pascalCase}Endpoint(',
              ),
            ),
          );
        },
      );

      test('then TestEndpoints constructor initializes concrete endpoint.', () {
        expect(
          testToolsFile,
          contains(
            '$concreteEndpointName = _${concreteEndpointName.pascalCase}Endpoint(',
          ),
        );
      });
    },
  );

  group(
    'Given protocol definition with a concrete endpoint that extends another concrete endpoint when generating test tools file',
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

      test('then test tools file is created.', () {
        expect(codeMap, contains(expectedFileName));
      });

      late var testToolsFile = codeMap[expectedFileName];

      test('then test tools file contains both endpoint classes.', () {
        expect(
          testToolsFile,
          contains('class _${baseEndpointName.pascalCase}Endpoint'),
        );
        expect(
          testToolsFile,
          contains('class _${concreteEndpointName.pascalCase}Endpoint'),
        );
      });

      test('then TestEndpoints class has field for both endpoints.', () {
        expect(
          testToolsFile,
          contains(
            'late final _${baseEndpointName.pascalCase}Endpoint $baseEndpointName;',
          ),
        );
        expect(
          testToolsFile,
          contains(
            'late final _${concreteEndpointName.pascalCase}Endpoint $concreteEndpointName;',
          ),
        );
      });

      test('then TestEndpoints constructor initializes both endpoints.', () {
        expect(
          testToolsFile,
          contains(
            '$baseEndpointName = _${baseEndpointName.pascalCase}Endpoint(',
          ),
        );
        expect(
          testToolsFile,
          contains(
            '$concreteEndpointName = _${concreteEndpointName.pascalCase}Endpoint(',
          ),
        );
      });
    },
  );

  group(
    'Given protocol definition with abstract > concrete > abstract subclass > concrete subclass endpoint hierarchy when generating test tools file',
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

      test('then test tools file is created.', () {
        expect(codeMap, contains(expectedFileName));
      });

      late var testToolsFile = codeMap[expectedFileName];

      test(
        'then test tools file does not contain abstract endpoint classes.',
        () {
          expect(
            testToolsFile,
            isNot(
              contains('class _${abstractBaseEndpointName.pascalCase}Endpoint'),
            ),
          );
          expect(
            testToolsFile,
            isNot(
              contains(
                'class _${abstractSubClassEndpointName.pascalCase}Endpoint',
              ),
            ),
          );
        },
      );

      test('then test tools file contains all concrete endpoint classes.', () {
        expect(
          testToolsFile,
          contains('class _${concreteBaseEndpointName.pascalCase}Endpoint'),
        );
        expect(
          testToolsFile,
          contains('class _${concreteSubclassEndpointName.pascalCase}Endpoint'),
        );
      });

      test(
        'then TestEndpoints class does not have fields for abstract endpoints.',
        () {
          expect(
            testToolsFile,
            isNot(
              contains(
                'late final _${abstractBaseEndpointName.pascalCase}Endpoint $abstractBaseEndpointName;',
              ),
            ),
          );
          expect(
            testToolsFile,
            isNot(
              contains(
                'late final _${abstractSubClassEndpointName.pascalCase}Endpoint $abstractSubClassEndpointName;',
              ),
            ),
          );
        },
      );

      test('then TestEndpoints class has fields for all concrete endpoints.', () {
        expect(
          testToolsFile,
          contains(
            'late final _${concreteBaseEndpointName.pascalCase}Endpoint $concreteBaseEndpointName;',
          ),
        );
        expect(
          testToolsFile,
          contains(
            'late final _${concreteSubclassEndpointName.pascalCase}Endpoint $concreteSubclassEndpointName;',
          ),
        );
      });

      test(
        'then TestEndpoints constructor does not initialize abstract endpoints.',
        () {
          expect(
            testToolsFile,
            isNot(
              contains(
                '$abstractBaseEndpointName = _${abstractBaseEndpointName.pascalCase}Endpoint(',
              ),
            ),
          );
          expect(
            testToolsFile,
            isNot(
              contains(
                '$abstractSubClassEndpointName = _${abstractSubClassEndpointName.pascalCase}Endpoint(',
              ),
            ),
          );
        },
      );

      test(
        'then TestEndpoints constructor initializes all concrete endpoints.',
        () {
          expect(
            testToolsFile,
            contains(
              '$concreteBaseEndpointName = _${concreteBaseEndpointName.pascalCase}Endpoint(',
            ),
          );
          expect(
            testToolsFile,
            contains(
              '$concreteSubclassEndpointName = _${concreteSubclassEndpointName.pascalCase}Endpoint(',
            ),
          );
        },
      );
    },
  );

  group(
    'Given protocol definition with method annotated with @deprecated when generating test tools file',
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
                  const AnnotationDefinition(
                    name: 'deprecated',
                  ),
                ]).buildMethodCallDefinition(),
              ])
              .build(),
        ],
        models: [],
      );

      late var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      test('then test tools file is created.', () {
        expect(codeMap, contains(expectedFileName));
      });

      late var testToolsFile = codeMap[expectedFileName];

      test('then test method has @deprecated annotation.', () {
        expect(
          testToolsFile,
          contains('@deprecated'),
        );
      });
    },
  );

  group(
    'Given protocol definition with method annotated with @Deprecated when generating test tools file',
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
                  const AnnotationDefinition(
                    name: 'Deprecated',
                    arguments: ["'This method is deprecated'"],
                  ),
                ]).buildMethodCallDefinition(),
              ])
              .build(),
        ],
        models: [],
      );

      late var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      test('then test tools file is created.', () {
        expect(codeMap, contains(expectedFileName));
      });

      late var testToolsFile = codeMap[expectedFileName];

      test('then test method has @Deprecated annotation with message.', () {
        expect(
          testToolsFile,
          contains("@Deprecated('This method is deprecated')"),
        );
      });
    },
  );
}
