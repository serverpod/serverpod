
import 'package:openid_client/openid_client.dart';
import 'package:serverpod_auth_server/src/firebase/firebase_admin.dart';
import 'package:serverpod_auth_server/src/firebase/src/auth/token_generator.dart';
import 'package:serverpod_auth_server/src/firebase/src/auth/token_verifier.dart';

import 'auth/auth_api_request.dart';
import 'service.dart';

export 'auth/user_record.dart';

/// The Firebase Auth service interface.
class Auth implements FirebaseService {
  @override
  final App app;

  final AuthRequestHandler _authRequestHandler;
  final FirebaseTokenVerifier _tokenVerifier;
  final FirebaseTokenGenerator _tokenGenerator;

  /// Do not call this constructor directly. Instead, use app().auth.
  Auth(this.app)
      : _authRequestHandler = AuthRequestHandler(app),
        _tokenVerifier = FirebaseTokenVerifier.factory(app),
        _tokenGenerator = FirebaseTokenGenerator.factory(app);

  @override
  Future<void> delete() async {
    // TODO: implement delete
  }

  /// Gets the user data for the user corresponding to a given [uid].
  Future<UserRecord> getUser(String uid) async {
    return await _authRequestHandler.getAccountInfoByUid(uid);
  }

  /// Looks up the user identified by the provided email and returns a future
  /// that is fulfilled with a user record for the given user if that user is
  /// found.
  Future<UserRecord> getUserByEmail(String email) async {
    return await _authRequestHandler.getAccountInfoByEmail(email);
  }

  /// Looks up the user identified by the provided phone number and returns a
  /// future that is fulfilled with a user record for the given user if that
  /// user is found.
  Future<UserRecord> getUserByPhoneNumber(String phoneNumber) async {
    return await _authRequestHandler.getAccountInfoByPhoneNumber(phoneNumber);
  }

  /// Retrieves a list of users (single batch only) with a size of [maxResults]
  /// and starting from the offset as specified by [pageToken].
  ///
  /// This is used to retrieve all the users of a specified project in batches.
  Future<ListUsersResult> listUsers(
      [int? maxResults, String? pageToken]) async {
    return await _authRequestHandler.downloadAccount(maxResults, pageToken);
  }

  /// Creates a new user.
  Future<UserRecord> createUser({
    bool? disabled,
    String? displayName,
    String? email,
    bool? emailVerified,
    String? password,
    String? phoneNumber,
    Uri? photoUrl,
    String? uid,
    List<CreateMultiFactorInfoRequest>? multiFactorEnrolledFactors,
  }) async {
    try {
      uid = await _authRequestHandler.createNewAccount(
        disabled: disabled,
        displayName: displayName,
        email: email,
        emailVerified: emailVerified,
        password: password,
        phoneNumber: phoneNumber,
        photoUrl: photoUrl?.toString(),
        uid: uid,
        multiFactorEnrolledFactors: multiFactorEnrolledFactors,
      );
      // Return the corresponding user record.
      return await getUser(uid);
    } on FirebaseException catch (error) {
      if (error.code == 'auth/user-not-found') {
        // Something must have happened after creating the user and then retrieving it.
        throw FirebaseAuthError.internalError(
            'Unable to create the user record provided.');
      }
      rethrow;
    }
  }

  /// Deletes an existing user.
  Future<void> deleteUser(String uid) async {
    await _authRequestHandler.deleteAccount(uid);
  }

  /// Updates an existing user.
  ///
  /// Set [displayName], [photoUrl] and/or [phoneNumber] to the empty string to
  /// remove them from the user record. When phone number is removed, also the
  /// corresponding provider will be removed.
  Future<UserRecord> updateUser(
    String uid, {
    bool? disabled,
    String? displayName,
    String? email,
    bool? emailVerified,
    String? password,
    String? phoneNumber,
    Uri? photoUrl,
    List<UpdateMultiFactorInfoRequest>? multiFactorEnrolledFactors,
  }) async {
    uid = await _authRequestHandler.updateExistingAccount(
      uid,
      disableUser: disabled,
      displayName: displayName,
      email: email,
      emailVerified: emailVerified,
      password: password,
      phoneNumber: phoneNumber,
      photoUrl: photoUrl?.toString(),
      multiFactorEnrolledFactors: multiFactorEnrolledFactors,
    );
    // Return the corresponding user record.
    return await getUser(uid);
  }

  /// Sets additional developer claims on an existing user identified by the
  /// provided uid, typically used to define user roles and levels of access.
  ///
  /// These claims should propagate to all devices where the user is already
  /// signed in (after token expiration or when token refresh is forced) and the
  /// next time the user signs in. If a reserved OIDC claim name is used
  /// (sub, iat, iss, etc), an error is thrown. They will be set on the
  /// authenticated user's ID token JWT.
  ///
  /// [customUserClaims] can be `null`.
  ///
  /// Returns a promise containing `void`.
  Future<void> setCustomUserClaims(
      String uid, Map<String, dynamic> customUserClaims) async {
    await _authRequestHandler.setCustomUserClaims(uid, customUserClaims);
  }

  /// Revokes all refresh tokens for an existing user.
  ///
  /// This API will update the user's [UserRecord.tokensValidAfterTime] to the
  /// current UTC. It is important that the server on which this is called has
  /// its clock set correctly and synchronized.
  ///
  /// While this will revoke all sessions for a specified user and disable any
  /// new ID tokens for existing sessions from getting minted, existing ID tokens
  /// may remain active until their natural expiration (one hour). To verify that
  /// ID tokens are revoked, use [Auth.verifyIdToken] where `checkRevoked` is set
  /// to `true`.
  Future<void> revokeRefreshTokens(String uid) async {
    await _authRequestHandler.revokeRefreshTokens(uid);
  }

  /// Generates the out of band email action link for password reset flows for
  /// the email specified using the action code settings provided.
  Future<String> generatePasswordResetLink(String email,
      [ActionCodeSettings? actionCodeSettings]) {
    return _authRequestHandler.getEmailActionLink('PASSWORD_RESET', email,
        actionCodeSettings: actionCodeSettings);
  }

  /// Generates the out of band email action link for email verification flows
  /// for the email specified using the action code settings provided.
  Future<String> generateEmailVerificationLink(String email,
      [ActionCodeSettings? actionCodeSettings]) {
    return _authRequestHandler
        .getEmailActionLink('VERIFY_EMAIL', email,
            actionCodeSettings: actionCodeSettings)
        .then((value) => value);
  }

  /// Generates the out of band email action link for email link sign-in flows
  /// for the email specified using the action code settings provided.
  Future<String> generateSignInWithEmailLink(
      String email, ActionCodeSettings? actionCodeSettings) {
    return _authRequestHandler
        .getEmailActionLink('EMAIL_SIGNIN', email,
            actionCodeSettings: actionCodeSettings)
        .then((value) => value);
  }

  /// Verifies a Firebase ID token (JWT).
  ///
  /// If the token is valid, the returned [Future] is completed with an instance
  /// of [IdToken]; otherwise, the future is completed with an error.
  /// An optional flag can be passed to additionally check whether the ID token
  /// was revoked.
  Future<IdToken> verifyIdToken(String idToken,
      [bool checkRevoked = false]) async {
    var decodedIdToken = await _tokenVerifier.verifyJwt(idToken);
    // Whether to check if the token was revoked.
    if (!checkRevoked) {
      return decodedIdToken;
    }
    return _verifyDecodedJwtNotRevoked(decodedIdToken);
  }

  /// Creates a new Firebase custom token (JWT) that can be sent back to a client
  /// device to use to sign in with the client SDKs' signInWithCustomToken()
  /// methods.
  ///
  /// Returns a [Future] containing a custom token string for the provided [uid]
  /// and payload.
  Future<String> createCustomToken(String uid,
      [Map<String, dynamic> developerClaims = const {}]) async {
    return _tokenGenerator.createCustomToken(uid, developerClaims);
  }

  /// Verifies the decoded Firebase issued JWT is not revoked. Returns a future
  /// that resolves with the decoded claims on success. Rejects the future with
  /// revocation error if revoked.
  Future<IdToken> _verifyDecodedJwtNotRevoked(IdToken decodedIdToken) async {
    // Get tokens valid after time for the corresponding user.
    var user = await getUser(decodedIdToken.claims.subject);
    // If no tokens valid after time available, token is not revoked.
    if (user.tokensValidAfterTime != null) {
      // Get the ID token authentication time.
      final authTimeUtc = decodedIdToken.claims.authTime!;
      // Get user tokens valid after time.
      final validSinceUtc = user.tokensValidAfterTime!;
      // Check if authentication time is older than valid since time.
      if (authTimeUtc.isBefore(validSinceUtc)) {
        throw FirebaseAuthError.idTokenRevoked();
      }
    }
    // All checks above passed. Return the decoded token.
    return decodedIdToken;
  }
}

/// Defines the required continue/state URL with optional Android and iOS
/// settings.
///
/// Used when invoking the email action link generation APIs in FirebaseAuth.
class ActionCodeSettings {
  /// The link continue/state URL
  final String url;

  /// Specifies whether to open the link via a mobile app or a browser
  final bool? handleCodeInApp;

  /// The bundle ID of the iOS app where the link should be handled if the
  /// application is already installed on the device.
  final String? iosBundleId;

  /// The Android package name of the app where the link should be handled if
  /// the Android app is installed.
  final String? androidPackageName;

  /// Specifies whether to install the Android app if the device supports it and
  /// the app is not already installed.
  final bool? androidInstallApp;

  /// The minimum version for Android app.
  final String? androidMinimumVersion;

  /// The dynamic link domain to use for the current link if it is to be opened
  /// using Firebase Dynamic Links, as multiple dynamic link domains can be
  /// configured per project.
  final String? dynamicLinkDomain;

  ActionCodeSettings(
      {required this.url,
      this.handleCodeInApp,
      this.iosBundleId,
      this.androidPackageName,
      this.androidInstallApp,
      this.androidMinimumVersion,
      this.dynamicLinkDomain});
}

/// Response object for a listUsers operation.
class ListUsersResult {
  final List<UserRecord> users;
  final String? pageToken;

  ListUsersResult({required this.users, this.pageToken});

  ListUsersResult.fromJson(Map<String, dynamic> map)
      : this(
            users: (map['users'] as List)
                .map((v) => UserRecord.fromJson(v))
                .toList(),
            pageToken: map['nextPageToken']);
}

/// Represents properties of a user-enrolled second factor for a
/// [Auth.createUser] call.
abstract class CreateMultiFactorInfoRequest {
  /// The optional display name for an enrolled second factor.
  final String? displayName;

  /// The type identifier of the second factor.
  ///
  /// For SMS second factors, this is phone.
  final String factorId;

  CreateMultiFactorInfoRequest({this.displayName, required this.factorId});

  factory CreateMultiFactorInfoRequest.phone(
      {String? displayName,
      required String phoneNumber}) = CreatePhoneMultiFactorInfoRequest;
}

/// Represents a phone specific user-enrolled second factor for a
/// [Auth.createUser] call.
class CreatePhoneMultiFactorInfoRequest extends CreateMultiFactorInfoRequest {
  /// The phone number associated with a phone second factor.
  final String phoneNumber;

  CreatePhoneMultiFactorInfoRequest(
      {String? displayName, required this.phoneNumber})
      : super(factorId: 'phone', displayName: displayName);
}

/// Represents the properties of a user-enrolled second factor for a
/// [Auth.updateUser] call.
abstract class UpdateMultiFactorInfoRequest {
  /// The optional display name for an enrolled second factor.
  final String? displayName;

  /// The type identifier of the second factor.
  ///
  /// For SMS second factors, this is phone.
  final String factorId;

  /// The optional date the second factor was enrolled.
  final DateTime? enrollmentTime;

  /// The ID of the enrolled second factor.
  ///
  /// This ID is unique to the user. When not provided, a new one is provisioned
  /// by the Auth server.
  final String? uid;

  UpdateMultiFactorInfoRequest(
      {this.displayName,
      required this.factorId,
      this.enrollmentTime,
      this.uid});

  factory UpdateMultiFactorInfoRequest.phone(
      {String? displayName,
      required String phoneNumber,
      DateTime? enrollmentTime,
      String? uid}) = UpdatePhoneMultiFactorInfoRequest;
}

/// Represents a phone specific user-enrolled second factor for a
/// [Auth.updateUser] call.
class UpdatePhoneMultiFactorInfoRequest extends UpdateMultiFactorInfoRequest {
  /// The phone number associated with a phone second factor.
  final String phoneNumber;

  UpdatePhoneMultiFactorInfoRequest(
      {String? displayName,
      required this.phoneNumber,
      DateTime? enrollmentTime,
      String? uid})
      : super(
            factorId: 'phone',
            displayName: displayName,
            enrollmentTime: enrollmentTime,
            uid: uid);
}
