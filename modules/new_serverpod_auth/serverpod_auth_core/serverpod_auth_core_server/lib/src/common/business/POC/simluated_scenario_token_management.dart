// #### VALIDATION SCENARIOS

import 'package:serverpod/server.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_core_server/src/common/business/POC/token_providers/jwt_provider.dart';
import 'package:serverpod_auth_core_server/src/common/business/POC/token_providers/sss_provider.dart';
import 'package:uuid/uuid_value.dart';
import 'package:uuid/v4.dart';

import 'auth_config.dart';
import 'idp_providers/email.dart';
import 'idp_providers/google.dart';
import 'token_manager.dart';
import 'token_provider.dart';

void main() async {
  AuthConfig.set(
    tokenIssuer: JwtTokenIssuer(),
    identityProviders: [
      EmailAuthFactory(enabled: true),
      GoogleAuthFactory(enabled: true),
    ],
  );

  Future<void> runTest(
      final Future<void> Function(TokenManager, List<UuidValue>) test) async {
    // Create a test user ID
    final userIds = List.generate(
      2,
      (final _) => UuidValue.fromString(const UuidV4().generate()),
    );

    // Generate tokens for the user
    for (final userId in userIds) {
      List.generate(
        2,
        (final _) =>
            AuthConfig.getProvider<GoogleAuthProvider>().authenticate(userId),
      );
      List.generate(
          2,
          (final _) =>
              AuthConfig.getProvider<EmailAuthProvider>().authenticate(userId));
    }

    final jwtTokenIssuer = JwtTokenIssuer();
    final sssTokenIssuer = SSSTokenIssuer();

    /// Create API Keys
    for (final userId in userIds) {
      jwtTokenIssuer.issueToken(
        authUserId: userId,
        method: 'admin',
        kind: 'apiKey',
        scopes: {const Scope('api')},
        transaction: null,
      );
      sssTokenIssuer.issueToken(
        authUserId: userId,
        method: 'admin',
        kind: 'apiKey',
        scopes: {const Scope('api')},
        transaction: null,
      );
    }

    final tokenManager = AuthConfig.instance.tokenManager;
    // List tokens for the user
    print('### Initial state ###');
    await _printTokens(tokenManager);

    print('\n### Run scenario ${test.toString()}###');
    await test(tokenManager, userIds);

    print('\n### End state ###');
    await _printTokens(tokenManager);

    await tokenManager.revokeAllTokens();
  }

  for (final action in [
    _singleUserRevokeSingleTokenFromList,
    _singleUserRevokeAllFromJWTProvider,
    _singleUserRevokeAllFromSameMethod,
    _singleUserRevokeAllFromSameApiKeyKind,
    _singleUserRevokeAll,
    _multipleUserRevokeAllFromJWTProvider,
    _multipleUserRevokeAllFromSameUserMethod,
    _multipleUserRevokeAllFromSameApiKeyKind,
    _multipleUserRevokeAll,
  ]) {
    await runTest(action);
  }
}

Future<void> _singleUserRevokeSingleTokenFromList(
  final TokenManager tokenManager,
  final List<UuidValue> userIds,
) async {
  final allTokens = await tokenManager.listTokens(authUserId: userIds.first);

  // Here we could have a roundtrip with the client so that the user can
  // select which token to revoke.

  // The important part is that all information required to revoke the token
  // is passed back.

  final tokenToRevoke = allTokens.first;
  await tokenManager.revokeToken(
    tokenId: tokenToRevoke.tokenId,
  );
}

/// Could be used to clear out all tokens from a single token provider
/// that is no longer supported.
Future<void> _singleUserRevokeAllFromJWTProvider(
  final TokenManager tokenManager,
  final List<UuidValue> userIds,
) async {
  await tokenManager.revokeAllTokens(
    tokenProvider: AuthStrategy.jwt.name,
    authUserId: userIds.first,
  );
}

Future<void> _multipleUserRevokeAllFromJWTProvider(
  final TokenManager tokenManager,
  final List<UuidValue> userIds,
) async {
  await tokenManager.revokeAllTokens(
    tokenProvider: AuthStrategy.jwt.name,
  );
}

/// Could be used to clear out all tokens for a single method.
Future<void> _singleUserRevokeAllFromSameMethod(
  final TokenManager tokenManager,
  final List<UuidValue> userIds,
) async {
  await tokenManager.revokeAllTokens(
    authUserId: userIds.first,
    method: 'user',
  );
}

Future<void> _multipleUserRevokeAllFromSameUserMethod(
  final TokenManager tokenManager,
  final List<UuidValue> userIds,
) async {
  await tokenManager.revokeAllTokens(
    method: 'user',
  );
}

Future<void> _singleUserRevokeAllFromSameApiKeyKind(
  final TokenManager tokenManager,
  final List<UuidValue> userIds,
) async {
  await tokenManager.revokeAllTokens(
    authUserId: userIds.first,
    kind: 'apiKey',
  );
}

Future<void> _multipleUserRevokeAllFromSameApiKeyKind(
  final TokenManager tokenManager,
  final List<UuidValue> userIds,
) async {
  await tokenManager.revokeAllTokens(
    kind: 'apiKey',
  );
}

Future<void> _singleUserRevokeAll(
  final TokenManager tokenManager,
  final List<UuidValue> userIds,
) async {
  await tokenManager.revokeAllTokens(
    authUserId: userIds.first,
  );
}

Future<void> _multipleUserRevokeAll(
  final TokenManager tokenManager,
  final List<UuidValue> userIds,
) async {
  await tokenManager.revokeAllTokens();
}

Future<void> _printTokens(final TokenManager tokenManager) async {
  void printTokens(final List<TokenInfo> tokens) {
    for (final token in tokens) {
      print(token);
    }
  }

  final allTokens = await tokenManager.listTokens();
  print('\n--- Listing tokens (${allTokens.length}) ---');
  printTokens(allTokens);

  final jwtTokens = await tokenManager.listTokens(
    tokenProvider: AuthStrategy.jwt.name,
  );
  print('\n--- JWT tokens (${jwtTokens.length})---');
  printTokens(jwtTokens);

  final sseTokens = await tokenManager.listTokens(
    tokenProvider: AuthStrategy.session.name,
  );
  print('\n--- SSE tokens (${sseTokens.length}) ---');
  printTokens(sseTokens);
}
