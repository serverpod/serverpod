import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

void main() {
  group('Given a ServerpodCloudEmailClient', () {
    test(
      'when sending a sign-up email '
      'then it posts a well-formed request and completes on a 200 response',
      () async {
        late http.Request captured;
        final client = ServerpodCloudEmailClient(
          baseUrl: 'https://emails.example.test',
          httpClient: MockClient((final request) async {
            captured = request;
            return http.Response(jsonEncode({'success': true}), 200);
          }),
        );

        await client.sendEmail(
          token: 'a-token',
          emailType: ServerpodCloudEmailType.signup,
          email: 'user@example.com',
          projectName: 'Acme Corp',
          authCode: 'XY9Z42',
        );

        expect(captured.method, 'POST');
        expect(
          captured.url.toString(),
          'https://emails.example.test/api/email/send',
        );
        expect(captured.headers['content-type'], contains('application/json'));
        expect(jsonDecode(captured.body), {
          'token': 'a-token',
          'emailType': 'signup',
          'email': 'user@example.com',
          'projectName': 'Acme Corp',
          'authCode': 'XY9Z42',
        });
      },
    );

    test(
      'when sending a password-reset email '
      'then it uses the lostpassword emailType',
      () async {
        late http.Request captured;
        final client = ServerpodCloudEmailClient(
          httpClient: MockClient((final request) async {
            captured = request;
            return http.Response(jsonEncode({'success': true}), 200);
          }),
        );

        await client.sendEmail(
          token: 'a-token',
          emailType: ServerpodCloudEmailType.lostpassword,
          email: 'user@example.com',
          projectName: 'Acme Corp',
          authCode: 'A1B2C3',
        );

        expect((jsonDecode(captured.body) as Map)['emailType'], 'lostpassword');
      },
    );

    test('then it targets the hosted service by default', () {
      expect(
        ServerpodCloudEmailClient.defaultBaseUrl,
        'https://emails.serverpod.dev',
      );
    });

    test(
      'when the service responds with 400 then it throws a '
      'ServerpodCloudEmailException with the parsed error message',
      () async {
        final client = ServerpodCloudEmailClient(
          httpClient: MockClient(
            (final _) async =>
                http.Response(jsonEncode({'error': 'Invalid field'}), 400),
          ),
        );

        await expectLater(
          () => client.sendEmail(
            token: 'a-token',
            emailType: ServerpodCloudEmailType.signup,
            email: 'user@example.com',
            projectName: 'Acme Corp',
            authCode: 'XY9Z42',
          ),
          throwsA(
            isA<ServerpodCloudEmailException>()
                .having((final e) => e.statusCode, 'statusCode', 400)
                .having((final e) => e.message, 'message', 'Invalid field'),
          ),
        );
      },
    );

    test(
      'when the service responds with 401 then it throws a '
      'ServerpodCloudEmailException',
      () async {
        final client = ServerpodCloudEmailClient(
          httpClient: MockClient(
            (final _) async =>
                http.Response(jsonEncode({'error': 'Token expired'}), 401),
          ),
        );

        await expectLater(
          () => client.sendEmail(
            token: 'a-token',
            emailType: ServerpodCloudEmailType.signup,
            email: 'user@example.com',
            projectName: 'Acme Corp',
            authCode: 'XY9Z42',
          ),
          throwsA(
            isA<ServerpodCloudEmailException>().having(
              (final e) => e.statusCode,
              'statusCode',
              401,
            ),
          ),
        );
      },
    );

    test(
      'when the service responds with a non-JSON error body then the raw body '
      'is used as the message',
      () async {
        final client = ServerpodCloudEmailClient(
          httpClient: MockClient(
            (final _) async => http.Response('Internal Server Error', 500),
          ),
        );

        await expectLater(
          () => client.sendEmail(
            token: 'a-token',
            emailType: ServerpodCloudEmailType.signup,
            email: 'user@example.com',
            projectName: 'Acme Corp',
            authCode: 'XY9Z42',
          ),
          throwsA(
            isA<ServerpodCloudEmailException>()
                .having((final e) => e.statusCode, 'statusCode', 500)
                .having(
                  (final e) => e.message,
                  'message',
                  'Internal Server Error',
                ),
          ),
        );
      },
    );
  });
}
