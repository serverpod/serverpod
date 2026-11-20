import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/analyzer.dart';
import 'package:serverpod_cli/src/analyzer/dart/definitions.dart';
import 'package:serverpod_cli/src/generator/code_generator.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_database/serverpod_database.dart'
    show EnumSerialization;

/// Generates an OpenAPI 3.1 specification describing the project's endpoints.
///
/// Serverpod exposes every method as `POST /{endpoint}/{method}` with a JSON
/// body holding the named parameters. Only the project's own endpoints are
/// described, not those of modules. Streaming methods are omitted, since they
/// use WebSockets which OpenAPI cannot describe.
///
/// Disabled unless `openapi.enabled` is set in `config/generator.yaml`.
class OpenApiGenerator extends CodeGenerator {
  const OpenApiGenerator();

  @override
  Map<String, String> generateSerializableModelsCode({
    required List<SerializableModelDefinition> models,
    required GeneratorConfig config,
  }) => {};

  @override
  Map<String, String> generateProtocolCode({
    required ProtocolDefinition protocolDefinition,
    required GeneratorConfig config,
  }) {
    if (!config.openApi.enabled) return {};

    var spec = buildOpenApiSpec(protocolDefinition, config);
    var json = const JsonEncoder.withIndent('  ').convert(spec);

    return {
      p.joinAll(config.generatedOpenApiFilePathParts): '$json\n',
    };
  }
}

/// Builds the OpenAPI document as a JSON-encodable map.
Map<String, Object?> buildOpenApiSpec(
  ProtocolDefinition protocolDefinition,
  GeneratorConfig config,
) {
  var schemas = _SchemaRegistry(protocolDefinition.models);
  var schemeNames = config.openApi.securitySchemes.keys.toSet();
  var paths = <String, Object?>{};

  var endpoints =
      protocolDefinition.endpoints
          .where(
            (e) =>
                !e.isAbstract &&
                !e.annotations.has('doNotGenerate') &&
                !e.annotations.has('openApiExclude'),
          )
          .toList()
        ..sort((a, b) => a.name.compareTo(b.name));

  for (var endpoint in endpoints) {
    var methods =
        endpoint.methods
            .where(
              (m) =>
                  m is MethodCallDefinition &&
                  !m.annotations.has('doNotGenerate') &&
                  !m.annotations.has('openApiExclude'),
            )
            .toList()
          ..sort((a, b) => a.name.compareTo(b.name));

    for (var method in methods) {
      paths['/${endpoint.name}/${method.name}'] = {
        'post': _buildOperation(endpoint, method, schemas, schemeNames),
      };
    }
  }

  var components = <String, Object?>{
    if (schemas.schemas.isNotEmpty) 'schemas': schemas.sorted(),
    if (config.openApi.securitySchemes.isNotEmpty)
      'securitySchemes': {
        for (var key in config.openApi.securitySchemes.keys.toList()..sort())
          key: config.openApi.securitySchemes[key],
      },
  };

  return {
    'openapi': '3.1.0',
    'info': {
      'title': config.openApi.title ?? config.name,
      'version': config.openApi.version,
    },
    if (config.openApi.servers.isNotEmpty)
      'servers': [
        for (var server in config.openApi.servers)
          {
            'url': server.url,
            'description': ?server.description,
            'x-insights-url': ?server.insightsUrl,
            if (server.testCredentials.isNotEmpty)
              'x-test-credentials': server.testCredentials,
          },
      ],
    'paths': paths,
    if (components.isNotEmpty) 'components': components,
  };
}

Map<String, Object?> _buildOperation(
  EndpointDefinition endpoint,
  MethodDefinition method,
  _SchemaRegistry schemas,
  Set<String> schemeNames,
) {
  var doc = _firstProperty(method.annotations, 'OpenApiDoc') ?? const {};
  var endpointDoc =
      _firstProperty(endpoint.annotations, 'OpenApiDoc') ?? const {};

  var methodDocText = _cleanDoc(method.documentationComment);

  String? summary =
      (doc['summary'] as String?) ??
      (endpointDoc['summary'] as String?) ??
      _firstLine(methodDocText);
  String? description =
      (doc['description'] as String?) ??
      (endpointDoc['description'] as String?) ??
      methodDocText;

  var tags = <String>[
    ...?(doc['tags'] as List?)?.cast<String>(),
    if (doc['tags'] == null || (doc['tags'] as List).isEmpty)
      ...?(endpointDoc['tags'] as List?)?.cast<String>(),
  ];
  if (tags.isEmpty) tags = [endpoint.name];

  var security = _resolveSecurity(endpoint, method, schemeNames);

  var responses = <String, Object?>{
    '200': _successResponse(method.returnType, schemas),
    '400': {'description': 'Invalid parameters.'},
    if (security != null && security.isNotEmpty)
      '401': {'description': 'Authentication is required or failed.'},
    if (security != null && _hasScopes(security))
      '403': {'description': 'Insufficient scopes.'},
    '500': {'description': 'Internal server error.'},
  };

  for (var response in method.annotations.where(
    (a) => a.name == 'OpenApiResponse',
  )) {
    var code = response.properties['statusCode'];
    if (code is! int) continue;
    responses['$code'] = {
      'description': (response.properties['description'] as String?) ?? '',
    };
  }

  var deprecated =
      method.annotations.has('Deprecated') ||
      method.annotations.has('deprecated');

  var requestBody = _buildRequestBody(method, schemas);

  return {
    'operationId':
        (doc['operationId'] as String?) ?? '${endpoint.name}_${method.name}',
    'tags': tags,
    'summary': ?summary,
    if (description != null && description != summary)
      'description': description,
    if (deprecated) 'deprecated': true,
    'requestBody': ?requestBody,
    'security': ?security,
    'responses': _sortedResponses(responses),
  };
}

/// The security requirements of an operation, or null when none are declared
/// (the spec then applies no security). An empty list means explicitly public.
List<Map<String, List<String>>>? _resolveSecurity(
  EndpointDefinition endpoint,
  MethodDefinition method,
  Set<String> schemeNames,
) {
  List<Map<String, List<String>>>? fromAnnotations(
    List<AnnotationDefinition> annotations,
  ) {
    var auths = annotations.where((a) => a.name == 'OpenApiAuth').toList();
    if (auths.isNotEmpty) {
      var requirements = <Map<String, List<String>>>[];
      for (var auth in auths) {
        var scheme = auth.properties['scheme'] as String?;
        if (scheme == null) continue;
        if (!schemeNames.contains(scheme)) {
          log.warning(
            "@OpenApiAuth on '${endpoint.name}' references the security scheme "
            "'$scheme', which is not declared under openapi.securitySchemes "
            'in config/generator.yaml. Ignoring it.',
          );
          continue;
        }
        requirements.add({
          scheme: ((auth.properties['scopes'] as List?) ?? const [])
              .cast<String>(),
        });
      }
      if (requirements.isNotEmpty) return requirements;
    }
    if (annotations.has('unauthenticatedClientCall')) return [];
    return null;
  }

  return fromAnnotations(method.annotations) ??
      fromAnnotations(endpoint.annotations);
}

bool _hasScopes(List<Map<String, List<String>>> security) =>
    security.any((r) => r.values.any((scopes) => scopes.isNotEmpty));

Map<String, Object?>? _buildRequestBody(
  MethodDefinition method,
  _SchemaRegistry schemas,
) {
  var parameters = method.allParameters;
  if (parameters.isEmpty) return null;

  var properties = <String, Object?>{};
  var required = <String>[];

  for (var parameter in parameters) {
    var schema = schemas.schemaForEndpointType(parameter.type);
    var description = _parameterDeprecation(parameter);
    properties[parameter.name] = description == null
        ? schema
        : {...schema, 'deprecated': true};
    if (parameter.required && !parameter.type.nullable) {
      required.add(parameter.name);
    }
  }

  return {
    'required': required.isNotEmpty,
    'content': {
      'application/json': {
        'schema': {
          'type': 'object',
          'properties': properties,
          if (required.isNotEmpty) 'required': required,
        },
      },
    },
  };
}

String? _parameterDeprecation(ParameterDefinition parameter) =>
    parameter.annotations.has('Deprecated') ||
        parameter.annotations.has('deprecated')
    ? 'deprecated'
    : null;

Map<String, Object?> _successResponse(
  TypeDefinition returnType,
  _SchemaRegistry schemas,
) {
  // Endpoint methods always return a Future; unwrap it.
  var type = returnType.isFutureType && returnType.generics.isNotEmpty
      ? returnType.generics.first
      : returnType;

  if (type.isVoidType) return {'description': 'Successful response.'};

  return {
    'description': 'Successful response.',
    'content': {
      'application/json': {'schema': schemas.schemaForEndpointType(type)},
    },
  };
}

Map<String, Object?> _sortedResponses(Map<String, Object?> responses) => {
  for (var key in responses.keys.toList()..sort()) key: responses[key],
};

Map<String, Object?>? _firstProperty(
  List<AnnotationDefinition> annotations,
  String name,
) => annotations.where((a) => a.name == name).firstOrNull?.properties;

/// Strips comment markers from a stored documentation comment.
String? _cleanDoc(String? comment) {
  if (comment == null) return null;
  var lines = comment
      .split('\n')
      .map(
        (l) => l
            .trim()
            .replaceFirst(RegExp(r'^(///|/\*\*|\*/|\*)\s?'), '')
            .replaceFirst(RegExp(r'\s*\*/$'), ''),
      )
      .toList();
  var text = lines.join('\n').trim();
  return text.isEmpty ? null : text;
}

String? _firstLine(String? text) {
  if (text == null) return null;
  return text.split(RegExp(r'\n\s*\n')).first.replaceAll('\n', ' ').trim();
}

/// Collects `components.schemas` while mapping Dart types to JSON schemas.
class _SchemaRegistry {
  _SchemaRegistry(this.models);

  /// All models of the protocol, used to resolve types of endpoint parameters
  /// and return values. Those are not linked to their model definitions by the
  /// endpoint analyzer, unlike the field types of the models themselves.
  final List<SerializableModelDefinition> models;

  final Map<String, Object?> schemas = {};

  /// Describes a class or enum that has no model definition, such as a type
  /// from a module that only ships generated Dart, by reading its Dart
  /// declaration. Returns null if the type has no usable declaration.
  ///
  /// This can only see what Dart sees: every public instance field is
  /// included, so a field the model marks as server-only would show up, and
  /// enums are assumed to be serialized by name.
  Map<String, Object?>? _refFromDartType(TypeDefinition type) {
    var dartType = type.dartType;
    if (dartType is! InterfaceType) return null;

    var element = dartType.element;
    var name = element.displayName;
    var ref = <String, Object?>{r'$ref': '#/components/schemas/$name'};
    if (schemas.containsKey(name)) return ref;

    if (element is EnumElement) {
      schemas[name] = {
        'type': 'string',
        'enum': [
          for (var constant in element.fields)
            if (constant.isEnumConstant) constant.displayName,
        ],
      };
      return ref;
    }
    if (element is! ClassElement) return null;

    // Reserve the name first so recursive classes terminate.
    schemas[name] = <String, Object?>{};

    var properties = <String, Object?>{};
    var required = <String>[];
    // Collect inherited fields first, so a subclass can override them.
    var hierarchy = <InterfaceElement>[];
    for (
      InterfaceElement? e = element;
      e != null && e.displayName != 'Object';
      e = e.supertype?.element
    ) {
      hierarchy.insert(0, e);
    }
    for (var cls in hierarchy) {
      for (var field in cls.fields) {
        if (field.isStatic ||
            field.isOriginGetterSetter ||
            field.displayName.startsWith('_')) {
          continue;
        }
        var fieldType = TypeDefinition.fromDartType(field.type);
        properties[field.displayName] = schemaFor(fieldType);
        required.remove(field.displayName);
        if (!fieldType.nullable) required.add(field.displayName);
      }
    }

    schemas[name] = {
      'type': 'object',
      'properties': properties,
      if (required.isNotEmpty) 'required': required,
    };
    return ref;
  }

  /// The schema of a type taken straight from an endpoint signature.
  Map<String, Object?> schemaForEndpointType(TypeDefinition type) =>
      schemaFor(type.applyProtocolReferences(models));

  Map<String, Object?> sorted() => {
    for (var key in schemas.keys.toList()..sort()) key: schemas[key],
  };

  Map<String, Object?> schemaFor(TypeDefinition type) {
    var schema = _nonNullableSchema(type);
    if (!type.nullable) return schema;

    // OpenAPI 3.1 / JSON Schema 2020-12 express nullability with a union.
    if (schema.containsKey(r'$ref')) {
      return {
        'oneOf': [
          schema,
          {'type': 'null'},
        ],
      };
    }
    var t = schema['type'];
    if (t is String) {
      return {
        ...schema,
        'type': [t, 'null'],
      };
    }
    if (schema.isEmpty) return schema;
    return {
      'oneOf': [
        schema,
        {'type': 'null'},
      ],
    };
  }

  Map<String, Object?> _nonNullableSchema(TypeDefinition type) {
    if (type.isListType || type.isSetType) {
      return {
        'type': 'array',
        if (type.isSetType) 'uniqueItems': true,
        'items': type.generics.isEmpty ? {} : schemaFor(type.generics.first),
      };
    }

    if (type.isMapType) {
      var key = type.generics.firstOrNull;
      var value = type.generics.length > 1 ? type.generics[1] : null;
      var valueSchema = value == null ? <String, Object?>{} : schemaFor(value);
      if (key == null || key.className == 'String') {
        return {'type': 'object', 'additionalProperties': valueSchema};
      }
      // Maps with non-string keys are sent as a list of key/value pairs.
      return {
        'type': 'array',
        'items': {
          'type': 'object',
          'properties': {'k': schemaFor(key), 'v': valueSchema},
          'required': ['k', 'v'],
        },
      };
    }

    if (type.isRecordType) return {'type': 'object'};
    if (type.isVectorType) {
      return {
        'type': 'array',
        'items': {'type': 'number'},
      };
    }
    if (type.isGeographyType) return {'type': 'object'};

    switch (type.className) {
      case 'String':
        return {'type': 'string'};
      case 'int':
        return {'type': 'integer', 'format': 'int64'};
      case 'double':
        return {'type': 'number', 'format': 'double'};
      case 'bool':
        return {'type': 'boolean'};
      case 'DateTime':
        return {'type': 'string', 'format': 'date-time'};
      case 'Duration':
        return {
          'type': 'integer',
          'format': 'int64',
          'description': 'Duration in milliseconds.',
        };
      case 'UuidValue':
        return {'type': 'string', 'format': 'uuid'};
      case 'Uri':
        return {'type': 'string', 'format': 'uri'};
      case 'BigInt':
        return {
          'type': 'string',
          'description': 'Arbitrary precision integer.',
        };
      case 'ByteData':
        return {'type': 'string', 'format': 'byte'};
      case 'dynamic':
      case 'Object':
        return {};
    }

    var model =
        type.enumDefinition ??
        type.projectModelDefinition ??
        type.classDefinition;
    if (model == null) return _refFromDartType(type) ?? {};
    return _refFor(model);
  }

  Map<String, Object?> _refFor(SerializableModelDefinition model) {
    var name = model.className;
    var ref = <String, Object?>{r'$ref': '#/components/schemas/$name'};
    if (schemas.containsKey(name)) return ref;

    // Reserve the name first so recursive models terminate.
    schemas[name] = <String, Object?>{};

    if (model is EnumDefinition) {
      var byIndex = model.serialized == EnumSerialization.byIndex;
      schemas[name] = {
        'type': byIndex ? 'integer' : 'string',
        'enum': byIndex
            ? [for (var i = 0; i < model.values.length; i++) i]
            : [for (var v in model.values) v.name],
        'description': ?_docLines(model.documentation),
      };
    } else if (model is ClassDefinition) {
      var properties = <String, Object?>{};
      var required = <String>[];
      for (var field in model.fieldsIncludingInherited) {
        if (field.scope != ModelFieldScopeDefinition.all) continue;
        var schema = schemaFor(field.type);
        var doc = _docLines(field.documentation);
        properties[field.jsonKey] = doc == null
            ? schema
            : {...schema, 'description': doc};
        if (!field.type.nullable) required.add(field.jsonKey);
      }
      schemas[name] = {
        'type': 'object',
        'description': ?_docLines(model.documentation),
        'properties': properties,
        if (required.isNotEmpty) 'required': required,
      };
    }

    return ref;
  }

  String? _docLines(List<String>? lines) {
    if (lines == null || lines.isEmpty) return null;
    var text = lines
        .map((l) => l.replaceFirst(RegExp(r'^\s*///\s?'), ''))
        .join('\n')
        .trim();
    return text.isEmpty ? null : text;
  }
}
