import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/type_definition_builder.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();

void main() {
  var serverProtocolPath = path.join(
    'lib',
    'src',
    'generated',
    'protocol.dart',
  );

  group(
    'Given a protocol definition with a retry policy and a subclass of it listed after it,',
    () {
      late ProtocolDefinition protocolDefinition;

      setUp(() {
        TypeDefinition policy(String className) => TypeDefinitionBuilder()
            .withClassName(className)
            .withUrl('package:$projectName/src/retry/policies.dart')
            .withCustomClass(true)
            .build();

        protocolDefinition = ProtocolDefinition(
          endpoints: [],
          models: [],
          futureCalls: [],
          futureCallRetryPolicies: [
            policy('BaseFutureCallRetryPolicy'),
            policy('SubFutureCallRetryPolicy'),
          ],
        );
      });

      group(
        'when the server protocol is generated,',
        () {
          late String serverProtocol;

          setUp(() {
            serverProtocol = const DartServerCodeGenerator()
                .generateProtocolCode(
                  protocolDefinition: protocolDefinition,
                  config: config,
                )[serverProtocolPath]!;
          });

          test('then the policies are deserialized with their fromJson.', () {
            expect(
              serverProtocol,
              contains('SubFutureCallRetryPolicy.fromJson(data)'),
            );
            expect(
              serverProtocol,
              contains('BaseFutureCallRetryPolicy.fromJson(data)'),
            );
          });

          test('then the policies can be deserialized by class name.', () {
            expect(
              serverProtocol,
              contains("dataClassName == 'SubFutureCallRetryPolicy'"),
            );
            expect(
              serverProtocol,
              contains("dataClassName == 'BaseFutureCallRetryPolicy'"),
            );
          });

          test(
            'then each policy is named by its exact type.',
            () {
              for (var className in [
                'BaseFutureCallRetryPolicy',
                'SubFutureCallRetryPolicy',
              ]) {
                expect(
                  serverProtocol,
                  matches(
                    RegExp(
                      'data\\.runtimeType == [\\w.]*$className\\)\\s*\\{\\s*'
                      "return '$className';",
                    ),
                  ),
                );
                expect(serverProtocol, isNot(contains('$className():')));
              }
            },
          );
        },
      );

      test(
        'when the client protocol is generated,'
        'then it does not refer to the policies.',
        () {
          var clientCode = const DartClientCodeGenerator().generateProtocolCode(
            protocolDefinition: protocolDefinition,
            config: config,
          );

          expect(
            clientCode.values,
            everyElement(isNot(contains('FutureCallRetryPolicy'))),
          );
        },
      );
    },
  );
}
