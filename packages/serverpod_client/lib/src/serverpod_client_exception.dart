import 'dart:html' if (dart.library.io) 'dart:io';

/// [Exception] thrown when errors in communication with the server occurs.
class ServerpodClientException implements Exception {
  /// Error message sent from the server.
  final String message;

  /// Http status code associated with the error.
  final int statusCode;

  /// Creates a new [ServerpodClientException].
  const ServerpodClientException(this.message, this.statusCode);

  @override
  String toString() {
    return ('ServerpodClientException: ${message.trim()}, statusCode = $statusCode');
  }
}

/// Thrown if the client created a malformed or invalid request
/// to the server.
class ServerpodClientBadRequest extends ServerpodClientException {
  /// Creates a Bad Request Exception
  ServerpodClientBadRequest() : super('Bad request', HttpStatus.badRequest);
}

/// Thrown if the client fails to authenticate and is therefore
/// not authorized to perform the request.
class ServerpodClientUnauthorized extends ServerpodClientException {
  /// Creates an Unauthorized Exception
  ServerpodClientUnauthorized()
      : super('Unauthorized', HttpStatus.unauthorized);
}

/// Thrown if the client is forbidden to perform the request.
/// This is typically due to missing permissions.
class ServerpodClientForbidden extends ServerpodClientException {
  /// Creates a Forbidden Exception
  ServerpodClientForbidden() : super('Forbidden', HttpStatus.forbidden);
}

/// Thrown if the requested resource was not found on the server.
class ServerpodClientNotFound extends ServerpodClientException {
  /// Creates a Not Found Exception
  ServerpodClientNotFound() : super('Not found', HttpStatus.notFound);
}

/// Thrown if the server encountered an internal error.
/// This is typically a bug in the server code.
class ServerpodClientInternalServerError extends ServerpodClientException {
  /// Creates an Internal Server Error Exception
  ServerpodClientInternalServerError()
      : super('Internal server error', HttpStatus.internalServerError);
}
