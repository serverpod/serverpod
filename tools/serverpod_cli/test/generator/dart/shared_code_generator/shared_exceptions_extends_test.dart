import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:serverpod_cli/src/generator/dart/library_generators/util/model_generators_util.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:serverpod_cli/src/generator/dart/shared_code_generator.dart';
import 'package:serverpod_cli/src/generator/types.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/exception_class_definition_builder.dart';
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
    'Given a shared parent exception and a shared child that extends the parent '
    'when generating the shared package code',
    () {
      const parentClassName = 'SharedAppException';
      const parentClassFileName = 'shared_app_exception';
      const childClassName = 'SharedNotFoundException';
      const childClassFileName = 'shared_not_found_exception';

      var childExpectedFilePath = path.joinAll([
        ...serverPathParts,
        'packages',
        'shared',
        'lib',
        'src',
        'generated',
        '$childClassFileName.dart',
      ]);

      late ExceptionClassDefinition sharedParent;
      late ExceptionClassDefinition sharedChild;
      late Map<String, String> codeMap;

      setUpAll(() {
        sharedParent = ExceptionClassDefinitionBuilder()
            .withClassName(parentClassName)
            .withFileName(parentClassFileName)
            .withSimpleField('message', 'String')
            .withSharedPackageName(sharedPackageName)
            .build();

        sharedChild = ExceptionClassDefinitionBuilder()
            .withClassName(childClassName)
            .withFileName(childClassFileName)
            .withSimpleField('code', 'int')
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

      test('then the shared child exception is generated.', () {
        expect(codeMap, containsPair(childExpectedFilePath, isA<String>()));
      });

      late var childCode = codeMap[childExpectedFilePath]!;

      test('then the shared child exception extends the shared parent.', () {
        expect(
          childCode,
          contains('$childClassName extends $parentClassName'),
        );
      });
    },
  );

  group(
    'Given a shared parent exception and a project child that extends the parent '
    'when generating the server package code',
    () {
      const parentClassName = 'SharedAppException';
      const parentClassFileName = 'shared_app_exception';
      const childClassName = 'ProjectNotFoundException';
      const childClassFileName = 'project_not_found_exception';

      var childExpectedFilePath = path.joinAll([
        ...serverPathParts,
        'lib',
        'src',
        'generated',
        '$childClassFileName.dart',
      ]);

      late ExceptionClassDefinition sharedParent;
      late ExceptionClassDefinition projectChild;
      late Map<String, String> codeMap;

      setUpAll(() {
        sharedParent = ExceptionClassDefinitionBuilder()
            .withClassName(parentClassName)
            .withFileName(parentClassFileName)
            .withSimpleField('message', 'String')
            .withSharedPackageName(sharedPackageName)
            .build();

        projectChild = ExceptionClassDefinitionBuilder()
            .withClassName(childClassName)
            .withFileName(childClassFileName)
            .withSimpleField('code', 'int')
            .withExtendsClass(sharedParent)
            .build();

        sharedParent.childClasses.add(
          ResolvedInheritanceDefinition(projectChild),
        );

        codeMap = const DartServerCodeGenerator()
            .generateSerializableModelsCode(
              models: [sharedParent, projectChild],
              config: config,
            );
      });

      test('then the project child exception is generated.', () {
        expect(codeMap, containsPair(childExpectedFilePath, isA<String>()));
      });

      late var childCode = codeMap[childExpectedFilePath]!;

      test(
        'then the project child exception extends the shared parent.',
        () {
          expect(
            childCode,
            contains('$childClassName extends $parentClassName'),
          );
        },
      );
    },
  );

  group(
    'Given a shared parent exception and a project child that extends the parent '
    'when generating the client package code',
    () {
      const parentClassName = 'SharedAppException';
      const parentClassFileName = 'shared_app_exception';
      const childClassName = 'ProjectNotFoundException';
      const childClassFileName = 'project_not_found_exception';

      late ExceptionClassDefinition sharedParent;
      late ExceptionClassDefinition projectChild;
      late Map<String, String> codeMap;

      setUpAll(() {
        sharedParent = ExceptionClassDefinitionBuilder()
            .withClassName(parentClassName)
            .withFileName(parentClassFileName)
            .withSimpleField('message', 'String')
            .withSharedPackageName(sharedPackageName)
            .build();

        projectChild = ExceptionClassDefinitionBuilder()
            .withClassName(childClassName)
            .withFileName(childClassFileName)
            .withSimpleField('code', 'int')
            .withExtendsClass(sharedParent)
            .build();

        sharedParent.childClasses.add(
          ResolvedInheritanceDefinition(projectChild),
        );

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

      test('then the project child exception is generated.', () {
        expect(codeMap, containsPair(childExpectedFilePath, isA<String>()));
      });

      late var childCode = codeMap[childExpectedFilePath]!;

      test(
        'then the project child exception extends the shared parent.',
        () {
          expect(
            childCode,
            contains('$childClassName extends $parentClassName'),
          );
        },
      );
    },
  );

  group(
    'Given a project model with a field that references a shared exception',
    () {
      const sharedExceptionClassName = 'SharedAppException';
      const sharedExceptionFileName = 'shared_app_exception';
      const projectModelClassName = 'ProjectModel';
      const projectModelFileName = 'project_model';

      late ExceptionClassDefinition sharedException;
      late ModelClassDefinition projectModel;
      late Map<String, String> codeMap;

      setUpAll(() {
        sharedException = ExceptionClassDefinitionBuilder()
            .withClassName(sharedExceptionClassName)
            .withFileName(sharedExceptionFileName)
            .withSimpleField('message', 'String')
            .withSharedPackageName(sharedPackageName)
            .build();

        var sharedExceptionType = TypeDefinition(
          className: sharedException.className,
          nullable: true,
          url: defaultModuleAlias,
          projectModelDefinition: sharedException,
        );

        projectModel = ModelClassDefinitionBuilder()
            .withClassName(projectModelClassName)
            .withFileName(projectModelFileName)
            .withSimpleField('id', 'int')
            .withField(
              FieldDefinitionBuilder()
                  .withName('error')
                  .withType(sharedExceptionType)
                  .withScope(ModelFieldScopeDefinition.all)
                  .build(),
            )
            .build();
      });

      group('when generating the client package code', () {
        setUpAll(() {
          codeMap = const DartClientCodeGenerator()
              .generateSerializableModelsCode(
                models: [sharedException, projectModel],
                config: config,
              );
        });

        late var modelExpectedFilePath = projectModel.getFullFilePath(
          config,
          serverCode: false,
        );

        late var modelCode = codeMap[modelExpectedFilePath]!;

        test(
          'then the field type references the shared exception class.',
          () {
            expect(modelCode, contains(sharedExceptionClassName));
          },
        );

        test(
          'then the project model file imports the shared exception class from the shared package.',
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
                models: [sharedException, projectModel],
                config: config,
              );
        });

        late var modelExpectedFilePath = projectModel.getFullFilePath(
          config,
          serverCode: true,
        );

        late var modelCode = codeMap[modelExpectedFilePath]!;

        test(
          'then the field type references the shared exception class.',
          () {
            expect(modelCode, contains(sharedExceptionClassName));
          },
        );

        test(
          'then the project model file imports the shared exception class from the shared package.',
          () {
            expect(
              modelCode,
              contains('package:$sharedPackageName/$sharedPackageName.dart'),
            );
          },
        );
      });
    },
  );
}
