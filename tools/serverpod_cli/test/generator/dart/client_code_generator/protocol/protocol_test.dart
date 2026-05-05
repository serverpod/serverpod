import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/models/definitions.dart';
import 'package:serverpod_cli/src/generator/dart/client_code_generator.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/endpoint_definition_builder.dart';
import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/method_definition_builder.dart';
import '../../../../test_util/builders/model_class_definition_builder.dart';
import '../../../../test_util/builders/parameter_definition_builder.dart';
import '../../../../test_util/builders/serializable_entity_field_definition_builder.dart';
import '../../../../test_util/builders/type_definition_builder.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartClientCodeGenerator();

void main() {
  var expectedFileName = path.join(
    '..',
    'example_project_client',
    'lib',
    'src',
    'protocol',
    'protocol.dart',
  );
  var expectedClientFileName = path.join(
    '..',
    'example_project_client',
    'lib',
    'src',
    'protocol',
    'client.dart',
  );
  var expectedMigrationRegistryFileName = path.join(
    '..',
    'example_project_client',
    'lib',
    'migrations',
    'migration_registry.dart',
  );

  group(
    'Given a client database table when generating protocol files',
    () {
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName('Example')
            .withFileName('example')
            .withTableName('example')
            .withDatabase(ModelDatabaseDefinition.client)
            .build(),
      ];

      var protocolDefinition = ProtocolDefinition(
        endpoints: [],
        models: models,
        futureCalls: [],
      );

      var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      test(
        'then the protocol.dart extends the database serialization manager.',
        () {
          expect(
            codeMap[expectedFileName],
            contains('DatabaseSerializationManager'),
          );
        },
      );

      test(
        'then the protocol.dart does not expose client migrations directly.',
        () {
          expect(
            codeMap[expectedFileName],
            isNot(contains('clientMigrations')),
          );
        },
      );

      test(
        'then the client.dart wires the generated migration registry into createSession.',
        () {
          expect(
            codeMap[expectedClientFileName],
            contains('clientMigrations: MigrationRegistry.migrations'),
          );
          expect(
            codeMap[expectedClientFileName],
            contains(
              'package:example_project_client/migrations/migration_registry.dart',
            ),
          );
        },
      );

      test(
        'then the migration registry placeholder file is created.',
        () {
          expect(codeMap[expectedMigrationRegistryFileName], isNotNull);
          expect(
            codeMap[expectedMigrationRegistryFileName],
            contains('class MigrationRegistry'),
          );
        },
      );
    },
  );

  group(
    'Given a client database table and a Dart module dependency that also has client database tables, '
    'when generating protocol files,',
    () {
      var moduleAwareConfig = GeneratorConfigBuilder()
          .withName(projectName)
          .withAuthModule()
          .build();

      var models = [
        ModelClassDefinitionBuilder()
            .withClassName('Example')
            .withFileName('example')
            .withTableName('example')
            .withDatabase(ModelDatabaseDefinition.client)
            .build(),
      ];

      var protocolDefinition = ProtocolDefinition(
        endpoints: [],
        models: models,
        futureCalls: [],
      );

      var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: moduleAwareConfig,
      );

      test(
        'then targetTableDefinitions conditionally merges table definitions from module protocols that implement DatabaseSerializationManager.',
        () {
          var protocol = codeMap[expectedFileName]!;
          expect(
            protocol,
            matches(
              RegExp(
                r'    \.\.\._i(\d+)\.Protocol\(\) is _i\d+\.DatabaseSerializationManager\n'
                r'        \? _i\1\.Protocol\.targetTableDefinitions\n'
                r'        : \[\],\n'
                r'  \];',
              ),
            ),
          );
        },
      );

      test(
        'then getTableForType resolves tables from module protocols only when they implement DatabaseSerializationManager.',
        () {
          var protocol = codeMap[expectedFileName]!;
          expect(
            protocol,
            matches(
              RegExp(
                r'  @override\n'
                r'  _i(\d+)\.Table\? getTableForType\(Type t\) \{\n'
                r'    \{\n'
                r'      var table = _i(\d+)\.Protocol\(\) is _i\1\.DatabaseSerializationManager\n'
                r'          \? _i\2\.Protocol\(\).getTableForType\(t\)\n'
                r'          : null;\n'
                r'      if \(table != null\) \{\n'
                r'        return table;\n'
                r'      \}\n'
                r'    \}\n'
                r'    switch \(t\) \{\n'
                r'      case _i(\d+)\.Example:\n'
                r'        return _i\3\.Example\.t;\n'
                r'    \}\n'
                r'    return null;\n'
                r'  \}',
              ),
            ),
          );
        },
      );

      test(
        'then protocol.dart imports the module client package for module table metadata.',
        () {
          expect(
            codeMap[expectedFileName],
            contains(
              "import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i",
            ),
          );
        },
      );
    },
  );

  group(
    'Given model with server only field with list of server only model when generating protocol files',
    () {
      var serverOnlyModel = 'server_only_model';
      var modelWithServerOnlyListField = 'model_with_server_only_list_field';
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(serverOnlyModel.pascalCase)
            .withFileName(serverOnlyModel)
            .withServerOnly(true)
            .build(),
        ModelClassDefinitionBuilder()
            .withClassName(modelWithServerOnlyListField.pascalCase)
            .withFileName(modelWithServerOnlyListField)
            .withListField(
              'serverOnlyModelField',
              serverOnlyModel.pascalCase,
              scope: ModelFieldScopeDefinition.serverOnly,
            )
            .build(),
      ];

      var protocolDefinition = ProtocolDefinition(
        endpoints: [],
        models: models,
        futureCalls: [],
      );

      var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      test(
        'then the protocol.dart file is created.',
        () {
          expect(codeMap[expectedFileName], isNotNull);
        },
      );

      test(
        'then the protocol.dart does not contain server only model deserialization.',
        () {
          expect(
            codeMap[expectedFileName],
            isNot(contains(serverOnlyModel.pascalCase)),
          );
        },
      );
    },
  );

  group(
    'Given model with server only field with map of server only model when generating protocol files',
    () {
      var serverOnlyModel = 'server_only_model';
      var modelWithServerOnlyListField = 'model_with_server_only_list_field';
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(serverOnlyModel.pascalCase)
            .withFileName(serverOnlyModel)
            .withServerOnly(true)
            .build(),
        ModelClassDefinitionBuilder()
            .withClassName(modelWithServerOnlyListField.pascalCase)
            .withFileName(modelWithServerOnlyListField)
            .withMapField(
              'serverOnlyModelField',
              keyType: 'String',
              valueType: serverOnlyModel.pascalCase,
              scope: ModelFieldScopeDefinition.serverOnly,
            )
            .build(),
      ];

      var protocolDefinition = ProtocolDefinition(
        endpoints: [],
        models: models,
        futureCalls: [],
      );

      var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      test(
        'then the protocol.dart file is created.',
        () {
          expect(codeMap[expectedFileName], isNotNull);
        },
      );

      test(
        'then the protocol.dart does not contain server only model deserialization.',
        () {
          expect(
            codeMap[expectedFileName],
            isNot(contains(serverOnlyModel.pascalCase)),
          );
        },
      );
    },
  );

  group(
    'Given an endpoint with Stream with model generic return type when generating protocol files',
    () {
      var modelName = 'example_model';
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(modelName.pascalCase)
            .withFileName(modelName)
            .build(),
      ];
      var endpoints = [
        EndpointDefinitionBuilder().withMethods([
          MethodDefinitionBuilder()
              .withName('streamingMethod')
              .withReturnType(
                TypeDefinitionBuilder()
                    .withStreamOf(modelName.pascalCase)
                    .build(),
              )
              .buildMethodCallDefinition(),
        ]).build(),
      ];

      var protocolDefinition = ProtocolDefinition(
        endpoints: endpoints,
        models: models,
        futureCalls: [],
      );

      var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      test(
        'then the protocol.dart file is created.',
        () {
          expect(codeMap[expectedFileName], isNotNull);
        },
      );

      test(
        'then the protocol.dart contains deserialization for the model type.',
        () {
          expect(
            codeMap[expectedFileName],
            contains(modelName.pascalCase),
          );
        },
      );
    },
  );

  group(
    'Given a model with a field with list of other model when generating protocol files',
    () {
      var testModelName = 'TestModel';
      var testModelFileName = 'test_model.dart';
      var modelWithListName = 'modelWithList';
      var modelWithListFileName = 'model_with_list.dart';
      var testModel = ModelClassDefinitionBuilder()
          .withClassName(testModelName)
          .withFileName(testModelFileName)
          .build();
      var models = [
        testModel,
        ModelClassDefinitionBuilder()
            .withClassName(modelWithListName)
            .withFileName(modelWithListFileName)
            .withField(
              FieldDefinitionBuilder()
                  .withName('model')
                  .withType(
                    TypeDefinitionBuilder()
                        .withListOf(
                          testModelName,
                          url: defaultModuleAlias,
                          modelInfo: testModel,
                        )
                        .build(),
                  )
                  .build(),
            )
            .build(),
      ];

      var protocolDefinition = ProtocolDefinition(
        endpoints: [],
        models: models,
        futureCalls: [],
      );

      var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      test(
        'then the protocol.dart file is created.',
        () {
          expect(codeMap[expectedFileName], isNotNull);
        },
      );

      test(
        'then the protocol.dart does not contain import to itself.',
        () {
          expect(
            codeMap[expectedFileName],
            isNot(contains("import 'protocol.dart' as")),
          );
        },
      );
    },
  );

  group(
    'Given an endpoint that takes a list of models as a parameter when generating protocol files',
    () {
      var testModelName = 'TestModel';
      var testModelFileName = 'test_model.dart';
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testModelName)
            .withFileName(testModelFileName)
            .build(),
      ];

      var endpoints = [
        EndpointDefinitionBuilder().withMethods([
          MethodDefinitionBuilder().withName('myEndpoint').withParameters([
            ParameterDefinitionBuilder()
                .withType(
                  TypeDefinitionBuilder().withClassName('List').withGenerics([
                    TypeDefinitionBuilder()
                        .withClassName(testModelName)
                        .withNullable(false)
                        .withUrl(defaultModuleAlias)
                        .withModelDefinition(models.first)
                        .build(),
                  ]).build(),
                )
                .build(),
          ]).buildMethodCallDefinition(),
        ]).build(),
      ];

      var protocolDefinition = ProtocolDefinition(
        endpoints: endpoints,
        models: models,
        futureCalls: [],
      );

      var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      test(
        'then the protocol.dart file is created.',
        () {
          expect(codeMap[expectedFileName], isNotNull);
        },
      );

      test(
        'then the protocol.dart does not contain import to itself.',
        () {
          expect(
            codeMap[expectedFileName],
            isNot(contains("import 'protocol.dart' as")),
          );
        },
      );
    },
  );

  group(
    'Given an endpoint that takes a list of models as a named parameter when generating protocol files',
    () {
      var testModelName = 'TestModel';
      var testModelFileName = 'test_model.dart';
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testModelName)
            .withFileName(testModelFileName)
            .build(),
      ];

      var endpoints = [
        EndpointDefinitionBuilder().withMethods([
          MethodDefinitionBuilder().withName('myEndpoint').withParametersNamed([
            ParameterDefinitionBuilder()
                .withType(
                  TypeDefinitionBuilder().withClassName('List').withGenerics([
                    TypeDefinitionBuilder()
                        .withClassName(testModelName)
                        .withNullable(false)
                        .withUrl(defaultModuleAlias)
                        .withModelDefinition(models.first)
                        .build(),
                  ]).build(),
                )
                .build(),
          ]).buildMethodCallDefinition(),
        ]).build(),
      ];

      var protocolDefinition = ProtocolDefinition(
        endpoints: endpoints,
        models: models,
        futureCalls: [],
      );

      var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      test(
        'then the protocol.dart file is created.',
        () {
          expect(codeMap[expectedFileName], isNotNull);
        },
      );

      test(
        'then the protocol.dart does not contain import to itself.',
        () {
          expect(
            codeMap[expectedFileName],
            isNot(contains("import 'protocol.dart' as")),
          );
        },
      );
    },
  );

  group(
    'Given an endpoint that takes a list of models as a named parameter when generating protocol files',
    () {
      var testModelName = 'TestModel';
      var testModelFileName = 'test_model.dart';
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(testModelName)
            .withFileName(testModelFileName)
            .build(),
      ];

      var endpoints = [
        EndpointDefinitionBuilder().withMethods([
          MethodDefinitionBuilder()
              .withName('myEndpoint')
              .withParametersPositional([
                ParameterDefinitionBuilder()
                    .withType(
                      TypeDefinitionBuilder()
                          .withClassName('List')
                          .withGenerics([
                            TypeDefinitionBuilder()
                                .withClassName(testModelName)
                                .withNullable(false)
                                .withUrl(defaultModuleAlias)
                                .withModelDefinition(models.first)
                                .build(),
                          ])
                          .build(),
                    )
                    .build(),
              ])
              .buildMethodCallDefinition(),
        ]).build(),
      ];

      var protocolDefinition = ProtocolDefinition(
        endpoints: endpoints,
        models: models,
        futureCalls: [],
      );

      var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      test(
        'then the protocol.dart file is created.',
        () {
          expect(codeMap[expectedFileName], isNotNull);
        },
      );

      test(
        'then the protocol.dart does not contain import to itself.',
        () {
          expect(
            codeMap[expectedFileName],
            isNot(contains("import 'protocol.dart' as")),
          );
        },
      );
    },
  );

  group(
    'Given serverOnly models with List field of another serverOnly model when generating protocol files',
    () {
      var serverOnlyModel = 'Article';
      var serverOnlyModelWithList = 'ArticleList';
      var models = [
        ModelClassDefinitionBuilder()
            .withClassName(serverOnlyModel)
            .withFileName('article')
            .withServerOnly(true)
            .withSimpleField('name', 'String')
            .withSimpleField('price', 'double')
            .build(),
        ModelClassDefinitionBuilder()
            .withClassName(serverOnlyModelWithList)
            .withFileName('article_list')
            .withServerOnly(true)
            .withListField(
              'results',
              serverOnlyModel,
              scope: ModelFieldScopeDefinition.serverOnly,
            )
            .build(),
      ];

      var protocolDefinition = ProtocolDefinition(
        endpoints: [],
        models: models,
        futureCalls: [],
      );

      var codeMap = generator.generateProtocolCode(
        protocolDefinition: protocolDefinition,
        config: config,
      );

      test(
        'then the protocol.dart file is created.',
        () {
          expect(codeMap[expectedFileName], isNotNull);
        },
      );

      test(
        'then the protocol.dart does not contain any reference to serverOnly model.',
        () {
          var protocolContent = codeMap[expectedFileName]!;
          expect(protocolContent, isNot(contains('Article')));
        },
      );
    },
  );
}
