import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/generator/dart/shared_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/model_class_definition_builder.dart';
import '../../../test_util/builders/serializable_entity_field_definition_builder.dart';
import '../../../test_util/builders/type_definition_builder.dart';
import '../../../test_util/compilation_unit_helpers.dart';

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
  var testClassName = 'Example';
  var testClassFileName = 'example';
  var expectedFilePath = path.joinAll([
    ...serverPathParts,
    'packages',
    'shared',
    'lib',
    'src',
    'generated',
    '$testClassFileName.dart',
  ]);

  group('Given class $testClassName when generating code', () {
    var models = [
      ModelClassDefinitionBuilder()
          .withClassName(testClassName)
          .withFileName(testClassFileName)
          .withField(
            FieldDefinitionBuilder()
                .withName('customClassField')
                .withType(
                  TypeDefinitionBuilder()
                      .withClassName('CustomClass')
                      .withCustomClass(true)
                      .build(),
                )
                .build(),
          )
          .withSharedPackageName(sharedPackageName)
          .build(),
    ];

    late var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    late var compilationUnit = parseString(
      content: codeMap[expectedFilePath]!,
    ).unit;

    late var maybeClassNamedExample =
        CompilationUnitHelpers.tryFindClassDeclaration(
          compilationUnit,
          name: testClassName,
        );

    test(
      'fromJson method should pass data as dynamic to custom class fromJson',
      () {
        var fromJsonConstructor =
            CompilationUnitHelpers.tryFindConstructorDeclaration(
              maybeClassNamedExample!,
              name: 'fromJson',
            );

        var fromJsonCode = fromJsonConstructor!.toSource();

        expect(
          fromJsonCode.contains(
            "CustomClass.fromJson(jsonSerialization['customClassField'])",
          ),
          isTrue,
          reason:
              'The fromJson method should pass data as dynamic to CustomClass.fromJson but doesn\'t.',
        );
      },
    );
  });
}
