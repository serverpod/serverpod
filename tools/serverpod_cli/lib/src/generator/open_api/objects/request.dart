import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/generator/open_api/objects/content.dart';
import 'package:serverpod_cli/src/generator/open_api/objects/schema.dart';

/// Describes a single request body.
class RequestBodyObject {
  /// A brief description of the request body.
  final String? description;

  /// A list of parameters from a Serverpod's endpoint method, to be converted
  /// into the content of the request body.
  final List<ParameterDefinition> parameterList;

  /// Determines if the request body is required in the request.
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
