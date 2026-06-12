import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
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
    .withName(projectName)
    .withServerPackageDirectoryPathParts(serverPathParts)
    .withSharedModelsSourcePathsParts({
      sharedPackageName: ['packages', 'shared'],
    })
    .withModules([])
    .build();
const generator = DartServerCodeGenerator();

void main() {
  var testClassName = 'SharedModel';
  var testClassFileName = 'shared_model';

  var testContainerClassName = 'SharedModelContainer';
  var testContainerClassFileName = 'shared_model_container';
  var testContainerExpectedFilePath = path.joinAll([
    ...serverPathParts,
    'lib',
    'src',
    'generated',
    '$testContainerClassFileName.dart',
  ]);

  group(
    'Given a server model with a shared package class field '
    'when generating toJsonForProtocol',
    () {
      late ModelClassDefinition sharedModel;
      late ModelClassDefinition containerModel;
      late Map<String, String> codeMap;

      setUpAll(() {
        sharedModel = ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withSimpleField('name', 'String')
            .withSharedPackageName(sharedPackageName)
            .build();

        var sharedModelType = TypeDefinitionBuilder()
            .withClassName(testClassName)
            .withNullable(false)
            .withUrl(sharedPackageName)
            .withModelDefinition(sharedModel)
            .build();

        containerModel = ModelClassDefinitionBuilder()
            .withClassName(testContainerClassName)
            .withFileName(testContainerClassFileName)
            .withField(
              FieldDefinitionBuilder()
                  .withName('sharedModelField')
                  .withType(sharedModelType)
                  .build(),
            )
            .build();

        codeMap = generator.generateSerializableModelsCode(
          models: [sharedModel, containerModel],
          config: config,
        );
      });

      test(
        'then toJsonForProtocol uses toJson for shared model field, not toJsonForProtocol.',
        () {
          expect(codeMap.containsKey(testContainerExpectedFilePath), isTrue);

          var compilationUnit = parseString(
            content: codeMap[testContainerExpectedFilePath]!,
          ).unit;
          var containerClass = CompilationUnitHelpers.tryFindClassDeclaration(
            compilationUnit,
            name: testContainerClassName,
          );
          expect(containerClass, isNotNull);

          var toJsonForProtocolMethod =
              CompilationUnitHelpers.tryFindMethodDeclaration(
                containerClass!,
                name: 'toJsonForProtocol',
              );
          expect(toJsonForProtocolMethod, isNotNull);

          var code = toJsonForProtocolMethod!.toSource();

          expect(
            code.contains('sharedModelField.toJson()'),
            isTrue,
            reason:
                'Shared model fields must use toJson() since they do not '
                'implement ProtocolSerialization',
          );
          expect(
            code.contains('sharedModelField.toJsonForProtocol()'),
            isFalse,
            reason:
                'Shared model fields must NOT use toJsonForProtocol() '
                'as they do not implement ProtocolSerialization',
          );
        },
      );

      test('then toJson method uses toJson for shared model field.', () {
        var compilationUnit = parseString(
          content: codeMap[testContainerExpectedFilePath]!,
        ).unit;
        var containerClass = CompilationUnitHelpers.tryFindClassDeclaration(
          compilationUnit,
          name: testContainerClassName,
        );

        var toJsonMethod = CompilationUnitHelpers.tryFindMethodDeclaration(
          containerClass!,
          name: 'toJson',
        );
        expect(toJsonMethod, isNotNull);
        expect(toJsonMethod!.toSource(), contains('sharedModelField.toJson()'));
      });
    },
  );

  group(
    'Given a server model with List<SharedModel> field '
    'when generating toJsonForProtocol',
    () {
      late ModelClassDefinition sharedModel;
      late ModelClassDefinition containerModel;
      late Map<String, String> codeMap;

      setUpAll(() {
        sharedModel = ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withSimpleField('name', 'String')
            .withSharedPackageName(sharedPackageName)
            .build();

        var sharedModelType = TypeDefinitionBuilder()
            .withClassName(testClassName)
            .withNullable(false)
            .withUrl(sharedPackageName)
            .withModelDefinition(sharedModel)
            .build();

        var listOfSharedModelType = TypeDefinitionBuilder()
            .withClassName('List')
            .withNullable(false)
            .withGenerics([sharedModelType])
            .build();

        containerModel = ModelClassDefinitionBuilder()
            .withClassName(testContainerClassName)
            .withFileName(testContainerClassFileName)
            .withField(
              FieldDefinitionBuilder()
                  .withName('sharedModelList')
                  .withType(listOfSharedModelType)
                  .withShouldPersist(false)
                  .build(),
            )
            .build();

        codeMap = generator.generateSerializableModelsCode(
          models: [sharedModel, containerModel],
          config: config,
        );
      });

      test(
        'then toJsonForProtocol uses toJson in valueToJson for List elements.',
        () {
          expect(codeMap.containsKey(testContainerExpectedFilePath), isTrue);

          var code = codeMap[testContainerExpectedFilePath]!;

          expect(
            code.contains('valueToJson: (v) => v.toJson()'),
            isTrue,
            reason:
                'List<SharedModel> valueToJson must use toJson() for elements',
          );
          expect(
            code.contains('valueToJson: (v) => v.toJsonForProtocol()'),
            isFalse,
            reason:
                'List<SharedModel> must NOT use toJsonForProtocol() for elements',
          );
        },
      );
    },
  );
  group(
    'Given a server model with shared package class field where type has null url but projectModelDefinition is shared model',
    () {
      late ModelClassDefinition sharedModel;
      late ModelClassDefinition containerModel;
      late Map<String, String> codeMap;

      setUpAll(() {
        sharedModel = ModelClassDefinitionBuilder()
            .withClassName(testClassName)
            .withFileName(testClassFileName)
            .withSimpleField('name', 'String')
            .withSharedPackageName(sharedPackageName)
            .build();

        // NOTE: null url simulates type parsed from bare "SharedModel" in YAML
        // before applyProtocolReferences sets url. The projectModelDefinition
        // identifies it as a shared model, so reference() should still produce
        // the correct package import.
        var sharedModelType = TypeDefinitionBuilder()
            .withClassName(testClassName)
            .withNullable(false)
            .withModelDefinition(sharedModel)
            .build();

        containerModel = ModelClassDefinitionBuilder()
            .withClassName(testContainerClassName)
            .withFileName(testContainerClassFileName)
            .withField(
              FieldDefinitionBuilder()
                  .withName('sharedModelField')
                  .withType(sharedModelType)
                  .build(),
            )
            .build();

        codeMap = generator.generateSerializableModelsCode(
          models: [sharedModel, containerModel],
          config: config,
        );
      });

      test(
        'then generated code imports shared package and uses SharedModel type',
        () {
          expect(codeMap.containsKey(testContainerExpectedFilePath), isTrue);

          var code = codeMap[testContainerExpectedFilePath]!;

          expect(
            code.contains('package:$sharedPackageName/$sharedPackageName.dart'),
            isTrue,
            reason:
                'When url is null but projectModelDefinition is shared model, '
                'reference() must still produce the shared package import',
          );
          expect(
            code.contains(testClassName),
            isTrue,
            reason: 'Generated code must reference the shared model class',
          );
        },
      );
    },
  );
}
