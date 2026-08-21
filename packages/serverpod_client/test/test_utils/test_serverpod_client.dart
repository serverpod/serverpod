import 'package:serverpod_client/serverpod_client.dart';

export 'package:serverpod_client/serverpod_client.dart'
    show ServerpodClientCookieAuth;

/// Test serialization manager used in tests.
class TestSerializationManager extends SerializationManager {}

/// Test Serverpod client for unit tests.
class TestServerpodClient extends ServerpodClientShared {
  TestServerpodClient({
    required Uri host,
    ClientAuthKeyProvider? authKeyProvider,
    super.httpClientOverride,
  }) : super(
         host.toString(),
         TestSerializationManager(),
         streamingConnectionTimeout: const Duration(seconds: 5),
         connectionTimeout: const Duration(seconds: 20),
       ) {
    this.authKeyProvider = authKeyProvider;
  }

  @override
  Map<String, EndpointRef> get endpointRefLookup => {};

  @override
  Map<String, ModuleEndpointCaller> get moduleLookup => {};
}
