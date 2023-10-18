import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/generator/open_api/objects/content.dart';
import 'package:serverpod_cli/src/generator/open_api/objects/schema.dart';

/// [RequestBodyObject] Request bodies are typically used with “create” and
/// “update” operations (POST, PUT, PATCH). For example, when creating a
/// resource using POST or PUT, the request body usually contains the
/// representation of the resource to be created. OpenAPI 3.0 provides the
/// requestBody keyword to describe request bodies.
class RequestBodyObject {
  final String? description;
  final List<ParameterDefinition> parameterList;
  final bool requiredField;
  RequestBodyObject({
    this.description,
    required this.parameterList,
    this.requiredField = true,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    if (description != null) map['description'] = description;
    map['content'] = ContentObject(
      requestContentSchemaObject: RequestContentSchemaObject(
        params: parameterList,
      ),
    ).toJson();
    map['required'] = requiredField;
    return map;
  }
}
