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
  map[OpenAPIJsonKey.type.name] = OpenAPISchemaType.object.name;
  if (type.nullable) map[OpenAPIJsonKey.nullable.name] = true;

  // If data is Map<String,int> use last int from generics as
  // additionalProperties.
  if (type.generics.isEmpty) return map;
  var lastType = type.generics.last;
  map[OpenAPIJsonKey.additionalProperties.name] =
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
  map[OpenAPIJsonKey.type.name] = type.toOpenAPISchemaType.name;
  if (type.nullable) map[OpenAPIJsonKey.nullable.name] = true;
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
  if (!child) map[OpenAPIJsonKey.type.name] = OpenAPISchemaType.object.name;
  map[OpenAPIJsonKey.$ref.name] =
      _getRef(type.className == 'dynamic' ? 'AnyValue' : type.className);
  if (type.nullable && !child) map[OpenAPIJsonKey.nullable.name] = true;
  return map;
}

/// Serializes a [TypeDefinition] [List] type to JSON.
Map<String, dynamic> listTypeToJson(TypeDefinition type, [bool child = false]) {
  assert(
    type.isListType,
    'Use listTypeToJson only when the typeDefinition is of the ListType.',
  );
  Map<String, dynamic> map = {};
  map[OpenAPIJsonKey.type.name] = OpenAPISchemaType.array.name;

  map[OpenAPIJsonKey.items.name] = {};

  var generic = type.generics;
  if (generic.isEmpty) {
    map[OpenAPIJsonKey.items.name][OpenAPIJsonKey.$ref.name] =
        _getRef('AnyValue');
    return map;
  }
  map[OpenAPIJsonKey.items.name] = typeDefinitionToJson(generic.first, true);
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
        OpenAPIJsonKey.type.name: OpenAPISchemaType.string.name,
        'enum': enumDefinition.values.map((e) => e.name).toList(),
      };
      return map;
    }

    if (entityDefinition is ClassDefinition) {
      var classDefinition = entityDefinition as ClassDefinition;
      map[entityDefinition.className] = {
        OpenAPIJsonKey.type.name: OpenAPISchemaType.object.name,
        OpenAPIJsonKey.properties.name: {
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
    return {
      OpenAPIJsonKey.type.name: OpenAPISchemaType.object.name,
      OpenAPIJsonKey.properties.name: {
        for (var param in params)
          param.name: typeDefinitionToJson(param.type, true),
      }
    };
  }
}

/// A schema  used within [OpenAPIParameter].
class ParameterSchemaObject {
  final TypeDefinition typeDefinition;

  ParameterSchemaObject(this.typeDefinition);

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    if (typeDefinition.isEnum) {
      map[OpenAPIJsonKey.type.name] = OpenAPISchemaType.string.name;
      map['enum'] = {};
      return map;
    }
    map = typeDefinitionToJson(typeDefinition);
    return map;
  }
}

String _getRef(String ref) {
  return '#/components/schemas/$ref';
}
