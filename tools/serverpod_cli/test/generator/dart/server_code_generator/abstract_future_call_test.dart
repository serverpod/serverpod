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

  group(
    'Given protocol definition with an abstract future call when generating server files',
    () {
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

      late var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      test('then future calls file is created.', () {
        expect(codeMap, contains(expectedFutureCallsFileName));
      });

      group('then generated future calls file', () {
        late var futureCallsFileContent = codeMap[expectedFutureCallsFileName]!;

        test(
          'does not contain abstract future call in registered future calls map.',
          () {
            expect(
              futureCallsFileContent,
              matches(
                r'  @override\n'
                r'  void initialize\(\n'
                r'    _i\d.FutureCallManager futureCallManager,\n'
                r'    String serverId,\n'
                r'  \) \{\n'
                r'    var registeredFutureCalls = <String, _i\d.FutureCall>\{\};\n',
              ),
            );
          },
        );

        test('does not contain abstract future call implementation.', () {
          expect(
            futureCallsFileContent,
            isNot(
              matches(
                r'class AbstractTestMethodFutureCall extends _i\d.FutureCall \{\n',
              ),
            ),
          );
        });
      });
    },
  );
}
