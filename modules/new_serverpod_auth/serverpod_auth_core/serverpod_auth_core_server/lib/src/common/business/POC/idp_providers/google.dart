import 'package:serverpod/serverpod.dart';
import 'package:uuid/v4.dart';

import '../../../../generated/protocol.dart';
import '../provider_factory.dart';
import '../token_issuer.dart';

/// Simulated concrete implementation of GoogleAuthProvider
class GoogleAuthProvider {
  final TokenIssuer _tokenIssuer;

  /// Simulated example of provider configuration
  final bool enabled;

  /// Simulates Google authentication.
  Future<AuthSuccess> authenticate([final UuidValue? authUserId]) async {
    if (!enabled) {
      throw StateError('Google authentication is not enabled');
    }

    return _tokenIssuer.issueToken(
      // session: session,
      authUserId: authUserId ?? UuidValue.fromString(const UuidV4().generate()),
      method: 'google',
      kind: 'login',
      scopes: {const Scope('google')},
      transaction: null,
    );
  }

  /// Creates a new instance of the GoogleAuthProvider.
  GoogleAuthProvider({
    required final TokenIssuer tokenIssuer,
    required final GoogleConfig config,
  })  : _tokenIssuer = tokenIssuer,
        enabled = config.enabled;
}

/// Configuration for the Google authentication provider.
class GoogleConfig {
  /// Simulated configuration.
  final bool enabled;

  /// Creates a new instance of the GoogleAuthConfig.
  GoogleConfig({required this.enabled});
}

/// Configuration for the Google authentication provider.
/// It also implements the [IdentityProviderFactory] interface making it possible to
/// pass directly to the [AuthConfig] during initialization.
class GoogleAuthFactory implements IdentityProviderFactory<GoogleAuthProvider> {
  /// Simulated configuration.
  final bool enabled;

  /// Creates a new instance of the GoogleAuthConfig.
  GoogleAuthFactory({required this.enabled});

  @override
  GoogleAuthProvider construct({required final TokenIssuer tokenIssuer}) {
    return GoogleAuthProvider(
        tokenIssuer: tokenIssuer, config: GoogleConfig(enabled: enabled));
  }

  @override
  Type get type => GoogleAuthProvider;
}
