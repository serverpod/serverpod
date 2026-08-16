import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/model_class_definition_builder.dart';
import '../../../test_util/builders/serializable_entity_field_definition_builder.dart';
import '../../../test_util/builders/type_definition_builder.dart';
import '../../../test_util/compilation_unit_helpers.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartClientCodeGenerator();

void main() {
  var testClassName = 'Example';
  var testClassFileName = 'example';
  var expectedFilePath = path.join(
    '..',
    'example_project_client',
    'lib',
    'src',
    'protocol',
    '$testClassFileName.dart',
  );

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
          .build(),
    ];

    var codeMap = generator.generateSerializableModelsCode(
      models: models,
      config: config,
    );

    var compilationUnit = parseString(content: codeMap[expectedFilePath]!).unit;

    var maybeClassNamedExample = CompilationUnitHelpers.tryFindClassDeclaration(
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
