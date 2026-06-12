import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/generator/dart/shared_code_generator.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/enum_definition_builder.dart';
import '../../../test_util/builders/exception_class_definition_builder.dart';
import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/model_class_definition_builder.dart';
import '../../../test_util/builders/serializable_entity_field_definition_builder.dart';
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
  var expectedFileName = path.joinAll([
    ...serverPathParts,
    'packages',
    'shared',
    'lib',
    'src',
    'generated',
    '$testClassFileName.dart',
  ]);

  group(
    'Given a shared package model referencing another shared package model when generating code',
    () {
      var sharedUser = ModelClassDefinitionBuilder()
          .withClassName('User')
          .withFileName('user')
          .withSimpleField('name', 'String')
          .withSharedPackageName(sharedPackageName)
          .build();

      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withField(
              FieldDefinitionBuilder()
                  .withName('user')
                  .withType(
                    TypeDefinition(
                      className: sharedUser.className,
                      nullable: true,
                      url: defaultModuleAlias,
                      projectModelDefinition: sharedUser,
                    ),
                  )
                  .build(),
            )
            .withSharedPackageName(sharedPackageName)
            .build(),
        sharedUser,
      ];

      late var codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      late var compilationUnit = parseString(
        content: codeMap[expectedFileName]!,
      ).unit;

      test(
        'then the generated class imports the shared package root library.',
        () {
          expect(
            CompilationUnitHelpers.hasImportDirective(
              compilationUnit,
              uri: 'package:$sharedPackageName/$sharedPackageName.dart',
            ),
            isTrue,
          );
        },
      );

      test(
        'then the generated class does not import the client protocol library.',
        () {
          expect(
            CompilationUnitHelpers.hasImportDirective(
              compilationUnit,
              uri:
                  'package:${config.dartClientPackage}/src/protocol/protocol.dart',
            ),
            isFalse,
          );
        },
      );
    },
  );

  group(
    'Given a shared package model referencing an enum in a shared package when generating code',
    () {
      var sharedEnum = EnumDefinitionBuilder()
          .withClassName('SharedEnum')
          .withFileName('shared_enum')
          .withValues([
            ProtocolEnumValueDefinition('one'),
            ProtocolEnumValueDefinition('two'),
          ])
          .withSharedPackageName(sharedPackageName)
          .build();

      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withField(
              FieldDefinitionBuilder()
                  .withName('enumField')
                  .withType(sharedEnum.type)
                  .build(),
            )
            .withSharedPackageName(sharedPackageName)
            .build(),
        sharedEnum,
      ];

      late var codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      late var compilationUnit = parseString(
        content: codeMap[expectedFileName]!,
      ).unit;

      test(
        'then the generated class imports the shared package root library.',
        () {
          expect(
            CompilationUnitHelpers.hasImportDirective(
              compilationUnit,
              uri: 'package:$sharedPackageName/$sharedPackageName.dart',
            ),
            isTrue,
          );
        },
      );

      test(
        'then the generated class does not import the client protocol library.',
        () {
          expect(
            CompilationUnitHelpers.hasImportDirective(
              compilationUnit,
              uri:
                  'package:${config.dartClientPackage}/src/protocol/protocol.dart',
            ),
            isFalse,
          );
        },
      );
    },
  );

  group(
    'Given a shared exception class referencing another shared model when generating code',
    () {
      var sharedUser = ModelClassDefinitionBuilder()
          .withClassName('User')
          .withFileName('user')
          .withSimpleField('name', 'String')
          .withSharedPackageName(sharedPackageName)
          .build();

      var models = [
        ExceptionClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withField(
              FieldDefinitionBuilder()
                  .withName('user')
                  .withType(sharedUser.type)
                  .build(),
            )
            .withSharedPackageName(sharedPackageName)
            .build(),
        sharedUser,
      ];

      late var codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      late var compilationUnit = parseString(
        content: codeMap[expectedFileName]!,
      ).unit;

      test(
        'then the generated class imports the shared package root library.',
        () {
          expect(
            CompilationUnitHelpers.hasImportDirective(
              compilationUnit,
              uri: 'package:$sharedPackageName/$sharedPackageName.dart',
            ),
            isTrue,
          );
        },
      );

      test(
        'then the generated class does not import the client protocol library.',
        () {
          expect(
            CompilationUnitHelpers.hasImportDirective(
              compilationUnit,
              uri:
                  'package:${config.dartClientPackage}/src/protocol/protocol.dart',
            ),
            isFalse,
          );
        },
      );
    },
  );
}
