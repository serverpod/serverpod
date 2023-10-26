import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/generator/open_api/helpers/extensions.dart';
import 'package:serverpod_cli/src/generator/open_api/helpers/utils.dart';

/// Serializes [TypeDefinition] all type to JSON.
Map<String, dynamic> typeDefinitionToJson(TypeDefinition type,
    [bool child = false]) {
  Map<String, dynamic> map = {};
  if (type.className == 'Future') {
    return typeDefinitionToJson(type.generics.first, child);
  }
  if (type.className == 'void') return map;
  if (type.isMapType) {
    map = mapTypeToJson(type, child);
    return map;
  }
  if (type.isListType) {
    map = listTypeToJson(type, child);
    return map;
  }

  if (type.isUnknownSchemaType) {
    map = unknownSchemaTypeToJson(type, child);
    return map;
  }
  map = coreDartTypeToJson(type, child);
  return map;
}

/// Serializes a [TypeDefinition] [Map] type to JSON.
Map<String, dynamic> mapTypeToJson(TypeDefinition type, [bool child = false]) {
  assert(
    type.isMapType,
    'Use mapTypeToJson only when the typeDefinition is of the MapType.',
  );

  Map<String, dynamic> map = {};
  map[OpenAPIJsonKey.type] = OpenAPISchemaType.object.name;
  if (type.nullable) map[OpenAPIJsonKey.nullable] = true;

  // If data is Map<String,int> use last int from generics as
  // additionalProperties.
  if (type.generics.isEmpty) return map;
  var lastType = type.generics.last;
  map[OpenAPIJsonKey.additionalProperties] =
      typeDefinitionToJson(lastType, true);
  return map;
}

/// Serializes a [TypeDefinition] core dart type (String, bool, double, int,
/// BigInt, ...) to JSON.
Map<String, dynamic> coreDartTypeToJson(TypeDefinition type,
    [bool child = false]) {
  assert(
    type.toOpenAPISchemaType != OpenAPISchemaType.serializableObjects,
    'OpenAPISchemaType should not be serializableObjects type.',
  );
  assert(
    type.toOpenAPISchemaType != OpenAPISchemaType.array,
    'OpenAPISchemaType should not be array type.',
  );
  assert(
    type.toOpenAPISchemaType != OpenAPISchemaType.object,
    'OpenAPISchemaType should not be object type.',
  );
  Map<String, dynamic> map = {};
  map[OpenAPIJsonKey.type] = type.toOpenAPISchemaType.name;
  if (type.nullable) map[OpenAPIJsonKey.nullable] = true;
  return map;
}

/// Serializes a [OpenAPISchemaType.serializableObjects] to JSON.
Map<String, dynamic> unknownSchemaTypeToJson(TypeDefinition type,
    [bool child = false]) {
  assert(
    type.toOpenAPISchemaType == OpenAPISchemaType.serializableObjects,
    'Use unknownSchemaTypeToJson only when the OpenAPISchemaType is serializableObjects.',
  );
  Map<String, dynamic> map = {};

  // SerializableObjects types are always object.
  if (!child) map[OpenAPIJsonKey.type] = OpenAPISchemaType.object.name;
  map[OpenAPIJsonKey.$ref] =
      _getRef(type.className == 'dynamic' ? 'AnyValue' : type.className);
  if (type.nullable && !child) map[OpenAPIJsonKey.nullable] = true;
  return map;
}

/// Serializes a [TypeDefinition] [List] type to JSON.
Map<String, dynamic> listTypeToJson(TypeDefinition type, [bool child = false]) {
  assert(
    type.isListType,
    'Use listTypeToJson only when the typeDefinition is of the ListType.',
  );
  Map<String, dynamic> map = {};
  map[OpenAPIJsonKey.type] = OpenAPISchemaType.array.name;

  map[OpenAPIJsonKey.items] = {};

  var generic = type.generics;
  if (generic.isEmpty) {
    map[OpenAPIJsonKey.items][OpenAPIJsonKey.$ref] = _getRef('AnyValue');
    return map;
  }
  map[OpenAPIJsonKey.items] = typeDefinitionToJson(generic.first, true);
  return map;
}

/// A schema object used within [OpenAPIComponent].
class OpenAPIComponentSchema {
  final SerializableEntityDefinition entityDefinition;

  OpenAPIComponentSchema(
    this.entityDefinition,
  );

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};

    if (entityDefinition is EnumDefinition) {
      var enumDefinition = entityDefinition as EnumDefinition;
      map[entityDefinition.className] = {
        OpenAPIJsonKey.type: OpenAPISchemaType.string.name,
        OpenAPIJsonKey.enumKey:
            enumDefinition.values.map((e) => e.name).toList(),
      };
      return map;
    }

    if (entityDefinition is ClassDefinition) {
      var classDefinition = entityDefinition as ClassDefinition;
      map[entityDefinition.className] = {
        OpenAPIJsonKey.type: OpenAPISchemaType.object.name,
        OpenAPIJsonKey.properties: {
          for (var field in classDefinition.fields)
            field.name: typeDefinitionToJson(field.type, true),
        }
      };
    }

    return map;
  }
}

/// A schema object used within [ContentObject]. Generate request body content
/// based on the parameters of a Serverpod endpoint's method.
class OpenAPIRequestContentSchema {
  final List<ParameterDefinition> params;
  OpenAPIRequestContentSchema({
    required this.params,
  });

  Map<String, dynamic> toJson() {
    var properties = <String, dynamic>{};
    for (var param in params) {
      if (param.type.nullable &&
          param.type.toOpenAPISchemaType ==
              OpenAPISchemaType.serializableObjects) {
        // Note: In OpenAPI (3.0.x) components, sibling properties alongside
        // $refs are not considered. Directly specifying 'nullable' or other
        // properties in this context is not supported.
        properties.addAll({
          param.name: {
            OpenAPIJsonKey.allOf: typeDefinitionToJson(param.type, true),
          },
          OpenAPIJsonKey.nullable: param.type.nullable
        });
      } else {
        properties.addAll(
          {
            param.name: typeDefinitionToJson(param.type, true),
          },
        );
      }
    }
    return {
      OpenAPIJsonKey.type: OpenAPISchemaType.object.name,
      OpenAPIJsonKey.properties: properties
    };
  }
}

/// A schema  used within [OpenAPIParameter].
class OpenAPIParameterSchema {
  final TypeDefinition typeDefinition;

  OpenAPIParameterSchema(this.typeDefinition);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    if (typeDefinition.isEnum) {
      map[OpenAPIJsonKey.type] = OpenAPISchemaType.string.name;
      map[OpenAPIJsonKey.enumKey] = {};
      return map;
    }
    map = typeDefinitionToJson(typeDefinition);
    return map;
  }
}

String _getRef(String ref) {
  return '#/components/schemas/$ref';
}
