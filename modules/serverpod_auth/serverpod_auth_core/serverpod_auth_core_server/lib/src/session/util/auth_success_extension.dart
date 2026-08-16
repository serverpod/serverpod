import 'package:serverpod/serverpod.dart';

import '../business/server_side_sessions_token.dart';
import '../session.dart';

/// Server side session ID extension for [AuthSuccess].
extension AuthSuccessServerSideSessionId on AuthSuccess {
  /// Returns the server side session token ID from the [AuthSuccess.token].
  UuidValue get serverSideSessionId {
    final parsedToken = tryParseServerSideSessionToken(null, token);
    if (parsedToken == null) {
      throw const FormatException(
        'Failed to parse server side session token from `AuthSuccess.token`.',
      );
    }
    return parsedToken.serverSideSessionId;
  }
}
