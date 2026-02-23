import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/src/utils/get_passwords_extension.dart';

import '../../../../../core.dart';
import 'facebook_idp.dart';
import 'facebook_idp_utils.dart';

/// Function to be called to check whether a Facebook account details match the
/// requirements during registration.
typedef FacebookAccountDetailsValidation =
    void Function(
      FacebookAccountDetails accountDetails,
    );

/// Function to be called to extract additional information from Facebook API
/// using the access token. The [session] and [transaction] can be used to
/// store additional information in the database.
typedef GetExtraFacebookInfoCallback =
    Future<void> Function(
      Session session, {
      required FacebookAccountDetails accountDetails,
      required String accessToken,
      required Transaction? transaction,
    });

/// Configuration for the Facebook identity provider.
class FacebookIdpConfig extends IdentityProviderBuilder<FacebookIdp> {
  /// The app ID from your Facebook Developer app.
  final String appId;

  /// The app secret from your Facebook Developer app.
  final String appSecret;

  /// Validation function for Facebook account details.
  ///
  /// This function should throw an exception if the account details do not
  /// match the requirements. If the function returns normally, the account
  /// is considered valid.
  ///
  /// It can be used to enforce additional requirements on the Facebook account
  /// details before allowing the user to sign in.
  ///
  /// To avoid blocking real users with private profiles from signing in,
  /// adjust your validation function with care.
  final FacebookAccountDetailsValidation facebookAccountDetailsValidation;

  /// Callback that can be used with the access token to extract additional
  /// information from Facebook Graph API.
  ///
  /// This callback is invoked during [FacebookIdpUtils.fetchAccountDetails],
  /// before the system determines if the user is new or returning. It runs on
  /// EVERY authentication attempt.
  ///
  /// **CRITICAL - Do NOT create these models in the callback:**
  /// - [FacebookAccount] - Breaks new account detection
  /// - [UserProfile] - Interferes with automatic profile creation
  /// - [AuthUser] - Already handled by the authentication flow
  ///
  /// Creating these models will cause the authentication flow in [FacebookIdp.login]
  /// to fail or skip critical steps like user profile creation.
  ///
  /// **Safe usage:** Store data in your own custom tables, linked by
  /// [FacebookAccountDetails.userIdentifier]. Keep operations lightweight.
  final GetExtraFacebookInfoCallback? getExtraFacebookInfoCallback;

  /// Creates a new instance of [FacebookIdpConfig].
  const FacebookIdpConfig({
    required this.appId,
    required this.appSecret,
    this.facebookAccountDetailsValidation = validateFacebookAccountDetails,
    this.getExtraFacebookInfoCallback,
  });

  /// Default validation function for extracted Facebook account details.
  ///
  /// This default implementation performs minimal validation.
  /// Override this to add custom validation logic.
  static void validateFacebookAccountDetails(
    final FacebookAccountDetails accountDetails,
  ) {
    // Default validation - can be customized by users
    if (accountDetails.userIdentifier.isEmpty) {
      throw FacebookUserInfoMissingDataException();
    }
  }

  @override
  FacebookIdp build({
    required final TokenManager tokenManager,
    required final AuthUsers authUsers,
    required final UserProfiles userProfiles,
  }) {
    return FacebookIdp(
      this,
      tokenManager: tokenManager,
      authUsers: authUsers,
      userProfiles: userProfiles,
    );
  }
}

/// Creates a new [FacebookIdpConfig] from keys on the `passwords.yaml` file.
///
/// This constructor requires that a [Serverpod] instance has already been initialized.
///
/// The following keys must be present in the `passwords.yaml` file:
/// - `facebookAppId`: The app ID from your Facebook Developer app
/// - `facebookAppSecret`: The app secret from your Facebook Developer app
///
/// Example `passwords.yaml`:
/// ```yaml
/// facebookAppId: 'your-app-id'
/// facebookAppSecret: 'your-app-secret'
/// ```
class FacebookIdpConfigFromPasswords extends FacebookIdpConfig {
  /// Creates a new [FacebookIdpConfigFromPasswords] instance.
  FacebookIdpConfigFromPasswords({
    super.facebookAccountDetailsValidation,
    super.getExtraFacebookInfoCallback,
  }) : super(
         appId: Serverpod.instance.getPasswordOrThrow('facebookAppId'),
         appSecret: Serverpod.instance.getPasswordOrThrow('facebookAppSecret'),
       );
}

/// Exception thrown when Facebook user information is missing required data.
class FacebookUserInfoMissingDataException implements Exception {
  @override
  String toString() =>
      'FacebookUserInfoMissingDataException: Required user information is missing from Facebook account.';
}
