import 'dart:async';

import 'package:serverpod/serverpod.dart';

import '../../../../../core.dart';
import '../../../common/id_token_verifier/id_token_verifier_config.dart';
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

/// Callback to be invoked after a new Firebase account has been created and
/// linked to an auth user. The [session] and [transaction] can be used to
/// perform additional database operations.
typedef AfterFirebaseAccountCreatedFunction =
    FutureOr<void> Function(
      Session session,
      AuthUserModel authUser,
      FirebaseAccount firebaseAccount, {
      required Transaction? transaction,
    });

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
  /// is considered valid. Thrown exceptions that implement
  /// [SerializableException] are passed through to the client, while any
  /// other exception surfaces as a generic
  /// [FirebaseIdTokenVerificationException].
  ///
  /// It can be used to enforce additional requirements on the Firebase account
  /// details before allowing the user to sign in, such as requiring a verified
  /// email or specific email domains.
  ///
  /// By default all account details are accepted, including unverified
  /// emails — see [validateFirebaseAccountDetails]. To reject accounts whose
  /// email has not been verified, pass [requireVerifiedEmail].
  final FirebaseAccountDetailsValidation firebaseAccountDetailsValidation;

  /// Callback to be invoked after a new Firebase account has been created
  /// and linked to an auth user.
  ///
  /// This can be used to perform additional setup tasks after the Firebase
  /// account has been created and linked.
  final AfterFirebaseAccountCreatedFunction? onAfterFirebaseAccountCreated;

  /// Tolerance for clock skew when validating Firebase ID token timestamps.
  final Duration clockSkewTolerance;

  /// Creates a new instance of [FirebaseIdpConfig].
  const FirebaseIdpConfig({
    required this.credentials,
    this.firebaseAccountDetailsValidation = validateFirebaseAccountDetails,
    this.onAfterFirebaseAccountCreated,
    this.clockSkewTolerance = defaultIdTokenClockSkewTolerance,
  });

  /// Default validation function for extracted Firebase account details.
  ///
  /// Accepts all account details, including unverified emails. Firebase
  /// Email/Password accounts start out with an unverified email and users are
  /// typically signed in right after signup, before they have clicked the
  /// verification link — rejecting unverified emails would block that flow.
  ///
  /// To require a verified email, use [requireVerifiedEmail] instead.
  static void validateFirebaseAccountDetails(
    final FirebaseAccountDetails accountDetails,
  ) {}

  /// Validation function that requires the email to be verified when present.
  ///
  /// Throws a [FirebaseEmailNotVerifiedException] if an email is present but
  /// has not been verified. Accounts without an email (e.g. phone
  /// authentication) are accepted.
  ///
  /// Note that with Firebase Email/Password sign-in this blocks users from
  /// signing in between signup and clicking the verification link Firebase
  /// emails them.
  static void requireVerifiedEmail(
    final FirebaseAccountDetails accountDetails,
  ) {
    if (accountDetails.email != null && accountDetails.verifiedEmail != true) {
      throw FirebaseEmailNotVerifiedException();
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
    super.onAfterFirebaseAccountCreated,
    super.clockSkewTolerance,
  }) : super(
         credentials: FirebaseServiceAccountCredentials.fromJsonString(
           Serverpod.instance.getPasswordOrThrow('firebaseServiceAccountKey'),
         ),
       );
}

/// Exception thrown when the user info from Firebase is missing required data.
class FirebaseUserInfoMissingDataException implements Exception {}
