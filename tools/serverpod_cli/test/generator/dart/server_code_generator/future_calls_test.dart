import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';
import 'package:serverpod_cli/src/analyzer/protocol_definition.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/future_call_definition_builder.dart';
import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/method_definition_builder.dart';
import '../../../test_util/builders/parameter_definition_builder.dart';
import '../../../test_util/builders/type_definition_builder.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  var expectedFileName = path.join(
    'lib',
    'src',
    'generated',
    'future_calls.dart',
  );
  group(
    'Given protocol definition without future calls when generating future calls file',
    () {
      late Map<String, String> codeMap;
      late String? futureCallsFile;
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
        futureCallsFile = codeMap[expectedFileName];
      });

      test('then future calls file is created.', () {
        expect(codeMap, contains(expectedFileName));
      });

      group(
        'then future calls file',
        () {
          test('has no future calls defined.', () {
            expect(futureCallsFile, isNot(contains('var futureCalls =')));
          });

          test('has a future call manager field defined.', () {
            expect(
              futureCallsFile,
              contains('FutureCallManager? _futureCallManager;'),
            );
          });

          test('has a serverId field defined.', () {
            expect(
              futureCallsFile,
              contains('String? _serverId;'),
            );
          });
        },
      );
    },
  );

  group(
    'Given protocol definition with future calls when generating future calls file',
    () {
      var futureCallName = 'testing';
      late Map<String, String> codeMap;
      late String? futureCallsFile;
      setUpAll(() {
        var protocolDefinition = ProtocolDefinition(
          futureCalls: [
            FutureCallDefinitionBuilder()
                .withClassName('${futureCallName.pascalCase}FutureCall')
                .withName(futureCallName)
                .withMethods([
                  MethodDefinitionBuilder().withName('sayHello').withParameters(
                    [
                      ParameterDefinitionBuilder()
                          .withName('session')
                          .withType(
                            TypeDefinitionBuilder()
                                .withClassName('Session')
                                .build(),
                          )
                          .build(),
                      ParameterDefinitionBuilder()
                          .withName('name')
                          .withType(
                            TypeDefinitionBuilder()
                                .withClassName('String')
                                .build(),
                          )
                          .build(),
                    ],
                  ).buildMethodCallDefinition(),
                ])
                .build(),
          ],
          endpoints: [],
          models: [],
        );

        codeMap = generator.generateProtocolCode(
          protocolDefinition: protocolDefinition,
          config: config,
        );

        futureCallsFile = codeMap[expectedFileName];
      });

      test('then future calls file is created.', () {
        expect(codeMap, contains(expectedFileName));
      });

      group(
        'then future calls file',
        () {
          test('has future calls map defined.', () {
            expect(futureCallsFile, contains('var futureCalls ='));
          });

          test(
            'has the future call instance for the method with a Future return type whose first argument is a Session.',
            () {
              expect(
                futureCallsFile,
                contains(
                  'FutureCall${futureCallName.pascalCase}SayHello',
                ),
              );
            },
          );
        },
      );
    },
  );

  group(
    'Given protocol definition with multiple future calls when generating future calls file',
    () {
      var firstFutureCallName = 'testing1';
      var secondFutureCallName = 'testing2';
      late Map<String, String> codeMap;
      late String? futureCallsFile;

      setUpAll(() {
        var protocolDefinition = ProtocolDefinition(
          futureCalls: [
            FutureCallDefinitionBuilder()
                .withClassName('${firstFutureCallName.pascalCase}FutureCall')
                .withName(firstFutureCallName)
                .withMethods([
                  MethodDefinitionBuilder().withName('sayHello').withParameters(
                    [
                      ParameterDefinitionBuilder()
                          .withName('session')
                          .withType(
                            TypeDefinitionBuilder()
                                .withClassName('Session')
                                .build(),
                          )
                          .build(),
                      ParameterDefinitionBuilder()
                          .withName('name')
                          .withType(
                            TypeDefinitionBuilder()
                                .withClassName('String')
                                .build(),
                          )
                          .build(),
                    ],
                  ).buildMethodCallDefinition(),
                ])
                .build(),
            FutureCallDefinitionBuilder()
                .withClassName('${secondFutureCallName.pascalCase}FutureCall')
                .withName(secondFutureCallName)
                .withMethods([
                  MethodDefinitionBuilder().withName('sayBye').withParameters(
                    [
                      ParameterDefinitionBuilder()
                          .withName('session')
                          .withType(
                            TypeDefinitionBuilder()
                                .withClassName('Session')
                                .build(),
                          )
                          .build(),
                      ParameterDefinitionBuilder()
                          .withName('name')
                          .withType(
                            TypeDefinitionBuilder()
                                .withClassName('int')
                                .build(),
                          )
                          .build(),
                    ],
                  ).buildMethodCallDefinition(),
                ])
                .build(),
          ],
          endpoints: [],
          models: [],
        );

        codeMap = generator.generateProtocolCode(
          protocolDefinition: protocolDefinition,
          config: config,
        );
        futureCallsFile = codeMap[expectedFileName];
      });

      test('then future calls file is created.', () {
        expect(codeMap, contains(expectedFileName));
      });

      group(
        'then future calls file',
        () {
          test('has future calls defined.', () {
            expect(futureCallsFile, contains('var futureCalls ='));
          });

          test(
            'has future call instances for all the methods with Future return type where the first parameter is a Session.',
            () {
              expect(
                futureCallsFile,
                contains(
                  'FutureCall${firstFutureCallName.pascalCase}SayHello',
                ),
              );
              expect(
                futureCallsFile,
                contains(
                  'FutureCall${secondFutureCallName.pascalCase}SayBye',
                ),
              );
            },
          );
        },
      );
    },
  );
}
