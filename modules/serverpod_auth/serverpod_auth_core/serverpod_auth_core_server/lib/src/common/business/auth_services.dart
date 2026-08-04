import 'dart:async';
import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../../common/integrations/provider_builder.dart';
import '../../common/integrations/token_manager.dart';
import '../../generated/protocol.dart' show UserProfile;
import '../../profile/profile.dart';
import '../integrations/token_manager_builder.dart';
import 'multi_token_manager.dart';

const _adminEmailsPasswordKey = 'adminEmails';
const _adminScopeName = 'serverpod.admin';
const _adminEmailsPasswordTypeError =
    'The `adminEmails` password must be a string or a list of strings.';
const _adminEmailsPasswordEntryError =
    'The `adminEmails` password must contain only strings.';

/// Global configuration for auth providers that are exposed through endpoints.
/// This object is also used to manage the lifecycle of authentication tokens
/// regardless of who issues the token.
class AuthServices {
  /// Returns the singleton instance of [AuthServices] used by the provider
  /// endpoints.
  static AuthServices get instance {
    final localInstance = _instance;
    if (localInstance == null) {
      throw StateError(
        'AuthServices is not set. Call AuthServices.set() to initialize it before accessing the instance.',
      );
    }

    return localInstance;
  }

  static AuthServices? _instance;

  /// {@template auth_services_set}
  /// Creates a new [AuthServices] instance and sets it as the global instance.
  ///
  /// [tokenManagerBuilders] is the list of token manager builders. The first in
  /// the list will be used as the primary token manager, and the others as
  /// additional token managers.
  ///
  /// [identityProviderBuilders] is a list of [IdentityProviderBuilder] that
  /// build the identity providers used by authentication endpoints. Each one
  /// creates a provider instance with the appropriate token manager dependency.
  ///
  /// [authUsersConfig] is the configuration for the auth users manager that
  /// will be used to create the auth users manager.
  ///
  /// [userProfileConfig] is the configuration for the user profiles manager
  /// that will be used to create the user profiles manager.
  ///
  /// These are passed to the [AuthServices] constructor to create the instance.
  /// {@endtemplate}
  static void set({
    required final List<TokenManagerBuilder> tokenManagerBuilders,
    final List<IdentityProviderBuilder> identityProviderBuilders = const [],
    final AuthUsersConfig authUsersConfig = const AuthUsersConfig(),
    final UserProfileConfig userProfileConfig = const UserProfileConfig(),
  }) {
    final instance = AuthServices(
      primaryTokenManagerBuilder: tokenManagerBuilders.first,
      identityProviderBuilders: identityProviderBuilders,
      additionalTokenManagerBuilders: tokenManagerBuilders.skip(1).toList(),
      authUsers: AuthUsers(config: authUsersConfig),
      userProfiles: UserProfiles(config: userProfileConfig),
    );
    _instance = instance;
  }

  /// Creates a new [AuthServices] instance.
  ///
  /// Use [AuthServices.set] to create a new instance and set it as the global
  /// instance.
  ///
  /// [primaryTokenManagerBuilder] is the primary token manager builder that
  /// will build the token manager used by identity providers for issuing new
  /// tokens. The builder is used to build the token manager instance with the
  /// necessary dependencies.
  ///
  /// [identityProviderBuilders] is a list of [IdentityProviderBuilder] that
  /// build the identity providers used by authentication endpoints. Each one
  /// creates a provider instance with the appropriate token manager dependency.
  ///
  /// [additionalTokenManagerBuilders] is a list of additional token manager
  /// builders that are used to build additional token managers that handle
  /// token lifecycle operations alongside the [primaryTokenManagerBuilder].
  /// These additional token managers are used to validate tokens in the same
  /// order they are represented in the list.
  ///
  /// [authUsers] is the default manager for managing auth users.
  ///
  /// [userProfiles] is the default manager for managing user profiles.
  AuthServices({
    required final TokenManagerBuilder primaryTokenManagerBuilder,
    final List<IdentityProviderBuilder> identityProviderBuilders = const [],
    final List<TokenManagerBuilder> additionalTokenManagerBuilders = const [],
    this.authUsers = const AuthUsers(),
    this.userProfiles = const UserProfiles(),
  }) {
    tokenManager = MultiTokenManager(
      primaryTokenManager: primaryTokenManagerBuilder.build(
        authUsers: authUsers,
      ),
      additionalTokenManagers: additionalTokenManagerBuilders
          .map((final factory) => factory.build(authUsers: authUsers))
          .toList(),
    );

    for (final provider in identityProviderBuilders) {
      _providers[provider.type] = provider.build(
        tokenManager: tokenManager,
        authUsers: authUsers,
        userProfiles: userProfiles,
      );
    }
  }

  final Map<Type, Object> _providers = {};

  /// Retrieves the identity provider of type [T].
  static T getIdentityProvider<T>() {
    final provider = instance._providers[T];
    if (provider == null) {
      throw StateError(
        'Provider for $T is not registered. To register this provider, add its '
        'IdentityProviderBuilder to the identityProvidersBuilders list when calling '
        'AuthServices.set(). Example: AuthServices.set(tokenManagerBuilders: ..., '
        'tokenManagerBuilders: ..., identityProviderBuilders: [YourProviderBuilder()]).',
      );
    }
    return provider as T;
  }

  /// Manager for managing auth users.
  final AuthUsers authUsers;

  /// Manager for managing user profiles.
  final UserProfiles userProfiles;

  /// The token manager that handles token lifecycle operations.
  late final MultiTokenManager tokenManager;

  /// Validates an authentication token and returns the associated authentication info.
  ///
  /// This handler delegates to the [tokenManager] to validate the provided [key]
  /// against all registered token managers. Returns [AuthenticationInfo] if the
  /// token is valid, or `null` if validation fails.
  Future<AuthenticationInfo?> authenticationHandler(
    final Session session,
    final String key,
  ) async {
    return tokenManager.validateToken(session, key);
  }

  /// Retrieves the token manager of type [T].
  static T getTokenManager<T extends TokenManager>() {
    return instance.tokenManager.getTokenManager<T>();
  }
}

/// Extension to initialize the AuthServices with the default configuration.
extension AuthServicesInit on Serverpod {
  /// {@macro auth_services_set}
  void initializeAuthServices({
    required final List<TokenManagerBuilder> tokenManagerBuilders,
    final List<IdentityProviderBuilder> identityProviderBuilders = const [],
    final AuthUsersConfig authUsersConfig = const AuthUsersConfig(),
    final UserProfileConfig userProfileConfig = const UserProfileConfig(),
  }) {
    final adminEmails = _parseAdminEmails(getPassword(_adminEmailsPasswordKey));

    AuthServices.set(
      tokenManagerBuilders: tokenManagerBuilders,
      identityProviderBuilders: identityProviderBuilders,
      authUsersConfig: authUsersConfig,
      userProfileConfig: _wrapUserProfileConfigWithAdminEmails(
        userProfileConfig,
        adminEmails,
      ),
    );

    authenticationHandler = AuthServices.instance.authenticationHandler;

    if (adminEmails.isNotEmpty) {
      unawaited(_backfillAdminScopesForConfiguredEmails(this, adminEmails));
    }
  }
}

UserProfileConfig _wrapUserProfileConfigWithAdminEmails(
  final UserProfileConfig config,
  final Set<String> adminEmails,
) {
  if (adminEmails.isEmpty) {
    return config;
  }

  return UserProfileConfig(
    userImageSize: config.userImageSize,
    userInfoCacheLifetime: config.userInfoCacheLifetime,
    userImageGenerator: config.userImageGenerator,
    userImageFormat: config.userImageFormat,
    userImageQuality: config.userImageQuality,
    imageFetchFunc: config.imageFetchFunc,
    onBeforeUserProfileCreated: config.onBeforeUserProfileCreated,
    onAfterUserProfileCreated:
        (
          final session,
          final userProfile, {
          required final transaction,
        }) async {
          await _ensureAdminScopeForProfile(
            session,
            authUserId: userProfile.authUserId,
            email: userProfile.email,
            adminEmails: adminEmails,
            transaction: transaction,
          );

          await config.onAfterUserProfileCreated?.call(
            session,
            userProfile,
            transaction: transaction,
          );
        },
    onBeforeUserProfileUpdated: config.onBeforeUserProfileUpdated,
    onAfterUserProfileUpdated: config.onAfterUserProfileUpdated,
  );
}

Future<void> _backfillAdminScopesForConfiguredEmails(
  final Serverpod serverpod,
  final Set<String> adminEmails,
) async {
  final session = await serverpod.createSession(enableLogging: false);

  try {
    final matchingProfiles = await UserProfile.db.find(
      session,
      where: (final t) => t.email.inSet(adminEmails),
      include: UserProfile.include(
        authUser: AuthUser.include(),
      ),
    );

    for (final profile in matchingProfiles) {
      await _ensureAdminScopeForAuthUser(
        session,
        authUserId: profile.authUserId,
        authUser: profile.authUser,
      );
    }
  } catch (e, stackTrace) {
    session.log(
      'Failed to assign admin scope to configured admin emails (${adminEmails.length} configured).',
      level: LogLevel.error,
      exception: e,
      stackTrace: stackTrace,
    );
  } finally {
    await session.close();
  }
}

Future<void> _ensureAdminScopeForProfile(
  final Session session, {
  required final UuidValue authUserId,
  required final String? email,
  required final Set<String> adminEmails,
  required final Transaction transaction,
}) async {
  final normalizedEmail = _normalizeAdminEmail(email);
  if (normalizedEmail == null || !adminEmails.contains(normalizedEmail)) {
    return;
  }

  await _ensureAdminScopeForAuthUser(
    session,
    authUserId: authUserId,
    transaction: transaction,
  );
}

Future<void> _ensureAdminScopeForAuthUser(
  final Session session, {
  required final UuidValue authUserId,
  final AuthUser? authUser,
  final Transaction? transaction,
}) async {
  final resolvedAuthUser =
      authUser ??
      await AuthUser.db.findById(
        session,
        authUserId,
        transaction: transaction,
      );

  if (resolvedAuthUser == null ||
      resolvedAuthUser.scopeNames.contains(_adminScopeName)) {
    return;
  }

  await AuthUser.db.updateRow(
    session,
    resolvedAuthUser.copyWith(
      scopeNames: {
        ...resolvedAuthUser.scopeNames,
        _adminScopeName,
      },
    ),
    transaction: transaction,
  );
}

Set<String> _parseAdminEmails(final String? configuredValue) {
  final trimmedValue = configuredValue?.trim();
  if (trimmedValue == null || trimmedValue.isEmpty) {
    return const {};
  }

  final decodedValue = _tryDecodeAdminEmails(trimmedValue);
  if (decodedValue is List) {
    return _normalizedAdminEmails(decodedValue.map(_requireAdminEmailString));
  }

  if (decodedValue is String) {
    return _normalizedAdminEmails([decodedValue]);
  }

  if (decodedValue != null) {
    throw const FormatException(_adminEmailsPasswordTypeError);
  }

  // Supports plain-text configuration values, such as a single e-mail address
  // or a comma / newline separated list from an environment variable.
  return _normalizedAdminEmails(trimmedValue.split(RegExp(r'[\n,]')));
}

Object? _tryDecodeAdminEmails(final String configuredValue) {
  try {
    return jsonDecode(configuredValue);
  } on FormatException {
    return null;
  }
}

String _requireAdminEmailString(final Object? value) {
  if (value is String) {
    return value;
  }

  throw const FormatException(_adminEmailsPasswordEntryError);
}

String? _normalizeAdminEmail(final String? email) {
  final normalizedEmail = email?.trim().toLowerCase();
  if (normalizedEmail == null || normalizedEmail.isEmpty) {
    return null;
  }

  return normalizedEmail;
}

Set<String> _normalizedAdminEmails(final Iterable<String> emails) {
  final normalizedEmails = <String>{};

  for (final email in emails) {
    final normalizedEmail = _normalizeAdminEmail(email);
    if (normalizedEmail != null) {
      normalizedEmails.add(normalizedEmail);
    }
  }

  return normalizedEmails;
}
