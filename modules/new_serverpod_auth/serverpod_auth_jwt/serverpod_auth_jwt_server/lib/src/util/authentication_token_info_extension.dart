import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_jwt_server/serverpod_auth_jwt_server.dart';

/// Extensions for [AuthenticationTokenInfo].
extension AuthenticationTokenInfoExtension on AuthenticationTokenInfo {
  /// Returns the `Scope`s for this authentication token.
  Set<Scope> get scopes {
    return scopeNames.map(Scope.new).toSet();
  }

  /// Returns the extra claims set on this authentication token.
  Map<String, dynamic>? get extraClaims {
    final extraClaims = this.extraClaims;
    if (extraClaims == null) {
      return null;
    }

    return (jsonDecode(extraClaims) as Map).cast<String, dynamic>();
  }
}
