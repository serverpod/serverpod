import 'package:serverpod_test_client/serverpod_test_client.dart';

class TestAuthKeyManager extends AuthenticationKeyProvider {
  String? key;

  @override
  String? getAuthenticationKey() => key;
}
