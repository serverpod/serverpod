import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_test_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given an AuthServices configured with a ServerSideSessions with onSessionCreated callback that attaches custom metadata to the session',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authUserId;

      setUp(() async {
        AuthServices.set(
          tokenManagerBuilders: [
            ServerSideSessionsConfig(
              sessionKeyHashPepper: 'test-pepper',
              onSessionCreated:
                  (
                    final session, {
                    required final authUserId,
                    required final serverSideSessionId,
                    required final transaction,
                  }) async {
                    await SessionMetadata.db.insertRow(
                      session,
                      SessionMetadata(
                        serverSideSessionId: serverSideSessionId,
                        deviceName: 'Test Device',
                        ipAddress: '192.168.1.1',
                        userAgent: 'TestAgent/1.0',
                        metadata: null,
                      ),
                      transaction: transaction,
                    );
                  },
            ),
          ],
          identityProviderBuilders: [],
        );

        session = sessionBuilder.build();
        authUserId = await endpoints.authTest.createTestUser(sessionBuilder);
      });

      test('when creating a token from the AuthServices token manager, '
          'then the metadata is attached to the token', () async {
        await AuthServices.instance.tokenManager.issueToken(
          session,
          authUserId: authUserId,
          method: 'test',
          scopes: {},
        );

        final tokenMetadata = await SessionMetadata.db.find(session);

        expect(tokenMetadata.length, equals(1));
        expect(tokenMetadata.first.deviceName, equals('Test Device'));
        expect(tokenMetadata.first.ipAddress, equals('192.168.1.1'));
        expect(tokenMetadata.first.userAgent, equals('TestAgent/1.0'));

        final serverSideSession = await ServerSideSession.db.find(session);

        expect(serverSideSession.length, equals(1));
        expect(serverSideSession.first.authUserId, equals(authUserId));
        expect(
          serverSideSession.first.id,
          equals(tokenMetadata.first.serverSideSessionId),
        );
      });
    },
  );

  withServerpod(
    'Given an AuthServices configured with a JwtConfig with onRefreshTokenCreated callback that attaches custom metadata to the refresh token',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authUserId;

      setUp(() async {
        AuthServices.set(
          tokenManagerBuilders: [
            JwtConfig(
              refreshTokenHashPepper: 'test-pepper',
              algorithm: JwtAlgorithm.hmacSha512(
                SecretKey('test-private-key-for-HS512'),
              ),
              onRefreshTokenCreated:
                  (
                    final session, {
                    required final authUserId,
                    required final refreshTokenId,
                    required final transaction,
                  }) async {
                    await TokenMetadata.db.insertRow(
                      session,
                      TokenMetadata(
                        refreshTokenId: refreshTokenId,
                        deviceName: 'JWT Device',
                        ipAddress: '10.0.0.1',
                        userAgent: 'JWTClient/1.0',
                        metadata: null,
                      ),
                      transaction: transaction,
                    );
                  },
            ),
          ],
          identityProviderBuilders: [],
        );

        session = sessionBuilder.build();
        authUserId = await endpoints.authTest.createTestUser(sessionBuilder);
      });

      test('when creating a refresh token from the AuthServices token manager, '
          'then the metadata is attached to the token', () async {
        await AuthServices.instance.tokenManager.issueToken(
          session,
          authUserId: authUserId,
          method: 'test',
          scopes: {},
        );

        final tokenMetadata = await TokenMetadata.db.find(session);

        expect(tokenMetadata.length, equals(1));
        expect(tokenMetadata.first.deviceName, equals('JWT Device'));
        expect(tokenMetadata.first.ipAddress, equals('10.0.0.1'));
        expect(tokenMetadata.first.userAgent, equals('JWTClient/1.0'));

        final refreshToken = await RefreshToken.db.find(session);

        expect(refreshToken.length, equals(1));
        expect(refreshToken.first.authUserId, equals(authUserId));
        expect(
          refreshToken.first.id,
          equals(tokenMetadata.first.refreshTokenId),
        );
      });
    },
  );

  withServerpod(
    'Given an AuthServices configured with a ServerSideSessions with onSessionCreated callback that attaches custom metadata from the session dynamic userObject',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late UuidValue authUserId;

      setUp(() async {
        AuthServices.set(
          tokenManagerBuilders: [
            ServerSideSessionsConfig(
              sessionKeyHashPepper: 'test-pepper',
              onSessionCreated:
                  (
                    final session, {
                    required final authUserId,
                    required final serverSideSessionId,
                    required final transaction,
                  }) async {
                    final object = session.userObject as Map<String, dynamic>;
                    final deviceName = object['deviceName'] as String;
                    final userAgent = object['userAgent'] as String;

                    await SessionMetadata.db.insertRow(
                      session,
                      SessionMetadata(
                        serverSideSessionId: serverSideSessionId,
                        deviceName: deviceName,
                        ipAddress: session
                            .request
                            ?.connectionInfo
                            .remote
                            .address
                            .toString(),
                        userAgent: userAgent,
                        metadata: null,
                      ),
                      transaction: transaction,
                    );
                  },
            ),
          ],
          identityProviderBuilders: [],
        );

        session = sessionBuilder.build();
        authUserId = await endpoints.authTest.createTestUser(sessionBuilder);
      });

      test(
        'when creating a token from the AuthServices token manager, '
        'then the dynamic userObject metadata is attached to the token',
        () async {
          // Must be attached before issuing the token.
          session.userObject = {
            'deviceName': 'Test Device',
            'userAgent': 'TestAgent/1.0',
          };

          await AuthServices.instance.tokenManager.issueToken(
            session,
            authUserId: authUserId,
            method: 'test',
            scopes: {},
          );

          final tokenMetadata = await SessionMetadata.db.find(session);

          expect(tokenMetadata.length, equals(1));
          expect(tokenMetadata.first.deviceName, equals('Test Device'));
          expect(tokenMetadata.first.userAgent, equals('TestAgent/1.0'));
        },
      );
    },
  );

  withServerpod(
    'Given an AuthSuccess generated from a ServerSideSessions with no onSessionCreated callback',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AuthSuccess authSuccess;

      setUp(() async {
        AuthServices.set(
          tokenManagerBuilders: [
            ServerSideSessionsConfig(
              sessionKeyHashPepper: 'test-pepper',
            ),
          ],
          identityProviderBuilders: [],
        );

        session = sessionBuilder.build();
        final authUserId = await endpoints.authTest.createTestUser(
          sessionBuilder,
        );

        authSuccess = await AuthServices.instance.tokenManager.issueToken(
          session,
          authUserId: authUserId,
          method: 'test',
          scopes: {},
        );
      });

      test(
        'when attaching metadata to the token using the `serverSideSessionId` getter, '
        'then the metadata is attached to the token.',
        () async {
          await SessionMetadata.db.insertRow(
            session,
            SessionMetadata(
              serverSideSessionId: authSuccess.serverSideSessionId,
              deviceName: 'Test Device',
              ipAddress: '192.168.1.1',
              userAgent: 'TestAgent/1.0',
            ),
          );

          final tokenMetadata = await SessionMetadata.db.find(session);

          expect(tokenMetadata.length, equals(1));
          expect(tokenMetadata.first.deviceName, equals('Test Device'));
          expect(tokenMetadata.first.userAgent, equals('TestAgent/1.0'));
        },
      );
    },
  );

  withServerpod(
    'Given an AuthSuccess generated from a JwtConfig with no onRefreshTokenCreated callback',
    (final sessionBuilder, final endpoints) {
      late Session session;
      late AuthSuccess authSuccess;

      setUp(() async {
        AuthServices.set(
          tokenManagerBuilders: [
            JwtConfig(
              refreshTokenHashPepper: 'test-pepper',
              algorithm: JwtAlgorithm.hmacSha512(
                SecretKey('test-private-key-for-HS512'),
              ),
            ),
          ],
          identityProviderBuilders: [],
        );

        session = sessionBuilder.build();
        final authUserId = await endpoints.authTest.createTestUser(
          sessionBuilder,
        );

        authSuccess = await AuthServices.instance.tokenManager.issueToken(
          session,
          authUserId: authUserId,
          method: 'test',
          scopes: {},
        );
      });

      test(
        'when attaching metadata to the refresh token using the `jwtRefreshTokenId` getter, '
        'then the metadata is attached to the refresh token.',
        () async {
          await TokenMetadata.db.insertRow(
            session,
            TokenMetadata(
              refreshTokenId: authSuccess.jwtRefreshTokenId,
              deviceName: 'JWT Device',
              ipAddress: '10.0.0.1',
              userAgent: 'JWTClient/1.0',
            ),
          );

          final tokenMetadata = await TokenMetadata.db.find(session);

          expect(tokenMetadata.length, equals(1));
          expect(tokenMetadata.first.deviceName, equals('JWT Device'));
          expect(tokenMetadata.first.userAgent, equals('JWTClient/1.0'));
        },
      );
    },
  );
}
