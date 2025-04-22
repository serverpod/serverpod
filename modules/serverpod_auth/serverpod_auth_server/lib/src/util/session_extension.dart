import 'package:serverpod/serverpod.dart';

/// Authentication extension for `Session`
extension SessionUserId on Session {
  /// Returns the `int` user ID of the authenticated user, or `null` if the user is not logged in.
  Future<int?> get userId {
    return authenticated.then((v) => v == null ? null : int.parse(v.user));
  }
}
