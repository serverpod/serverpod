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

  group('Given a class with a half vector field when generating code', () {
    var models = [
      ModelClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withTableName(tableName)
          .withVectorField(
            'embedding',
            dimension: 768,
            vectorType: 'HalfVector',
          )
          .build()
    ];

    late final codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    late final compilationUnit =
        parseString(content: codeMap[expectedFilePath]!).unit;

    late final maybeClassNamedExampleWithHalfVectorTable =
        CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '${testClassName}Table',
    );

    test('then a class named ${testClassName}Table is generated.', () {
      expect(
        maybeClassNamedExampleWithHalfVectorTable,
        isNotNull,
        reason: 'Missing definition for class named ${testClassName}Table',
      );
    });

    group('then the class named ${testClassName}Table', () {
      test(
          'has a half vector field declaration with correct dimension parameter',
          () {
        final constructorDeclaration =
            CompilationUnitHelpers.tryFindConstructorDeclaration(
          maybeClassNamedExampleWithHalfVectorTable!,
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
            "ColumnHalfVector('embedding', this, dimension: 768)",
          ),
          isTrue,
          reason:
              'Constructor should initialize half vector with dimension: 768',
        );
      });
    });
  });

  group('Given a class with a sparse vector field when generating code', () {
    var models = [
      ModelClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withTableName(tableName)
          .withVectorField(
            'sparse_data',
            dimension: 1024,
            vectorType: 'SparseVector',
          )
          .build()
    ];

    late final codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    late final compilationUnit =
        parseString(content: codeMap[expectedFilePath]!).unit;

    late final maybeClassNamedExampleWithSparseVectorTable =
        CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '${testClassName}Table',
    );

    test('then a class named ${testClassName}Table is generated.', () {
      expect(
        maybeClassNamedExampleWithSparseVectorTable,
        isNotNull,
        reason: 'Missing definition for class named ${testClassName}Table',
      );
    });

    group('then the class named ${testClassName}Table', () {
      test(
          'has a sparse vector field declaration with correct dimension parameter',
          () {
        final constructorDeclaration =
            CompilationUnitHelpers.tryFindConstructorDeclaration(
          maybeClassNamedExampleWithSparseVectorTable!,
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
            "ColumnSparseVector('sparse_data', this, dimension: 1024)",
          ),
          isTrue,
          reason:
              'Constructor should initialize sparse vector with dimension: 1024',
        );
      });
    });
  });

  group('Given a class with a bit vector field when generating code', () {
    var models = [
      ModelClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withTableName(tableName)
          .withVectorField('signature', dimension: 64, vectorType: 'Bit')
          .build()
    ];

    late final codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    late final compilationUnit =
        parseString(content: codeMap[expectedFilePath]!).unit;

    late final maybeClassNamedExampleWithBitTable =
        CompilationUnitHelpers.tryFindClassDeclaration(
      compilationUnit,
      name: '${testClassName}Table',
    );

    test('then a class named ${testClassName}Table is generated.', () {
      expect(
        maybeClassNamedExampleWithBitTable,
        isNotNull,
        reason: 'Missing definition for class named ${testClassName}Table',
      );
    });

    group('then the class named ${testClassName}Table', () {
      test(
          'has a bit vector field declaration with correct dimension parameter',
          () {
        final constructorDeclaration =
            CompilationUnitHelpers.tryFindConstructorDeclaration(
          maybeClassNamedExampleWithBitTable!,
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
            "ColumnBit('signature', this, dimension: 64)",
          ),
          isTrue,
          reason: 'Constructor should initialize bit with dimension: 64',
        );
      });
    });
  });
}
