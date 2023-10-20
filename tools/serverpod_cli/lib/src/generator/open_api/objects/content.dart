import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/generator/open_api/objects/schema.dart';

/// The [OpenAPIContent] describes the supported media types for an operation,
/// specifying the format and schema of request and response payloads. This can
/// include formats like JSON, XML, and others.
///
/// Example:
/// ```dart
/// "content": {
///   "application/json": {
///     "schema": {
///       "$ref": "#/components/schemas/Pet"
///     }
///   },
///   "application/xml": {
///     "schema": {
///       "$ref": "#/components/schemas/Pet"
///     }
///   }
/// }
/// ```
class OpenAPIContent {
  final RequestContentSchemaObject? requestContentSchemaObject;
  final TypeDefinition? responseType;
  OpenAPIContent({
    this.requestContentSchemaObject,
    this.responseType,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> contentMap = {};

    contentMap[ContentType.applicationJson] = {};

    if (requestContentSchemaObject != null) {
      contentMap[ContentType.applicationJson]['schema'] =
          requestContentSchemaObject!.toJson();
      return contentMap;
    }

    if (responseType != null) {
      contentMap[ContentType.applicationJson]['schema'] =
          typeDefinitionToJson(responseType!, true);
      return contentMap;
    }

    return contentMap;
  }
}

class ContentType {
  static const applicationJson = 'application/json';
  static const applicationXml = 'application/xml';
  static const applicationForm = 'application/x-www-form-urlencoded';
  static const any = '*/*';
  static const image = 'image/png';
  static const imageAny = 'image/*';
  static const imageJpeg = 'image/jpeg';
  static const applicationOctetStream = 'application/octet-stream';
}
