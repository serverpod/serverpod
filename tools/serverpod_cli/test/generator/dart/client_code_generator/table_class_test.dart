import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/model_class_definition_builder.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartClientCodeGenerator();

void main() {
  const testClassName = 'Example';
  const testClassFileName = 'example';
  const tableName = 'example_table';

  final expectedFilePath = path.join(
    '..',
    'example_project_client',
    'lib',
    'src',
    'protocol',
    '$testClassFileName.dart',
  );

  group(
    'Given a class with a client database table when generating client code',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withTableName(tableName)
            .withDatabase(ModelDatabaseDefinition.client)
            .build(),
      ];

      var codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      test('then a table class is generated.', () {
        expect(
          codeMap[expectedFilePath],
          contains('class ${testClassName}Table'),
        );
      });

      test('then the database runtime package is imported.', () {
        expect(
          codeMap[expectedFilePath],
          contains('package:serverpod_database/serverpod_database.dart'),
        );
      });
    },
  );
}
