import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/analyzer/protocol_definition.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/future_call_definition_builder.dart';
import '../../../test_util/builders/future_call_method_definition_builder.dart';
import '../../../test_util/builders/future_call_parameter_definition_builder.dart';
import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/parameter_definition_builder.dart';
import '../../../test_util/builders/type_definition_builder.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  var modelName = 'example_hello_model';
  var expectedModeFileName = path.join(
    'lib',
    'src',
    'generated',
    'future_calls_models',
    '$modelName.dart',
  );
  var expectedFutureCallsFileName = path.join(
    'lib',
    'src',
    'generated',
    'future_calls.dart',
  );

  group(
    'Given future call serializable model and protocol definition with future calls when generating code',
    () {
      var futureCallName = 'example';

      late Map<String, String> modelCodeMap;
      late Map<String, String> protocolCodeMap;
      late String? futureCallsFile;
      late String? modelFile;
      late FutureCallParameterDefinition futureCallParameter;

      setUpAll(() {
        final parameters = [
          ParameterDefinitionBuilder()
              .withName('name')
              .withType(
                TypeDefinitionBuilder().withClassName('String').build(),
              )
              .build(),
          ParameterDefinitionBuilder()
              .withName('age')
              .withType(
                TypeDefinitionBuilder().withClassName('int').build(),
              )
              .build(),
        ];

        futureCallParameter = FutureCallParameterDefinitionBuilder()
            .withName(modelName.pascalCase)
            .withType(
              TypeDefinitionBuilder()
                  .withClassName(modelName.pascalCase)
                  .build(),
            )
            .withParameters(parameters)
            .build();

        final models = [futureCallParameter.toSerializableModel()];

        final protocolDefinition = ProtocolDefinition(
          endpoints: [],
          models: models,
          futureCalls: [
            FutureCallDefinitionBuilder()
                .withClassName('${futureCallName.pascalCase}FutureCall')
                .withName(futureCallName)
                .withMethods([
                  FutureCallMethodDefinitionBuilder()
                      .withName('hello')
                      .withFutureCallMethodParameter(futureCallParameter)
                      .withParameters(parameters)
                      .buildMethodCallDefinition(),
                ])
                .build(),
          ],
        );

        protocolCodeMap = generator.generateProtocolCode(
          protocolDefinition: protocolDefinition,
          config: config,
        );

        modelCodeMap = generator.generateSerializableModelsCode(
          models: models,
          config: GeneratorConfigBuilder().build(),
        );

        futureCallsFile = protocolCodeMap[expectedFutureCallsFileName];
        modelFile = modelCodeMap[expectedModeFileName];
      });

      test('then future calls file is generated', () {
        expect(protocolCodeMap, contains(expectedFutureCallsFileName));
      });

      test('then serializable model file is generated', () {
        expect(modelCodeMap, contains(expectedModeFileName));
      });

      test('then the generated serializable model has defined parameters', () {
        expect(
          modelFile,
          matches(
            r'abstract class ExampleHelloModel\n'
            r'    implements _i\d.SerializableModel, _i\d.ProtocolSerialization \{\n'
            r'  ExampleHelloModel._\(\{\n'
            r'    required this.name,\n'
            r'    required this.age,\n'
            r'  \}\);\n'
            r'\n'
            r'  factory ExampleHelloModel\(\{\n'
            r'    required String name,\n'
            r'    required int age,\n'
            r'  \}\) = _ExampleHelloModelImpl;\n',
          ),
        );
      });

      test('then the generated future calls file uses the generated model', () {
        expect(
          futureCallsFile,
          matches(
            r'  Future<void> hello\(\n'
            r'    String name,\n'
            r'    int age,\n'
            r'  \) \{\n'
            r'    var object = _i\d.ExampleHelloModel\(\n'
            r'      name: name,\n'
            r'      age: age,\n'
            r'    \);\n'
            r'    return _invokeFutureCall\(\n'
            r"      \'ExampleHelloFutureCall\',\n"
            r'      object,\n'
            r'    \);\n',
          ),
        );
      });
    },
  );
}
