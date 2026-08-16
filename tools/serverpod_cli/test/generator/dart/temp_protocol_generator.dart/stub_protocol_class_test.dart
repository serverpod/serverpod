import 'package:serverpod_cli/src/generator/dart/library_generators/library_generator.dart';
import 'package:serverpod_cli/src/generator/dart/temp_protocol_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/generator_config_builder.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartTemporaryProtocolGenerator();

void main() {
  group('Given no models when generating the temporary protocol', () {
    final codeMap = generator.generateSerializableModelsCode(
      models: const [],
      config: config,
    );

    test('then the protocol file includes a stub Protocol class', () {
      final source = codeMap.values.first;

      expect(source, contains('class Protocol'));
      expect(source, contains('factory Protocol'));
      expect(source, contains('extends SerializationManager'));
    });

    test(
      'then the stub Protocol declares Protocol-specific serialization helpers',
      () {
        final source = codeMap.values.first;

        expect(source, contains(mapRecordToJsonFuncName));
        expect(source, contains(mapContainerToJsonFunctionName));
      },
    );
  });
}
