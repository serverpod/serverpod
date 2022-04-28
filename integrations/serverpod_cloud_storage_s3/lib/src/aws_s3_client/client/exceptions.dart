import 'package:http/http.dart';

class S3Exception implements Exception {
  final Response response;

  S3Exception(this.response);

  @override
  String toString() {
    return '''$devDebugHint: ${runtimeType.toString()}{
    statusCode: ${response.statusCode},
    body: ${response.body},
    headers: ${response.headers}
    }''';
  }

  String get devDebugHint => "We got an unexpected response from S3: ";
}

class NoPermissionsException extends S3Exception {
  NoPermissionsException(Response response) : super(response);

  @override
  String get devDebugHint =>
      "S3 returned a 403 status code. Please make sure you have the right permissons for this request";
}
