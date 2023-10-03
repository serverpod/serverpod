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
    if (description != null) map['description'] = description;
    if (content != null) map['content'] = content!.toJson();
    map['required'] = requiredField;
    return map;
  }

  factory RequestBodyObject.fromParameterDefinitionList(
      List<ParameterDefinition> parameterDefinitions) {
    ContentObject contentObject = ContentObject(
      contentTypes: [
        ContentType.applicationJson,
      ],
      requestContentSchemaObject: RequestContentSchemaObject(
        params: parameterDefinitions,
      ),
    );
    return RequestBodyObject(
      content: contentObject,
      requiredField: parameterDefinitions.length > 1 ? false : true,
    );
  }
}
