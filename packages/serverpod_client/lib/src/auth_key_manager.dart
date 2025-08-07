import 'dart:async';

import 'package:meta/meta.dart';

/// Manages keys for authentication with the server.
abstract class AuthenticationKeyProvider {
  /// Retrieves the authentication key to be used for the next request.
  ///
  /// Depending on the request, plain HTTP vs. WebSocket for streaming-requests,
  /// this will be send either as the `Authorization` header or an `auth` URL
  /// query parameter.
  ///
  /// The framework ensures that this is encoded appropriately and the server
  /// will unwrap it to its original value.
  FutureOr<String?> getAuthenticationKey();

  /// Callback to be invoked whenever a given auth header value lead to an
  /// unauthenticated exception on the server.
  ///
  /// Implementors may use this to invalidate their stored session.
  @visibleForOverriding
  void onUnauthenticatedException(String authenticationKey) {}
}

// TODO: Remove in 3.0
// ignore: public_member_api_docs
typedef AuthenticationKeyManager = AuthenticationKeyProvider;
