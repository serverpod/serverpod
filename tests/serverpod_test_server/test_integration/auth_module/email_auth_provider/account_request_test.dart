import 'package:serverpod/database.dart';
import 'package:serverpod_auth_server/module.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();

  tearDown(() async {
    // Shared cleanup if an account was to be created
    await EmailCreateAccountRequest.db.deleteWhere(
      session,
      where: (t) => Constant.bool(true),
    );
    await EmailAuth.db.deleteWhere(
      session,
      where: (t) => Constant.bool(true),
    );
    await UserImage.db.deleteWhere(
      session,
      where: (t) => Constant.bool(true),
    );
    await UserInfo.db.deleteWhere(
      session,
      where: (t) => Constant.bool(true),
    );
  });

  group('Given no account request when trying to create account ', () {
    late UserInfo? response;
    setUp(
      () async => {
        response = await Emails.tryCreateAccount(
          session,
          email: 'test@serverpod.dev',
          verificationCode: 'somecode',
        )
      },
    );

    test('then null is returned', () async {
      expect(response, isNull);
    });

    test('then no account is created', () async {
      var accounts = await UserInfo.db.count(
        session,
        where: (t) => Constant.bool(true),
      );

      expect(accounts, 0);
    });
  });

  group(
      'Given existing account request when creating account with incorrect validation code then null is returned and no account is created',
      () {
    var username = 'test';
    var password = 'password';
    var email = 'test@serverpod.dev';
    var verificationCode = 'somecode';

    setUp(
      () async => {
        await EmailCreateAccountRequest.db.insertRow(
          session,
          EmailCreateAccountRequest(
            userName: username,
            email: email,
            hash: password,
            verificationCode: verificationCode,
          ),
        ),
      },
    );

    group('when creating account with incorrect validation code', () {
      late UserInfo? response;
      setUp(
        () async {
          var incorrectVerificationCode = 'incorrect-$verificationCode';
          response = await Emails.tryCreateAccount(
            session,
            email: email,
            verificationCode: incorrectVerificationCode,
          );
        },
      );

      test('then create account request is not removed', () async {
        var accountRequests = await EmailCreateAccountRequest.db.count(
          session,
          where: (t) => Constant.bool(true),
        );

        expect(accountRequests, 1);
      });

      test('then null is returned', () async {
        expect(response, isNull);
      });

      test('then no account is created', () async {
        var accounts = await UserInfo.db.count(
          session,
          where: (t) => Constant.bool(true),
        );

        expect(accounts, 0);
      });
    });
    group(
        'when creating account with incorrect email then null is returned and no account is created',
        () {
      late UserInfo? response;
      setUp(
        () async {
          var incorrectEmail = 'incorrect.$email';
          response = await Emails.tryCreateAccount(
            session,
            email: incorrectEmail,
            verificationCode: verificationCode,
          );
        },
      );

      test('then create account request is not removed', () async {
        var accountRequests = await EmailCreateAccountRequest.db.count(
          session,
          where: (t) => Constant.bool(true),
        );

        expect(accountRequests, 1);
      });

      test('then null is returned', () async {
        expect(response, isNull);
      });

      test('then no account is created', () async {
        var accounts = await UserInfo.db.count(
          session,
          where: (t) => Constant.bool(true),
        );

        expect(accounts, 0);
      });
    });

    group('when creating account with correct email and validation code', () {
      late UserInfo? response;
      setUp(
        () async {
          response = await Emails.tryCreateAccount(
            session,
            email: email,
            verificationCode: verificationCode,
          );
        },
      );

      test('then account is created', () async {
        var accounts = await UserInfo.db.find(
          session,
          where: (t) => Constant.bool(true),
        );

        expect(accounts, hasLength(1));
        expect(accounts.first.email, email);
      });
      test('then user info is returned', () {
        expect(response, isNotNull);
        expect(response?.email, email);
      });

      test('then account request is removed', () async {
        var accountRequests = await EmailCreateAccountRequest.db.count(
          session,
          where: (t) => Constant.bool(true),
        );

        expect(accountRequests, 0);
      });
    });
  });
}
