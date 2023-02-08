import 'package:serverpod_serialization/serverpod_serialization.dart';

import 'serverpod_client_exception.dart';

/// Encodes arguments for serialization.
String formatArgs(
    Map<String, dynamic> args, String? authorizationKey, String method) {
  if (authorizationKey != null) args['auth'] = authorizationKey;

  args['method'] = method;

  return SerializationManager.encode(args);
}

/// Deserializes data sent from the server based on the return type.
T parseData<T>(
  String data,
  Type returnType,
  SerializationManager serializationManager,
) {
  return serializationManager.decode<T>(data, returnType);
}

/// A helper method, that just 'returns' void.
void returnVoid() {}

/// Trying to parse an exception from a failure response
dynamic getExceptionFrom({
  required String data,
  required SerializationManager serializationManager,
  required int statusCode,
}) {
  dynamic dataObject = serializationManager.decodeWithType(data);
  if (dataObject is SerializableException) {
    return dataObject;
  }
  return (ServerpodClientException(data, statusCode));
}
