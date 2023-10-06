part of '../open_api_objects.dart';

///  example
/// ```
/// {
///  "name": "pet",
///  "description": "Pets operations"
/// }
///```
/// must be unique
/// used for grouping endpoints
class TagObject {
  final String name;
  final String? description;
  final ExternalDocumentationObject? externalDocumentationObject;
  TagObject({
    required this.name,
    this.description,
    this.externalDocumentationObject,
  });

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      'name': name,
    };
    if (description != null) {
      map['description'] = description!;
    }
    if (externalDocumentationObject != null) {
      map['externalDocumentationObject'] =
          externalDocumentationObject!.toJson();
    }
    return map;
  }

  @override
  bool operator ==(covariant TagObject other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.description == description &&
        other.externalDocumentationObject == externalDocumentationObject;
  }

  @override
  int get hashCode =>
      name.hashCode ^
      description.hashCode ^
      externalDocumentationObject.hashCode;
}
