part of '../open_api_objects.dart';

/// The [ContentObject] is used to describe the media types that an operation
/// can consume and produce. It specifies the format and schema of the request
/// and response payloads for different media types, such as JSON, XML, or
/// others. example
/// ```dart
/// "content": {
///               "application/json": {
///                 "schema": {
///                   "$ref": "#/components/schemas/Pet"
///                 }
///               },
///               "application/xml": {
///                 "schema": {
///                   "$ref": "#/components/schemas/Pet"
///                 }
///               }
///             }
///           },
/// ```
class ContentObject {
  final RequestContentSchemaObject? requestContentSchemaObject;
  final TypeDefinition? responseType;
  ContentObject({
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
