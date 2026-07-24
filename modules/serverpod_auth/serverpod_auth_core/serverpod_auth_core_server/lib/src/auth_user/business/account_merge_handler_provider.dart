import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';

/// Interface for identity providers that support migrating their custom data
/// when an account merge happens.
abstract interface class AccountMergeHandlerProvider {
  /// The handler for migrating an identity provider's data during an account merge.
  AccountMergeHandler get accountMergeHook;
}
