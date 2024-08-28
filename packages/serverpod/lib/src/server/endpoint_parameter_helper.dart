import 'package:serverpod_serialization/serverpod_serialization.dart';

import 'endpoint_dispatch.dart';

/// Parses parameters from a map of parameters to a formatted map
/// according to the provided [ParameterDescription]s.
/// Throws a [InvalidParametersException] if required parameters are missing.
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
