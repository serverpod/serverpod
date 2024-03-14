import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;

import 'package:serverpod_cli/src/test_util/builders/class_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  var testClassFileName = 'example';
  var expectedFilePath =
      path.join('lib', 'src', 'generated', '$testClassFileName.dart');

  group('Given class with documentation when generating code', () {
    var documentation = [
      '// This is an example documentation',
      '// This is another example'
    ];
    var models = [
      ClassDefinitionBuilder()
          .withFileName(testClassFileName)
          .withDocumentation(documentation)
          .build()
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    test('then documentation is included in code.', () {
      for (var comment in documentation) {
        expect(codeMap[expectedFilePath], contains(comment));
      }
    });
  });
}
