import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/util/model_generators_util.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:serverpod_cli/src/generator/dart/shared_code_generator.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/enum_definition_builder.dart';
import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/model_class_definition_builder.dart';
import '../../../test_util/builders/serializable_entity_field_definition_builder.dart';

const sharedPackageName = 'shared_pkg';
const serverPathParts = ['server_root'];
final config = GeneratorConfigBuilder()
    .withServerPackageDirectoryPathParts(serverPathParts)
    .withSharedModelsSourcePathsParts({
      sharedPackageName: ['packages', 'shared'],
    })
    .withName('example_project')
    .withModules([])
    .build();

void main() {
  group(
    'Given a shared parent and a shared child that extends the parent '
    'when generating the shared package code',
    () {
      const parentClassName = 'SharedParent';
      const parentClassFileName = 'shared_parent';
      const childClassName = 'SharedChild';
      const childClassFileName = 'shared_child';

      var childExpectedFilePath = path.joinAll([
        ...serverPathParts,
        'packages',
        'shared',
        'lib',
        'src',
        'generated',
        '$childClassFileName.dart',
      ]);

      late ModelClassDefinition sharedParent;
      late ModelClassDefinition sharedChild;
      late Map<String, String> codeMap;

      setUpAll(() {
        sharedParent = ModelClassDefinitionBuilder()
            .withClassName(parentClassName)
            .withFileName(parentClassFileName)
            .withSimpleField('name', 'String')
            .withSharedPackageName(sharedPackageName)
            .build();

        sharedChild = ModelClassDefinitionBuilder()
            .withClassName(childClassName)
            .withFileName(childClassFileName)
            .withSimpleField('value', 'int')
            .withSharedPackageName(sharedPackageName)
            .withExtendsClass(sharedParent)
            .build();

        sharedParent.childClasses.add(
          ResolvedInheritanceDefinition(sharedChild),
        );

        codeMap = const DartSharedCodeGenerator()
            .generateSerializableModelsCode(
              models: [sharedParent, sharedChild],
              config: config,
            );
      });

      test('then the shared child class is generated.', () {
        expect(codeMap, containsPair(childExpectedFilePath, isA<String>()));
      });

      late var childCode = codeMap[childExpectedFilePath]!;

      test('then the shared child class extends the shared parent.', () {
        expect(
          childCode,
          matches('$childClassName extends _i[0-9]+.$parentClassName'),
        );
      });

      test(
        'then the shared child file references the shared parent class from the shared package.',
        () {
          expect(
            childCode,
            contains('package:$sharedPackageName/$sharedPackageName.dart'),
          );
        },
      );
    },
  );

  group(
    'Given a shared parent and a project child that extends the parent '
    'when generating the server package code',
    () {
      const parentClassName = 'SharedParent';
      const parentClassFileName = 'shared_parent';
      const childClassName = 'ProjectChild';
      const childClassFileName = 'project_child';

      var childExpectedFilePath = path.joinAll([
        ...serverPathParts,
        'lib',
        'src',
        'generated',
        '$childClassFileName.dart',
      ]);

      late ModelClassDefinition sharedParent;
      late ModelClassDefinition projectChild;
      late Map<String, String> codeMap;

      setUpAll(() {
        sharedParent = ModelClassDefinitionBuilder()
            .withClassName(parentClassName)
            .withFileName(parentClassFileName)
            .withSimpleField('name', 'String')
            .withSharedPackageName(sharedPackageName)
            .build();

        projectChild = ModelClassDefinitionBuilder()
            .withClassName(childClassName)
            .withFileName(childClassFileName)
            .withTableName(childClassFileName)
            .withSimpleField('extra', 'String')
            .withExtendsClass(sharedParent)
            .build();

        codeMap = const DartServerCodeGenerator()
            .generateSerializableModelsCode(
              models: [sharedParent, projectChild],
              config: config,
            );
      });

      test('then the shared parent class is generated.', () {
        expect(codeMap, containsPair(childExpectedFilePath, isA<String>()));
      });

      late var childCode = codeMap[childExpectedFilePath]!;

      test(
        'then the project child class extends the shared parent.',
        () {
          expect(
            childCode,
            matches('$childClassName extends _i[0-9]+.$parentClassName'),
          );
        },
      );

      test(
        'then the project child file imports the shared parent class from the shared package.',
        () {
          expect(
            childCode,
            contains('package:$sharedPackageName/$sharedPackageName.dart'),
          );
        },
      );
    },
  );

  group(
    'Given a shared parent and a project child that extends the parent '
    'when generating the client package code',
    () {
      const parentClassName = 'SharedParent';
      const parentClassFileName = 'shared_parent';
      const childClassName = 'ProjectChild';
      const childClassFileName = 'project_child';

      late ModelClassDefinition sharedParent;
      late ModelClassDefinition projectChild;
      late Map<String, String> codeMap;

      setUpAll(() {
        sharedParent = ModelClassDefinitionBuilder()
            .withClassName(parentClassName)
            .withFileName(parentClassFileName)
            .withSimpleField('name', 'String')
            .withSharedPackageName(sharedPackageName)
            .build();

        projectChild = ModelClassDefinitionBuilder()
            .withClassName(childClassName)
            .withFileName(childClassFileName)
            .withSimpleField('extra', 'String')
            .withExtendsClass(sharedParent)
            .build();

        codeMap = const DartClientCodeGenerator()
            .generateSerializableModelsCode(
              models: [sharedParent, projectChild],
              config: config,
            );
      });

      late var childExpectedFilePath = projectChild.getFullFilePath(
        config,
        serverCode: false,
      );

      test('then the shared parent class is generated.', () {
        expect(codeMap, containsPair(childExpectedFilePath, isA<String>()));
      });

      late var childCode = codeMap[childExpectedFilePath]!;

      test(
        'then the project child class extends the shared parent.',
        () {
          expect(
            childCode,
            matches('$childClassName extends _i[0-9]+.$parentClassName'),
          );
        },
      );

      test(
        'then the project child file imports the shared parent class from the shared package.',
        () {
          expect(
            childCode,
            contains('package:$sharedPackageName/$sharedPackageName.dart'),
          );
        },
      );
    },
  );

  group(
    'Given a project model with a field that references a shared model',
    () {
      const sharedModelClassName = 'SharedModel';
      const sharedModelFileName = 'shared_model';
      const projectModelClassName = 'ProjectModel';
      const projectModelFileName = 'project_model';

      late ModelClassDefinition sharedModel;
      late ModelClassDefinition projectModel;
      late Map<String, String> codeMap;

      setUpAll(() {
        sharedModel = ModelClassDefinitionBuilder()
            .withClassName(sharedModelClassName)
            .withFileName(sharedModelFileName)
            .withSimpleField('name', 'String')
            .withSharedPackageName(sharedPackageName)
            .build();

        var sharedModelType = TypeDefinition(
          className: sharedModel.className,
          nullable: true,
          url: defaultModuleAlias,
          projectModelDefinition: sharedModel,
        );

        projectModel = ModelClassDefinitionBuilder()
            .withClassName(projectModelClassName)
            .withFileName(projectModelFileName)
            .withSimpleField('id', 'int')
            .withField(
              FieldDefinitionBuilder()
                  .withName('nested')
                  .withType(sharedModelType)
                  .withScope(ModelFieldScopeDefinition.all)
                  .build(),
            )
            .build();
      });

      group('when generating the client package code', () {
        setUpAll(() {
          codeMap = const DartClientCodeGenerator()
              .generateSerializableModelsCode(
                models: [sharedModel, projectModel],
                config: config,
              );
        });

        late var modelExpectedFilePath = projectModel.getFullFilePath(
          config,
          serverCode: false,
        );

        late var modelCode = codeMap[modelExpectedFilePath]!;

        test(
          'then the field type references the shared model class.',
          () {
            expect(modelCode, contains(sharedModelClassName));
          },
        );

        test(
          'then the project model file imports the shared model class from the shared package.',
          () {
            expect(
              modelCode,
              contains('package:$sharedPackageName/$sharedPackageName.dart'),
            );
          },
        );
      });

      group('when generating the server package code', () {
        setUpAll(() {
          codeMap = const DartServerCodeGenerator()
              .generateSerializableModelsCode(
                models: [sharedModel, projectModel],
                config: config,
              );
        });
      });

      late var modelExpectedFilePath = projectModel.getFullFilePath(
        config,
        serverCode: true,
      );

      late var modelCode = codeMap[modelExpectedFilePath]!;

      test(
        'then the field type references the shared model class.',
        () {
          expect(modelCode, contains(sharedModelClassName));
        },
      );

      test(
        'then the project model file imports the shared model class from the shared package.',
        () {
          expect(
            modelCode,
            contains('package:$sharedPackageName/$sharedPackageName.dart'),
          );
        },
      );
    },
  );

  group(
    'Given a project model with a field that references an enum in a shared package',
    () {
      const sharedEnumClassName = 'SharedEnum';
      const sharedEnumFileName = 'shared_enum';
      const projectModelClassName = 'ProjectModel';
      const projectModelFileName = 'project_model';

      late EnumDefinition sharedEnum;
      late ModelClassDefinition projectModel;
      late Map<String, String> codeMap;

      setUpAll(() {
        sharedEnum = EnumDefinitionBuilder()
            .withClassName(sharedEnumClassName)
            .withFileName(sharedEnumFileName)
            .withValues([
              ProtocolEnumValueDefinition('one'),
              ProtocolEnumValueDefinition('two'),
            ])
            .withSharedPackageName(sharedPackageName)
            .build();

        var sharedModelType = TypeDefinition(
          className: sharedEnum.className,
          nullable: true,
          url: defaultModuleAlias,
          projectModelDefinition: sharedEnum,
        );

        projectModel = ModelClassDefinitionBuilder()
            .withClassName(projectModelClassName)
            .withFileName(projectModelFileName)
            .withSimpleField('id', 'int')
            .withField(
              FieldDefinitionBuilder()
                  .withName('nested')
                  .withType(sharedModelType)
                  .withScope(ModelFieldScopeDefinition.all)
                  .build(),
            )
            .build();
      });

      group('when generating the client package code', () {
        setUpAll(() {
          codeMap = const DartClientCodeGenerator()
              .generateSerializableModelsCode(
                models: [sharedEnum, projectModel],
                config: config,
              );
        });

        late var modelExpectedFilePath = projectModel.getFullFilePath(
          config,
          serverCode: false,
        );

        late var modelCode = codeMap[modelExpectedFilePath]!;

        test(
          'then the field type references the shared enum class.',
          () {
            expect(modelCode, contains(sharedEnumClassName));
          },
        );

        test(
          'then the project model file imports the shared enum class from the shared package.',
          () {
            expect(
              modelCode,
              contains('package:$sharedPackageName/$sharedPackageName.dart'),
            );
          },
        );
      });

      group('when generating the server package code', () {
        setUpAll(() {
          codeMap = const DartServerCodeGenerator()
              .generateSerializableModelsCode(
                models: [sharedEnum, projectModel],
                config: config,
              );
        });
      });

      late var modelExpectedFilePath = projectModel.getFullFilePath(
        config,
        serverCode: true,
      );

      late var modelCode = codeMap[modelExpectedFilePath]!;

      test(
        'then the field type references the shared enum class.',
        () {
          expect(modelCode, contains(sharedEnumClassName));
        },
      );

      test(
        'then the project model file imports the shared enum class from the shared package.',
        () {
          expect(
            modelCode,
            contains('package:$sharedPackageName/$sharedPackageName.dart'),
          );
        },
      );
    },
  );
}
