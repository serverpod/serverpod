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
).build();
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

    var codeMap = generator.generateProtocolCode(
      protocolDefinition: protocolDefinition,
      config: config,
    );

    test('then test tools file is created.', () {
      expect(codeMap, contains(expectedFileName));
    });

    var testToolsFile = codeMap[expectedFileName];

    test('then components needed by the end user are exported', () {
      expect(
        testToolsFile,
        contains(
            "export 'package:serverpod_test/serverpod_test_public_exports.dart'"),
      );
    }, skip: testToolsFile == null);

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
              r'\}\)',
            ));
      },
      skip: testToolsFile == null,
    );

    test('then doc comment with general description is present', () async {
      expect(
        testToolsFile,
        contains(
          '/// Creates a new test group that takes a callback that can be used to write tests.',
        ),
      );
    }, skip: testToolsFile == null);

    test('then configuration options header is present', () async {
      expect(
        testToolsFile,
        contains(
          '**Configuration options**',
        ),
      );
    }, skip: testToolsFile == null);

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
          contains('\n///\n/// [experimentalFeatures] '),
        );
      },
      skip: testToolsFile == null,
    );

    test(
      'then test tools file has `TestEndpoints` class defined.',
      () {
        expect(codeMap[expectedFileName], contains('class TestEndpoints {'));
      },
      skip: testToolsFile == null,
    );

    test(
      'then test tools file has `_InternalTestEndpoints` class defined that extends `TestEndpoints` and implements `InternalTestEndpoints`.',
      () {
        expect(
            testToolsFile,
            matches(
                r'class _InternalTestEndpoints extends TestEndpoints\n\s*implements _i\d\.InternalTestEndpoints \{\n'));
      },
      skip: testToolsFile == null,
    );

    test('then import path towards project protocol is correct.', () {
      var importPath = [
        'package:example_project_server',
        'src',
        'generated',
        'protocol.dart',
      ].join('/');
      expect(testToolsFile, contains("import '$importPath';"));
    }, skip: testToolsFile == null);

    test('then import path towards project endpoints is correct.', () {
      var importPath = [
        'package:example_project_server',
        'src',
        'generated',
        'endpoints.dart',
      ].join('/');
      expect(testToolsFile, contains("import '$importPath';"));
    }, skip: testToolsFile == null);
  });

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
    ).withEnabledFeatures([]).build();
    var protocolDefinition = const ProtocolDefinition(
      endpoints: [],
      models: [],
    );

    var codeMap = generator.generateProtocolCode(
      protocolDefinition: protocolDefinition,
      config: serverpodMiniConfig,
    );

    test('then test tools file is created.', () {
      expect(codeMap, contains(expectedFileName));
    });

    var testToolsFile = codeMap[expectedFileName];

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
              r'\}\)',
            ));
      },
      skip: testToolsFile == null,
    );

    test('then doc comment with general description is present', () async {
      expect(
        testToolsFile,
        contains(
          '/// Creates a new test group that takes a callback that can be used to write tests.',
        ),
      );
    }, skip: testToolsFile == null);

    test('then configuration options header is present', () async {
      expect(
        testToolsFile,
        contains(
          '**Configuration options**',
        ),
      );
    }, skip: testToolsFile == null);

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
          contains('\n///\n/// [experimentalFeatures] '),
        );
      },
      skip: testToolsFile == null,
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
      skip: testToolsFile == null,
    );
  });

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

    var codeMap = generator.generateProtocolCode(
      protocolDefinition: protocolDefinition,
      config: config,
    );

    test('then test tools file is created.', () {
      expect(codeMap, contains(expectedFileName));
    });

    var testToolsFile = codeMap[expectedFileName];

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
              r'\}\)',
            ));
      },
      skip: testToolsFile == null,
    );

    test('then doc comment with general description is present', () async {
      expect(
        testToolsFile,
        contains(
          '/// Creates a new test group that takes a callback that can be used to write tests.',
        ),
      );
    }, skip: testToolsFile == null);

    test('then configuration options header is present', () async {
      expect(
        testToolsFile,
        contains(
          '**Configuration options**',
        ),
      );
    }, skip: testToolsFile == null);

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
          contains('\n///\n/// [experimentalFeatures] '),
        );
      },
      skip: testToolsFile == null,
    );

    test(
      'then test tools file has `TestEndpoints` class defined.',
      () {
        expect(testToolsFile, contains('class TestEndpoints {'));
      },
      skip: testToolsFile == null,
    );

    test(
      'then test tools file has `_InternalTestEndpoints` class defined that extends `TestEndpoints` and implements `InternalTestEndpoints`.',
      () {
        expect(
            testToolsFile,
            matches(
                r'class _InternalTestEndpoints extends TestEndpoints\n\s*implements _i\d\.InternalTestEndpoints \{\n'));
      },
      skip: testToolsFile == null,
    );

    test(
      'then test tools file has private endpoint class defined.',
      () {
        expect(testToolsFile,
            contains('class _${endpointName.pascalCase}Endpoint'));
      },
      skip: testToolsFile == null,
    );
  });

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

    var codeMap = generator.generateProtocolCode(
      protocolDefinition: protocolDefinition,
      config: config,
    );

    test('then test tools file is created.', () {
      expect(codeMap, contains(expectedFileName));
    });

    var testToolsFile = codeMap[expectedFileName];

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
              r'\}\)',
            ));
      },
      skip: testToolsFile == null,
    );

    test('then doc comment with general description is present', () async {
      expect(
        testToolsFile,
        contains(
          '/// Creates a new test group that takes a callback that can be used to write tests.',
        ),
      );
    }, skip: testToolsFile == null);

    test('then configuration options header is present', () async {
      expect(
        testToolsFile,
        contains(
          '**Configuration options**',
        ),
      );
    }, skip: testToolsFile == null);

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
          contains('\n///\n/// [experimentalFeatures] '),
        );
      },
      skip: testToolsFile == null,
    );

    test(
      'then test tools file has `TestEndpoints` class defined.',
      () {
        expect(testToolsFile, contains('class TestEndpoints {'));
      },
      skip: testToolsFile == null,
    );

    test(
      'then test tools file has `_InternalTestEndpoints` class defined that extends `TestEndpoints` and implements `InternalTestEndpoints`.',
      () {
        expect(
            testToolsFile,
            matches(
                r'class _InternalTestEndpoints extends TestEndpoints\n\s*implements _i\d\.InternalTestEndpoints \{\n'));
      },
      skip: testToolsFile == null,
    );

    test(
      'then test tools file has private endpoint class defined.',
      () {
        expect(testToolsFile,
            contains('class _${firstEndpointName.pascalCase}Endpoint'));
      },
      skip: testToolsFile == null,
    );

    test(
      'then test tools file has private endpoint class defined.',
      () {
        expect(testToolsFile,
            contains('class _${secondEndpointName.pascalCase}Endpoint'));
      },
      skip: testToolsFile == null,
    );
  });

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
        ]).build(),
      ],
      models: [],
    );

    var codeMap = generator.generateProtocolCode(
      protocolDefinition: protocolDefinition,
      config: config,
    );

    test('then test tools file is created.', () {
      expect(codeMap, contains(expectedFileName));
    });
    var testToolsFile = codeMap[expectedFileName];

    test(
      'then test tools file contains the method definition.',
      () {
        expect(
            testToolsFile,
            matches(
                r'Future<String> futureMethod\(_i\d\.TestSessionBuilder sessionBuilder\) async \{'));
      },
      skip: testToolsFile == null,
    );

    test(
      'then the method body contains a call to the correct exception handler function.',
      () {
        expect(testToolsFile,
            contains('callAwaitableFunctionAndHandleExceptions('));
      },
      skip: testToolsFile == null,
    );

    test(
      'then the method body contains a call to the correct endpoint method.',
      () {
        expect(testToolsFile, contains('getMethodCallContext('));
      },
      skip: testToolsFile == null,
    );
  });

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
                  TypeDefinitionBuilder().withStreamOf('String').build())
              .buildMethodStreamDefinition(),
        ]).build(),
      ],
      models: [],
    );

    var codeMap = generator.generateProtocolCode(
      protocolDefinition: protocolDefinition,
      config: config,
    );

    test('then test tools file is created.', () {
      expect(codeMap, contains(expectedFileName));
    });
    var testToolsFile = codeMap[expectedFileName];

    test(
      'then test tools file contains the method definition.',
      () {
        expect(
            testToolsFile,
            matches(
                r'Stream<String> streamMethod\(_i\d\.TestSessionBuilder sessionBuilder\) \{'));
      },
      skip: testToolsFile == null,
    );

    test(
      'then the method body contains a call to the correct exception handler function.',
      () {
        expect(
            testToolsFile, contains('callStreamFunctionAndHandleExceptions('));
      },
      skip: testToolsFile == null,
    );

    test(
      'then the method body contains a call to the correct endpoint method.',
      () {
        expect(testToolsFile, contains('getMethodStreamCallContext('));
      },
      skip: testToolsFile == null,
    );
  });

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
          MethodDefinitionBuilder().withName(methodName).withParametersNamed([
            ParameterDefinition(
              name: 'stringParam',
              type: TypeDefinitionBuilder().withClassName('String').build(),
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

    test('then test tools file is created.', () {
      expect(codeMap, contains(expectedFileName));
    });

    var testToolsFile = codeMap[expectedFileName];

    test(
      'then test tools file contains the method definition.',
      () {
        expect(
            testToolsFile,
            contains('  Future<String> nonStreamMethod(\n'
                '    _i1.TestSessionBuilder sessionBuilder, {\n'
                '    required String stringParam,\n'
                '  }) async {\n'));
      },
      skip: testToolsFile == null,
    );

    test(
      'then the method body contains a call to the correct exception handler function.',
      () {
        expect(testToolsFile,
            contains('callAwaitableFunctionAndHandleExceptions('));
      },
      skip: testToolsFile == null,
    );

    test(
      'then the method body contains a call to the correct endpoint method.',
      () {
        expect(testToolsFile, contains('getMethodCallContext('));
      },
      skip: testToolsFile == null,
    );
  });
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
              type: TypeDefinitionBuilder().withClassName('String?').build(),
              required: false,
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

    test('then test tools file is created.', () {
      expect(codeMap, contains(expectedFileName));
    });

    var testToolsFile = codeMap[expectedFileName];

    test(
      'then test tools file contains the method definition.',
      () {
        expect(
            testToolsFile,
            contains('  Future<String> nonStreamMethod(\n'
                '    _i1.TestSessionBuilder sessionBuilder, [\n'
                '    String? stringParam,\n'
                '  ]) async {'));
      },
      skip: testToolsFile == null,
    );

    test(
      'then the method body contains a call to the correct exception handler function.',
      () {
        expect(testToolsFile,
            contains('callAwaitableFunctionAndHandleExceptions('));
      },
      skip: testToolsFile == null,
    );

    test(
      'then the method body contains a call to the correct endpoint method.',
      () {
        expect(testToolsFile, contains('getMethodCallContext('));
      },
      skip: testToolsFile == null,
    );
  });

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
          MethodDefinitionBuilder().withName(methodName).withParametersNamed([
            ParameterDefinition(
              name: 'stringParam',
              type: TypeDefinitionBuilder().withClassName('String?').build(),
              required: false,
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

    test('then test tools file is created.', () {
      expect(codeMap, contains(expectedFileName));
    });

    var testToolsFile = codeMap[expectedFileName];

    test(
      'then test tools file contains the method definition.',
      () {
        expect(
            testToolsFile,
            contains('  Future<String> nonStreamMethod(\n'
                '    _i1.TestSessionBuilder sessionBuilder, {\n'
                '    String? stringParam,\n'
                '  }) async {\n'));
      },
      skip: testToolsFile == null,
    );

    test(
      'then the method body contains a call to the correct exception handler function.',
      () {
        expect(testToolsFile,
            contains('callAwaitableFunctionAndHandleExceptions('));
      },
      skip: testToolsFile == null,
    );

    test(
      'then the method body contains a call to the correct endpoint method.',
      () {
        expect(testToolsFile, contains('getMethodCallContext('));
      },
      skip: testToolsFile == null,
    );
  });

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
              type: TypeDefinitionBuilder().withStreamOf('String').build(),
              required: false,
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

    test('then test tools file is created.', () {
      expect(codeMap, contains(expectedFileName));
    });

    var testToolsFile = codeMap[expectedFileName];

    test(
      'then test tools file contains the method definition.',
      () {
        expect(
            testToolsFile,
            contains('  Future<String> streamMethod(\n'
                '    _i1.TestSessionBuilder sessionBuilder,\n'
                '    Stream<String> streamParam,\n'
                '  ) async {'));
      },
      skip: testToolsFile == null,
    );

    test(
      'then the method body contains a call to the correct exception handler function.',
      () {
        expect(
            testToolsFile,
            contains(
                'callAwaitableFunctionWithStreamInputAndHandleExceptions('));
      },
      skip: testToolsFile == null,
    );

    test(
      'then the method body contains a call to the correct endpoint method.',
      () {
        expect(testToolsFile, contains('getMethodStreamCallContext('));
      },
      skip: testToolsFile == null,
    );
  });

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
          MethodDefinitionBuilder().withName(methodName).withParametersNamed([
            ParameterDefinition(
              name: 'streamParam',
              type: TypeDefinitionBuilder().withStreamOf('String').build(),
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

    test('then test tools file is created.', () {
      expect(codeMap, contains(expectedFileName));
    });

    var testToolsFile = codeMap[expectedFileName];

    test(
      'then test tools file contains the method definition.',
      () {
        expect(
            testToolsFile,
            contains('  Future<String> streamMethod(\n'
                '    _i1.TestSessionBuilder sessionBuilder, {\n'
                '    required Stream<String> streamParam,\n'
                '  }) async {'));
      },
      skip: testToolsFile == null,
    );

    test(
      'then the method body contains a call to the correct exception handler function.',
      () {
        expect(
            testToolsFile,
            contains(
                'callAwaitableFunctionWithStreamInputAndHandleExceptions('));
      },
      skip: testToolsFile == null,
    );

    test(
      'then the method body contains a call to the correct endpoint method.',
      () {
        expect(testToolsFile, contains('getMethodStreamCallContext('));
      },
      skip: testToolsFile == null,
    );
  });
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
                  type: TypeDefinitionBuilder().withStreamOf('String').build(),
                  required: false,
                ),
              ])
              .withReturnType(
                  TypeDefinitionBuilder().withStreamOf('String').build())
              .buildMethodStreamDefinition(),
        ]).build(),
      ],
      models: [],
    );

    var codeMap = generator.generateProtocolCode(
      protocolDefinition: protocolDefinition,
      config: config,
    );

    test('then test tools file is created.', () {
      expect(codeMap, contains(expectedFileName));
    });

    var testToolsFile = codeMap[expectedFileName];

    test(
      'then test tools file contains the method definition.',
      () {
        expect(
            testToolsFile,
            contains('  Stream<String> streamMethod(\n'
                '    _i1.TestSessionBuilder sessionBuilder,\n'
                '    Stream<String> streamParam,\n'
                '  ) {'));
      },
      skip: testToolsFile == null,
    );

    test(
      'then the method body contains a call to the correct exception handler function.',
      () {
        expect(
            testToolsFile, contains('callStreamFunctionAndHandleExceptions('));
      },
      skip: testToolsFile == null,
    );

    test(
      'then the method body contains a call to the correct endpoint method.',
      () {
        expect(testToolsFile, contains('getMethodStreamCallContext('));
      },
      skip: testToolsFile == null,
    );
  });
}
