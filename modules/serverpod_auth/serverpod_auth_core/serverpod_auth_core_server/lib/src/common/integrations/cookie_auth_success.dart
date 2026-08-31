import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';

class _Undefined {}

/// An [AuthSuccess] whose cookie-delivered secrets are hidden from
/// serialization, so they only reach the browser via `Set-Cookie` while
/// server-side code can still read them (e.g. to attach metadata to the
/// newly issued token).
class CookieAuthSuccess implements AuthSuccess {
  /// Wraps [authSuccess], masking the fields that were delivered as cookies.
  CookieAuthSuccess(
    final AuthSuccess authSuccess, {
    this.maskToken = false,
    this.maskRefreshToken = false,
  }) : authStrategy = authSuccess.authStrategy,
       token = authSuccess.token,
       tokenExpiresAt = authSuccess.tokenExpiresAt,
       refreshToken = authSuccess.refreshToken,
       authUserId = authSuccess.authUserId,
       scopeNames = authSuccess.scopeNames;

  /// Whether [token] is delivered as a cookie and hidden from serialization.
  final bool maskToken;

  /// Whether [refreshToken] is delivered as a cookie and hidden from
  /// serialization.
  final bool maskRefreshToken;

  @override
  String authStrategy;

  @override
  String token;

  @override
  DateTime? tokenExpiresAt;

  @override
  String? refreshToken;

  @override
  UuidValue authUserId;

  @override
  Set<String> scopeNames;

  @useResult
  @override
  CookieAuthSuccess copyWith({
    final String? authStrategy,
    final String? token,
    final Object? tokenExpiresAt = _Undefined,
    final Object? refreshToken = _Undefined,
    final UuidValue? authUserId,
    final Set<String>? scopeNames,
  }) {
    return CookieAuthSuccess(
      AuthSuccess(
        authStrategy: authStrategy ?? this.authStrategy,
        token: token ?? this.token,
        tokenExpiresAt: tokenExpiresAt is DateTime?
            ? tokenExpiresAt
            : this.tokenExpiresAt,
        refreshToken: refreshToken is String?
            ? refreshToken
            : this.refreshToken,
        authUserId: authUserId ?? this.authUserId,
        scopeNames: scopeNames ?? this.scopeNames.map((final e0) => e0).toSet(),
      ),
      maskToken: maskToken,
      maskRefreshToken: maskRefreshToken,
    );
  }

  Map<String, dynamic> _maskedJson() {
    return {
      '__className__': 'serverpod_auth_core.AuthSuccess',
      'authStrategy': authStrategy,
      'token': maskToken ? '' : token,
      if (tokenExpiresAt != null) 'tokenExpiresAt': tokenExpiresAt?.toJson(),
      if (!maskRefreshToken) 'refreshToken': ?refreshToken,
      'authUserId': authUserId.toJson(),
      'scopeNames': scopeNames.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJson() => _maskedJson();

  @override
  Map<String, dynamic> toJsonForProtocol() => _maskedJson();

  @override
  String toString() => SerializationManager.encode(this);
}
