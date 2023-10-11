import 'package:recase/recase.dart';
import 'package:serverpod_cli/analyzer.dart';

import '../../analyzer/dart/definitions.dart';
import 'open_api_objects.dart';

/// OpenAPI Object
/// This is the root object of the OpenAPI document.
class OpenApiDefinition {
  final String openApi;

  /// Provides metadata about the API.
  /// The metadata may be used by tooling as required.
  final InfoObject info;

  /// The default value for the $schema keyword within Schema Objects contained
  ///  within this OAS document.
  /// This MUST be in the form of a URI.
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
  /// The order of the tags can be used to reflect on their order by
  /// the parsing tools.
  /// Not all tags that are used by the Operation Object must be declared.
  /// The tags that are not declared may be organized randomly or based on
  /// the tools' logic.
  /// Each tag name in the list must be unique.
  /// Serverpod Endpoints name camelCase
  final Set<TagObject>? tags;

  /// Additional external documentation.
  final ExternalDocumentationObject? externalDocs;
  OpenApiDefinition({
    this.openApi = '3.0.0',
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
      'openapi': openApi,
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

  factory OpenApiDefinition.fromProtocolDefinition(
      ProtocolDefinition protocolDefinition, GeneratorConfig config) {
    // TODO: get more info from config
    InfoObject infoObject =
        InfoObject(title: 'ServerPod Endpoint - OpenAPI', version: '0.0.1');

    Set<TagObject> tags = _getTagsFromProtocolDefinition(protocolDefinition);
    Set<PathsObject> paths =
        _getPathsFromProtocolDefinition(protocolDefinition);

    var classDefinitionList =
        protocolDefinition.entities.whereType<ClassDefinition>().toList();
    Set<ComponentSchemaObject> schemas =
        _getSchemaObjectFromClassDefinitions(classDefinitionList);

    ComponentsObject componentsObject =
        ComponentsObject(schemas: schemas, securitySchemes: {
      serverpodAuth,
    });

    var servers = {
      ServerObject(
          url: Uri.http('localhost:8080'), description: 'Development Server')
    };

    return OpenApiDefinition(
      info: config.openApiInfo ?? infoObject,
      servers: config.servers.isNotEmpty ? config.servers : servers,
      tags: tags,
      paths: paths,
      components: componentsObject,
    );
  }
}

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

/// Get a set of [ComponentSchemaObject] from entities
/// example```
///   Set<SchemaObject> schemas =
///  _getSchemaObjectFromClassDefinitions(protocolDefinition.entities);
/// ```
Set<ComponentSchemaObject> _getSchemaObjectFromClassDefinitions(
    List<SerializableEntityDefinition> classDefs) {
  Set<ComponentSchemaObject> schemas = {};
  for (var classInfo in classDefs) {
    assert(classInfo is ClassDefinition, 'classInfo should be ClassDefinition');
    classInfo as ClassDefinition;
    schemas.add(ComponentSchemaObject(classInfo));
  }
  return schemas;
}
