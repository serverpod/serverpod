import 'package:serverpod_client/serverpod_client.dart';

/// Manages keys for authentication with the server.
@Deprecated(
  'Use ClientAuthKeyProvider instead. This will be removed in future releases.',
)
abstract class AuthenticationKeyManager implements ClientAuthKeyProvider {
  /// Backwards compatible authentication header value getter.
  @override
  Future<String?> get authHeaderValue => getHeaderValue();

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

  /// Converts an authentication key to a format that can be used in a transport
  /// header. This will automatically be unwrapped again on the server side
  /// before being handed to the authentication handler.
  ///
  /// The value must be compliant with the HTTP header format defined in
  /// RFC 9110 HTTP Semantics, 11.6.2. Authorization.
  /// See:
  /// https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Authorization
  /// https://httpwg.org/specs/rfc9110.html#field.authorization
  Future<String?> toHeaderValue(String? key);
}
