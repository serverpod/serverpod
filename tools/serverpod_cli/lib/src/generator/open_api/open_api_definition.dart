part of 'open_api_objects.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
/// OpenAPI Object
/// This is the root object of the OpenAPI document.
class OpenApiDefinition {
  final String openApi;

  /// REQUIRED. Provides metadata about the API.
  /// The metadata MAY be used by tooling as required.
  final InfoObject info;

  /// The default value for the $schema keyword within Schema Objects contained within this OAS document.
  /// This MUST be in the form of a URI.
  final String? jsonSchemaDialect;

  /// An array of Server Objects, which provide connectivity information to a target server.
  /// If the servers property is not provided, or is an empty array, the default value would be a Server Object with a url value of /.
  final List<ServerObject>? servers;

  /// The available paths and operations for the API.
  final PathsObject? paths;

  ///TODO: add webhook

  /// An element to hold various schemas for the document.
  final ComponentsObject? components;

  /// A declaration of which security mechanisms can be used across the API.
  /// The list of values includes alternative security requirement objects that can be used.
  /// Only one of the security requirement objects need to be satisfied to authorize a request.
  /// Individual operations can override this definition.
  /// To make security optional, an empty security requirement ({}) can be included in the array.
  final List<SecurityRequirementObject>? security;

  /// A list of tags used by the document with additional metadata.
  /// The order of the tags can be used to reflect on their order by the parsing tools.
  /// Not all tags that are used by the Operation Object must be declared.
  /// The tags that are not declared MAY be organized randomly or based on the tools' logic.
  /// Each tag name in the list MUST be unique.
  /// Serverpod Endpoints name camelCase
  final Set<TagObject>? tags;

  /// Additional external documentation.
  final ExternalDocumentationObject? externalDocs;
  OpenApiDefinition({
    this.openApi = '3.1.0',
    required this.info,
    this.jsonSchemaDialect,
    this.servers,
    this.paths,
    this.components,
    this.security,
    this.tags,
    this.externalDocs,
  });

  Map<String, dynamic> toJson() {
    var map = {
      'openApi': openApi,
      'info': info.toJson(),
    };
    if (jsonSchemaDialect != null) {
      map['jsonSchemaDialect'] = jsonSchemaDialect!;
    }
    if (servers != null) {
      // map['servers']=servers;
    }
    if (paths != null) {
      // map['paths'] = paths.toJson();
    }
    if (components != null) {
      // map['components'] = components;
    }
    if (security != null) {
      //map['security']=security
    }
    if (tags != null) {
      map['tags'] = tags!.map((tag) => tag.toJson()).toList();
    }
    if (externalDocs != null) {
      //map['externalDocs'] = externalDocs
    }

    return map;
  }

  factory OpenApiDefinition.fromProtocolDefinition(
      ProtocolDefinition protocolDefinition, GeneratorConfig config) {
    ///TODO: get more info from config
    InfoObject infoObject =
        InfoObject(title: 'ServerPod Endpoint - OpenAPI', version: '0.0.1');

    Set<TagObject> tags = _getTagsFromProtocolDefinition(protocolDefinition);
    return OpenApiDefinition(
      info: infoObject,
      tags: tags,
    );
  }
}

/// get set of tags from protocol definition
/// use endpoint name for name and documentationComment for description
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
