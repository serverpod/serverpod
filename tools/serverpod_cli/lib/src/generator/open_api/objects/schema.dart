// ignore_for_file: public_member_api_docs, sort_constructors_first
part of '../open_api_objects.dart';

/// A Schema Object that will be used in ParameterObject
class ParameterSchemaObject {
  final TypeDefinition typeDefinition;

  ParameterSchemaObject(this.typeDefinition);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    if (typeDefinition.isEnum) {
      map['type'] = SchemaObjectType.string.name;
      map['enum'] = {};
      return map;
    }
    if (typeDefinition.isListType) {
      map['type'] = SchemaObjectType.array.name;
      map['items'] = {
        'type': typeDefinition.generics.first.toSchemaObjectType.name,
      };
      return map;
    }

    if ((typeDefinition.className == 'String') ||
        (typeDefinition.className == 'int') ||
        (typeDefinition.className == 'double')) {
      map['type'] = typeDefinition.toSchemaObjectType.name;
    }

    if (!typeDefinition.isDartCoreType) {
      map['schema'] = {
        '\$ref': getRef(typeDefinition.className),
      };
      return map;
    }
    return map;
  }
}

/// A Schema Object that will be used in ContentObject
class ContentSchemaObject {
  /// Should be [returnType] from [MethodDefinition]
  final TypeDefinition returnType;

  ContentSchemaObject({
    required this.returnType,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    List<TypeDefinition> generics = returnType.generics;

    if (generics.first.className == 'void') return map;

    /// If type is [Map] set [SchemaObjectType] to [object]
    /// and should contain key [additionalProperties]
    /// If type is dart:core type
    /// ```
    ///   "type":"string",
    ///
    /// ```
    /// else
    /// ```
    /// "\$ref":"#/components/schemas/ComplexModel"
    /// ```
    ///
    if (returnType.generics.first.isMapType) {
      map['type'] = SchemaObjectType.object.name;
      if (returnType.generics.isNotEmpty) {
        if (returnType.generics.last.generics.isNotEmpty) {
          map['additionalProperties'] = ItemSchemaObject(
            generics.last.generics.last,
            removeTypeKey: true,
          ).toJson();
        }
      }
      return map;
    }

    /// If type is [List] set [SchemaObjectType] to [array]
    /// and should contain key [items]
    /// example
    /// ```
    /// {
    ///   'type':'array',
    ///   'items':{
    ///      # 1. "type": "string"
    ///      # 2."type":"object"
    ///      #   "$ref": "#/components/schemas/ComplexModel"
    ///     }
    /// }
    /// ```
    if (generics.first.isListType) {
      map['type'] = SchemaObjectType.array.name;
      var items = ItemSchemaObject(
        generics.last.generics.first,
      );
      map['items'] = items.toJson();
      return map;
    }

    if (!generics.first.isDartCoreType) {
      map['type'] = SchemaObjectType.object.name;
      map['\$ref'] = getRef(generics.first.className);
      return map;
    } else {
      map['type'] = generics.first.toSchemaObjectType.name;
    }

    /// Binary file and an arbitrary binary file can omit schema .Just return {}
    return map;
  }
}

class RequestContentSchemaObject {
  final List<ParameterDefinition> params;
  RequestContentSchemaObject({
    required this.params,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['type'] = SchemaObjectType.object.name;
    map['properties'] = {};
    for (var param in params) {
      map['properties'][param.name] = ItemSchemaObject(
        param.type,
        removeTypeKey: !param.type.isDartCoreType,
      ).toJson();
    }

    return map;
  }
}

/// A SchemaObject used in [items]
class ItemSchemaObject {
  /// Use in Map items if true remove [type] key.
  final bool removeTypeKey;
  final TypeDefinition typeDefinition;

  ItemSchemaObject(this.typeDefinition, {this.removeTypeKey = false});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    ///if type is custom class return ref
    if (!typeDefinition.isDartCoreType) {
      if (!removeTypeKey) {
        map['type'] = SchemaObjectType.object.name;
      }
      map['\$ref'] = getRef(typeDefinition.className);
    } else if (typeDefinition.isListType) {
      map['type'] = SchemaObjectType.array.name;
      map['items'] = {};
      TypeDefinition generic = typeDefinition.generics.first;
      if (generic.isDartCoreType) {
        map['items']['type'] = generic.toSchemaObjectType.name;
      } else {
        map['items']['\$ref'] = getRef(
          generic.className,
        );
      }
    } else {
      map['type'] = typeDefinition.toSchemaObjectType.name;
    }

    return map;
  }
}

// TODO: create reusable mapToJson and listToJson
Map<String, dynamic> mapToJson(TypeDefinition type) {
  assert(type.isMapType,
      'Use mapToJson only when the typeDefinition is of the MapType.');

  Map<String, dynamic> map = {};
  map['type'] = SchemaObjectType.object.name;
  if (!type.isDartCoreType) {
    map['properties'] = {};
  }

  return map;
}

/// A SchemaObject that will use in Request
class RequestSchemaObject {
  final TypeDefinition typeDefinition;
  RequestSchemaObject({
    required this.typeDefinition,
  });
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    /// If type is [Map] set [SchemaObjectType] to [object]
    /// and should contain key [additionalProperties]
    /// If type is dart:core type
    /// ```
    ///   "type":"string",
    ///
    /// ```
    /// else
    /// ```
    /// "\$ref":"#/components/schemas/ComplexModel"
    /// ```
    ///
    if (typeDefinition.isMapType) {
      map['type'] = SchemaObjectType.object.name;
      if (typeDefinition.generics.length > 1) {
        map['additionalProperties'] = ItemSchemaObject(
          typeDefinition.generics.last,
          removeTypeKey: true,
        ).toJson();
      }
      return map;
    }

    /// If type is [List] set [SchemaObjectType] to [array]
    /// and should contain key [items]
    /// example
    /// ```
    /// {
    ///   'type':'array',
    ///   'items':{
    ///      # 1. "type": "string"
    ///      # 2."type":"object"
    ///      #   "$ref": "#/components/schemas/ComplexModel"
    ///     }
    /// }
    /// ```
    if (typeDefinition.isListType) {
      map['type'] = SchemaObjectType.array.name;
      var items = ItemSchemaObject(typeDefinition.generics.last);
      map['items'] = items.toJson();
      return map;
    }

    if (!typeDefinition.isDartCoreType) {
      map['\$ref'] = getRef(typeDefinition.className);
      return map;
    }

    /// Binary file and an arbitrary binary file can omit schema .Just return {}
    return map;
  }
}

/// A simple object to allow referencing other components in the OpenAPI
/// document, internally and externally.
/// The $ref string value contains a URI RFC3986, which identifies the location
/// of the value being referenced.
class ReferenceObject {
  /// The reference identifier. This must be in the form of a URI.
  /// key - [$ref]
  /// ```
  /// {
  /// "$ref": "#/components/schemas/Pet"
  /// }
  ///
  /// ref = 'Pet';
  /// ```
  ///

  final String ref;
  final String? summary;
  final String? description;
  ReferenceObject({
    required this.ref,
    this.summary,
    this.description,
  });

  Map<String, String> toJson() {
    var map = {
      '\$ref': getRef(ref),
    };
    if (summary != null) {
      map['summary'] = summary!;
    }
    if (description != null) {
      map['description'] = description!;
    }
    return map;
  }
}

/// A Schema object which will use in [ComponentObject]
class ComponentSchemaObject {
  final ClassDefinition classDefinition;

  ComponentSchemaObject(
    this.classDefinition,
  );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    Map<String, dynamic> objectMap = {};
    objectMap['type'] = SchemaObjectType.object.name;
    objectMap['properties'] = {};
    for (var field in classDefinition.fields) {
      objectMap['properties'][field.name] = {
        'type': field.type.toSchemaObjectType.name,
      };
    }
    map[classDefinition.className] = objectMap;

    return map;
  }
}
