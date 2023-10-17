import 'package:recase/recase.dart';
import 'package:serverpod_cli/analyzer.dart';

import '../../analyzer/dart/definitions.dart';
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
  final Set<ServerObject>? servers;

  /// The available paths and operations for the API.
  final Set<PathsObject>? paths;

  /// An element to hold various schemas for the document.
  final ComponentsObject? components;

  /// A list of tags used by the document with additional metadata.
  final Set<TagObject>? tags;

  /// Additional external documentation.
  final ExternalDocumentationObject? externalDocs;
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

    Set<TagObject> tags = _getTagsFromProtocolDefinition(protocolDefinition);
    Set<PathsObject> paths =
        _getPathsFromProtocolDefinition(protocolDefinition);

    Set<ComponentSchemaObject> schemas =
        _getSchemaObjectFromClassDefinitions(protocolDefinition.entities);

    ComponentsObject componentsObject =
        ComponentsObject(schemas: schemas, securitySchemes: {
      serverpodAuth,
    });

    var servers = {
      ServerObject(
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

/// Generate a map of paths' values based on a set of [PathsObject].
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
Map<String, dynamic> _allPathsToJson(Set<PathsObject> paths) {
  Map<String, dynamic> map = {};
  for (var path in paths) {
    map[path.pathName] = path.path?.toJson() ?? {};
  }
  return map;
}

/// Get a set of [PathsObject] from ProtocolDefinition.
Set<PathsObject> _getPathsFromProtocolDefinition(
    ProtocolDefinition protocolDefinition) {
  Set<PathsObject> paths = {};
  for (var endpoint in protocolDefinition.endpoints) {
    var extraPath = getExtraPath(endpoint.subDirParts);

    for (var method in endpoint.methods) {
      String? description = method.documentationComment;

      /// Method name is operationId + Tag
      String operationId = method.name + endpoint.name.pascalCase;

      List<ParameterDefinition> params = [
        ...method.parameters,
        ...method.parametersNamed,
        ...method.parametersPositional
      ];
      ResponseObject responseObject =
          ResponseObject(responseType: method.returnType);
      OperationObject operationObject = OperationObject(
        description: description,
        operationId: operationId,
        responses: responseObject,
        tags: [endpoint.name],

        // TODO(b14ckc0d3) : add more security base on installed auths
        security: {
          serverpodAuth,
        },

        // No need in OpeApi 2.0
        parameters: [],

        requestBody: RequestBodyObject(
          parameterList: params,
          requiredField: params.isNotEmpty,
        ),
      );
      var pathItemObject = PathItemObject(
        postOperation: operationObject,
      );

      var pathsObject = PathsObject(
        pathName: '$extraPath/${endpoint.name}/${method.name}',
        path: pathItemObject,
      );
      paths.add(pathsObject);
    }
  }
  return paths;
}

/// Get a set of [TagObject] from protocol definition.
Set<TagObject> _getTagsFromProtocolDefinition(
    ProtocolDefinition protocolDefinition) {
  Set<TagObject> tags = {};

  for (var endpoint in protocolDefinition.endpoints) {
    var tag = TagObject(
        name: endpoint.name.camelCase,
        description: endpoint.documentationComment);
    tags.add(tag);
  }
  return tags;
}

/// Get a set of [ComponentSchemaObject] from entities.
/// example```
///   Set<SchemaObject> schemas =
///  _getSchemaObjectFromClassDefinitions(protocolDefinition.entities);
/// ```
Set<ComponentSchemaObject> _getSchemaObjectFromClassDefinitions(
    List<SerializableEntityDefinition> entitiesDefinition) {
  Set<ComponentSchemaObject> schemas = {};
  for (var entityInfo in entitiesDefinition) {
    schemas.add(ComponentSchemaObject(entityInfo));
  }
  return schemas;
}
