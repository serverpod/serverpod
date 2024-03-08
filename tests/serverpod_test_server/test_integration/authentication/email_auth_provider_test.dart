import 'package:serverpod/database.dart';
import 'package:serverpod_auth_server/module.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';

void main() async {
  var session = await IntegrationTestServer().session();
  AuthConfig.set(
    AuthConfig(
      sendValidationEmail: (session, email, validationCode) async {
        print('Sending validation email to $email with code $validationCode');
        return true;
      },
      extraSaltyHash: false,
    ),
  );

  group('Given create account request ', () {
    var userName = 'test';
    var email = 'test@serverpod.dev';
    var password = 'password';

    tearDown(() async {
      await EmailCreateAccountRequest.db
          .deleteWhere(session, where: (t) => Constant.bool(true));
    });

    setUp(() async {
      await Emails.createAccountRequest(session, userName, email, password);
    });

    test('when inspecting password hash then password is hashed using Argon2id',
        () async {
      var createAccountRequest =
          await EmailCreateAccountRequest.db.findFirstRow(
        session,
        where: (t) => t.userName.equals(userName) & t.email.equals(email),
      );

      expect(
        createAccountRequest,
        isNotNull,
        reason: 'Failed to find create account request',
      );
      var passwordHash = createAccountRequest!.hash;

      expect(
        passwordHash,
        contains('argon2id'),
        reason: 'Password hash is not using Argon2id',
      );
    });
  });

  group('Given a created user', () {
    var userName = 'test';
    var email = 'test@serverpod.dev';
    var password = 'password';

    tearDown(() async {
      await Future.wait([
        UserInfo.db.deleteWhere(session, where: (t) => Constant.bool(true)),
        EmailAuth.db.deleteWhere(session, where: (t) => Constant.bool(true)),
        UserImage.db.deleteWhere(session, where: (t) => Constant.bool(true)),
      ]);
    });

    setUp(() async {
      await Emails.createUser(session, userName, email, password);
    });

    test(
        'when inspecting email auth hash then password is hashed using Argon2id',
        () async {
      var emailAuth = await EmailAuth.db.findFirstRow(
        session,
        where: (t) => t.email.equals(email),
      );
      expect(
        emailAuth,
        isNotNull,
        reason: 'Failed to find email auth entry',
      );

      var passwordHash = emailAuth!.hash;
      expect(
        passwordHash,
        contains('argon2id'),
        reason: 'Password hash is not using Argon2id',
      );
    });
  });

  group('Given user with legacy password hash when authenticating', () {
    var userName = 'test';
    var email = 'test@serverpod.dev';
    var password = 'hunter2';

    tearDown(() async {
      await Future.wait([
        UserInfo.db.deleteWhere(session, where: (t) => Constant.bool(true)),
        EmailAuth.db.deleteWhere(session, where: (t) => Constant.bool(true)),
        UserImage.db.deleteWhere(session, where: (t) => Constant.bool(true)),
      ]);
    });

    setUp(() async {
      await Emails.createUser(session, userName, email, password);
      var entry = await EmailAuth.db
          .findFirstRow(session, where: (t) => t.email.equals(email));
      assert(entry != null, 'Failed to find email auth entry');
      var withLegacyHash = entry!.copyWith(
        // Legacy hash of the password 'hunter2'
        hash:
            '0713234b3cb6a6f98f6978f17a55a54578c580698dc1d56371502be6abb457eb',
      );
      await EmailAuth.db.updateRow(session, withLegacyHash);
    });

    test('then user can authenticate', () async {
      var authResponse = await Emails.authenticate(session, email, password);
      expect(authResponse.success, isTrue,
          reason: 'Failed to authenticate user.');
    });

    test('then hash is migrated.', () async {
      await Emails.authenticate(session, email, password);
      var emailAuth = await EmailAuth.db.findFirstRow(
        session,
        where: (t) => t.email.equals(email),
      );
      expect(
        emailAuth,
        isNotNull,
        reason: 'Failed to find email auth entry for user.',
      );

      var passwordHash = emailAuth!.hash;
      expect(
        passwordHash,
        contains('argon2id'),
        reason: 'Password hash was not migrated to Argon2id.',
      );
    });
  });

  group('Given all password hash types in database', () {
    tearDown(
      () async => await EmailAuth.db
          .deleteWhere(session, where: (t) => Constant.bool(true)),
    );

    setUp(
      () async => await EmailAuth.db.insert(session, [
        // These entries where generated using the hash algorithms.
        // The salt for all passwords is 'serverpod password salt'.
        EmailAuth(
          userId: 1,
          email: 'test1@serverpod.dev',
          // This is the hash of the password 'hunter0'
          hash:
              '8be0c8699ff49f0f0edaa3a69e9e175504e2b7909a1b9cb24b5fd448171da49f',
        ),
        EmailAuth(
          userId: 2,
          email: 'test2@serverpod.dev',
          // This is the hash of the password 'hunter1'
          hash:
              '51c7c7e0c3e275b1c6a9076701bf3234d7a60da111cf0ee719a6fe2884c4cf89',
        ),
        EmailAuth(
          userId: 3,
          email: 'test3@serverpod.dev',
          // This is the hash of the password 'hunter2'
          hash:
              '0713234b3cb6a6f98f6978f17a55a54578c580698dc1d56371502be6abb457eb',
        ),
        EmailAuth(
          userId: 4,
          email: 'test4@serverpod.dev',
          // This is the hash of the password 'hunter3'
          hash:
              'e0bbc3d67336323cfdaf616ca1a4cbc68aee7fdb1cf107349ff7328fcaace081',
        ),
        EmailAuth(
          userId: 5,
          email: 'test5@serverpod.dev',
          // This is the hash of the password 'hunter4'
          hash:
              '2ee3dc6432300eabf9630ac7827d6dd23fd23cc9120ec4cd58f8f66bd3ce2db9',
        ),
        EmailAuth(
          userId: 6,
          email: 'test6@serverpod.dev',
          // This is the hash from the password 'hunter2'
          hash:
              r'$migratedLegacy$c2VydmVycG9kIHBhc3N3b3JkIHNhbHQ=$zr46HulgsH9Kv8dZR/oNKPkltWHz5axYpINct5ZSRM7mgk7DMXeHI4vyPZkAvICQJPG50OKQdRAnIxaIyitIXvQBhQhcdHYZTAc2wOZfXEwDQGFJahy+N8xLwiT2FFlcaR7rorYKIEwpxZ+haihLauN4G4hFPVoftVbHz6KCY0ZzLbrHxbZtHCRWDy/dmlA0OegUu0Q1cwAXTCOZjobWOUn6uEM0/JbRJ26Mhe2UqTOFdSY/SSVIXyYuDrGDuOtm1OhOTcaLFA68FHANSOzlYPPUy6JHOvTeGfcsjdDWF720uVYUSxP5VDb4MvWWRoB212VXasswtNc2xwBOLO++4Q==',
        ),
        EmailAuth(
          userId: 7,
          email: 'test7@serverpod.dev',
          // This is the hash from the password 'hunter2'
          hash:
              r'$argon2id$c2VydmVycG9kIHBhc3N3b3JkIHNhbHQ=$lratTXSlVuxb6xwzHQzMu4Ra0pPVl1YLDdR8AwPY0gRlvF/5M7jxf6tODW9+KOgowfbP1tSGFHQebAjEOsmvL5NvAOrFDI3u0mD/414W8wR0Cni1KpATP7p5MHr5OZ2O4gEtOWfSJfgPTcq0X/uWZjRi1m4mc40TkyIFbMOfyO05JtoX0hi6r/4fTlIgIp1s7KgXEwF7B8IrmEb5zdnDgUs4qUifUM+SEH2S59fNBAt5CIviCOK7VreBztQw+L5S58ZHYSWWyB7bHJLcg1pDV9uiBb+q7qmXWJqDUBQjeJMH4nePzDmy7zarA04zQFhd6d5wIfZilJxJb8XXVGKZrQ==',
        ),
      ]),
    );

    test(
        'when migrating auth entries then updated rows matches legacy hashes stored.',
        () async {
      var updatedRows = await Emails.migrateLegacyPasswordHashes(
        session,
        batchSize: 2,
      );
      expect(updatedRows, 5);
    });

    test(
        'when migrating auth entries then all legacy hashes are stored with migrate algorithm.',
        () async {
      await Emails.migrateLegacyPasswordHashes(session, batchSize: 2);

      var emailAuth = await EmailAuth.db.find(
        session,
        where: (t) => t.email.inSet({
          'test1@serverpod.dev',
          'test2@serverpod.dev',
          'test3@serverpod.dev',
          'test4@serverpod.dev',
          'test5@serverpod.dev',
        }),
      );

      expect(emailAuth, hasLength(5));
      var hashes = emailAuth.map((e) => e.hash).toList();
      expect(
        hashes,
        everyElement(contains('migratedLegacy')),
        reason:
            'Not all legacy hashes where migrated to migratedLegacy algorithm',
      );
    });

    group('when migrating auth entries', () {
      setUp(() async => await Emails.migrateLegacyPasswordHashes(session));

      test('then user that had legacy password passes validation.', () async {
        var emailAuth = await EmailAuth.db.findFirstRow(
          session,
          where: (t) => t.email.equals('test1@serverpod.dev'),
        );

        expect(emailAuth, isNotNull, reason: 'Failed to find email auth entry');
        var passwordHash = emailAuth!.hash;

        expect(
          Emails.validatePasswordHash(
            'hunter0',
            'test1@serverpod.dev',
            passwordHash,
          ),
          isTrue,
        );
      });

      test(
          'then user with already migrated legacy password hash can passes validation.',
          () async {
        var emailAuth = await EmailAuth.db.findFirstRow(
          session,
          where: (t) => t.email.equals('test6@serverpod.dev'),
        );

        expect(emailAuth, isNotNull, reason: 'Failed to find email auth entry');
        var passwordHash = emailAuth!.hash;

        expect(
          Emails.validatePasswordHash(
            'hunter2',
            'test6@serverpod.dev',
            passwordHash,
          ),
          isTrue,
        );
      });

      test('then user with argon2id password hash passes validation.',
          () async {
        var emailAuth = await EmailAuth.db.findFirstRow(
          session,
          where: (t) => t.email.equals('test7@serverpod.dev'),
        );

        expect(emailAuth, isNotNull, reason: 'Failed to find email auth entry');
        var passwordHash = emailAuth!.hash;

        expect(
          Emails.validatePasswordHash(
            'hunter2',
            'test7@serverpod.dev',
            passwordHash,
          ),
          isTrue,
        );
      });
    });
  });
}
