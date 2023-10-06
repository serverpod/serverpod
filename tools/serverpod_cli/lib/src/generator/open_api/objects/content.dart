// ignore_for_file: public_member_api_docs, sort_constructors_first
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
          typeToJson(responseType!, true);
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
