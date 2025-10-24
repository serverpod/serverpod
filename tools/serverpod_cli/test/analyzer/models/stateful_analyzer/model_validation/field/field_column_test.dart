import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/models/stateful_analyzer.dart';
import 'package:serverpod_cli/src/generator/code_generation_collector.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:test/test.dart';

import '../../../../../test_util/builders/generator_config_builder.dart';
import '../../../../../test_util/builders/model_source_builder.dart';
import '../../../../../test_util/compilation_unit_helpers.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  const testClassName = 'Example';
  const testClassFileName = 'example';
  final expectedFilePath =
      path.join('lib', 'src', 'generated', '$testClassFileName.dart');

  group('Given a class with an explicit column name', () {
    const noColumnFieldName = 'name';
    const columnFieldName = 'userName';
    const columnName = 'user_name';
    const fieldType = 'String';
    var models = [
      ModelSourceBuilder().withYaml(
        '''
          class: Example
          fields:
            $noColumnFieldName: $fieldType
            $columnFieldName: $fieldType, column=$columnName
          ''',
      ).build()
    ];
    var collector = CodeGenerationCollector();
    var definitions =
        StatefulAnalyzer(config, models, onErrorsCollector(collector))
            .validateAll();

    var codeMap = generator.generateSerializableModelsCode(
      models: definitions,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;

    var maybeClassNamedExample = CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: testClassName,
    );

    test('then no errors are collected.', () {
      expect(
        collector.errors,
        isEmpty,
        reason: 'Expected no errors but some were generated.',
      );
      expect(definitions, isNotEmpty);
    });

    group('then fromJson method should get ', () {
      test('column name from jsonSerialization for field with column set', () {
        var fromJsonConstructor =
            CompilationUnitHelpers.tryFindConstructorDeclaration(
          maybeClassNamedExample!,
          name: 'fromJson',
        );

        var fromJsonCode = fromJsonConstructor!.toSource();

        expect(
          fromJsonCode.contains(
            "$columnFieldName: jsonSerialization['$columnName'] as $fieldType",
          ),
          isTrue,
          reason: 'The fromJson method should map the field name to '
              'jsonSerialization of the column name.',
        );
      });

      test('field name from jsonSerialization for field with column not set',
          () {
        var fromJsonConstructor =
            CompilationUnitHelpers.tryFindConstructorDeclaration(
          maybeClassNamedExample!,
          name: 'fromJson',
        );

        var fromJsonCode = fromJsonConstructor!.toSource();

        expect(
          fromJsonCode.contains(
            "$noColumnFieldName: jsonSerialization['$noColumnFieldName'] as $fieldType",
          ),
          isTrue,
          reason: 'The fromJson method should map the field name to its '
              'jsonSerialization.',
        );
      });
    });
  });

  test(
    'Given a class with a duplicated column name, then an error is collected.',
    () {
      const columnName = 'field_one';
      var models = [
        ModelSourceBuilder().withYaml(
          '''
          class: Example
          fields:
            fieldOne: String, column=$columnName
            fieldTwo: String, column=$columnName
          ''',
        ).build()
      ];

      var collector = CodeGenerationCollector();
      StatefulAnalyzer analyzer = StatefulAnalyzer(
        config,
        models,
        onErrorsCollector(collector),
      );
      analyzer.validateAll();

      expect(
        collector.errors,
        isNotEmpty,
        reason: 'Expected an error to be collected, but none was generated.',
      );

      var error = collector.errors.first;

      expect(
        error.message,
        'The column "$columnName" should only be used for a single field.',
        reason:
            'Expected the error message to indicate a column should only be '
            'used for a single field.',
      );
    },
  );
}
