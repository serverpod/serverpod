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
    final extraClaimsJSON = this.extraClaimsJSON;
    if (extraClaimsJSON == null) {
      return null;
    }

    return (jsonDecode(extraClaimsJSON) as Map).cast<String, dynamic>();
  }
}
