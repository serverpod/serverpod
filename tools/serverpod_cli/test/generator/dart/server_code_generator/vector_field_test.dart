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
  var testClassName = 'ExampleWithVector';
  var testClassFileName = 'example_with_vector';
  var expectedFilePath =
      path.join('lib', 'src', 'generated', '$testClassFileName.dart');
  var tableName = 'example_with_vector_table';

  group('Given a class with a vector field when generating code', () {
    var models = [
      ModelClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withTableName(tableName)
          .withVectorField('vector', dimension: 512)
          .build()
    ];

    late final codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    late final compilationUnit =
        parseString(content: codeMap[expectedFilePath]!).unit;

    late final maybeClassNamedExampleWithVectorTable =
        CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '${testClassName}Table',
    );

    test('then a class named ${testClassName}Table is generated.', () {
      expect(
        maybeClassNamedExampleWithVectorTable,
        isNotNull,
        reason: 'Missing definition for class named ${testClassName}Table',
      );
    });

    group('then the class named ${testClassName}Table', () {
      test('has a vector field declaration with correct dimension parameter',
          () {
        final constructorDeclaration =
            CompilationUnitHelpers.tryFindConstructorDeclaration(
          maybeClassNamedExampleWithVectorTable!,
          name: null,
        );

        expect(
          constructorDeclaration,
          isNotNull,
          reason: 'Missing constructor declaration in ${testClassName}Table',
        );

        final constructorSource = constructorDeclaration!.toSource();
        expect(
          constructorSource.contains(
            "ColumnVector('vector', this, dimension: 512)",
          ),
          isTrue,
          reason: 'Constructor should initialize vector with dimension: 512',
        );
      });
    });
  });
}
