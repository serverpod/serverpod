import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email_passwordless.dart';
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

/// A session that records the alerts and logs that are written to it.
class _RecordingSession implements Session {
  final List<String> alerts = [];
  final List<String> errorLogs = [];

  @override
  void alert(final String message, {final LogLevel? level}) {
    alerts.add(message);
  }

  @override
  void log(
    final String message, {
    final LogLevel? level,
    final dynamic exception,
    final StackTrace? stackTrace,
    final Map<String, Object?>? metadata,
  }) {
    if (level == LogLevel.error) errorLogs.add(message);
  }

  @override
  dynamic noSuchMethod(final Invocation invocation) =>
      super.noSuchMethod(invocation);
}

void main() {
  final portZeroConfig = ServerConfig(
    port: 0,
    publicScheme: 'http',
    publicHost: 'localhost',
    publicPort: 0,
  );

  Future<void> initServerpodWithPasswords(final String passwords) async {
    await d.dir('config', [
      d.file('passwords.yaml', passwords),
    ]).create();

    // Constructing `Serverpod` internally sets `Serverpod.instance`, which the
    // config reads passwords and the run mode from.
    Serverpod(
      ['-m', 'test'],
      Protocol(),
      Endpoints(),
      config: ServerpodConfig(apiServer: portZeroConfig),
      serverDirectory: Directory(d.sandbox),
    );
  }

  Future<void> sendSignUp(
    final EmailPasswordlessIdpConfig config,
    final Session session, {
    final String email = 'user@example.com',
    final String code = '123456',
  }) async {
    await config.sendSignUpVerificationCode(
      session,
      email: email,
      loginRequestId: const Uuid().v7obj(),
      verificationCode: code,
      transaction: null,
    );
  }

  Future<void> sendSignIn(
    final EmailPasswordlessIdpConfig config,
    final Session session, {
    final String email = 'user@example.com',
    final String code = '123456',
  }) async {
    await config.sendSignInVerificationCode(
      session,
      email: email,
      loginRequestId: const Uuid().v7obj(),
      verificationCode: code,
      transaction: null,
    );
  }

  group('Given the emailSecretHashPepper password is missing', () {
    setUpAll(() => initServerpodWithPasswords('test:\n  database: "test"'));

    test(
      'when constructing ServerpodCloudEmailPasswordlessIdpConfig '
      'then it throws a PasswordNotFoundException for emailSecretHashPepper',
      () {
        expect(
          () => ServerpodCloudEmailPasswordlessIdpConfig(
            appDisplayName: 'My App',
          ),
          throwsA(
            isA<PasswordNotFoundException>().having(
              (final e) => e.key,
              'key',
              'emailSecretHashPepper',
            ),
          ),
        );
      },
    );
  });

  group(
    'Given the emailSecretHashPepper password is present and development mode',
    () {
      late List<http.Request> requests;
      late EmailPasswordlessIdpConfig config;

      setUpAll(
        () => initServerpodWithPasswords(
          "test:\n  database: 'test'\n  emailSecretHashPepper: 'a-pepper'\n",
        ),
      );

      setUp(() {
        requests = [];
        config = ServerpodCloudEmailPasswordlessIdpConfig(
          appDisplayName: 'My App',
          emailClient: ServerpodCloudEmailClient(
            httpClient: MockClient((final request) async {
              requests.add(request);
              return http.Response('{}', 200);
            }),
          ),
        );
      });

      test(
        'when constructing ServerpodCloudEmailPasswordlessIdpConfig '
        'then it succeeds without the cloud email key and uses the defaults of the passwordless configuration',
        () {
          expect(config, isA<EmailPasswordlessIdpConfig>());
          expect(config.allowSignUp, isTrue);
          expect(
            config.loginVerificationCodeGenerator,
            same(defaultSixDigitVerificationCodeGenerator),
          );
        },
      );

      test(
        'when the sign-up sender is called '
        'then the code is logged as an alert labeled "Sign-up code" and nothing is sent',
        () async {
          final session = _RecordingSession();

          await sendSignUp(config, session);

          expect(session.alerts, [
            'Sign-up code for user@example.com: <123456>',
          ]);
          expect(requests, isEmpty);
        },
      );

      test(
        'when the sign-in sender is called '
        'then the code is logged as an alert labeled "Sign-in code" and nothing is sent',
        () async {
          final session = _RecordingSession();

          await sendSignIn(config, session);

          expect(session.alerts, [
            'Sign-in code for user@example.com: <123456>',
          ]);
          expect(requests, isEmpty);
        },
      );

      test(
        'when constructing ServerpodCloudEmailPasswordlessIdpConfig with the hooks and allowSignUp, '
        'then they are stored on the config.',
        () {
          Future<void> onBeforeAccountCreated(
            final Session session, {
            required final String email,
            required final Transaction? transaction,
          }) async {}
          Future<void> onAfterAccountCreated(
            final Session session, {
            required final String email,
            required final UuidValue authUserId,
            required final UuidValue emailAccountId,
            required final Transaction? transaction,
          }) async {}
          Future<void> onAfterLogin(
            final Session session, {
            required final String email,
            required final UuidValue authUserId,
            required final UuidValue emailAccountId,
            required final bool accountCreated,
            required final Transaction? transaction,
          }) async {}

          final config = ServerpodCloudEmailPasswordlessIdpConfig(
            appDisplayName: 'My App',
            allowSignUp: false,
            onBeforeAccountCreated: onBeforeAccountCreated,
            onAfterAccountCreated: onAfterAccountCreated,
            onAfterLogin: onAfterLogin,
          );

          expect(config.allowSignUp, isFalse);
          expect(config.onBeforeAccountCreated, same(onBeforeAccountCreated));
          expect(config.onAfterAccountCreated, same(onAfterAccountCreated));
          expect(config.onAfterLogin, same(onAfterLogin));
        },
      );
    },
  );

  group(
    'Given staging run mode and all required passwords are present',
    () {
      late List<http.Request> requests;
      late int responseStatus;

      setUpAll(
        () => initServerpodWithPasswords(
          "test:\n  database: 'test'\n  emailSecretHashPepper: 'a-pepper'\n"
          "  scloudAuthEmailKey: 'a-cloud-token'\n",
        ),
      );

      setUp(() {
        requests = [];
        responseStatus = 200;
      });

      EmailPasswordlessIdpConfig buildConfig({
        final ServerpodCloudEmailType? signUpEmailType,
        final ServerpodCloudEmailType? signInEmailType,
      }) {
        final client = ServerpodCloudEmailClient(
          httpClient: MockClient((final request) async {
            requests.add(request);
            return http.Response(jsonEncode({'success': true}), responseStatus);
          }),
        );

        return ServerpodCloudEmailPasswordlessIdpConfig(
          appDisplayName: 'My App',
          runMode: ServerpodRunMode.staging,
          emailClient: client,
          signUpEmailType: signUpEmailType ?? ServerpodCloudEmailType.signup,
          signInEmailType: signInEmailType ?? ServerpodCloudEmailType.signup,
        );
      }

      Map<String, dynamic> bodyOf(final http.Request request) =>
          jsonDecode(request.body) as Map<String, dynamic>;

      test(
        'when the sign-up sender is called '
        'then it sends a signup email with the code and the app name',
        () async {
          final session = _RecordingSession();

          await sendSignUp(buildConfig(), session, code: '654321');

          expect(requests, hasLength(1));
          expect(bodyOf(requests.single), {
            'token': 'a-cloud-token',
            'emailType': 'signup',
            'email': 'user@example.com',
            'projectName': 'My App',
            'authCode': '654321',
          });
          expect(session.alerts, isEmpty);
        },
      );

      test(
        'when the sign-in sender is called with the default email types '
        'then it sends a signup email as well, as there is no sign-in email type yet',
        () async {
          await sendSignIn(buildConfig(), _RecordingSession());

          expect(requests, hasLength(1));
          expect(bodyOf(requests.single)['emailType'], 'signup');
        },
      );

      test(
        'when the email types are overridden '
        'then each sender uses its own email type',
        () async {
          final config = buildConfig(
            signUpEmailType: ServerpodCloudEmailType.lostpassword,
            signInEmailType: ServerpodCloudEmailType.signup,
          );

          await sendSignUp(config, _RecordingSession());
          await sendSignIn(config, _RecordingSession());

          expect(requests.map((final r) => bodyOf(r)['emailType']), [
            'lostpassword',
            'signup',
          ]);
        },
      );

      test(
        'when the service responds with an error '
        'then the sender does not throw and logs the failure',
        () async {
          responseStatus = 500;
          final session = _RecordingSession();
          final config = buildConfig();

          await sendSignUp(config, session);
          await sendSignIn(config, session);

          expect(session.errorLogs, hasLength(2));
          expect(session.errorLogs.first, contains('Sign-up'));
          expect(session.errorLogs.last, contains('Sign-in'));
        },
      );

      test(
        'when the HTTP request fails '
        'then the sender does not throw and logs the failure',
        () async {
          final config = ServerpodCloudEmailPasswordlessIdpConfig(
            appDisplayName: 'My App',
            runMode: ServerpodRunMode.staging,
            emailClient: ServerpodCloudEmailClient(
              httpClient: MockClient(
                (final request) async => throw const SocketException('down'),
              ),
            ),
          );
          final session = _RecordingSession();

          await sendSignIn(config, session);

          expect(session.errorLogs, hasLength(1));
        },
      );
    },
  );

  group(
    'Given staging run mode and the scloudAuthEmailKey password is missing',
    () {
      setUpAll(
        () => initServerpodWithPasswords(
          "test:\n  database: 'test'\n  emailSecretHashPepper: 'a-pepper'\n",
        ),
      );

      test(
        'when constructing ServerpodCloudEmailPasswordlessIdpConfig '
        'then it still succeeds (the key is read lazily, so the server boots without it)',
        () {
          final config = ServerpodCloudEmailPasswordlessIdpConfig(
            appDisplayName: 'My App',
            runMode: ServerpodRunMode.staging,
          );

          expect(config, isA<EmailPasswordlessIdpConfig>());
        },
      );

      test(
        'when a sender is called then it does not throw, sends nothing and logs the failure',
        () async {
          var requestCount = 0;
          final config = ServerpodCloudEmailPasswordlessIdpConfig(
            appDisplayName: 'My App',
            runMode: ServerpodRunMode.staging,
            emailClient: ServerpodCloudEmailClient(
              httpClient: MockClient((final request) async {
                requestCount++;
                return http.Response('{}', 200);
              }),
            ),
          );
          final session = _RecordingSession();

          await sendSignUp(config, session);

          expect(requestCount, 0);
          expect(session.errorLogs, hasLength(1));
        },
      );
    },
  );
}
