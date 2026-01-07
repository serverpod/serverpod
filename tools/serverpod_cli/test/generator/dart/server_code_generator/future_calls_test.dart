import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';
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
    'Given protocol definition without future calls when generating server files',
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
        endpointsFile = codeMap[expectedEndpointsFileName];
      });

      test('then no future calls file is created.', () {
        expect(codeMap[expectedFutureCallsFileName], isNull);
      });

      group('then endpoints file', () {
        test('is created', () {
          expect(codeMap, contains(expectedEndpointsFileName));
        });

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
    'Given protocol definition with future calls when generating server files',
    () {
      var futureCallName = 'testing';
      late Map<String, String> codeMap;
      late String? futureCallsFile;
      late String? endpointsFile;
      setUpAll(() {
        var protocolDefinition = ProtocolDefinition(
          futureCalls: [
            FutureCallDefinitionBuilder()
                .withClassName('${futureCallName.pascalCase}FutureCall')
                .withName(futureCallName)
                .withMethods([
                  FutureCallMethodDefinitionBuilder()
                      .withName('sayHello')
                      .withParameters(
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
                      )
                      .buildMethodCallDefinition(),
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

        futureCallsFile = codeMap[expectedFutureCallsFileName];
        endpointsFile = codeMap[expectedEndpointsFileName];
      });

      test('then future calls file is created.', () {
        expect(codeMap, contains(expectedFutureCallsFileName));
      });

      group('then endpoints file', () {
        test('is created', () {
          expect(codeMap, contains(expectedEndpointsFileName));
        });

        test('has an export for the Serverpod future calls getter', () {
          expect(
            endpointsFile,
            matches(
              r"export \'future_calls.dart\' show ServerpodFutureCallsGetter;",
            ),
          );
        });

        test('has an override for FutureCallDispatch', () {
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

      group(
        'then future calls file',
        () {
          test('has future calls map defined.', () {
            expect(
              futureCallsFile,
              matches(
                r'var registeredFutureCalls = <String, _i\d.FutureCall>\{\n'
                r"      \'TestingSayHelloFutureCall\': TestingSayHelloFutureCall\(\),\n"
                r'    \};\n',
              ),
            );
          });

          test(
            'has the future call instance for the method with a Future return type whose first argument is a Session.',
            () {
              expect(
                futureCallsFile,
                contains(
                  '${futureCallName.pascalCase}SayHelloFutureCall',
                ),
              );
            },
          );
        },
      );
    },
  );

  group(
    'Given protocol definition with multiple future calls when generating server files',
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
                  FutureCallMethodDefinitionBuilder()
                      .withName('sayHello')
                      .withParameters(
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
                      )
                      .buildMethodCallDefinition(),
                ])
                .build(),
            FutureCallDefinitionBuilder()
                .withClassName('${secondFutureCallName.pascalCase}FutureCall')
                .withName(secondFutureCallName)
                .withMethods([
                  FutureCallMethodDefinitionBuilder()
                      .withName('sayBye')
                      .withParameters(
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
                      )
                      .buildMethodCallDefinition(),
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
        futureCallsFile = codeMap[expectedFutureCallsFileName];
      });

      test('then future calls file is created.', () {
        expect(codeMap, contains(expectedFutureCallsFileName));
      });

      group(
        'then future calls file',
        () {
          test('has future calls defined.', () {
            expect(
              futureCallsFile,
              matches(
                r'var registeredFutureCalls = <String, _i\d.FutureCall>\{\n'
                r"      \'Testing1SayHelloFutureCall\': Testing1SayHelloFutureCall\(\),\n"
                r"      \'Testing2SayByeFutureCall\': Testing2SayByeFutureCall\(\),\n"
                r'    \};\n',
              ),
            );
          });

          test(
            'has future call instances for all the methods with Future return type where the first parameter is a Session.',
            () {
              expect(
                futureCallsFile,
                contains(
                  '${firstFutureCallName.pascalCase}SayHelloFutureCall',
                ),
              );
              expect(
                futureCallsFile,
                contains(
                  '${secondFutureCallName.pascalCase}SayByeFutureCall',
                ),
              );
            },
          );
        },
      );
    },
  );
}
