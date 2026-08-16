import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/dart/shared_code_generator.dart';
import 'package:serverpod_cli/src/generator/shared.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/model_class_definition_builder.dart';

const sharedPackageName = 'shared_pkg';
const projectName = 'example_project';
const serverPathParts = ['server_root'];
final config = GeneratorConfigBuilder()
    .withServerPackageDirectoryPathParts(serverPathParts)
    .withSharedModelsSourcePathsParts({
      sharedPackageName: ['packages', 'shared'],
    })
    .withModules([])
    .build();
const generator = DartSharedCodeGenerator();

void main() {
  var testClassName = 'SharedExample';
  var testClassFileName = 'shared_example';
  var expectedFilePath = path.joinAll([
    ...serverPathParts,
    'packages',
    'shared',
    'lib',
    'src',
    'generated',
    '$testClassFileName.dart',
  ]);

  var expectedProtocolPath = path.joinAll([
    ...serverPathParts,
    'packages',
    'shared',
    'lib',
    'src',
    'generated',
    'protocol.dart',
  ]);

  group(
    'Given a single shared model when generating the shared package code',
    () {
      var sharedModel = ModelClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withSimpleField('name', 'String')
          .withSharedPackageName(sharedPackageName)
          .build();

      var models = [sharedModel];

      late var codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      test(
        'then the result contains the shared package model file path.',
        () {
          expect(codeMap, containsPair(expectedFilePath, isA<String>()));
        },
      );

      test(
        'then the generated code uses serverpod_serialization import.',
        () {
          var code = codeMap[expectedFilePath]!;
          expect(code, contains(serverpodSerializationUrl));
        },
      );
    },
  );

  group(
    'Given a single server model',
    () {
      var serverModel = ModelClassDefinitionBuilder()
          .withClassName('ServerExample')
          .withFileName('server_example')
          .withSimpleField('id', 'int')
          .build();

      test(
        ' when generating the shared package code then the result is empty.',
        () {
          var codeMap = generator.generateSerializableModelsCode(
            models: [serverModel],
            config: config,
          );
          expect(codeMap, isEmpty);
        },
      );

      test(
        'when generating the protocol code then the result is empty.',
        () {
          var codeMap = generator.generateProtocolCode(
            protocolDefinition: ProtocolDefinition(
              endpoints: [],
              models: [serverModel],
              futureCalls: [],
            ),
            config: config,
          );
          expect(codeMap, isEmpty);
        },
      );
    },
  );

  group(
    'Given a single shared model when generating the protocol code',
    () {
      var sharedModel = ModelClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withSimpleField('name', 'String')
          .withSharedPackageName(sharedPackageName)
          .build();

      var protocolDefinition = ProtocolDefinition(
        endpoints: [],
        models: [sharedModel],
        futureCalls: [],
      );

      late var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      test(
        'then the result contains the shared package protocol.dart path.',
        () {
          expect(codeMap, containsPair(expectedProtocolPath, isA<String>()));
        },
      );

      test(
        'then the generated protocol code uses serverpod_serialization import.',
        () {
          var code = codeMap[expectedProtocolPath]!;
          expect(code, contains(serverpodSerializationUrl));
        },
      );
    },
  );
}
