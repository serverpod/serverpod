import 'package:recase/recase.dart';
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/open_api/helpers/extensions.dart';

import '../../analyzer/dart/definitions.dart';
import 'helpers/utils.dart';
import 'open_api_objects.dart';

/// OpenAPI Object
/// This is the root object of the OpenAPI document.
class OpenAPIDefinition {
  final String openAPI;

  /// Provides metadata about the API.
  /// The metadata may be used by tooling as required.
  final OpenAPIConfig info;

  /// The default value for the $schema keyword within Schema Objects contained
  ///  within this OAS document.
  final String? jsonSchemaDialect;

  /// An array of Server Objects, which provide connectivity information
  /// to a target server.
  /// If the servers property is not provided, or is an empty array,
  /// the default value would be a Server Object with a url value of /.
  final Set<OpenAPIServer>? servers;

  /// The available paths and operations for the API.
  final Set<OpenAPIPaths>? paths;

  /// An element to hold various schemas for the document.
  final OpenAPIComponents? components;

  /// A list of tags used by the document with additional metadata.
  final Set<OpenAPITag>? tags;

  /// Additional external documentation.
  final OpenAPIExternalDocumentation? externalDocs;
  OpenAPIDefinition({
    this.openAPI = '3.0.0',
    required this.info,
    this.jsonSchemaDialect,
    this.servers,
    this.paths,
    this.components,
    this.tags,
    this.externalDocs,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'openapi': openAPI,
      'info': info.toJson(),
    };
    if (jsonSchemaDialect != null) {
      map['jsonSchemaDialect'] = jsonSchemaDialect!;
    }
    if (servers != null) {
      map['servers'] = servers!.map((e) => e.toJson()).toList();
    }
    if (tags != null) {
      map['tags'] = tags!.map((tag) => tag.toJson()).toList();
    }
    if (paths != null) {
      map['paths'] = _allPathsToJson(paths!);
    }
    if (components != null) {
      map['components'] = components!.toJson();
    }

    if (externalDocs != null) {
      map['externalDocs'] = externalDocs!.toJson();
    }

    return map;
  }

  factory OpenAPIDefinition.fromProtocolDefinition(
      ProtocolDefinition protocolDefinition, GeneratorConfig config) {
    OpenAPIConfig infoObject =
        OpenAPIConfig(title: 'ServerPod Endpoint - OpenAPI', version: '0.0.1');

    var returnTypeList = _getEntitiesFromEndpointsReturnType(
      protocolDefinition,
    );

    Set<OpenAPITag> tags = _getTagsFromProtocolDefinition(protocolDefinition);
    Set<OpenAPIPaths> paths =
        _getPathsFromProtocolDefinition(protocolDefinition);

    Set<OpenAPIComponentSchema> schemas =
        _getComponentSchemasFromClassDefinitions(
            protocolDefinition.entities, returnTypeList);

    OpenAPIComponents componentsObject =
        OpenAPIComponents(schemas: schemas, securitySchemes: {
      serverpodAuth,
    });

    var servers = {
      OpenAPIServer(
          url: Uri.http('localhost:8080'), description: 'Development Server')
    };

    return OpenAPIDefinition(
      info: config.openAPIConfig ?? infoObject,
      servers: config.servers.isNotEmpty ? config.servers : servers,
      tags: tags,
      paths: paths,
      components: componentsObject,
    );
  }
}

/// Generate a map of paths' values based on a set of [OpenAPIPaths].
/// example
/// ```
///     {
///   "paths":{
///        "/pet":{
///               },
///         },
///       "/pet/findById":{},
///       "/store/":{}
///     }
/// ```
Map<String, dynamic> _allPathsToJson(Set<OpenAPIPaths> paths) {
  Map<String, dynamic> map = {};
  for (var path in paths) {
    map[path.pathName] = path.path?.toJson() ?? {};
  }
  return map;
}

/// Get a set of [OpenAPIPaths] from ProtocolDefinition.
Set<OpenAPIPaths> _getPathsFromProtocolDefinition(
    ProtocolDefinition protocolDefinition) {
  Set<OpenAPIPaths> paths = {};
  for (var endpoint in protocolDefinition.endpoints) {
    var extraPath = getExtraPath(endpoint.subDirParts);

    for (var method in endpoint.methods) {
      String? description = method.documentationComment?.replaceAll('/// ', '');

      /// Method name is operationId + Tag .
      String operationId = method.name + endpoint.name.pascalCase;

      List<ParameterDefinition> params = [
        ...method.parameters,
        ...method.parametersNamed,
        ...method.parametersPositional
      ];
      OpenAPIResponse responseObject =
          OpenAPIResponse(responseType: method.returnType);
      OperationObject operationObject = OperationObject(
        description: description,
        operationId: operationId,
        responses: responseObject,
        tags: [endpoint.name],

        // TODO(b14ckc0d3) : add more security base on installed auths
        security: {
          serverpodAuth,
        },
        parameters: [],
        requestBody: OpenAPIRequestBody(
          parameterList: params,
          requiredField: params.isNotEmpty,
        ),
      );
      var pathItemObject = OpenAPIPathItem(
        postOperation: operationObject,
      );

      var pathsObject = OpenAPIPaths(
        pathName: '$extraPath/${endpoint.name}/${method.name}',
        path: pathItemObject,
      );
      paths.add(pathsObject);
    }
  }
  return paths;
}

/// Get a set of [OpenAPITag] from protocol definition.
Set<OpenAPITag> _getTagsFromProtocolDefinition(
    ProtocolDefinition protocolDefinition) {
  Set<OpenAPITag> tags = {};

  for (var endpoint in protocolDefinition.endpoints) {
    var tag = OpenAPITag(
        name: endpoint.name.camelCase,
        description: endpoint.documentationComment?.replaceAll('/// ', ''));
    tags.add(tag);
  }
  return tags;
}

/// Get a set of [OpenAPIComponentSchema] from entities.
/// example```
///   Set<SchemaObject> schemas =
///  _getSchemaObjectFromClassDefinitions(protocolDefinition.entities);
/// ```
Set<OpenAPIComponentSchema> _getComponentSchemasFromClassDefinitions(
    List<SerializableEntityDefinition> entitiesDefinition,
    List<SerializableEntityDefinition> returnTypeList) {
  Set<OpenAPIComponentSchema> schemas = {};
  var entitiesFromMethodReturn = returnTypeList;
  for (var entityInfo in entitiesDefinition) {
    // Removes entity that are already present in entitiesDefinition.
    entitiesFromMethodReturn
        .removeWhere((e) => e.className == entityInfo.className);
    schemas.add(OpenAPIComponentSchema(entityInfo));
  }

  for (var entityInfo in entitiesFromMethodReturn) {
    schemas.add(OpenAPIComponentSchema(entityInfo));
  }

  return schemas;
}

/// Collects entities from [List<EndpointDefinition>] when the type is
/// 'serializableObjects' to enable validation, ensuring all
/// serializableObjects are correctly referenced in 'components.schemas'.
List<SerializableEntityDefinition> _getEntitiesFromEndpointsReturnType(
  ProtocolDefinition protocolDefinition,
) {
  List<SerializableEntityDefinition> returnTypeList = [];
  for (var endpoint in protocolDefinition.endpoints) {
    for (var method in endpoint.methods) {
      var returnType = method.returnType.className == 'Future'
          ? method.returnType.generics.first
          : method.returnType;
      if (returnType.toOpenAPISchemaType !=
              OpenAPISchemaType.serializableObjects ||
          returnType.className == 'void' ||
          returnType.className == 'dynamic') {
        continue;
      }
      SerializableEntityDefinition entity;
      if (returnType.isEnum) {
        entity = EnumDefinition(
            fileName: 'undefined',
            sourceFileName: 'undefined',
            className: returnType.className,
            values: [],
            serverOnly: false);
      } else {
        entity = ClassDefinition(
            fileName: 'undefined',
            sourceFileName: 'undefined',
            className: returnType.className,
            fields: [],
            serverOnly: false,
            isException: false);
      }

      returnTypeList.add(entity);
    }
  }

  return returnTypeList;
}
