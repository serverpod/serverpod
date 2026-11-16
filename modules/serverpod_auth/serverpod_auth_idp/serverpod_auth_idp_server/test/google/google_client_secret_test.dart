import 'package:serverpod_auth_idp_server/providers/google.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given a client secret JSON with redirect uris when parsing then the redirect uris are read.',
    () {
      final secret = GoogleClientSecret.fromJson({
        'web': {
          'client_id': 'id',
          'client_secret': 'secret',
          'redirect_uris': ['http://localhost:8080/auth/google/callback'],
        },
      });

      expect(secret.clientId, 'id');
      expect(secret.clientSecret, 'secret');
      expect(secret.redirectUris, [
        'http://localhost:8080/auth/google/callback',
      ]);
    },
  );

  test(
    'Given a client secret JSON without redirect uris when parsing then the redirect uris are empty.',
    () {
      final secret = GoogleClientSecret.fromJson({
        'web': {
          'client_id': 'id',
          'client_secret': 'secret',
        },
      });

      expect(secret.clientId, 'id');
      expect(secret.clientSecret, 'secret');
      expect(secret.redirectUris, isEmpty);
    },
  );

  test(
    'Given a client secret JSON string without redirect uris when parsing then the redirect uris are empty.',
    () {
      final secret = GoogleClientSecret.fromJsonString(
        '{"web":{"client_id":"id","client_secret":"secret"}}',
      );

      expect(secret.redirectUris, isEmpty);
    },
  );
}
