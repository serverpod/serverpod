import 'package:serverpod_client/serverpod_client.dart';
import 'package:test/test.dart';

class TestSerializationManager extends SerializationManager {}

class TestServerpodClient extends ServerpodClientShared {
  TestServerpodClient({
    required Uri host,
    Duration? connectionTimeout,
    Duration? streamingConnectionTimeout,
  }) : super(
         '${host.toString()}/',
         TestSerializationManager(),
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
       );

  @override
  Map<String, EndpointRef> get endpointRefLookup => {};

  @override
  Map<String, ModuleEndpointCaller> get moduleLookup => {};
}

void main() {
  test(
    'Given a ServerpodClient when connectionTimeout is provided in constructor then it is set correctly.',
    () {
      final client = TestServerpodClient(
        host: Uri.parse('http://localhost:8080'),
        connectionTimeout: const Duration(minutes: 10),
      );

      expect(client.connectionTimeout, const Duration(minutes: 10));
    },
  );

  test(
    'Given a ServerpodClient when connectionTimeout is not provided then it defaults to 20 seconds.',
    () {
      final client = TestServerpodClient(
        host: Uri.parse('http://localhost:8080'),
      );

      expect(client.connectionTimeout, const Duration(seconds: 20));
    },
  );
}
