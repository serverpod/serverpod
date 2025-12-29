import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/src/providers/anonymous/business/anonymous_idp.dart';
import '../../../../../core.dart';

// Ideally, this should be in a shared package
import '../../../../providers/email.dart' show RateLimit;

/// {@template before_anonymous_account_created_function}
/// Function to be called before a new anonymous account is created. This
/// function should return true if a new anonymous account is allowed to be
/// created, or false otherwise. This mechanism is how an application would
/// protect the anonymous account creation process to prevent abuse.
/// {@endtemplate}
typedef BeforeAnonymousAccountCreatedFunction =
    FutureOr<bool> Function(
      Session session, {
      String? token,
      required Transaction? transaction,
    });

/// {@template after_anonymous_account_created_function}
/// Function to be called after a new anonymous account has been created.
/// {@endtemplate}
typedef AfterAnonymousAccountCreatedFunction =
    FutureOr<void> Function(
      Session session, {
      required UuidValue authUserId,
      required Transaction? transaction,
    });

/// {@template anonymous_idp_config}
/// Configuration for the anonymous identity provider.
/// {@endtemplate}
class AnonymousIdpConfig extends IdentityProviderBuilder<AnonymousIdp> {
  /// {@macro before_anonymous_account_created_function}
  final BeforeAnonymousAccountCreatedFunction? onBeforeAnonymousAccountCreated;

  /// {@macro after_anonymous_account_created_function}
  final AfterAnonymousAccountCreatedFunction? onAfterAnonymousAccountCreated;

  /// {@template anonymous_idp_config.rate_limit}
  /// The maximum rate of anonymous accounts that can be created from a single
  /// IP address.
  /// {@endtemplate}
  final RateLimit? perIpAddressRateLimit;

  /// Creates a new [AnonymousIdpConfig].
  const AnonymousIdpConfig({
    this.onBeforeAnonymousAccountCreated,
    this.onAfterAnonymousAccountCreated,
    this.perIpAddressRateLimit = const RateLimit(
      maxAttempts: 100,
      timeframe: Duration(hours: 1),
    ),
  });

  @override
  AnonymousIdp build({
    required final TokenManager tokenManager,
    required final AuthUsers authUsers,
    required final UserProfiles userProfiles,
  }) {
    return AnonymousIdp(
      this,
      tokenManager: tokenManager,
      userProfiles: userProfiles,
    );
  }
}
