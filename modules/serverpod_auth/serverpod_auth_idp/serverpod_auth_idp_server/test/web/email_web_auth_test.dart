import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import '../email/test_utils/email_idp_test_fixture.dart';
import '../test_tools/serverpod_test_tools.dart';
import 'web_auth_test_utils.dart';

void main() {
  withServerpod(
    'Given HTML email web auth',
    rollbackDatabase: RollbackDatabase.disabled,
    configOverride: (final config) => config.copyWith(
      authCookie: const WebAuthCookieConfig(secure: false),
      allowedOrigins: const [allowedOrigin],
    ),
    (final sessionBuilder, final endpoints) {
      late http.Client client;
      late Uri base;
      late Session session;
      late EmailIdpTestFixture fixture;
      late AuthUsers authUsers;

      const emailA = 'a@serverpod.dev';
      const emailB = 'b@serverpod.dev';
      const password = 'Password123!';

      setUpAll(() async {
        final pod = Serverpod.instance;
        pod.initializeAuthServices(
          tokenManagerBuilders: [
            ServerSideSessionsConfig(sessionKeyHashPepper: 'test-pepper'),
          ],
          identityProviderBuilders: [
            const EmailIdpConfig(secretHashPepper: 'pepper'),
          ],
        );
        pod.configureWebAuthRoutes(loginSuccessPath: '/');
        pod.webServer.addRoute(WhoAmIRoute(), '/whoami');
        if (!pod.webServer.running) {
          await pod.webServer.start();
        }
        client = http.Client();
        base = Uri.parse('http://localhost:${pod.webServer.port}');
      });

      tearDownAll(() => client.close());

      setUp(() async {
        session = sessionBuilder.build();
        fixture = EmailIdpTestFixture();
        authUsers = const AuthUsers();
      });

      tearDown(() async {
        await fixture.tearDown(session);
      });

      Future<UuidValue> createAccount(final String email) async {
        final user = await authUsers.create(session);
        await fixture.createEmailAccount(
          session,
          authUserId: user.id,
          email: email,
          password: EmailAccountPassword.fromString(password),
        );
        return user.id;
      }

      Future<http.Response> getLogin({final String? cookie}) {
        return send(client, base, 'GET', '/auth/login', cookie: cookie);
      }

      Future<http.Response> postLogin({
        required final String csrf,
        required final String email,
        required final String password,
        required final String cookie,
        final String returnTo = '/',
      }) {
        return send(
          client,
          base,
          'POST',
          '/auth/login',
          origin: allowedOrigin,
          cookie: cookie,
          body: formBody({
            'csrf': csrf,
            'email': email,
            'password': password,
            'return_to': returnTo,
          }),
        );
      }

      test(
        'when login POST succeeds then Set-Cookie is issued and the next GET '
        'is authenticated.',
        () async {
          await createAccount(emailA);
          final page = await getLogin();
          final csrf = setCookieValue(page, '${authCookieName}_csrf')!;
          final login = await postLogin(
            csrf: csrf,
            email: emailA,
            password: password,
            cookie: '${authCookieName}_csrf=$csrf',
          );
          expect(login.statusCode, 303);
          final token = setCookieValue(login, authCookieName);
          expect(token, isNotEmpty);

          final who = await send(
            client,
            base,
            'GET',
            '/whoami',
            cookie: '$authCookieName=$token',
          );
          expect(who.statusCode, 200);
          expect(who.body, isNot('anonymous'));
        },
      );

      test(
        'when the password is wrong then no auth cookie is set and the page '
        'shows an error.',
        () async {
          await createAccount(emailA);
          final page = await getLogin();
          final csrf = setCookieValue(page, '${authCookieName}_csrf')!;
          final login = await postLogin(
            csrf: csrf,
            email: emailA,
            password: 'WrongPassword123!',
            cookie: '${authCookieName}_csrf=$csrf',
          );
          expect(login.statusCode, 200);
          expect(login.body, contains('Invalid email or password'));
          expect(setCookieValue(login, authCookieName), isNull);
        },
      );

      test(
        'when CSRF is missing then the response is 403.',
        () async {
          await createAccount(emailA);
          final login = await send(
            client,
            base,
            'POST',
            '/auth/login',
            origin: allowedOrigin,
            body: formBody({
              'email': emailA,
              'password': password,
            }),
          );
          expect(login.statusCode, 403);
        },
      );

      test(
        'when CSRF does not match then the response is 403.',
        () async {
          await createAccount(emailA);
          final page = await getLogin();
          final csrf = setCookieValue(page, '${authCookieName}_csrf')!;
          final login = await postLogin(
            csrf: 'not-the-cookie',
            email: emailA,
            password: password,
            cookie: '${authCookieName}_csrf=$csrf',
          );
          expect(login.statusCode, 403);
        },
      );

      test(
        'when duplicate CSRF cookies are sent then the response is 403.',
        () async {
          await createAccount(emailA);
          final page = await getLogin();
          final csrf = setCookieValue(page, '${authCookieName}_csrf')!;
          final login = await send(
            client,
            base,
            'POST',
            '/auth/login',
            origin: allowedOrigin,
            cookie:
                '${authCookieName}_csrf=$csrf; ${authCookieName}_csrf=other',
            body: formBody({
              'csrf': csrf,
              'email': emailA,
              'password': password,
            }),
          );
          expect(login.statusCode, 403);
        },
      );

      test(
        'when already signed in with a bad CSRF token then the session is '
        'not revoked.',
        () async {
          final userId = await createAccount(emailA);
          final page = await getLogin();
          final csrf = setCookieValue(page, '${authCookieName}_csrf')!;
          final login = await postLogin(
            csrf: csrf,
            email: emailA,
            password: password,
            cookie: '${authCookieName}_csrf=$csrf',
          );
          final token = setCookieValue(login, authCookieName)!;

          final page2 = await getLogin(cookie: '$authCookieName=$token');
          final csrf2 = setCookieValue(page2, '${authCookieName}_csrf')!;
          final bad = await postLogin(
            csrf: 'nope',
            email: emailA,
            password: password,
            cookie: '$authCookieName=$token; ${authCookieName}_csrf=$csrf2',
          );
          expect(bad.statusCode, 403);

          final who = await send(
            client,
            base,
            'GET',
            '/whoami',
            cookie: '$authCookieName=$token',
          );
          expect(who.body, userId.toString());
        },
      );

      test(
        'when already signed in as A then logging in as B revokes A and '
        'sets B cookie.',
        () async {
          final userA = await createAccount(emailA);
          final userB = await createAccount(emailB);

          final pageA = await getLogin();
          final csrfA = setCookieValue(pageA, '${authCookieName}_csrf')!;
          final loginA = await postLogin(
            csrf: csrfA,
            email: emailA,
            password: password,
            cookie: '${authCookieName}_csrf=$csrfA',
          );
          final tokenA = setCookieValue(loginA, authCookieName)!;

          final pageB = await getLogin(cookie: '$authCookieName=$tokenA');
          final csrfB = setCookieValue(pageB, '${authCookieName}_csrf')!;
          final loginB = await postLogin(
            csrf: csrfB,
            email: emailB,
            password: password,
            cookie: '$authCookieName=$tokenA; ${authCookieName}_csrf=$csrfB',
          );
          expect(loginB.statusCode, 303);
          final tokenB = setCookieValue(loginB, authCookieName);
          expect(tokenB, isNotEmpty);
          expect(tokenB, isNot(tokenA));

          final whoB = await send(
            client,
            base,
            'GET',
            '/whoami',
            cookie: '$authCookieName=$tokenB',
          );
          expect(whoB.body, userB.toString());

          final whoA = await send(
            client,
            base,
            'GET',
            '/whoami',
            cookie: '$authCookieName=$tokenA',
          );
          expect(whoA.body, 'anonymous');
          expect(userA, isNot(userB));
        },
      );

      test(
        'when logging out then this device token is revoked, the cookie is '
        'cleared, and another device token remains.',
        () async {
          final userId = await createAccount(emailA);
          final page = await getLogin();
          final csrf = setCookieValue(page, '${authCookieName}_csrf')!;
          final login = await postLogin(
            csrf: csrf,
            email: emailA,
            password: password,
            cookie: '${authCookieName}_csrf=$csrf',
          );
          final token = setCookieValue(login, authCookieName)!;

          await AuthServices.instance.tokenManager.createToken(
            session,
            authUserId: userId,
            method: 'email',
          );
          final before = await AuthServices.instance.tokenManager.listTokens(
            session,
            authUserId: userId,
          );
          expect(before, hasLength(2));

          final accountPage = await getLogin(
            cookie: '$authCookieName=$token',
          );
          final csrfOut = setCookieValue(
            accountPage,
            '${authCookieName}_csrf',
          )!;
          final logout = await send(
            client,
            base,
            'POST',
            '/auth/logout',
            origin: allowedOrigin,
            cookie: '$authCookieName=$token; ${authCookieName}_csrf=$csrfOut',
            body: formBody({'csrf': csrfOut}),
          );
          expect(logout.statusCode, 303);
          expect(logout.headers['location'], '/auth/login');
          expect(setCookieCleared(logout, authCookieName), isTrue);

          final after = await AuthServices.instance.tokenManager.listTokens(
            session,
            authUserId: userId,
          );
          expect(after, hasLength(1));

          final who = await send(
            client,
            base,
            'GET',
            '/whoami',
            cookie: '$authCookieName=$token',
          );
          expect(who.body, 'anonymous');
        },
      );
    },
  );
}
