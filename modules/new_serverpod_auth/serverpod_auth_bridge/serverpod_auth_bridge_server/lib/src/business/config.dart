import 'package:serverpod_auth_idp_server/providers/email.dart';

/// Configuration for the `serverpod_auth_bridge` backwards compability module.
class AuthBackwardsCompatibilityConfig {
  /// True if the server should use the account's email address as part of the
  /// salt when storing password hashes (strongly recommended). Default is true.
  final bool extraSaltyHash;

  /// The email IDP configuration to use for the backwards compatibility.
  final EmailIDP emailIDP;

  /// Creates a new instance.
  AuthBackwardsCompatibilityConfig({
    this.extraSaltyHash = true,
    required this.emailIDP,
  });
}
