import 'package:serverpod_serialization/serverpod_serialization.dart';

import 'serverpod_client_exception.dart';

import 'http/http_status.dart';

/// Encodes arguments for serialization.
String formatArgs(
  Map<String, dynamic> args,
  String method,
) {
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
Exception getExceptionFrom({
  required String data,
  required SerializationManager serializationManager,
  required int statusCode,
}) {
  if (data.isNotEmpty) {
    try {
      var dataObject = serializationManager.decodeWithType(data);
      if (dataObject is SerializableException) {
        return dataObject;
      }
    } catch (e) {
      // Ignore
    }
  }

  return switch (statusCode) {
    HttpStatus.badRequest => ServerpodClientBadRequest(data),
    HttpStatus.unauthorized => ServerpodClientUnauthorized(),
    HttpStatus.forbidden => ServerpodClientForbidden(),
    HttpStatus.notFound => ServerpodClientNotFound(),
    HttpStatus.internalServerError => ServerpodClientInternalServerError(),
    _ => ServerpodClientException('Unknown error, data: $data', statusCode),
  };
}
