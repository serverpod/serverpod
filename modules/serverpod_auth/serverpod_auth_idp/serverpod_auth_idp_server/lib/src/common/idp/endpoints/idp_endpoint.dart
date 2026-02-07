import 'package:serverpod/serverpod.dart';

/// Base endpoint for identity providers.
abstract class IdpBaseEndpoint extends Endpoint {
  /// Returns the `method` value for each connected [Idp] subclass if the
  /// current session is authenticated and if the user has an account connected
  /// to the [Idp].
  Future<bool> hasAccount(final Session session);
}
