import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/model_class_definition_builder.dart';
import '../../../test_util/compilation_unit_helpers.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  group(
    'Given a class with a table, '
    'when generating code,',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName('Example')
            .withFileName('example')
            .withTableName('example_table')
            .build(),
      ];

      var codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      var compilationUnit = parseString(
        content: codeMap[path.join('lib', 'src', 'generated', 'example.dart')]!,
      ).unit;

      var repositoryClass = CompilationUnitHelpers.tryFindClassDeclaration(
        compilationUnit,
        name: 'ExampleRepository',
      );

      for (var methodName in [
        'find',
        'watch',
        'findFirstRow',
        'findById',
        'updateById',
        'updateWhere',
        'deleteWhere',
        'count',
        'lockRows',
      ]) {
        test('then the repository $methodName method passes the table.', () {
          var method = CompilationUnitHelpers.tryFindMethodDeclaration(
            repositoryClass!,
            name: methodName,
          );

          expect(method?.body.toSource(), contains('table: Example.t,'));
        });
      }
    },
  );
}
