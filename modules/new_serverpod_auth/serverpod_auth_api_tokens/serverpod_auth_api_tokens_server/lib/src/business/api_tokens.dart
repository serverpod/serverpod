import 'dart:convert';
import 'dart:typed_data';

import 'package:clock/clock.dart';
import 'package:meta/meta.dart';
import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_api_tokens_server/serverpod_auth_api_tokens_server.dart';
import 'package:serverpod_auth_api_tokens_server/src/business/api_token_hash.dart';
import 'package:serverpod_auth_api_tokens_server/src/business/api_token_secrets.dart';
import 'package:serverpod_auth_api_tokens_server/src/generated/protocol.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// Business logic for handling API tokens.
abstract class ApiTokens {
  /// The current API token module configuration.
  static ApiTokenConfig config = ApiTokenConfig();

  /// Admin-related functions for managing API tokens.
  static final admin = ApiTokensAdmin();

  /// Looks up the `AuthenticationInfo` belonging to the [apiTokenString].
  ///
  /// Returns `null` in any case where no valid authentication could be derived from the input.
  static Future<AuthenticationInfo?> authenticationHandler(
    final Session session,
    final String apiTokenString,
  ) async {
    if (!apiTokenString.startsWith('$_apiTokenPrefix:')) {
      return null;
    }

    final parts = apiTokenString.split(':');
    if (parts.length != 3) {
      session.log(
        'Unexpected key format',
        level: LogLevel.debug,
      );

      return null;
    }

    final UuidValue apiTokenId;
    try {
      apiTokenId = UuidValue.fromByteList(base64Decode(parts[1]));
    } catch (e, stackTrace) {
      session.log(
        'Failed to parse API token ID',
        level: LogLevel.debug,
        exception: e,
        stackTrace: stackTrace,
      );

      return null;
    }
    final secret = base64Decode(parts[2]);

    var apiToken = await ApiToken.db.findById(session, apiTokenId);

    if (apiToken == null) {
      return null;
    }

    if (apiToken.expiresAt != null &&
        clock.now().isAfter(apiToken.expiresAt!)) {
      session.log(
        'Got API token after its set expiration date.',
        level: LogLevel.debug,
      );

      return null;
    }

    if (apiToken.expireAfterUnusedFor != null &&
        apiToken.lastUsed
            .add(apiToken.expireAfterUnusedFor!)
            .isBefore(clock.now())) {
      session.log(
        'Got API token which expired due to inactivity.',
        level: LogLevel.debug,
      );

      return null;
    }

    if (!_apiTokenHash.validateSessionKeyHash(
      secret: secret,
      hash: Uint8List.sublistView(apiToken.apiTokenHash),
      salt: Uint8List.sublistView(apiToken.apiTokenSalt),
    )) {
      session.log(
        'Provided `secret` did not result in correct API token hash.',
        level: LogLevel.debug,
      );

      return null;
    }

    if (apiToken.lastUsed
        .isBefore(clock.now().subtract(const Duration(minutes: 1)))) {
      apiToken = await ApiToken.db.updateRow(
        session,
        apiToken.copyWith(lastUsed: clock.now()),
      );
    }

    return AuthenticationInfo(
      apiToken.authUserId,
      apiToken.scopeNames.map(Scope.new).toSet(),
      authId: apiToken.id!.toString(),
    );
  }

  /// Creates a new API token for the given [authUserId] with the provided [scopes].
  ///
  /// A fixed [expiresAt] can be set to ensure that the token is not usable after that date.
  ///
  /// Additional [expireAfterUnusedFor] can be set to make sure that the API token has not been unused for longer than the provided value.
  /// In case the token was unused for at least [expireAfterUnusedFor] it'll automatically be decomissioned.
  static Future<String> createApiToken(
    final Session session, {
    required final UuidValue authUserId,
    required final Set<Scope> scopes,

    /// Fixed date at which the token expires.
    ///
    /// If `null` the token will work until it's deleted or when it's been inactive for [expireAfterUnusedFor].
    final DateTime? expiresAt,

    /// Length of inactivity after which the token is no longer usable.
    final Duration? expireAfterUnusedFor,
    final String? kind,
    final Transaction? transaction,
  }) async {
    final secret = generateRandomBytes(config.apiTokenSecretLength);
    final hash = _apiTokenHash.createSessionKeyHash(secret: secret);

    var apiToken = ApiToken(
      authUserId: authUserId,
      scopeNames: scopes.names,
      apiTokenHash: ByteData.sublistView(hash.hash),
      apiTokenSalt: ByteData.sublistView(hash.salt),
      expiresAt: expiresAt,
      expireAfterUnusedFor: expireAfterUnusedFor,
      kind: kind,
    );

    apiToken = await ApiToken.db.insertRow(
      session,
      apiToken,
      transaction: transaction,
    );

    return _buildApiTokenString(
      apiTokenId: apiToken.id!,
      secret: secret,
    );
  }

  /// List all tokens matching the given filters.
  static Future<List<ApiTokenInfo>> listTokens(
    final Session session, {
    final UuidValue? authUserId,
    final String? kind,
    final Transaction? transaction,
  }) async {
    final apiTokens = await ApiToken.db.find(
      session,
      where: (final t) =>
          (authUserId != null
              ? t.authUserId.equals(authUserId)
              : Constant.bool(true)) &
          (kind != null ? t.kind.equals(kind) : Constant.bool(true)),
      transaction: transaction,
    );

    final tokenInfos = <ApiTokenInfo>[
      for (final apiToken in apiTokens)
        ApiTokenInfo(
          id: apiToken.id!,
          authUserId: apiToken.authUserId,
          scopeNames: apiToken.scopeNames,
          created: apiToken.created,
          lastUsed: apiToken.lastUsed,
          expiresAt: apiToken.expiresAt,
          expireAfterUnusedFor: apiToken.expireAfterUnusedFor,
          kind: apiToken.kind,
        )
    ];

    return tokenInfos;
  }

  /// Deletes a single API token.
  ///
  /// This invalidates the API token immediately.
  static Future<void> deleteApiToken(
    final Session session, {
    required final UuidValue id,
    final Transaction? transaction,
  }) async {
    final apiToken = (await ApiToken.db.deleteWhere(
      session,
      where: (final t) => t.id.equals(id),
      transaction: transaction,
    ))
        .firstOrNull;

    if (apiToken == null) {
      return;
    }

    await session.messages.authenticationRevoked(
      apiToken.authUserId,
      RevokedAuthenticationAuthId(authId: apiToken.toString()),
    );
  }

  /// Deletes all API token for a given user.
  ///
  ///  This invalidates all the user's API tokens immediately.
  static Future<void> deleteApiTokensForUser(
    final Session session, {
    required final UuidValue authUserId,
    final Transaction? transaction,
  }) async {
    final deletedApiTokens = await ApiToken.db.deleteWhere(
      session,
      where: (final t) => t.authUserId.equals(authUserId),
      transaction: transaction,
    );

    if (deletedApiTokens.isEmpty) return;

    await session.messages.authenticationRevoked(
      authUserId,
      RevokedAuthenticationUser(),
    );
  }

  /// Prefix for API tokenskeys
  /// "sat" being abbreviated of "serverpod_auth_api_token"
  static const _apiTokenPrefix = 'sat';

  static String _buildApiTokenString({
    required final UuidValue apiTokenId,
    required final Uint8List secret,
  }) {
    return '$_apiTokenPrefix:${base64Encode(apiTokenId.toBytes())}:${base64Encode(secret)}';
  }

  /// The secrets configuration.
  static final __secrets = ApiTokenSecrets();

  /// Secrets to the used for testing. Also affects the internally used [ApiTokenHash].
  @visibleForTesting
  static ApiTokenSecrets? secretsTestOverride;
  static ApiTokenSecrets get _secrets => secretsTestOverride ?? __secrets;

  static ApiTokenHash get _apiTokenHash => ApiTokenHash(secrets: _secrets);
}

extension on Set<Scope> {
  Set<String> get names => ({
        for (final scope in this)
          if (scope.name != null) scope.name!,
      });
}
