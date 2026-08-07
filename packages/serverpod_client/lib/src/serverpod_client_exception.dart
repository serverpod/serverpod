import 'http/http_status.dart';

/// [Exception] thrown when errors in communication with the server occurs.
sealed class ServerpodClientException implements Exception {
  /// Error message sent from the server.
  final String message;

  /// Creates a new [ServerpodClientException].
  const ServerpodClientException(this.message);

  @override
  String toString() {
    return '$runtimeType: ${message.trim()}';
  }
}

/// [Exception] thrown when a network error occurs.
class ServerpodClientNetworkException extends ServerpodClientException {
  /// Creates a new [ServerpodClientNetworkException].
  const ServerpodClientNetworkException(super.message);
}

/// [Exception] thrown when an unknown error occurs.
class ServerpodClientUnknownException extends ServerpodClientException {
  /// Creates a new [ServerpodClientUnknownException].
  const ServerpodClientUnknownException(super.message);
}

/// [Exception] thrown when HTTP errors occur in communication with the server.
///
/// Sealed like [ServerpodClientException], so a `switch` over the status code
/// exceptions is also checked for exhaustiveness. Status codes without a
/// dedicated exception are reported as [ServerpodClientUnknownHttpException].
sealed class ServerpodClientHttpException extends ServerpodClientException {
  /// Http status code associated with the error.
  final int statusCode;

  /// Creates a new [ServerpodClientHttpException].
  const ServerpodClientHttpException(super.message, this.statusCode);

  @override
  String toString() {
    return '$runtimeType: ${message.trim()}, statusCode: $statusCode';
  }
}

/// Thrown if the client created a malformed or invalid request
/// to the server.
class ServerpodClientBadRequest extends ServerpodClientHttpException {
  /// Creates a Bad Request Exception
  ServerpodClientBadRequest([String? message])
    : super(
        'Bad request${message != null && message != '' ? ': $message' : ''}',
        HttpStatus.badRequest,
      );
}

/// Thrown if the client fails to authenticate and is therefore
/// not authorized to perform the request.
class ServerpodClientUnauthorized extends ServerpodClientHttpException {
  /// Creates an Unauthorized Exception
  ServerpodClientUnauthorized()
    : super('Unauthorized', HttpStatus.unauthorized);
}

/// Thrown if the client is forbidden to perform the request.
/// This is typically due to missing permissions.
class ServerpodClientForbidden extends ServerpodClientHttpException {
  /// Creates a Forbidden Exception
  ServerpodClientForbidden() : super('Forbidden', HttpStatus.forbidden);
}

/// Thrown if the requested resource was not found on the server.
class ServerpodClientNotFound extends ServerpodClientHttpException {
  /// Creates a Not Found Exception
  ServerpodClientNotFound() : super('Not found', HttpStatus.notFound);
}

/// Thrown if the request entity is too large for the server to process.
class ServerpodClientRequestEntityTooLarge
    extends ServerpodClientHttpException {
  /// Creates a Request Entity Too Large Exception
  ServerpodClientRequestEntityTooLarge()
    : super('Request entity too large', HttpStatus.requestEntityTooLarge);
}

/// Thrown if the server encountered an internal error.
/// This is typically a bug in the server code.
class ServerpodClientInternalServerError extends ServerpodClientHttpException {
  /// Creates an Internal Server Error Exception
  ServerpodClientInternalServerError()
    : super('Internal server error', HttpStatus.internalServerError);
}

/// Thrown if the server responded with an HTTP status code that the client has
/// no dedicated exception for.
class ServerpodClientUnknownHttpException extends ServerpodClientHttpException {
  /// Creates an Unknown Http Exception from the response [data] and the
  /// [statusCode] the server responded with.
  ServerpodClientUnknownHttpException(String data, int statusCode)
    : super('Unknown error, data: $data', statusCode);
}
