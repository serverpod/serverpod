import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/twitch.dart';
import 'package:test/test.dart';

void main() {
  group('TwitchIdpConfig', () {
    group('validateTwitchAccountDetails', () {
      test(
        'when given valid account details then validation passes',
        () {
          final details = (
            userIdentifier: 'twitch-user-123',
            login: 'testuser',
            displayName: 'Test User',
            email: 'test@example.com',
            profileImage: Uri.parse('https://example.com/image.png'),
          );

          expect(
            () => TwitchIdpConfig.validateTwitchAccountDetails(details),
            returnsNormally,
          );
        },
      );

      test(
        'when given account details with null email then validation passes',
        () {
          const details = (
            userIdentifier: 'twitch-user-123',
            login: 'testuser',
            displayName: 'Test User',
            email: null,
            profileImage: null,
          );

          expect(
            () => TwitchIdpConfig.validateTwitchAccountDetails(details),
            returnsNormally,
          );
        },
      );

      test(
        'when given account details with empty userIdentifier then throws TwitchUserInfoMissingDataException',
        () {
          const details = (
            userIdentifier: '',
            login: 'testuser',
            displayName: 'Test User',
            email: 'test@example.com',
            profileImage: null,
          );

          expect(
            () => TwitchIdpConfig.validateTwitchAccountDetails(details),
            throwsA(isA<TwitchUserInfoMissingDataException>()),
          );
        },
      );
    });

    group('parseTokenResponse', () {
      test(
        'when given valid token response then returns OAuth2PkceTokenResponse',
        () {
          final responseBody = {
            'access_token': 'test-access-token',
            'refresh_token': 'test-refresh-token',
            'expires_in': 3600,
            'token_type': 'bearer',
          };

          final result = TwitchIdpConfig.parseTokenResponse(responseBody);

          expect(result.accessToken, 'test-access-token');
          expect(result.refreshToken, 'test-refresh-token');
          expect(result.expiresIn, 3600);
        },
      );

      test(
        'when given response without refresh token then returns OAuth2PkceTokenResponse with null refresh token',
        () {
          final responseBody = {
            'access_token': 'test-access-token',
            'expires_in': 3600,
          };

          final result = TwitchIdpConfig.parseTokenResponse(responseBody);

          expect(result.accessToken, 'test-access-token');
          expect(result.refreshToken, isNull);
          expect(result.expiresIn, 3600);
        },
      );

      test(
        'when given response with error then throws OAuth2InvalidResponseException',
        () {
          final responseBody = {
            'error': 'invalid_grant',
            'error_description': 'The provided authorization code is invalid',
          };

          expect(
            () => TwitchIdpConfig.parseTokenResponse(responseBody),
            throwsA(isA<OAuth2InvalidResponseException>()),
          );
        },
      );

      test(
        'when given response without access token then throws OAuth2MissingAccessTokenException',
        () {
          final responseBody = {
            'refresh_token': 'test-refresh-token',
            'expires_in': 3600,
          };

          expect(
            () => TwitchIdpConfig.parseTokenResponse(responseBody),
            throwsA(isA<OAuth2MissingAccessTokenException>()),
          );
        },
      );
    });
  });

  group('TwitchOAuthCredentials', () {
    group('fromJson', () {
      test(
        'when given valid JSON then creates credentials',
        () {
          final json = {
            'clientId': 'test-client-id',
            'clientSecret': 'test-client-secret',
          };

          final credentials = TwitchOAuthCredentials.fromJson(json);

          expect(credentials.clientId, 'test-client-id');
          expect(credentials.clientSecret, 'test-client-secret');
        },
      );

      test(
        'when given JSON without clientId then throws FormatException',
        () {
          final json = {
            'clientSecret': 'test-client-secret',
          };

          expect(
            () => TwitchOAuthCredentials.fromJson(json),
            throwsA(isA<FormatException>()),
          );
        },
      );

      test(
        'when given JSON without clientSecret then throws FormatException',
        () {
          final json = {
            'clientId': 'test-client-id',
          };

          expect(
            () => TwitchOAuthCredentials.fromJson(json),
            throwsA(isA<FormatException>()),
          );
        },
      );
    });

    group('fromJsonString', () {
      test(
        'when given valid JSON string then creates credentials',
        () {
          const jsonString =
              '{"clientId": "test-client-id", "clientSecret": "test-client-secret"}';

          final credentials = TwitchOAuthCredentials.fromJsonString(jsonString);

          expect(credentials.clientId, 'test-client-id');
          expect(credentials.clientSecret, 'test-client-secret');
        },
      );

      test(
        'when given non-object JSON string then throws FormatException',
        () {
          const jsonString = '["clientId", "clientSecret"]';

          expect(
            () => TwitchOAuthCredentials.fromJsonString(jsonString),
            throwsA(isA<FormatException>()),
          );
        },
      );
    });
  });
}
