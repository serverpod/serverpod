import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import '../../../utils/get_passwords_extension.dart';
import 'passkey_idp.dart';

/// Configuration for the Passkey account module.
class PasskeyIdpConfig extends IdentityProviderBuilder<PasskeyIdp> {
  /// The hostname to be used on the web and associated with any apps.
  ///
  /// This is also known as the "relying party".
  final String hostname;

  /// Maximum time after which a challenge must have been solved.
  ///
  /// Default is 5 minutes.
  final Duration challengeLifetime;

  /// Creates a new configuration.
  const PasskeyIdpConfig({
    required this.hostname,
    this.challengeLifetime = const Duration(minutes: 5),
  });

  @override
  PasskeyIdp build({
    required final TokenManager tokenManager,
    required final AuthUsers authUsers,
    required final UserProfiles userProfiles,
  }) {
    return PasskeyIdp(
      this,
      tokenManager: tokenManager,
      authUsers: authUsers,
    );
  }
}

/// Creates a new [PasskeyIdpConfig] from keys on the `passwords.yaml` file.
///
/// This constructor requires that a [Serverpod] instance has already been initialized.
class PasskeyIdpConfigFromPasswords extends PasskeyIdpConfig {
  /// Creates a new [PasskeyIdpConfigFromPasswords] instance.
  PasskeyIdpConfigFromPasswords({
    super.challengeLifetime,
  }) : super(
         hostname: Serverpod.instance.getPasswordOrThrow('passkeyHostname'),
       );
}
