import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart';

export 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    show AuthSuccess;

/// Exposes a method for the session manager to update the [AuthSuccess].
abstract interface class ClientAuthSuccessStorage {
  /// Set the authentication info.
  Future<void> set(AuthSuccess? data);

  /// Get the stored authentication info, if any. To ensure good performance,
  /// the implementation should cache the value and return it on subsequent
  /// calls without accessing the storage again.
  Future<AuthSuccess?> get();
}
