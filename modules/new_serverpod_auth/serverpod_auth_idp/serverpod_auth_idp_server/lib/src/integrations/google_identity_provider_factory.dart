import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';

import '../providers/google/google.dart';

/// AuthServices factory for creating [GoogleIDP] instances.
class GoogleIdentityProviderFactory extends IdentityProviderFactory<GoogleIDP> {
  /// The configuration that will be used to create the [GoogleIDP].
  final GoogleIDPConfig config;

  /// Creates a new [GoogleIdentityProviderFactory].
  GoogleIdentityProviderFactory(
    this.config,
  );

  @override
  GoogleIDP construct({
    required final TokenManager tokenManager,
    required final AuthUsers authUsers,
    required final UserProfiles userProfiles,
    final Serverpod? pod,
  }) {
    return GoogleIDP(
      config,
      tokenIssuer: tokenManager,
      authUsers: authUsers,
      userProfiles: userProfiles,
    );
  }

  /// Creates a new [GoogleIdentityProviderFactory] from keys.
  factory GoogleIdentityProviderFactory.fromKeys(
    final String? Function(String key) getConfig,
  ) {
    return GoogleIdentityProviderFactory(
      GoogleIDPConfig.fromKeys(getConfig),
    );
  }
}

/// Extension to get the GoogleIDP instance from the AuthServices.
extension GoogleIDPGetter on AuthServices {
  /// Returns the GoogleIDP instance from the AuthServices.
  GoogleIDP get googleIDP => AuthServices.getIdentityProvider<GoogleIDP>();
}
