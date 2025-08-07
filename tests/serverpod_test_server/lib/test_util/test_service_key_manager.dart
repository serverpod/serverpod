import 'package:serverpod_test_client/serverpod_test_client.dart';

class TestServiceKeyManager extends AuthenticationKeyProvider {
  final String name;
  final String serviceSecret;

  TestServiceKeyManager(this.name, this.serviceSecret);

  @override
  Future<String?> getAuthenticationKey() async {
    return 'name:$serviceSecret';
  }
}
