import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import '../../../utils/get_passwords_extension.dart';
import 'microsoft_idp.dart';
import 'microsoft_idp_utils.dart';

/// Function to be called to check whether a Microsoft account details match the
/// requirements during registration.
typedef MicrosoftAccountDetailsValidation =
    void Function(MicrosoftAccountDetails accountDetails);

/// Function to be called to extract additional information from Microsoft APIs
/// using the access token. The [session] and [transaction] can be used to
/// store additional information in the database.
typedef GetExtraMicrosoftInfoCallback =
    Future<void> Function(
      Session session, {
      required MicrosoftAccountDetails accountDetails,
      required String accessToken,
      required Transaction? transaction,
    });

/// Configuration for the Microsoft identity provider.
class MicrosoftIdpConfig extends IdentityProviderBuilder<MicrosoftIdp> {
  /// The client ID from your Microsoft Entra ID (Azure AD) application.
  final String clientId;

  /// The client secret from your Microsoft Entra ID (Azure AD) application.
  final String clientSecret;

  /// The tenant ID or tenant type for the application.
  ///
  /// Valid values:
  /// - `common`: Allows sign-in with both personal Microsoft accounts and work/school accounts
  /// - `organizations`: Allows sign-in with work/school accounts only
  /// - `consumers`: Allows sign-in with personal Microsoft accounts only
  /// - Specific tenant ID (GUID): Allows sign-in with accounts from a specific organization
  ///
  /// Defaults to `common` for multi-tenant support.
  final String tenant;

  /// Whether to automatically fetch and store user profile photos.
  ///
  /// When `true`, profile photos are fetched from Microsoft Graph API and
  /// uploaded to your configured storage during authentication. This adds a
  /// small delay to the authentication process but provides a better user
  /// experience.
  ///
  /// When `false`, profile photo fetching is skipped to improve authentication
  /// speed. Authentication will succeed normally without profile photos.
  ///
  /// Defaults to `true`.
  final bool fetchProfilePhoto;

  /// OAuth2 PKCE server config for Microsoft.
  late final OAuth2PkceServerConfig oauth2Config;

  /// Validation function for Microsoft account details.
  ///
  /// This function should throw an exception if the account details do not
  /// match the requirements. If the function returns normally, the account
  /// is considered valid.
  ///
  /// It can be used to enforce additional requirements on the Microsoft account
  /// details before allowing the user to sign in. Note that Microsoft users
  /// can keep their email private, so email may be null even for valid
  /// accounts. Similarly, the name field is optional.
  ///
  /// To avoid blocking real users with private profiles from signing in,
  /// adjust your validation function with care.
  final MicrosoftAccountDetailsValidation microsoftAccountDetailsValidation;

  /// Callback that can be used with the access token to extract additional
  /// information from Microsoft Graph API.
  ///
  /// This callback is invoked during [MicrosoftIdpUtils.fetchAccountDetails],
  /// before the system determines if the user is new or returning. It runs on
  /// EVERY authentication attempt.
  ///
  /// **CRITICAL - Do NOT create these models in the callback:**
  /// - [MicrosoftAccount] - Breaks new account detection
  /// - [UserProfile] - Interferes with automatic profile creation
  /// - [AuthUser] - Already handled by the authentication flow
  ///
  /// Creating these models will cause the authentication flow in [MicrosoftIdp.login]
  /// to fail or skip critical steps like user profile creation.
  ///
  /// **Safe usage:** Store data in your own custom tables, linked by
  /// [MicrosoftAccountDetails.userIdentifier]. Keep operations lightweight.
  final GetExtraMicrosoftInfoCallback? getExtraMicrosoftInfoCallback;

  /// Creates a new instance of [MicrosoftIdpConfig].
  MicrosoftIdpConfig({
    required this.clientId,
    required this.clientSecret,
    this.tenant = 'common',
    this.fetchProfilePhoto = true,
    this.microsoftAccountDetailsValidation = validateMicrosoftAccountDetails,
    this.getExtraMicrosoftInfoCallback,
  }) : oauth2Config = OAuth2PkceServerConfig(
         tokenEndpointUrl: Uri.https(
           'login.microsoftonline.com',
           '/$tenant/oauth2/v2.0/token',
         ),
         clientId: clientId,
         clientSecret: clientSecret,
         credentialsLocation: OAuth2CredentialsLocation.body,
         parseTokenResponse: parseTokenResponse,
       );

  /// Default validation function for extracting additional Microsoft account details.
  ///
  /// This default implementation accepts all accounts as Microsoft's optional
  /// fields (email, name) are intentionally optional for user privacy.
  /// Override this if you need to enforce specific requirements.
  static void validateMicrosoftAccountDetails(
    final MicrosoftAccountDetails accountDetails,
  ) {
    if (accountDetails.userIdentifier.isEmpty) {
      throw MicrosoftUserInfoMissingDataException();
    }
  }

  /// Default Microsoft token response parser for OAuth2PkceServerConfig.
  static OAuth2PkceTokenResponse parseTokenResponse(
    final Map<String, dynamic> responseBody,
  ) {
    final error = responseBody['error'] as String?;
    if (error != null) {
      final errorDescription = responseBody['error_description'] as String?;
      throw OAuth2InvalidResponseException(
        'Invalid response from Microsoft:'
        ' $error${errorDescription != null ? ' - $errorDescription' : ''}',
      );
    }

    final accessToken = responseBody['access_token'] as String?;
    if (accessToken == null) {
      throw const OAuth2MissingAccessTokenException(
        'No access token in Microsoft response',
      );
    }

    return OAuth2PkceTokenResponse(accessToken: accessToken);
  }

  @override
  MicrosoftIdp build({
    required final TokenManager tokenManager,
    required final AuthUsers authUsers,
    required final UserProfiles userProfiles,
  }) {
    return MicrosoftIdp(
      this,
      tokenIssuer: tokenManager,
      authUsers: authUsers,
      userProfiles: userProfiles,
    );
  }
}

/// Creates a new [MicrosoftIdpConfig] from keys on the `passwords.yaml` file.
///
/// This constructor requires that a [Serverpod] instance has already been initialized.
///
/// The following keys must be present in the `passwords.yaml` file:
/// - `microsoftClientId`: The client ID from your Microsoft Entra ID application
/// - `microsoftClientSecret`: The client secret from your Microsoft Entra ID application
///
/// The following key is optional:
/// - `microsoftTenant`: The tenant ID or type (defaults to 'common' if not provided)
///
/// Example `passwords.yaml`:
/// ```yaml
/// microsoftClientId: 'your-microsoft-client-id'
/// microsoftClientSecret: 'your-microsoft-client-secret'
/// microsoftTenant: 'common'  # or 'organizations', 'consumers', or specific tenant ID
/// ```
class MicrosoftIdpConfigFromPasswords extends MicrosoftIdpConfig {
  /// Creates a new [MicrosoftIdpConfigFromPasswords] instance.
  MicrosoftIdpConfigFromPasswords()
    : super(
        clientId: Serverpod.instance.getPasswordOrThrow('microsoftClientId'),
        clientSecret: Serverpod.instance.getPasswordOrThrow(
          'microsoftClientSecret',
        ),
        tenant: Serverpod.instance.getPassword('microsoftTenant') ?? 'common',
      );
}
