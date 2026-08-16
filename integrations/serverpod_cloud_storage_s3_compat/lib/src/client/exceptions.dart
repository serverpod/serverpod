import 'package:http/http.dart';

/// Exception thrown when an S3-compatible API returns an error.
class S3Exception implements Exception {
  /// The HTTP response that caused this exception.
  final Response response;

  /// Creates an S3Exception from an HTTP response.
  S3Exception(this.response);

  @override
  String toString() {
    return '''$devDebugHint: ${runtimeType.toString()}{
    statusCode: ${response.statusCode},
    body: ${response.body},
    headers: ${response.headers}
    }''';
  }

  /// Debug hint message explaining the error.
  String get devDebugHint => 'We got an unexpected response from S3: ';
}

/// Exception thrown when the API returns a 403 Forbidden response.
class NoPermissionsException extends S3Exception {
  /// Creates a NoPermissionsException from an HTTP response.
  NoPermissionsException(super.response);

  @override
  String get devDebugHint =>
      'S3 returned a 403 status code. Please make sure you have the right permissions for this request';
}
