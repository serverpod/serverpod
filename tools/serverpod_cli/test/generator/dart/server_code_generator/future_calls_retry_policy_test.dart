import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/protocol_definition.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/future_call_definition_builder.dart';
import '../../../test_util/builders/future_call_method_definition_builder.dart';
import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/parameter_definition_builder.dart';
import '../../../test_util/builders/type_definition_builder.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();

void main() {
  var futureCallsFilePath = path.join(
    'lib',
    'src',
    'generated',
    'future_calls.dart',
  );

  group(
    'Given a protocol definition with a future call,',
    () {
      late ProtocolDefinition protocolDefinition;

      setUp(() {
        protocolDefinition = ProtocolDefinition(
          futureCalls: [
            FutureCallDefinitionBuilder()
                .withClassName('TestingFutureCall')
                .withName('testing')
                .withMethods([
                  FutureCallMethodDefinitionBuilder()
                      .withName('sayHello')
                      .withParameters([
                        ParameterDefinitionBuilder()
                            .withName('session')
                            .withType(
                              TypeDefinitionBuilder()
                                  .withClassName('Session')
                                  .build(),
                            )
                            .build(),
                      ])
                      .buildMethodCallDefinition(),
                ])
                .build(),
          ],
          endpoints: [],
          models: [],
        );
      });

      group(
        'when the server files are generated,',
        () {
          late String futureCallsFile;

          setUp(() {
            futureCallsFile = const DartServerCodeGenerator()
                .generateProtocolCode(
                  protocolDefinition: protocolDefinition,
                  config: config,
                )[futureCallsFilePath]!;
          });

          test(
            'then the function that schedules a future call takes an optional retry policy.',
            () {
              expect(
                futureCallsFile,
                matches(
                  RegExp(
                    r'typedef _InvokeFutureCall =\s*'
                    r'Future<void> Function\(\s*'
                    r'String name,\s*'
                    r'_i[a-z0-9]+\.SerializableModel\? object, \{\s*'
                    r'_i[a-z0-9]+\.FutureCallRetryPolicy\? retryPolicy,\s*'
                    r'\}\);',
                  ),
                ),
              );
            },
          );

          test(
            'then the reference returned by the scheduling methods has a withRetryPolicy method that returns the reference without it.',
            () {
              expect(
                futureCallsFile,
                matches(
                  RegExp(
                    r'class _FutureCallRef extends _FutureCallRefBase \{[\s\S]*'
                    r'_FutureCallRefBase withRetryPolicy\('
                    r'_i[a-z0-9]+\.FutureCallRetryPolicy retryPolicy\) \{\s*'
                    r'final policy = retryPolicy;\s*'
                    r'return _FutureCallRefBase\(\s*'
                    r'\(name, object, \{retryPolicy\}\) => _invokeFutureCall\(\s*'
                    r'name,\s*'
                    r'object,\s*'
                    r'retryPolicy: policy,\s*'
                    r'\),\s*'
                    r'\);\s*'
                    r'\}',
                  ),
                ),
              );
            },
          );

          test(
            'then the reference returned by withRetryPolicy has no withRetryPolicy method so a retry policy can only be set once.',
            () {
              var baseClass = RegExp(
                r'class _FutureCallRefBase \{[\s\S]*?\n\}\n',
              ).firstMatch(futureCallsFile)?.group(0);

              expect(baseClass, isNotNull);
              expect(baseClass, isNot(contains('withRetryPolicy')));
            },
          );

          test(
            'then the generated future call forwards shouldRetry to the future call class.',
            () {
              expect(
                futureCallsFile,
                matches(
                  RegExp(
                    r'class TestingSayHelloFutureCall[\s\S]*'
                    r'@override\s*'
                    r'_i[a-z0-9]+\.FutureOr<bool> shouldRetry\(\s*'
                    r'_i[a-z0-9]+\.Session session,\s*'
                    r'_i[a-z0-9]+\.FutureCallRetryContext context,\s*'
                    r'\) => _i[a-z0-9]+\.TestingFutureCall\(\)\.shouldRetry\(\s*'
                    r'session,\s*'
                    r'context,\s*'
                    r'\);',
                  ),
                ),
              );
            },
          );

          test(
            'then every scheduling method passes the retry policy to the future call manager.',
            () {
              expect(
                RegExp(
                  r'\(name, object, \{retryPolicy\}\) \{\s*'
                  r'return _[a-zA-Z]*[fF]utureCallManager\.scheduleFutureCall\('
                  r'[^;]*retryPolicy: retryPolicy,\s*\);',
                ).allMatches(futureCallsFile),
                hasLength(4),
              );
            },
          );
        },
      );
    },
  );
}
