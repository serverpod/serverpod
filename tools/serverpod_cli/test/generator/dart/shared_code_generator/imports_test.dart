import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/generator/dart/shared_code_generator.dart';
import 'package:serverpod_cli/src/generator/shared.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:test/test.dart';

import '../../../test_util/builders/endpoint_definition_builder.dart';
import '../../../test_util/builders/exception_class_definition_builder.dart';
import '../../../test_util/builders/generator_config_builder.dart';
import '../../../test_util/builders/method_definition_builder.dart';
import '../../../test_util/builders/model_class_definition_builder.dart';
import '../../../test_util/builders/parameter_definition_builder.dart';
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
  String getExpectedFilePath(String fileName, {List<String>? subDirParts}) =>
      p.joinAll([
        ...serverPathParts,
        'packages',
        'shared',
        'lib',
        'src',
        'generated',
        ...?subDirParts,
        '$fileName.dart',
      ]);

  group(
    'Given a hierarchy with a sealed parent that has a model and a normal child, when generating code',
    () {
      var parent = ModelClassDefinitionBuilder()
          .withSubDirParts(['subdir'])
          .withClassName('Example')
          .withFileName('example')
          .withField(
            FieldDefinitionBuilder()
                .withName('user')
                .withType(
                  TypeDefinitionBuilder()
                      .withClassName('User')
                      .withUrl(defaultModuleAlias)
                      .build(),
                )
                .build(),
          )
          .withIsSealed(true)
          .withSharedPackageName(sharedPackageName)
          .build();

      var child = ModelClassDefinitionBuilder()
          .withSubDirParts(['subdir'])
          .withClassName('ExampleChild')
          .withFileName('example_child')
          .withSimpleField('age', 'int')
          .withExtendsClass(parent)
          .withSharedPackageName(sharedPackageName)
          .build();

      var user = ModelClassDefinitionBuilder()
          .withSubDirParts(['subdir'])
          .withClassName('User')
          .withFileName('user')
          .withSimpleField('name', 'String')
          .withSharedPackageName(sharedPackageName)
          .build();

      parent.childClasses.add(ResolvedInheritanceDefinition(child));

      var models = [
        parent,
        child,
        user,
      ];

      late var codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      late var parentCompilationUnit = parseString(
        content:
            codeMap[getExpectedFilePath(
              parent.fileName,
              subDirParts: ['subdir'],
            )]!,
      ).unit;

      test(
        'then the ${parent.className} has a relative protocol import directive correctly generated',
        () {
          var protocolImport = CompilationUnitHelpers.tryFindImportDirective(
            parentCompilationUnit,
            uri: '../protocol.dart',
          );

          expect(protocolImport, isNotNull);
        },
      );
    },
  );

  group(
    'Given a hierarchy with a sealed parent exception that has a model and a normal child, when generating code',
    () {
      var parent = ExceptionClassDefinitionBuilder()
          .withSubDirParts(['subdir'])
          .withClassName('AppException')
          .withFileName('app_exception')
          .withField(
            FieldDefinitionBuilder()
                .withName('user')
                .withType(
                  TypeDefinitionBuilder()
                      .withClassName('User')
                      .withUrl(defaultModuleAlias)
                      .build(),
                )
                .build(),
          )
          .withIsSealed(true)
          .withSharedPackageName(sharedPackageName)
          .build();

      var child = ExceptionClassDefinitionBuilder()
          .withSubDirParts(['subdir'])
          .withClassName('NotFoundException')
          .withFileName('not_found_exception')
          .withSimpleField('code', 'int')
          .withExtendsClass(parent)
          .withSharedPackageName(sharedPackageName)
          .build();

      var user = ModelClassDefinitionBuilder()
          .withSubDirParts(['subdir'])
          .withClassName('User')
          .withFileName('user')
          .withSimpleField('name', 'String')
          .withSharedPackageName(sharedPackageName)
          .build();

      parent.childClasses.add(ResolvedInheritanceDefinition(child));

      var models = [
        parent,
        child,
        user,
      ];

      late var codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      late var parentCompilationUnit = parseString(
        content:
            codeMap[getExpectedFilePath(
              parent.fileName,
              subDirParts: ['subdir'],
            )]!,
      ).unit;

      test(
        'then the ${parent.className} has a relative protocol import directive correctly generated',
        () {
          var protocolImport = CompilationUnitHelpers.tryFindImportDirective(
            parentCompilationUnit,
            uri: '../protocol.dart',
          );

          expect(protocolImport, isNotNull);
        },
      );
    },
  );

  group(
    'Given an endpoint that has a UuidValue parameter imported from Serverpod when generating shared code',
    () {
      var endpoint = EndpointDefinitionBuilder()
          .withClassName('ExampleEndpoint')
          .withName('example')
          .withMethods([
            MethodDefinitionBuilder().withName('getById').withParameters([
              ParameterDefinitionBuilder()
                  .withName('id')
                  .withType(
                    TypeDefinitionBuilder()
                        .withClassName('UuidValue')
                        .withUrl('serverpod')
                        .build(),
                  )
                  .build(),
            ]).buildMethodCallDefinition(),
          ])
          .build();

      var protocolDefinition = ProtocolDefinition(
        endpoints: [endpoint],
        models: [],
        futureCalls: [],
      );

      late var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      test('then the shared package is not generated', () {
        expect(codeMap, isEmpty);
      });
    },
  );

  group(
    'Given a shared model when generating code,',
    () {
      const modelFileName = 'shared_example';

      late final models = [
        ModelClassDefinitionBuilder()
            .withClassName('SharedExample')
            .withFileName(modelFileName)
            .withSimpleField('name', 'String')
            .withSharedPackageName(sharedPackageName)
            .build(),
      ];

      late final codeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      late final modelSource = codeMap[getExpectedFilePath(modelFileName)]!;

      late final modelCompilationUnit = parseString(
        content: modelSource,
      ).unit;

      test(
        'then the generated model does not import serverpod_client.',
        () {
          expect(modelSource, isNot(contains(serverpodUrl(false))));
          expect(modelSource, isNot(contains(serverpodProtocolUrl(false))));
        },
      );

      test(
        'then SerializableModel is imported from serverpod_serialization.',
        () {
          expect(
            CompilationUnitHelpers.hasImportDirective(
              modelCompilationUnit,
              uri: serverpodSerializationUrl,
            ),
            isTrue,
          );
          expect(modelSource, contains('implements'));
          expect(modelSource, contains('SerializableModel'));
        },
      );
    },
  );

  group(
    'Given a shared package protocol when generating code,',
    () {
      late final protocolDefinition = ProtocolDefinition(
        endpoints: [],
        models: [
          ModelClassDefinitionBuilder()
              .withClassName('SharedExample')
              .withFileName('shared_example')
              .withSimpleField('name', 'String')
              .withSharedPackageName(sharedPackageName)
              .build(),
        ],
        futureCalls: [],
      );

      late final codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      late final protocolSource = codeMap[getExpectedFilePath('protocol')]!;

      late final protocolCompilationUnit = parseString(
        content: protocolSource,
      ).unit;

      test(
        'then the generated protocol does not import serverpod_client.',
        () {
          expect(protocolSource, isNot(contains(serverpodUrl(false))));
          expect(protocolSource, isNot(contains(serverpodProtocolUrl(false))));
        },
      );

      test(
        'then SerializationManager is imported from serverpod_serialization.',
        () {
          expect(
            CompilationUnitHelpers.hasImportDirective(
              protocolCompilationUnit,
              uri: serverpodSerializationUrl,
            ),
            isTrue,
          );
          expect(
            protocolSource,
            contains('extends _i1.SerializationManager'),
          );
        },
      );
    },
  );

  group(
    'Given a shared model with a database table when generating code,',
    () {
      const tableModelFileName = 'shared_table_record';

      late final models = [
        ModelClassDefinitionBuilder()
            .withClassName('SharedTableRecord')
            .withFileName(tableModelFileName)
            .withTableName('shared_table_record')
            .withDatabase(ModelDatabaseDefinition.all)
            .withSharedPackageName(sharedPackageName)
            .build(),
      ];

      late final modelCodeMap = generator.generateSerializableModelsCode(
        models: models,
        config: config,
      );

      late final modelSource =
          modelCodeMap[getExpectedFilePath(tableModelFileName)]!;

      late final modelCompilationUnit = parseString(
        content: modelSource,
      ).unit;

      late final protocolCodeMap = generator.generateProtocolCode(
        protocolDefinition: ProtocolDefinition(
          endpoints: [],
          models: models,
          futureCalls: [],
        ),
        config: config,
      );

      late final protocolSource =
          protocolCodeMap[getExpectedFilePath('protocol')]!;

      late final protocolCompilationUnit = parseString(
        content: protocolSource,
      ).unit;

      test(
        'then the generated model does not import serverpod_client.',
        () {
          expect(modelSource, isNot(contains(serverpodUrl(false))));
          expect(modelSource, isNot(contains(serverpodProtocolUrl(false))));
        },
      );

      test(
        'then the generated table class is imported from serverpod_database.',
        () {
          expect(
            CompilationUnitHelpers.hasImportDirective(
              modelCompilationUnit,
              uri: serverpodDatabaseUrl(false),
            ),
            isTrue,
          );
          expect(
            CompilationUnitHelpers.hasExtendsClause(
              CompilationUnitHelpers.tryFindClassDeclaration(
                modelCompilationUnit,
                name: 'SharedTableRecordTable',
              )!,
              name: 'Table',
            ),
            isTrue,
          );
        },
      );

      test(
        'then the generated protocol does not import serverpod_client.',
        () {
          expect(protocolSource, isNot(contains(serverpodUrl(false))));
          expect(protocolSource, isNot(contains(serverpodProtocolUrl(false))));
        },
      );

      test(
        'then the generated protocol extends DatabaseSerializationManager from serverpod_database.',
        () {
          expect(
            CompilationUnitHelpers.hasImportDirective(
              protocolCompilationUnit,
              uri: serverpodDatabaseUrl(false),
            ),
            isTrue,
          );
          expect(
            protocolSource,
            contains('extends'),
          );
          expect(
            protocolSource,
            contains('DatabaseSerializationManager'),
          );
        },
      );
    },
  );

  group(
    'Given a shared package protocol for a project whose Dart client depends on serverpod_service_client when generating code,',
    () {
      const serviceClientProjectName = 'serverpod_test_sqlite';
      const serviceClientSharedPackageName = 'serverpod_test_shared';

      late final serviceClientConfig = GeneratorConfigBuilder()
          .withName(serviceClientProjectName)
          .withDartClientDependsOnServiceClient(true)
          .withSharedModelsSourcePathsParts({
            serviceClientSharedPackageName: [
              '..',
              serviceClientSharedPackageName,
            ],
          })
          .build();

      late final serviceClientProtocolDefinition = ProtocolDefinition(
        endpoints: [],
        models: [
          ModelClassDefinitionBuilder()
              .withClassName('SharedModel')
              .withSharedPackageName(serviceClientSharedPackageName)
              .build(),
        ],
        futureCalls: [],
      );

      late final serviceClientCodeMap = generator.generateProtocolCode(
        protocolDefinition: serviceClientProtocolDefinition,
        config: serviceClientConfig,
      );

      late final serviceClientProtocolSource =
          serviceClientCodeMap[p.join(
            '..',
            serviceClientSharedPackageName,
            'lib',
            'src',
            'generated',
            'protocol.dart',
          )]!;

      late final serviceClientProtocolCompilationUnit = parseString(
        content: serviceClientProtocolSource,
      ).unit;

      test(
        'then the generated protocol does not import serverpod_service_client.',
        () {
          expect(
            CompilationUnitHelpers.hasImportDirective(
              serviceClientProtocolCompilationUnit,
              uri: serverpodServiceClientUrl(false),
            ),
            isFalse,
          );
          expect(
            serviceClientProtocolSource,
            isNot(contains(serverpodUrl(false))),
          );
          expect(
            serviceClientProtocolSource,
            isNot(contains(serverpodProtocolUrl(false))),
          );
        },
      );

      test(
        'then deserialization delegates to Protocol from serverpod_database.',
        () {
          expect(
            serviceClientProtocolSource,
            contains('Protocol().deserialize<T>(data, t)'),
          );
          expect(
            CompilationUnitHelpers.hasImportDirective(
              serviceClientProtocolCompilationUnit,
              uri: serverpodDatabaseUrl(false),
            ),
            isTrue,
          );
        },
      );

      test(
        'then mapRecordToJson delegates to Protocol from serverpod_database.',
        () {
          expect(
            serviceClientProtocolSource,
            contains('Protocol().mapRecordToJson(record)'),
          );
        },
      );
    },
  );
}
