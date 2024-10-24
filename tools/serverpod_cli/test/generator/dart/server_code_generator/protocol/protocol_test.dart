import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:serverpod_cli/src/test_util/builders/class_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/endpoint_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/method_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/type_definition_builder.dart';
import 'package:test/test.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  var expectedFileName = path.join(
    'lib',
    'src',
    'generated',
    'protocol.dart',
  );

  group(
      'Given an endpoint with Stream with model generic return type when generating protocol files',
      () {
    var modelName = 'example_model';
    var models = [
      ClassDefinitionBuilder()
          .withClassName(modelName.pascalCase)
          .withFileName(modelName)
          .build()
    ];
    var endpoints = [
      EndpointDefinitionBuilder().withMethods([
        MethodDefinitionBuilder()
            .withName('streamingMethod')
            .withReturnType(
              TypeDefinitionBuilder()
                  .withStreamOf(modelName.pascalCase)
                  .build(),
            )
            .buildMethodCallDefinition()
      ]).build()
    ];

    var protocolDefinition =
        ProtocolDefinition(endpoints: endpoints, models: models);

    var codeMap = generator.generateProtocolCode(
      protocolDefinition: protocolDefinition,
      config: config,
    );

    test(
      'then the protocol.dart file is created.',
      () {
        expect(codeMap[expectedFileName], isNotNull);
      },
    );

    test(
      'then the protocol.dart contains deserialization for the model type.',
      () {
        expect(
          codeMap[expectedFileName],
          contains(modelName.pascalCase),
        );
      },
    );
  });
}
