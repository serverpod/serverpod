import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import '../../../utils/get_passwords_extension.dart';
import 'firebase_idp.dart';
import 'firebase_idp_utils.dart';
import 'firebase_service_account_credentials.dart';

/// Function to be called to check whether Firebase account details match the
/// requirements during registration.
typedef FirebaseAccountDetailsValidation =
    void Function(
      FirebaseAccountDetails accountDetails,
    );

/// Configuration for the Firebase identity provider.
class FirebaseIdpConfig extends IdentityProviderBuilder<FirebaseIdp> {
  /// The Firebase service account credentials.
  ///
  /// Only the [FirebaseServiceAccountCredentials.projectId] is required for
  /// token verification.
  final FirebaseServiceAccountCredentials credentials;

  /// Validation function for Firebase account details.
  ///
  /// This function should throw an exception if the account details do not
  /// match the requirements. If the function returns normally, the account
  /// is considered valid.
  ///
  /// It can be used to enforce additional requirements on the Firebase account
  /// details before allowing the user to sign in, such as requiring a verified
  /// email or specific email domains.
  final FirebaseAccountDetailsValidation firebaseAccountDetailsValidation;

  /// Creates a new instance of [FirebaseIdpConfig].
  const FirebaseIdpConfig({
    required this.credentials,
    this.firebaseAccountDetailsValidation = validateFirebaseAccountDetails,
  });

  /// Default validation function for extracted Firebase account details.
  ///
  /// By default, this validates that the email is verified. Override this
  /// to implement custom validation logic.
  static void validateFirebaseAccountDetails(
    final FirebaseAccountDetails accountDetails,
  ) {
    // Firebase accounts may not have email if using phone auth
    // Only validate verifiedEmail if email is present
    if (accountDetails.email != null && accountDetails.verifiedEmail != true) {
      throw FirebaseUserInfoMissingDataException();
    }
  }

  @override
  FirebaseIdp build({
    required final TokenManager tokenManager,
    required final AuthUsers authUsers,
    required final UserProfiles userProfiles,
  }) {
    return FirebaseIdp(
      this,
      tokenIssuer: tokenManager,
      authUsers: authUsers,
      userProfiles: userProfiles,
    );
  }
}

/// Creates a new [FirebaseIdpConfig] from keys on the `passwords.yaml` file.
///
/// This constructor requires that a [Serverpod] instance has already been
/// initialized.
///
/// The password key should be `firebaseServiceAccountKey` and contain the
/// entire service account JSON as a string.
class FirebaseIdpConfigFromPasswords extends FirebaseIdpConfig {
  /// Creates a new [FirebaseIdpConfigFromPasswords] instance.
  FirebaseIdpConfigFromPasswords({
    super.firebaseAccountDetailsValidation,
  }) : super(
         credentials: FirebaseServiceAccountCredentials.fromJsonString(
           Serverpod.instance.getPasswordOrThrow('firebaseServiceAccountKey'),
         ),
       );
}

/// Exception thrown when the user info from Firebase is missing required data.
class FirebaseUserInfoMissingDataException implements Exception {}
