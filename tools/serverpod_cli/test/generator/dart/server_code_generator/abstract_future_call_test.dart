import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';
import 'package:serverpod_cli/src/analyzer/protocol_definition.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/future_call_definition_builder.dart';
import '../../../test_util/builders/future_call_method_definition_builder.dart';
import '../../../test_util/builders/generator_config_builder.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  var expectedFutureCallsFileName = path.join(
    'lib',
    'src',
    'generated',
    'future_calls.dart',
  );

  var expectedEndpointsFileName = path.join(
    'lib',
    'src',
    'generated',
    'endpoints.dart',
  );

  group(
    'Given protocol definition with an abstract future call when generating server files',
    () {
      late Map<String, String> codeMap;
      late String? endpointsFile;

      setUpAll(() {
        var abstractFutureCallName = 'abstract';
        var methodName = 'testMethod';

        var abstractFutureCall = FutureCallDefinitionBuilder()
            .withClassName('${abstractFutureCallName.pascalCase}FutureCall')
            .withName(abstractFutureCallName)
            .withIsAbstract()
            .withMethods([
              FutureCallMethodDefinitionBuilder()
                  .withName(methodName)
                  .buildMethodCallDefinition(),
            ])
            .build();

        var protocolDefinition = ProtocolDefinition(
          endpoints: [],
          models: [],
          futureCalls: [abstractFutureCall],
        );

        codeMap = generator.generateProtocolCode(
          protocolDefinition: protocolDefinition,
          config: config,
        );

        endpointsFile = codeMap[expectedEndpointsFileName];
      });

      test('then future calls file is not created.', () {
        expect(codeMap[expectedFutureCallsFileName], isNull);
      });

      group('then endpoints file', () {
        test('has no export for the Serverpod future calls getter', () {
          expect(
            endpointsFile,
            isNot(
              matches(
                r"export \'future_calls.dart\' show ServerpodFutureCallsGetter;",
              ),
            ),
          );
        });

        test('has no override for FutureCallDispatch', () {
          expect(
            endpointsFile,
            isNot(
              matches(
                r'  @override\n'
                r'  _i\d.FutureCallDispatch\? get futureCalls \{\n'
                r'    return _i\d.FutureCalls\(\);\n'
                r'  \}\n',
              ),
            ),
          );
        });
      });
    },
  );

  group(
    'Given protocol definition with both concrete and abstract future call when generating server files',
    () {
      late Map<String, String> codeMap;
      late String? endpointsFile;
      late String? futureCallsFile;

      setUpAll(() {
        var abstractFutureCallName = 'abstract';
        var concreteFutureCallName = 'concrete';
        var methodName = 'testMethod';

        var abstractFutureCall = FutureCallDefinitionBuilder()
            .withClassName('${abstractFutureCallName.pascalCase}FutureCall')
            .withName(abstractFutureCallName)
            .withIsAbstract()
            .withMethods([
              FutureCallMethodDefinitionBuilder()
                  .withName(methodName)
                  .buildMethodCallDefinition(),
            ])
            .build();

        var concreteFutureCall = FutureCallDefinitionBuilder()
            .withClassName('${concreteFutureCallName.pascalCase}FutureCall')
            .withName(concreteFutureCallName)
            .withMethods([
              FutureCallMethodDefinitionBuilder()
                  .withName(methodName)
                  .buildMethodCallDefinition(),
            ])
            .build();

        var protocolDefinition = ProtocolDefinition(
          endpoints: [],
          models: [],
          futureCalls: [abstractFutureCall, concreteFutureCall],
        );

        codeMap = generator.generateProtocolCode(
          protocolDefinition: protocolDefinition,
          config: config,
        );

        endpointsFile = codeMap[expectedEndpointsFileName];
        futureCallsFile = codeMap[expectedFutureCallsFileName];
      });

      test('then future calls file is created.', () {
        expect(codeMap, contains(expectedFutureCallsFileName));
      });

      test(
        'then generated future calls file does not contain abstract future call implementation.',
        () {
          expect(
            futureCallsFile,
            matches(
              r'class _FutureCallRef {\n'
              r'  _FutureCallRef\(this._invokeFutureCall\);\n'
              r'\n'
              r'  final _InvokeFutureCall _invokeFutureCall;\n'
              r'\n'
              r'  late final concrete = _ConcreteFutureCallDispatcher\(_invokeFutureCall\);\n'
              r'}\n',
            ),
          );
        },
      );

      group('then endpoints file', () {
        test('has export for the Serverpod future calls getter', () {
          expect(
            endpointsFile,
            matches(
              r"export \'future_calls.dart\' show ServerpodFutureCallsGetter;",
            ),
          );
        });

        test('has override for FutureCallDispatch', () {
          expect(
            endpointsFile,
            matches(
              r'  @override\n'
              r'  _i\d.FutureCallDispatch\? get futureCalls \{\n'
              r'    return _i\d.FutureCalls\(\);\n'
              r'  \}\n',
            ),
          );
        });
      });
    },
  );
}
