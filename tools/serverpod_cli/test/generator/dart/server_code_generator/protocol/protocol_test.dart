import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:serverpod_cli/src/util/model_helper.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';
import 'package:test/test.dart';

import '../../../../test_util/builders/database/index_definition_builder.dart';
import '../../../../test_util/builders/endpoint_definition_builder.dart';
import '../../../../test_util/builders/generator_config_builder.dart';
import '../../../../test_util/builders/method_definition_builder.dart';
import '../../../../test_util/builders/model_class_definition_builder.dart';
import '../../../../test_util/builders/parameter_definition_builder.dart';
import '../../../../test_util/builders/serializable_entity_field_definition_builder.dart';
import '../../../../test_util/builders/type_definition_builder.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  var expectedFileName = path.join(
    'lib',
    'src',
    'generated',
    'protocol.dart',
  );

  group(
      'Given an endpoint with Stream with model generic return type when generating protocol files',
      () {
    var modelName = 'example_model';
    var models = [
      ModelClassDefinitionBuilder()
          .withClassName(modelName.pascalCase)
          .withFileName(modelName)
          .build()
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
            .buildMethodCallDefinition()
      ]).build()
    ];

    var protocolDefinition =
        ProtocolDefinition(endpoints: endpoints, models: models);

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
  });

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
                .withType(TypeDefinitionBuilder()
                    .withListOf(
                      testModelName,
                      url: defaultModuleAlias,
                      modelInfo: testModel,
                    )
                    .build())
                .build(),
          )
          .build()
    ];

    var protocolDefinition = ProtocolDefinition(endpoints: [], models: models);

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
  });

  group(
      'Given an endpoint that returns a list of models when generating protocol files',
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
            .withReturnType(
              TypeDefinitionBuilder().withClassName('Future').withGenerics([
                TypeDefinitionBuilder().withClassName('List').withGenerics([
                  TypeDefinitionBuilder()
                      .withClassName(testModelName)
                      .withNullable(false)
                      .withUrl(defaultModuleAlias)
                      .withModelDefinition(models.first)
                      .build()
                ]).build(),
              ]).build(),
            )
            .buildMethodCallDefinition()
      ]).build()
    ];

    var protocolDefinition = ProtocolDefinition(
      endpoints: endpoints,
      models: models,
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
  });

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
                    .build()
              ]).build())
              .build()
        ]).buildMethodCallDefinition()
      ]).build()
    ];

    var protocolDefinition = ProtocolDefinition(
      endpoints: endpoints,
      models: models,
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
  });

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
                    .build()
              ]).build())
              .build()
        ]).buildMethodCallDefinition()
      ]).build()
    ];

    var protocolDefinition = ProtocolDefinition(
      endpoints: endpoints,
      models: models,
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
  });

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
                  TypeDefinitionBuilder().withClassName('List').withGenerics([
                TypeDefinitionBuilder()
                    .withClassName(testModelName)
                    .withNullable(false)
                    .withUrl(defaultModuleAlias)
                    .withModelDefinition(models.first)
                    .build()
              ]).build())
              .build()
        ]).buildMethodCallDefinition()
      ]).build()
    ];

    var protocolDefinition = ProtocolDefinition(
      endpoints: endpoints,
      models: models,
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
  });

  group(
      'Given an endpoint with Stream with a model return type when generating protocol files',
      () {
    var modelName = 'example_model';
    var models = [
      ModelClassDefinitionBuilder()
          .withClassName(modelName.pascalCase)
          .withFileName(modelName)
          .build()
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
            .buildMethodCallDefinition()
      ]).build()
    ];

    var protocolDefinition =
        ProtocolDefinition(endpoints: endpoints, models: models);

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
      'then the protocol.dart does not contain an overwrite of `wrapWithClassName`.',
      () {
        expect(
          codeMap[expectedFileName],
          isNot(contains('wrapWithClassName')),
        );
      },
    );
  });

  group(
      'Given an endpoint with Stream with a record return type when generating protocol files',
      () {
    var endpoints = [
      EndpointDefinitionBuilder().withMethods([
        MethodDefinitionBuilder()
            .withName('streamingMethod')
            .withReturnType(
              TypeDefinitionBuilder().withClassName('Stream').withGenerics([
                TypeDefinitionBuilder().withRecordOf([
                  TypeDefinitionBuilder().withClassName('int').build()
                ]).build()
              ]).build(),
            )
            .buildMethodCallDefinition()
      ]).build()
    ];

    var protocolDefinition =
        ProtocolDefinition(endpoints: endpoints, models: []);

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
      'then the protocol.dart contains an overwrite of `wrapWithClassName`.',
      () {
        expect(
          codeMap[expectedFileName],
          contains('wrapWithClassName'),
        );
      },
    );
  });

  group(
      'Given an endpoint with a Future record return type when generating protocol files',
      () {
    var endpoints = [
      EndpointDefinitionBuilder().withMethods([
        MethodDefinitionBuilder()
            .withName('streamingMethod')
            .withReturnType(
              TypeDefinitionBuilder().withClassName('Future').withGenerics([
                TypeDefinitionBuilder().withRecordOf([
                  TypeDefinitionBuilder().withClassName('int').build()
                ]).build()
              ]).build(),
            )
            .buildMethodCallDefinition()
      ]).build()
    ];

    var protocolDefinition =
        ProtocolDefinition(endpoints: endpoints, models: []);

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
      'then the protocol.dart does not contain an overwrite of `wrapWithClassName`.',
      () {
        expect(
          codeMap[expectedFileName],
          isNot(contains('wrapWithClassName')),
        );
      },
    );
  });

  group(
      'Given an endpoint with a Future<int> return type and Stream of record parameter when generating protocol files',
      () {
    var endpoints = [
      EndpointDefinitionBuilder().withMethods([
        MethodDefinitionBuilder()
            .withName('streamingMethod')
            .withReturnType(
              TypeDefinitionBuilder().withClassName('Future').withGenerics([
                TypeDefinitionBuilder().withRecordOf([
                  TypeDefinitionBuilder().withClassName('int').build()
                ]).build(),
              ]).build(),
            )
            .withParameters([
          ParameterDefinitionBuilder()
              .withName('streamOfRecords')
              .withType(
                TypeDefinitionBuilder().withClassName('Stream').withGenerics([
                  TypeDefinitionBuilder().withRecordOf([
                    TypeDefinitionBuilder().withClassName('int').build()
                  ]).build(),
                ]).build(),
              )
              .build()
        ]).buildMethodCallDefinition()
      ]).build()
    ];

    var protocolDefinition =
        ProtocolDefinition(endpoints: endpoints, models: []);

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
      'then the protocol.dart contains an overwrite of `wrapWithClassName`.',
      () {
        expect(
          codeMap[expectedFileName],
          contains('wrapWithClassName'),
        );
      },
    );
  });

  group(
      'Given an endpoint with a Future<int> return type and Stream of records (List) parameter when generating protocol files',
      () {
    var endpoints = [
      EndpointDefinitionBuilder().withMethods([
        MethodDefinitionBuilder()
            .withName('streamingMethod')
            .withReturnType(
              TypeDefinitionBuilder().withClassName('Future').withGenerics([
                TypeDefinitionBuilder().withRecordOf([
                  TypeDefinitionBuilder().withClassName('int').build()
                ]).build(),
              ]).build(),
            )
            .withParameters([
          ParameterDefinitionBuilder()
              .withName('streamOfRecords')
              .withType(
                TypeDefinitionBuilder().withClassName('Stream').withGenerics([
                  TypeDefinitionBuilder().withClassName('List').withGenerics([
                    TypeDefinitionBuilder().withRecordOf([
                      TypeDefinitionBuilder().withClassName('int').build()
                    ]).build()
                  ]).build(),
                ]).build(),
              )
              .build()
        ]).buildMethodCallDefinition()
      ]).build()
    ];

    var protocolDefinition =
        ProtocolDefinition(endpoints: endpoints, models: []);

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
      'then the protocol.dart contains an overwrite of `wrapWithClassName`.',
      () {
        expect(
          codeMap[expectedFileName],
          contains('wrapWithClassName'),
        );
      },
    );
  });

  group('Given a model with vector fields when generating protocol files', () {
    var testModelName = 'ModelWithVector';
    var testModelFileName = 'model_with_vector';

    var models = [
      ModelClassDefinitionBuilder()
          .withClassName(testModelName)
          .withFileName(testModelFileName)
          .withTableName('model_with_vector')
          .withVectorField('embedding', dimension: 384)
          .withVectorField('nullableEmbedding', dimension: 512, nullable: true)
          .build()
    ];

    var protocolDefinition = ProtocolDefinition(endpoints: [], models: models);

    var codeMap = generator.generateProtocolCode(
      protocolDefinition: protocolDefinition,
      config: config,
    );

    test('then the protocol.dart file is created.', () {
      expect(codeMap[expectedFileName], isNotNull);
    });

    late var content = codeMap[expectedFileName]!;

    test(
        'then the protocol contains non-nullable vector field with correct type and dimension.',
        () {
      expect(content, contains('dartType: \'Vector(384)\''));
      expect(content, contains('vectorDimension: 384'));
    });

    test(
        'then the protocol contains nullable vector field with correct type and dimension parameter.',
        () {
      expect(content, contains('dartType: \'Vector(512)?\''));
      expect(content, contains('vectorDimension: 512'));
    });
  });

  group(
      'Given a model with vector fields and indexes when generating protocol files',
      () {
    var testModelName = 'ModelWithVectorIndexes';
    var testModelFileName = 'model_with_vector_indexes';

    var models = [
      ModelClassDefinitionBuilder()
          .withClassName(testModelName)
          .withFileName(testModelFileName)
          .withTableName('model_with_vector_indexes')
          .withVectorField('vectorDefault', dimension: 512)
          .withVectorField('vectorHnsw', dimension: 512)
          .withVectorField('vectorHnswWithParams', dimension: 512)
          .withVectorField('vectorIvfflat', dimension: 512)
          .withVectorField('vectorIvfflatWithParams', dimension: 512)
          .withIndexesFromDefinitions([
        IndexDefinitionBuilder()
            .withIndexName('vector_index_default')
            .withType('hnsw')
            .withVectorDistanceFunction(VectorDistanceFunction.l2)
            .withElements([
          IndexElementDefinition(
            definition: 'vectorDefault',
            type: IndexElementDefinitionType.column,
          )
        ]).build(),
        IndexDefinitionBuilder()
            .withIndexName('vector_index_hnsw')
            .withType('hnsw')
            .withVectorDistanceFunction(VectorDistanceFunction.l2)
            .withElements([
          IndexElementDefinition(
            definition: 'vectorHnsw',
            type: IndexElementDefinitionType.column,
          )
        ]).build(),
        IndexDefinitionBuilder()
            .withIndexName('vector_index_hnsw_with_params')
            .withType('hnsw')
            .withVectorDistanceFunction(VectorDistanceFunction.cosine)
            .withParameters({
          'm': '64',
          'ef_construction': '200',
        }).withElements([
          IndexElementDefinition(
            definition: 'vectorHnswWithParams',
            type: IndexElementDefinitionType.column,
          )
        ]).build(),
        IndexDefinitionBuilder()
            .withIndexName('vector_index_ivfflat')
            .withType('ivfflat')
            .withVectorDistanceFunction(VectorDistanceFunction.l2)
            .withElements([
          IndexElementDefinition(
            definition: 'vectorIvfflat',
            type: IndexElementDefinitionType.column,
          )
        ]).build(),
        IndexDefinitionBuilder()
            .withIndexName('vector_index_ivfflat_with_params')
            .withType('ivfflat')
            .withVectorDistanceFunction(VectorDistanceFunction.innerProduct)
            .withParameters({
          'lists': '300',
        }).withElements([
          IndexElementDefinition(
            definition: 'vectorIvfflatWithParams',
            type: IndexElementDefinitionType.column,
          )
        ]).build(),
      ]).build()
    ];

    var protocolDefinition = ProtocolDefinition(endpoints: [], models: models);

    var codeMap = generator.generateProtocolCode(
      protocolDefinition: protocolDefinition,
      config: config,
    );

    test('then the protocol.dart file is created.', () {
      expect(codeMap[expectedFileName], isNotNull);
    });

    late var content = codeMap[expectedFileName]!;

    test('then the protocol contains HNSW index with L2 distance.', () {
      expect(content, contains('indexName: \'vector_index_default\''));
      expect(content, contains('type: \'hnsw\''));
      expect(content, contains('VectorDistanceFunction.l2'));
    });

    test(
        'then the protocol contains HNSW index with cosine distance and parameters.',
        () {
      expect(content, contains('indexName: \'vector_index_hnsw_with_params\''));
      expect(content, contains('VectorDistanceFunction.cosine'));
      expect(content, contains('\'m\': \'64\''));
      expect(content, contains('\'ef_construction\': \'200\''));
    });

    test('then the protocol contains IVFFLAT index with L2 distance.', () {
      expect(content, contains('indexName: \'vector_index_ivfflat\''));
      expect(content, contains('type: \'ivfflat\''));
      expect(content, contains('VectorDistanceFunction.l2'));
    });

    test(
        'then the protocol contains IVFFLAT index with innerProduct distance and parameters.',
        () {
      expect(
          content, contains('indexName: \'vector_index_ivfflat_with_params\''));
      expect(content, contains('VectorDistanceFunction.innerProduct'));
      expect(content, contains('\'lists\': \'300\''));
    });
  });
}
