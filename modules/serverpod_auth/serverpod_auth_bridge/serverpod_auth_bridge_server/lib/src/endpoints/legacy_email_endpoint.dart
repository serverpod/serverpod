import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_bridge_server/src/business/auth_backwards_compatibility.dart';
import 'package:serverpod_auth_bridge_server/src/generated/protocol.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// Proxy endpoint that handles legacy email authentication requests from old
/// clients (pre-migration). Delegates to the new auth system internally.
class LegacyEmailEndpoint extends Endpoint {
  /// Authenticates a user with email and password, returning a legacy-format
  /// response with session key and user info.
  Future<LegacyAuthenticationResponse> authenticate(
    final Session session,
    final String email,
    final String password,
  ) async {
    await AuthBackwardsCompatibility.importLegacyPasswordIfNeeded(
      session,
      email: email,
      password: password,
    );

    final UuidValue authUserId;
    try {
      authUserId = await AuthServices.instance.emailIdp.utils.authentication
          .authenticate(
            session,
            email: email,
            password: password,
            transaction: null,
          );
    } on EmailAccountNotFoundException {
      return LegacyAuthenticationResponse(
        success: false,
        failReason: LegacyAuthenticationFailReason.invalidCredentials,
      );
    } on EmailAuthenticationInvalidCredentialsException {
      return LegacyAuthenticationResponse(
        success: false,
        failReason: LegacyAuthenticationFailReason.invalidCredentials,
      );
    } on EmailAuthenticationTooManyAttemptsException {
      return LegacyAuthenticationResponse(
        success: false,
        failReason: LegacyAuthenticationFailReason.tooManyFailedAttempts,
      );
    } catch (_) {
      return LegacyAuthenticationResponse(
        success: false,
        failReason: LegacyAuthenticationFailReason.internalError,
      );
    }

    final authUser = await AuthUser.db.findById(session, authUserId);
    if (authUser == null || authUser.blocked) {
      return LegacyAuthenticationResponse(
        success: false,
        failReason: LegacyAuthenticationFailReason.blocked,
      );
    }

    final legacyRows = await session.db.unsafeQuery(
      'SELECT id FROM serverpod_user_info WHERE email = \$1 LIMIT 1',
      parameters: QueryParameters.positional([email]),
    );
    if (legacyRows.isEmpty) {
      return LegacyAuthenticationResponse(
        success: false,
        failReason: LegacyAuthenticationFailReason.internalError,
      );
    }
    final legacyRow = legacyRows.first;

    final profile = await AuthServices.instance.userProfiles
        .maybeFindUserProfileByUserId(session, authUserId);

    final secret = generateRandomString();
    final salt = session.passwords['authKeySalt'] ?? 'salty';
    final hash = sha256.convert(utf8.encode(salt + secret)).toString();
    final legacySession = await LegacySession.db.insertRow(
      session,
      LegacySession(
        authUserId: authUserId,
        hash: hash,
        method: 'email',
        scopeNames: authUser.scopeNames,
      ),
    );

    return LegacyAuthenticationResponse(
      success: true,
      keyId: legacySession.id,
      key: secret,
      userInfo: LegacyUserInfo(
        id: legacyRow[0] as int,
        userIdentifier: authUserId.toString(),
        userName: profile?.userName,
        fullName: profile?.fullName,
        email: email,
        created: authUser.createdAt,
        imageUrl: profile?.imageUrl?.toString(),
        scopeNames: authUser.scopeNames.toList(),
        blocked: false,
      ),
    );
  }

  /// Stub — registration is not supported via legacy endpoints.
  Future<bool> createAccountRequest(
    final Session session,
    final String userName,
    final String email,
    final String password,
  ) async {
    return false;
  }

  /// Stub — account creation is not supported via legacy endpoints.
  Future<LegacyUserInfo?> createAccount(
    final Session session,
    final String email,
    final String verificationCode,
  ) async {
    return null;
  }

  /// Stub — password change is not supported via legacy endpoints.
  Future<bool> changePassword(
    final Session session,
    final String oldPassword,
    final String newPassword,
  ) async {
    return false;
  }

  /// Stub — password reset initiation is not supported via legacy endpoints.
  Future<bool> initiatePasswordReset(
    final Session session,
    final String email,
  ) async {
    return false;
  }

  /// Stub — password reset is not supported via legacy endpoints.
  Future<bool> resetPassword(
    final Session session,
    final String verificationCode,
    final String password,
  ) async {
    return false;
  }
}
