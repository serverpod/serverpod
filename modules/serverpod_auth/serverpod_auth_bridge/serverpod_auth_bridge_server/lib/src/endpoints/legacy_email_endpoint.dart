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
    final UuidValue authUserId;
    try {
      authUserId = await _authenticateWithLegacyFallback(
        session,
        email: email,
        password: password,
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

    // NOTE: This endpoint must create a legacy-compatible session key directly
    // instead of issuing a token via the token manager. Legacy clients expect
    // an integer `keyId` plus plain secret, matching old `serverpod_auth`.
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

  /// Authenticates against the new email IdP, falling back to the password
  /// held in the legacy system for an account migrated without one.
  ///
  /// The fallback runs only after [EmailIdpAuthenticationUtil.authenticate] has
  /// rejected the credentials, which means the rate limiter has already
  /// accepted and recorded the attempt. Consulting the legacy password first,
  /// as this endpoint used to, verified it against the stored legacy hash on
  /// every request - including for an account that was already locked out - so
  /// the limit bounded how often the caller learned the outcome rather than
  /// how many guesses they got to make.
  Future<UuidValue> _authenticateWithLegacyFallback(
    final Session session, {
    required final String email,
    required final String password,
  }) async {
    final authentication = AuthServices.instance.emailIdp.utils.authentication;

    try {
      return await authentication.authenticate(
        session,
        email: email,
        password: password,
        transaction: null,
      );
    } on EmailAuthenticationInvalidCredentialsException {
      await AuthBackwardsCompatibility.importLegacyPasswordIfNeeded(
        session,
        email: email,
        password: password,
      );

      return authentication.authenticate(
        session,
        email: email,
        password: password,
        transaction: null,
      );
    }
  }

  /// Stub - registration is not supported via legacy endpoints.
  Future<bool> createAccountRequest(
    final Session session,
    final String userName,
    final String email,
    final String password,
  ) async {
    return false;
  }

  /// Stub - account creation is not supported via legacy endpoints.
  Future<LegacyUserInfo?> createAccount(
    final Session session,
    final String email,
    final String verificationCode,
  ) async {
    return null;
  }

  /// Stub - password change is not supported via legacy endpoints.
  Future<bool> changePassword(
    final Session session,
    final String oldPassword,
    final String newPassword,
  ) async {
    return false;
  }

  /// Stub - password reset initiation is not supported via legacy endpoints.
  Future<bool> initiatePasswordReset(
    final Session session,
    final String email,
  ) async {
    return false;
  }

  /// Stub - password reset is not supported via legacy endpoints.
  Future<bool> resetPassword(
    final Session session,
    final String verificationCode,
    final String password,
  ) async {
    return false;
  }
}
