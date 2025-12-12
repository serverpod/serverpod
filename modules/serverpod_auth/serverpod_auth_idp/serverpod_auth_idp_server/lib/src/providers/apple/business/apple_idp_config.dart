import 'package:serverpod/serverpod.dart';
import 'package:sign_in_with_apple_server/sign_in_with_apple_server.dart';

import '../../../../../core.dart';
import '../../../utils/get_passwords_extension.dart';
import 'apple_idp.dart';

/// Configuration for the Apple identity provider.
class AppleIdpConfig extends IdentityProviderBuilder<AppleIdp> {
  /// The service identifier for the Sign in with Apple project.
  final String serviceIdentifier;

  /// The bundle ID of the Apple-native app using Sign in with Apple.
  final String bundleIdentifier;

  /// The redirect URL used for 3rd party platforms, e.g. Android.
  final String redirectUri;

  /// The team identifier of the parent Apple Developer account.
  final String teamId;

  /// The ID of the key associated with the Sign in with Apple service.
  final String keyId;

  /// The secret contents of the private key file received once from Apple.
  final String key;

  /// Creates a new Sign in with Apple configuration.
  const AppleIdpConfig({
    required this.serviceIdentifier,
    required this.bundleIdentifier,
    required this.redirectUri,
    required this.teamId,
    required this.keyId,
    required this.key,
  });

  @override
  AppleIdp build({
    required final TokenManager tokenManager,
    required final AuthUsers authUsers,
    required final UserProfiles userProfiles,
  }) {
    return AppleIdp(
      this,
      tokenManager: tokenManager,
      authUsers: authUsers,
      userProfiles: userProfiles,
    );
  }
}

/// Creates a new [AppleIdpConfig] from keys on the `passwords.yaml` file.
///
/// This constructor requires that a [Serverpod] instance has already been initialized.
class AppleIdpConfigFromPasswords extends AppleIdpConfig {
  /// Creates a new [AppleIdpConfigFromPasswords] instance.
  AppleIdpConfigFromPasswords()
    : super(
        serviceIdentifier: Serverpod.instance.getPasswordOrThrow(
          'appleServiceIdentifier',
        ),
        bundleIdentifier: Serverpod.instance.getPasswordOrThrow(
          'appleBundleIdentifier',
        ),
        redirectUri: Serverpod.instance.getPasswordOrThrow('appleRedirectUri'),
        teamId: Serverpod.instance.getPasswordOrThrow('appleTeamId'),
        keyId: Serverpod.instance.getPasswordOrThrow('appleKeyId'),
        key: Serverpod.instance.getPasswordOrThrow('appleKey'),
      );
}

/// Extension methods for [AppleIdpConfig].
extension AppleIdpConfigExtension on AppleIdpConfig {
  /// Converts the [AppleIdpConfig] to a [SignInWithAppleConfiguration].
  SignInWithAppleConfiguration toSignInWithAppleConfiguration() {
    return SignInWithAppleConfiguration(
      serviceIdentifier: serviceIdentifier,
      bundleIdentifier: bundleIdentifier,
      redirectUri: redirectUri,
      teamId: teamId,
      keyId: keyId,
      key: key,
    );
  }
}
