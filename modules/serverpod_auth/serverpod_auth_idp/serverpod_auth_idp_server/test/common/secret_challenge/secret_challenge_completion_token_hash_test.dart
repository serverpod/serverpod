import 'dart:convert';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';

import '../../test_tools/serverpod_test_tools.dart';

const _verificationCode = '12345678';
const _verificationCodeCostPrefix = r'$argon2id$v=19$m=32,t=1,p=1$';
const _minimalCostPrefix = r'$argon2id$v=19$m=8,t=1,p=1$';

/// Hashes at the cost in [_verificationCodeCostPrefix].
Argon2HashUtil _verificationCodeHash() {
  return Argon2HashUtil(
    hashPepper: 'test-pepper',
    hashSaltLength: 8,
    parameters: Argon2HashParameters(
      memory: 32,
      iterations: 1,
      lanes: 1,
      desiredKeyLength: 16,
    ),
  );
}

Argon2HashUtil _randomSecretsHash() {
  return Argon2HashUtil.forRandomSecrets(
    hashPepper: 'test-pepper',
    hashSaltLength: 8,
  );
}

void main() {
  withServerpod('[SecretChallengeUtil completion token hash],', (
    final sessionBuilder,
    final endpoints,
  ) {
    late Session session;

    setUp(() {
      session = sessionBuilder.build();
    });

    group(
      'Given a SecretChallengeUtil with a completion token hash for random secrets and a request with a verification challenge,',
      () {
        late SecretChallengeUtil<_Request> challengeUtil;
        late _Request request;

        setUp(() async {
          challengeUtil = _buildChallengeUtil(
            hashUtil: _verificationCodeHash(),
            completionTokenHash: _randomSecretsHash(),
            getRequest: () => request,
          );
          request = _Request(
            verificationChallenge: await session.db.transaction(
              (final transaction) => challengeUtil.createChallenge(
                session,
                verificationCode: _verificationCode,
                transaction: transaction,
              ),
            ),
          );
        });

        test(
          'when verifying the challenge, '
          'then the completion token is stored at the minimal Argon2 cost',
          () async {
            await session.db.transaction(
              (final transaction) => challengeUtil.verifyChallenge(
                session,
                requestId: request.id,
                verificationCode: _verificationCode,
                transaction: transaction,
              ),
            );

            expect(
              request.completionChallenge?.challengeCodeHash,
              startsWith(_minimalCostPrefix),
            );
          },
        );

        test(
          'when verifying the challenge, '
          'then the verification code stays stored at the cost of the verification code hash',
          () async {
            await session.db.transaction(
              (final transaction) => challengeUtil.verifyChallenge(
                session,
                requestId: request.id,
                verificationCode: _verificationCode,
                transaction: transaction,
              ),
            );

            expect(
              request.verificationChallenge.challengeCodeHash,
              startsWith(_verificationCodeCostPrefix),
            );
          },
        );
      },
    );

    group(
      'Given a SecretChallengeUtil with a completion token hash for random secrets and a verified request,',
      () {
        late SecretChallengeUtil<_Request> challengeUtil;
        late _Request request;
        late String completionToken;

        setUp(() async {
          challengeUtil = _buildChallengeUtil(
            hashUtil: _verificationCodeHash(),
            completionTokenHash: _randomSecretsHash(),
            getRequest: () => request,
          );
          request = _Request(
            verificationChallenge: await session.db.transaction(
              (final transaction) => challengeUtil.createChallenge(
                session,
                verificationCode: _verificationCode,
                transaction: transaction,
              ),
            ),
          );
          completionToken = await session.db.transaction(
            (final transaction) => challengeUtil.verifyChallenge(
              session,
              requestId: request.id,
              verificationCode: _verificationCode,
              transaction: transaction,
            ),
          );
        });

        test(
          'when completing the challenge with its completion token, '
          'then the request is returned',
          () async {
            final completed = await session.db.transaction(
              (final transaction) => challengeUtil.completeChallenge(
                session,
                completionToken: completionToken,
                transaction: transaction,
              ),
            );

            expect(completed, same(request));
          },
        );

        test(
          'when completing the challenge with another token, '
          'then ChallengeInvalidVerificationCodeException is thrown',
          () async {
            await expectLater(
              session.db.transaction(
                (final transaction) => challengeUtil.completeChallenge(
                  session,
                  completionToken: _encodeToken(request.id, 'another-token'),
                  transaction: transaction,
                ),
              ),
              throwsA(isA<ChallengeInvalidVerificationCodeException>()),
            );
          },
        );
      },
    );

    test(
      'Given a SecretChallengeUtil with a completion token hash for random secrets and a request whose completion token is stored at a higher Argon2 cost, '
      'when completing the challenge with that token, '
      'then the request is returned',
      () async {
        late _Request request;
        final challengeUtil = _buildChallengeUtil(
          hashUtil: _verificationCodeHash(),
          completionTokenHash: _randomSecretsHash(),
          getRequest: () => request,
        );
        request = _Request(
          verificationChallenge: SecretChallenge(challengeCodeHash: ''),
          completionChallenge: SecretChallenge(
            challengeCodeHash: await _verificationCodeHash()
                .createHashFromString(secret: 'higher-cost-token'),
          ),
        );

        final completed = await session.db.transaction(
          (final transaction) => challengeUtil.completeChallenge(
            session,
            completionToken: _encodeToken(request.id, 'higher-cost-token'),
            transaction: transaction,
          ),
        );

        expect(completed, same(request));
      },
    );

    test(
      'Given a SecretChallengeUtil without a completion token hash and a request with a verification challenge, '
      'when verifying the challenge, '
      'then the completion token is stored at the cost of the verification code hash',
      () async {
        late _Request request;
        final challengeUtil = _buildChallengeUtil(
          hashUtil: _verificationCodeHash(),
          completionTokenHash: null,
          getRequest: () => request,
        );
        request = _Request(
          verificationChallenge: await session.db.transaction(
            (final transaction) => challengeUtil.createChallenge(
              session,
              verificationCode: _verificationCode,
              transaction: transaction,
            ),
          ),
        );

        await session.db.transaction(
          (final transaction) => challengeUtil.verifyChallenge(
            session,
            requestId: request.id,
            verificationCode: _verificationCode,
            transaction: transaction,
          ),
        );

        expect(
          request.completionChallenge?.challengeCodeHash,
          startsWith(_verificationCodeCostPrefix),
        );
      },
    );
  });
}

SecretChallengeUtil<_Request> _buildChallengeUtil({
  required final Argon2HashUtil hashUtil,
  required final Argon2HashUtil? completionTokenHash,
  required final _Request Function() getRequest,
}) {
  return SecretChallengeUtil<_Request>(
    hashUtil: hashUtil,
    completionTokenHash: completionTokenHash,
    verificationConfig: SecretChallengeVerificationConfig(
      getRequest:
          (
            final session,
            final requestId, {
            required final Transaction? transaction,
          }) async => getRequest(),
      isAlreadyUsed: (final request) => false,
      getChallenge: (final request) => request.verificationChallenge,
      isExpired: (final request) => false,
      onExpired: (final session, final request) async {},
      linkCompletionToken:
          (
            final session,
            final request,
            final completionChallenge, {
            required final Transaction? transaction,
          }) async {
            request.completionChallenge = completionChallenge;
          },
      rateLimiter: null,
    ),
    completionConfig: SecretChallengeCompletionConfig(
      getRequest:
          (
            final session,
            final requestId, {
            required final Transaction? transaction,
          }) async => getRequest(),
      getCompletionChallenge: (final request) => request.completionChallenge,
      isExpired: (final request) => false,
      onExpired: (final session, final request) async {},
      rateLimiter: null,
    ),
  );
}

String _encodeToken(final UuidValue requestId, final String token) {
  return base64Encode(utf8.encode('$requestId:$token'));
}

final class _Request {
  _Request({required this.verificationChallenge, this.completionChallenge});

  final UuidValue id = const Uuid().v4obj();
  final SecretChallenge verificationChallenge;
  SecretChallenge? completionChallenge;
}
