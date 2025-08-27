import 'package:serverpod/serverpod.dart';
import 'package:uuid/uuid_value.dart';
import 'package:uuid/v4.dart';

import '../../../../generated/protocol.dart';
import '../provider_factory.dart';
import '../token_issuer.dart';

/// Simulated concrete implementation of EmailAuthProvider
class EmailAuthProvider {
  final TokenIssuer _tokenIssuer;

  /// Simulated example of provider configuration
  final bool enabled;

  /// Simulates email authentication.
  Future<AuthSuccess> authenticate([final UuidValue? authUserId]) async {
    if (!enabled) {
      throw StateError('Email authentication is not enabled');
    }

    return _tokenIssuer.issueToken(
      // session: session,
      authUserId: authUserId ?? UuidValue.fromString(const UuidV4().generate()),
      method: 'email',
      kind: 'login',
      scopes: {const Scope('email')},
      transaction: null,
    );
  }

  /// Creates a new instance of the EmailAuthProvider.
  EmailAuthProvider({
    required final TokenIssuer tokenIssuer,
    required final EmailConfig config,
  })  : _tokenIssuer = tokenIssuer,
        enabled = config.enabled;
}

/// Configuration for the Email authentication provider.
class EmailConfig {
  /// Simulated configuration.
  final bool enabled;

  /// Creates a new instance of the EmailAuthConfig.
  EmailConfig({required this.enabled});
}

/// Factory with a configuration that creates the email authentication provider.
/// It also implements the [IdentityProviderFactory] interface making it possible to
/// pass directly to the [AuthConfig] during initialization.
class EmailAuthFactory implements IdentityProviderFactory<EmailAuthProvider> {
  /// Simulated configuration.
  final bool enabled;

  /// Creates a new instance of the EmailAuthConfig.
  EmailAuthFactory({required this.enabled});

  @override
  EmailAuthProvider construct({required final TokenIssuer tokenIssuer}) {
    return EmailAuthProvider(
        tokenIssuer: tokenIssuer, config: EmailConfig(enabled: enabled));
  }

  @override
  Type get type => EmailAuthProvider;
}
