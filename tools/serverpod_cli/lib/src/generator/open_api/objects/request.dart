part of '../open_api_objects.dart';

/// [RequestBodyObject] Request bodies are typically used with “create” and
/// “update” operations
/// (POST, PUT, PATCH). For example, when creating a resource using POST or
/// PUT, the request body usually contains the representation of the resource
/// to be created. OpenAPI 3.0 provides the requestBody keyword to describe
/// request bodies.

class RequestBodyObject {
  final String? description;
  final ContentObject? content;
  final bool requiredField;
  RequestBodyObject({
    this.description,
    this.content,
    this.requiredField = true,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    if (description != null) map['description'] = map;
    if (content != null) map['content'] = content;
    map['required'] = requiredField;
    return map;
  }

  // factory RequestBodyObject.fromMethod(MethodDefinition methodDefinition) {

  // }
}
