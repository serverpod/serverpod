import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:test/test.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartClientCodeGenerator();

class UnsupportedEntity extends SerializableEntityDefinition {
  UnsupportedEntity(
      {required super.fileName,
      required super.sourceFileName,
      required super.className,
      required super.serverOnly});
}

void main() {
  test('Given unsupported entity when generating code then exception is thrown',
      () {
    var entities = [
      UnsupportedEntity(
          fileName: 'example',
          sourceFileName: 'example',
          className: 'Example',
          serverOnly: false)
    ];

    expect(
      () => generator.generateSerializableEntitiesCode(
        entities: entities,
        config: config,
      ),
      throwsA(const TypeMatcher<Exception>().having((e) => e.toString(),
          'message', equals('Exception: Unsupported protocol entity type.'))),
    );
  });
}
