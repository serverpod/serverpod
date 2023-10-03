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
      if (returnType.generics.length > 1) {
        map['additionalProperties'] = ItemSchemaObject(
          generics.last,
          additionalProperties: true,
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
    if (generics.first.isListType) {
      map['type'] = SchemaObjectType.array.name;
      var items = ItemSchemaObject(generics.last);
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

/// A SchemaObject used in [items]
class ItemSchemaObject {
  /// Use in Map items if true remove type.
  final bool additionalProperties;
  final TypeDefinition typeDefinition;

  ItemSchemaObject(this.typeDefinition, {this.additionalProperties = false});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    ///if type is custom class return ref
    if (!typeDefinition.isDartCoreType) {
      if (!additionalProperties) {
        map['type'] = SchemaObjectType.object.name;
      }
      map['\$ref'] = getRef(typeDefinition.className);
    } else {
      map['type'] = typeDefinition.toSchemaObjectType.name;
    }

    return map;
  }
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
          additionalProperties: true,
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
