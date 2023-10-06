part of '../open_api_objects.dart';

/// Describes a single API operation on a path.
class OperationObject {
  /// A list of tags for API documentation control. Tags can be used for logical grouping of operations by resources or any other qualifier.
  final List<String>? tags;

  /// A short summary of what the operation does.
  final String? summary;

  final String? description;

  final ExternalDocumentationObject? externalDocs;

  /// Unique string used to identify the operation.The id must be unique among
  /// all operations described in the API.The operationId value is
  /// case-sensitive. Tools and libraries may use the operationId to uniquely
  /// identify an operation, therefore, it is recommended to follow common
  /// programming naming conventions. It should be serverpod endpoint's method
  /// name eg ``` findPetById ```
  final String? operationId;

  /// A list of parameters that are applicable for this operation.
  /// If a parameter is already defined at the Path Item, the new definition
  /// will override it but can never remove it. The list must not include
  /// duplicated parameters. A unique parameter is defined by a combination of
  /// a name and location.The list can use the Reference Object to link to
  /// parameters that are defined at the OpenAPI Object's components/parameters.
  final List<ParameterObject> parameters;

  /// The request body applicable for this operation.
  /// The requestBody is fully supported in HTTP methods where the HTTP 1.1
  /// specification RFC7231 has explicitly defined semantics for request bodies.
  /// In other cases where the HTTP spec is vague
  /// (such as GET, HEAD and DELETE),
  /// requestBody is permitted but does not have well-defined semantics
  /// and should be avoided if possible.
  final RequestBodyObject? requestBody;

  /// The list of possible responses as they are returned from executing
  /// this operation.
  final ResponseObject responses;

  /// Declares this operation to be deprecated. Consumers should refrain
  /// from usage of the declared operation.
  /// Default value is false.
  final bool deprecated;

  final SecurityRequirementObject security;

  final List<ServerObject>? servers;
  OperationObject({
    this.tags,
    this.summary,
    this.description,
    this.externalDocs,
    this.operationId,
    required this.parameters,
    this.requestBody,
    this.deprecated = false,
    required this.responses,
    required this.security,
    this.servers,
  });

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      'operationId': operationId,
    };

    if (tags?.isNotEmpty ?? false) {
      map['tags'] = tags!;
    }

    if (summary != null) {
      map['summary'] = summary;
    }

    if (description != null) {
      map['description'] = description;
    }
    if (externalDocs != null) {
      map['externalDocs'] = externalDocs;
    }

    if (requestBody != null) {
      map['requestBody'] = requestBody!.toJson();
    }

    if (parameters.isNotEmpty) {
      map['parameters'] = parameters.map((e) => e.toJson()).toList();
    }
    map['responses'] = responses.toJson();

    return map;
  }
}
