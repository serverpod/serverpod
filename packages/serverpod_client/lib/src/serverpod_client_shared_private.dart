import 'package:serverpod_serialization/serverpod_serialization.dart';

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
