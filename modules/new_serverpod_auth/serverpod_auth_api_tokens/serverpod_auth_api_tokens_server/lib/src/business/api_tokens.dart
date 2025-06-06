import 'dart:typed_data';

import 'package:clock/clock.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_api_tokens_server/src/generated/protocol.dart';

/// Business logic for handling API tokens.
abstract class ApiTokens {
  // TODO: Admin functions: Delete expired tokens, delete inactive tokens (maybe combined clean up with flags)

  static Future<AuthenticationInfo?> authenticationHandler(
    final Session session,
    final String apiTokenString,
  ) async {
    final apiToken = await ApiToken.db.findById(
      session,
      UuidValue.fromString(apiTokenString),
    );

    if (apiToken == null) {
      return null;
    }

    if (apiToken.expiresAt != null &&
        DateTime.now().isAfter(apiToken.expiresAt!)) {
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

    return AuthenticationInfo(
      apiToken.authUserId,
      apiToken.scopeNames.map(Scope.new).toSet(),
      authId: apiToken.id!.toString(),
    );
  }

  Future<String> createApiKey(
    final Session session, {
    required final UuidValue authUserId,
    required final Set<Scope> scopes,

    /// Fixed date at which the token expires.
    ///
    /// If `null` the token will work until it's deleted or when it's been inactive for [expireAfterUnusedFor].
    final DateTime? expiresAt,

    /// Length of inactivity after which the token is no longer usable.
    final Duration? expireAfterUnusedFor,
  }) async {
    final apiTokenHash = ByteData(0);
    final apiTokenSalt = ByteData(0);

    var apiToken = ApiToken(
      authUserId: authUserId,
      scopeNames: scopes.names,
      apiTokenHash: apiTokenHash,
      apiTokenSalt: apiTokenSalt,
    );

    apiToken = await ApiToken.db.insertRow(session, apiToken);

    return apiToken.id!.toString(); // TODO: Return actual secret here
  }

  /// Query tokens …
  Future<List<ApiTokenInfo>> listTokens(
    final Session session, {
    final UuidValue? authUserId,
    final String? kind,
  }) async {
    final apiTokens = await ApiToken.db.find(
      session,
      where: (final t) =>
          (authUserId != null
              ? t.authUserId.equals(authUserId)
              : Constant.bool(true)) &
          (kind != null ? t.kind.equals(kind) : Constant.bool(true)),
    );

    final tokenInfos = <ApiTokenInfo>[
      for (final apiToken in apiTokens)
        (
          id: apiToken.id!,
          authUserId: apiToken.authUserId,
          scopes: apiToken.scopeNames.map(Scope.new).toSet(),
          created: apiToken.created,
          lastUsed: apiToken.lastUsed,
          expiresAt: apiToken.expiresAt,
          expireAfterUnusedFor: apiToken.expireAfterUnusedFor,
          kind: apiToken.kind,
        )
    ];

    return tokenInfos;
  }

  Future<void> deleteToken(
    final Session session, {
    required final UuidValue id,
  }) {
    throw UnimplementedError();
  }

  Future<void> deleteTokensForUser(
    final Session session, {
    required final UuidValue authUserId,
  }) {
    throw UnimplementedError();
  }
}

extension on Set<Scope> {
  Set<String> get names => ({
        for (final scope in this)
          if (scope.name != null) scope.name!,
      });
}

/// TODO: Make model class which can be send to the client
typedef ApiTokenInfo = ({
  UuidValue id,
  UuidValue authUserId,
  Set<Scope> scopes,
  DateTime created,
  DateTime lastUsed,
  DateTime? expiresAt,
  Duration? expireAfterUnusedFor,
  String kind,
});
