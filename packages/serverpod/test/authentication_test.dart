import 'package:test/test.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';

void main() {
  var client = Client(
    'http://localhost:8080/',
    authenticationKeyManager: TestAuthKeyManager(),
  );

  setUp(() {});

  group('Basic authentication', () {
    test('Not authenticated', () async {
      var signedIn = await client.modules.auth.status.isSignedIn();
      expect(signedIn, equals(false));
    });

    test('Access endpoint with required signin without authentication', () async {
      int? statusCode;
      try {
        await client.signInRequired.testMethod();
      }
      catch(e) {
        if (e is ServerpodClientException) {
          statusCode = e.statusCode;
        }
      }
      expect(statusCode, equals(403));
    });

    test('Authenticate with incorrect credentials', () async {
      var response = await client.authentication.authenticate('test@foo.bar', 'incorrect password');
      expect(response.success, equals(false));
    });

    test('Not authenticated after failed sign in', () async {
      var signedIn = await client.modules.auth.status.isSignedIn();
      expect(signedIn, equals(false));
    });

    test('Authenticate with correct credentials', () async {
      var response = await client.authentication.authenticate('test@foo.bar', 'password');
      if (response.success) {
        await client.authenticationKeyManager!.put('${response.keyId}:${response.key}');
      }
      expect(response.success, equals(true));
      expect(response.userInfo, isNotNull);
    });

    test('Authenticated', () async {
      var signedIn = await client.modules.auth.status.isSignedIn();
      expect(signedIn, equals(true));
    });

    test('Access endpoint with required signin', () async {
      var result = await client.signInRequired.testMethod();
      expect(result, equals(true));
    });
  });
}

class TestAuthKeyManager extends AuthenticationKeyManager {
  String? _key;

  @override
  Future<String?> get() async => _key;

  @override
  Future<void> put(String key) async {
    _key = key;
  }
}