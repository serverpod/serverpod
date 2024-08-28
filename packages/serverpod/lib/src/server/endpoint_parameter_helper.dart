import 'dart:convert';

import 'package:serverpod_serialization/serverpod_serialization.dart';

import 'endpoint_dispatch.dart';

/// Parses query parameters from a raw string to a map.
Map<String, dynamic> decodeParameters(String? paramString) {
  return paramString == null || paramString.isEmpty
      ? {}
      : jsonDecode(paramString) as Map<String, dynamic>;
}

/// Parses query parameters from a raw map of parameters to a formatted map
/// according to the provided [ParameterDescription]s.
///
/// Throws an exception if required parameters are missing or if the
/// paramString can't be jsonDecoded.
Map<String, dynamic> parseParameters(
  Map<String, dynamic> decodedParams,
  Map<String, ParameterDescription> descriptions,
  SerializationManager serializationManager,
) {
  if (descriptions.isEmpty) return {};

  var deserializedParams = <String, dynamic>{};
  for (var description in descriptions.values) {
    var name = description.name;
    var serializedParam = decodedParams[name];

    if (serializedParam != null) {
      deserializedParams[name] = serializationManager.deserialize(
        serializedParam,
        description.type,
      );
    } else if (!description.nullable) {
      throw InvalidParametersException(
          'Missing required query parameter: $name');
    }
  }

  return deserializedParams;
}
