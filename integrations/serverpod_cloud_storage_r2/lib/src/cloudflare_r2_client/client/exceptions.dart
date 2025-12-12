import 'package:http/http.dart';

class R2Exception implements Exception {
  final Response response;

  R2Exception(this.response);

  @override
  String toString() {
    return '''$devDebugHint: ${runtimeType.toString()}{
    statusCode: ${response.statusCode},
    body: ${response.body},
    headers: ${response.headers}
    }''';
  }

  String get devDebugHint => "We got an unexpected response from Cloudflare R2: ";
}

class NoPermissionsException extends R2Exception {
  NoPermissionsException(super.response);

  @override
  String get devDebugHint =>
      "Cloudflare R2 returned a 403 status code. Please make sure you have the right permissions for this request";
}