import 'package:serverpod_serialization/serverpod_serialization.dart';

/// Manages keys for authentication with the server.
abstract class AuthenticationKeyManager {
  /// Retrieves an authentication key.
  Future<String?> get();

  /// Saves an authentication key retrieved by the server.
  Future<void> put(String key);

  /// Removes the authentication key.
  Future<void> remove();

  /// Retrieves the authentication key in a format that can be used in a transport header.
  /// The format conversion is performed by [toHeaderValue].
  Future<String?> getHeaderValue() async {
    String? key = await get();
    return toHeaderValue(key);
  }

  /// Converts an authentication key to a format that can be used in a transport header.
  /// The default implementation encodes and wraps the key in a 'Basic' scheme.
  /// (This will automatically be unwrapped again on the server side
  /// before being handed to the authentication handler.)
  ///
  /// To use a different scheme, override this method.
  /// The value must be compliant with the HTTP header format defined in
  /// RFC 9110 HTTP Semantics, 11.6.2. Authorization.
  /// See:
  /// https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Authorization
  /// https://httpwg.org/specs/rfc9110.html#field.authorization
  Future<String?> toHeaderValue(String? key) async {
    if (key == null) return null;
    return wrapAuthValue(key);
  }
}
