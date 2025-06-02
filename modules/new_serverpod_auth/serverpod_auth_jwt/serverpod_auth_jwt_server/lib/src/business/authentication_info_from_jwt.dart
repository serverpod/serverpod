import 'package:meta/meta.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_jwt_server/src/business/jwt_util.dart';

final _extraClaims = Expando<Map<String, dynamic>>(
  'extra claims for AuthenticationInfo',
);

@internal
extension AuthenticationInfoFromJwt on AuthenticationInfo {
  @internal
  static AuthenticationInfo fromJwtVerificationResult(
    final VerifiedJwtData result,
  ) {
    final authInfo = AuthenticationInfo(
      result.authUserId,
      result.scopes,
      authId: result.refreshTokenId.toString(),
    );

    _extraClaims[authInfo] = result.extraClaims;

    return authInfo;
  }
}

/// Extensions for [AuthenticationInfo] when used with module `serverpod_auth_jwt`.
extension AuthenticationInfoJwt on AuthenticationInfo {
  /// Get the extra claims associated with this authentication info.
  ///
  /// If the [AuthenticationInfo] was not created by the `serverpod_auth_jwt` module,
  /// this returns null.
  Map<String, dynamic>? get extraClaims {
    return _extraClaims[this];
  }
}
