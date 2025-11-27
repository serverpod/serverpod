import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();
  late AuthKey authKey;

  group('Given an authenticated user', () {
    setUp(() async {
      authKey = await UserAuthentication.signInUser(
        session,
        1,
        'email',
        updateSession: true,
      );
    });

    tearDown(() async {
      await AuthKey.db.deleteWhere(
        session,
        where: (row) => Constant.bool(true),
      );
    });

    test(
      'when authentication succeeds then authId is set to authKey id',
      () async {
        var result = await authenticationHandler(
          session,
          '${authKey.id}:${authKey.key}',
        );

        expect(
          result?.authId,
          equals('${authKey.id}'),
        );
      },
    );

    test('when authentication fails then authId is null', () async {
      var result = await authenticationHandler(
        session,
        '${authKey.id}:invalid-key',
      );

      expect(
        result?.authId,
        isNull,
      );
    });

    test('when authKey is not found then authentication fails', () async {
      var result = await authenticationHandler(
        session,
        '9999:${authKey.key}', // Non-existing keyId
      );

      expect(
        result?.authId,
        isNull,
      );
    });

    test('when key format is invalid then authentication fails', () async {
      var result = await authenticationHandler(
        session,
        'invalid-format-key', // Invalid format
      );

      expect(
        result?.authId,
        isNull,
      );
    });
  });
}
