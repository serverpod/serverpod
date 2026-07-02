@TestOn('vm')
@Tags(['integration', 'email'])
library;

import 'dart:io';

import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

/// Integration tests for the Serverpod Cloud transactional email service.
///
/// The negative paths run unconditionally - they only need network access to
/// the service and assert documented error codes (the service validates the
/// request fields before authenticating, so an invalid auth code yields `400`
/// regardless of the token). The happy path actually delivers email, so it only
/// runs when credentials are configured:
///
///   * `SERVERPOD_TEST_SCLOUD_EMAIL_KEY`       - a valid service token.
///   * `SERVERPOD_TEST_SCLOUD_EMAIL_RECIPIENT` - the address to deliver to.
///   * `SERVERPOD_TEST_SCLOUD_EMAIL_BASE_URL`  - optional service URL override.
void main() {
  final env = Platform.environment;
  // Treat unset and empty (e.g. an absent GitHub secret resolves to '') alike.
  String? read(final String key) {
    final value = env[key];
    return (value == null || value.isEmpty) ? null : value;
  }

  final baseUrl =
      read('SERVERPOD_TEST_SCLOUD_EMAIL_BASE_URL') ??
      ServerpodCloudEmailClient.defaultBaseUrl;
  final token = read('SERVERPOD_TEST_SCLOUD_EMAIL_KEY');
  final recipient = read('SERVERPOD_TEST_SCLOUD_EMAIL_RECIPIENT');

  final client = ServerpodCloudEmailClient(baseUrl: baseUrl);
  tearDownAll(client.close);

  group('Given the Serverpod Cloud email service', () {
    test(
      'when sending with an invalid token then it throws a '
      'ServerpodCloudEmailException with status 401',
      () async {
        await expectLater(
          () => client.sendEmail(
            token: 'definitely-not-a-valid-token',
            emailType: ServerpodCloudEmailType.signup,
            email: 'integration-test@example.com',
            projectName: 'Serverpod CI',
            authCode: 'ABC123',
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
      'when sending with an invalid auth code then it throws a '
      'ServerpodCloudEmailException with status 400',
      () async {
        await expectLater(
          () => client.sendEmail(
            token: 'definitely-not-a-valid-token',
            emailType: ServerpodCloudEmailType.signup,
            email: 'integration-test@example.com',
            projectName: 'Serverpod CI',
            // Violates the 1–16 alphanumeric constraint; rejected before auth.
            authCode: 'not valid!',
          ),
          throwsA(
            isA<ServerpodCloudEmailException>().having(
              (final e) => e.statusCode,
              'statusCode',
              400,
            ),
          ),
        );
      },
    );
  });

  group(
    'Given valid Serverpod Cloud email credentials',
    () {
      test('when sending a sign-up email then it succeeds', () async {
        await client.sendEmail(
          token: token!,
          emailType: ServerpodCloudEmailType.signup,
          email: recipient!,
          projectName: 'Serverpod CI',
          authCode: 'ABC123',
        );
      });

      test('when sending a password-reset email then it succeeds', () async {
        await client.sendEmail(
          token: token!,
          emailType: ServerpodCloudEmailType.lostpassword,
          email: recipient!,
          projectName: 'Serverpod CI',
          authCode: 'ABC123',
        );
      });
    },
    skip: (token == null || recipient == null)
        ? 'Set SERVERPOD_TEST_SCLOUD_EMAIL_KEY and '
              'SERVERPOD_TEST_SCLOUD_EMAIL_RECIPIENT to run the credentialed '
              'email tests.'
        : null,
  );
}
