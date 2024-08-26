import 'package:serverpod/serverpod.dart';

/// This class is meant for reflecting the received headers, auth keys in endpoint invocations.
class ReflectionEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Reflects the authentication key of the session.
  /// Returns null if the key is not set.
  Future<String?> reflectAuthenticationKey(Session session) async {
    var ms = session as MethodCallSession;
    ms.httpRequest.headers.forEach((key, value) {
      print('Header: $key: $value');
    });
    return session.authenticationKey;
  }

  /// Reflects a specified header of the HTTP request.
  /// Returns null of the header is not set.
  Future<List<String>?> reflectHttpHeader(
      Session session, String headerName) async {
    var ms = session as MethodCallSession;
    return ms.httpRequest.headers[headerName];
  }
}
