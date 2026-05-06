import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_bridge_server/src/business/auth_backwards_compatibility.dart';
import 'package:serverpod_auth_bridge_server/src/generated/protocol.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/google.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// Bridge endpoint for legacy Google authentication.
class LegacyGoogleEndpoint extends Endpoint {
  /// Google server auth code authentication is currently unsupported.
  Future<LegacyAuthenticationResponse> authenticateWithServerAuthCode(
    final Session session,
    final String authenticationCode,
    final String? redirectUri,
  ) async {
    return LegacyAuthenticationResponse(
      success: false,
      failReason: LegacyAuthenticationFailReason.internalError,
    );
  }

  /// Authenticates a user with a Google ID token and returns a legacy-format
  /// response.
  Future<LegacyAuthenticationResponse> authenticateWithIdToken(
    final Session session,
    final String idToken,
  ) async {
    try {
      await AuthBackwardsCompatibility.importGoogleAccount(
        session,
        idToken: idToken,
        accessToken: null,
      );
    } on GoogleIdTokenVerificationException {
      return LegacyAuthenticationResponse(
        success: false,
        failReason: LegacyAuthenticationFailReason.invalidCredentials,
      );
    } catch (_) {
      return LegacyAuthenticationResponse(
        success: false,
        failReason: LegacyAuthenticationFailReason.internalError,
      );
    }

    final AuthSuccess authSuccess;
    try {
      authSuccess = await AuthServices.instance.googleIdp.login(
        session,
        idToken: idToken,
        accessToken: null,
      );
    } on GoogleIdTokenVerificationException {
      return LegacyAuthenticationResponse(
        success: false,
        failReason: LegacyAuthenticationFailReason.invalidCredentials,
      );
    } on AuthUserBlockedException {
      return LegacyAuthenticationResponse(
        success: false,
        failReason: LegacyAuthenticationFailReason.blocked,
      );
    } catch (_) {
      return LegacyAuthenticationResponse(
        success: false,
        failReason: LegacyAuthenticationFailReason.internalError,
      );
    }

    final authUser = await AuthUser.db.findById(
      session,
      authSuccess.authUserId,
    );
    if (authUser == null || authUser.blocked) {
      return LegacyAuthenticationResponse(
        success: false,
        failReason: LegacyAuthenticationFailReason.blocked,
      );
    }

    final profile = await AuthServices.instance.userProfiles
        .maybeFindUserProfileByUserId(session, authSuccess.authUserId);

    int? legacyId;
    final profileEmail = profile?.email;
    if (profileEmail != null) {
      final legacyRows = await session.db.unsafeQuery(
        'SELECT id FROM serverpod_user_info WHERE lower(email) = lower(\$1) LIMIT 1',
        parameters: QueryParameters.positional([profileEmail]),
      );
      legacyId = legacyRows.isNotEmpty ? legacyRows.first[0] as int? : null;
    }

    final secret = generateRandomString();
    final salt = session.passwords['authKeySalt'] ?? 'salty';
    final hash = sha256.convert(utf8.encode(salt + secret)).toString();
    final legacySession = await LegacySession.db.insertRow(
      session,
      LegacySession(
        authUserId: authSuccess.authUserId,
        hash: hash,
        method: 'google',
        scopeNames: authSuccess.scopeNames,
      ),
    );

    return LegacyAuthenticationResponse(
      success: true,
      keyId: legacySession.id,
      key: secret,
      userInfo: LegacyUserInfo(
        id: legacyId,
        userIdentifier: authSuccess.authUserId.toString(),
        userName: profile?.userName,
        fullName: profile?.fullName,
        email: profile?.email,
        created: authUser.createdAt,
        imageUrl: profile?.imageUrl?.toString(),
        scopeNames: authSuccess.scopeNames.toList(),
        blocked: false,
      ),
    );
  }
}
