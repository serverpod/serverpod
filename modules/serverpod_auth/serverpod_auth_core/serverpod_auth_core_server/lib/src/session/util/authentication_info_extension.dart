import 'package:serverpod/serverpod.dart';

/// Server side session ID extension for `AuthenticationInfo`.
extension AuthenticationInfoServerSideSessionId on AuthenticationInfo {
  /// Returns the server side session ID of the authenticated user.
  ///
  /// Assumes that the system uses `Uuid` server side session IDs, otherwise throws.
  UuidValue get serverSideSessionId {
    return UuidValue.withValidation(authId);
  }
}
