import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:serverpod_cli/src/test_util/compilation_unit_helpers.dart';
import 'package:test/test.dart';
import 'package:path/path.dart' as path;

import 'package:serverpod_cli/src/test_util/builders/class_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  var testClassName = 'Example';
  var testClassFileName = 'example';
  var expectedFilePath =
      path.join('lib', 'src', 'generated', '$testClassFileName.dart');
  var tableName = 'example_table';

  group('Given a class with table name when generating code', () {
    var entities = [
      ClassDefinitionBuilder()
          .withFileName(testClassFileName)
          .withTableName(tableName)
          .build()
    ];

    var codeMap = generator.generateSerializableEntitiesCode(
      models: entities,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;

    test(
        'then top level variable t$testClassName marked deprecated is generated.',
        () {
      expect(
          CompilationUnitHelpers.hasTopLevelVariableDeclaration(
            compilationUnit,
            name: 't$testClassName',
            annotations: ['Deprecated'],
          ),
          isTrue,
          reason:
              'Missing top level variable declaration for "t$testClassName" marked deprecated.');
    });
  });
}
