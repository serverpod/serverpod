import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:jose/jose.dart';
import 'package:googleapis/iamcredentials/v1.dart' as iamcredentials;
import 'package:googleapis/iam/v1.dart' as iam;
import 'package:serverpod_auth_server/src/firebase/firebase_admin.dart';
import 'package:serverpod_auth_server/src/firebase/src/auth/credential.dart';

import '../utils/api_request.dart';
import '../utils/validator.dart' as validator;

/// Class for generating different types of Firebase Auth tokens (JWTs).
class FirebaseTokenGenerator {
  final App app;

  static FirebaseTokenGenerator Function(App app) factory =
      (app) => FirebaseTokenGenerator(app);

  FirebaseTokenGenerator(this.app);

  // List of blacklisted claims which cannot be provided when creating a custom token
  static const blacklistedClaims = [
    'acr',
    'amr',
    'at_hash',
    'aud',
    'auth_time',
    'azp',
    'cnf',
    'c_hash',
    'exp',
    'iat',
    'iss',
    'jti',
    'nbf',
    'nonce',
    'sub',
    'firebase',
    'user_id',
  ];

  // Audience to use for Firebase Auth Custom tokens
  static const firebaseAudience =
      'https://identitytoolkit.googleapis.com/google.identity.identitytoolkit.v1.IdentityToolkit';

  Map<String, dynamic> _createCustomTokenPayload(String uid,
      Map<String, dynamic> developerClaims, String serviceAccountId) {
    if (!validator.isUid(uid)) {
      throw FirebaseAuthError.invalidArgument(
          'First argument to createCustomToken() must be a non-empty string uid.');
    }

    for (var key in developerClaims.keys) {
      if (blacklistedClaims.contains(key)) {
        throw FirebaseAuthError.invalidArgument(
            'Developer claim "$key" is reserved and cannot be specified.');
      }
    }

    var iat = clock.now();
    return {
      'aud': firebaseAudience,
      'iat': iat.millisecondsSinceEpoch ~/ 1000,
      'exp': iat.add(Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000,
      'iss': serviceAccountId,
      'sub': serviceAccountId,
      'uid': uid,
      'claims': developerClaims,
    };
  }

  /// Creates a new Firebase Auth Custom token.
  Future<String> createCustomToken(
      String uid, Map<String, dynamic> developerClaims) async {
    var credential = app.options.credential;
    // If the SDK was initialized with a service account, use it to sign bytes.
    if (credential is ServiceAccountCredential &&
        credential.certificate.projectId == app.options.projectId) {
      var certificate = credential.certificate;
      var claims = _createCustomTokenPayload(
          uid, developerClaims, certificate.clientEmail);

      var builder = JsonWebSignatureBuilder()
        ..jsonContent = claims
        ..setProtectedHeader('typ', 'JWT')
        ..addRecipient(certificate.privateKey, algorithm: 'RS256');

      return builder.build().toCompactSerialization();
    }

    // If the SDK was initialized with a service account email, use it with the IAM service
    // to sign bytes.
    var serviceAccountId = app.options.serviceAccountId;

    if (serviceAccountId == null) {
      /// Find a service account id in the project
      var iamApi = iam.IamApi(AuthorizedHttpClient(app));
      var accounts = await iamApi.projects.serviceAccounts
          .list('projects/${app.options.projectId}');

      var account = accounts.accounts!.firstWhereOrNull(
          (a) => a.email?.startsWith('firebase-adminsdk-') ?? false);
      serviceAccountId = account?.email;
    }

    if (serviceAccountId != null) {
      var claims =
          _createCustomTokenPayload(uid, developerClaims, serviceAccountId);
      var client = iamcredentials.IAMCredentialsApi(AuthorizedHttpClient(app));

      var r = await client.projects.serviceAccounts.signJwt(
          iamcredentials.SignJwtRequest(
            payload: json.encode(claims),
          ),
          'projects/-/serviceAccounts/$serviceAccountId');

      return r.signedJwt!;
    }

    throw FirebaseAuthError.invalidServiceAccount(
        'Failed to determine service account ID. Initialize the SDK with service account credentials or specify a service account ID with iam.serviceAccounts.signBlob permission.');
  }
}
