part of '../open_api_objects.dart';

///example
///```
///"content": {
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
  final List<String> contentTypes;
  final ContentSchemaObject? responseSchemaObject;
  final RequestContentSchemaObject? requestContentSchemaObject;
  ContentObject({
    required this.contentTypes,
    this.responseSchemaObject,
    this.requestContentSchemaObject,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> contentMap = {};
    for (var type in contentTypes) {
      contentMap[type] = {};
      if (responseSchemaObject != null) {
        contentMap[type]['schema'] = responseSchemaObject!.toJson();
      }
      if (requestContentSchemaObject != null) {
        contentMap[type]['schema'] = requestContentSchemaObject!.toJson();
      }
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
