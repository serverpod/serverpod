import 'dart:async';

import 'package:serverpod_client/serverpod_client.dart';

/// Exception raised when authentication fails.
const unauthorizedException = ServerpodClientException('Unauthorized', 401);

/// Test serialization manager used in tests.
class TestSerializationManager extends SerializationManager {}

/// Test auth key provider that supports refresh functionality.
class TestRefresherAuthKeyProvider extends RefresherClientAuthKeyProvider {
  String? _authKey;
  bool _refreshResult;
  final List<String> refreshLog = [];
  int refreshCallCount = 0;

  TestRefresherAuthKeyProvider({
    String? initialAuthKey,
    bool refreshResult = true,
  })  : _authKey = initialAuthKey,
        _refreshResult = refreshResult;

  @override
  Future<String?> get notLockedAuthHeaderValue async => _authKey;

  @override
  Future<bool> refreshAuthKey() async {
    refreshCallCount++;
    refreshLog.add('Refresh attempt $refreshCallCount');

    if (_refreshResult) {
      _authKey = 'refreshed-token-$refreshCallCount';
    }

    return _refreshResult;
  }

  void setRefreshResult(bool result) {
    _refreshResult = result;
  }
}

/// Test auth key provider that does not support refresh functionality.
class TestNonRefresherAuthKeyProvider implements ClientAuthKeyProvider {
  final String? _authKey;
  int authHeaderValueCallCount = 0;

  TestNonRefresherAuthKeyProvider(this._authKey);

  @override
  Future<String?> get authHeaderValue async {
    authHeaderValueCallCount++;
    return _authKey;
  }
}

/// Test request delegate for mocking HTTP requests.
class TestRequestDelegate extends ServerpodClientRequestDelegate {
  final List<String> requestLog = [];
  String Function()? responseProvider;
  Exception? exceptionToThrow;
  bool throwOnFirstCallOnly;
  int callCount = 0;

  TestRequestDelegate({
    this.responseProvider,
    this.exceptionToThrow,
    this.throwOnFirstCallOnly = false,
  });

  @override
  Future<String> serverRequest<T>(
    Uri url, {
    required String body,
    String? authenticationValue,
  }) async {
    callCount++;
    requestLog.add('Request $callCount: auth=$authenticationValue');

    if (exceptionToThrow != null && (!throwOnFirstCallOnly || callCount == 1)) {
      throw exceptionToThrow!;
    }

    return responseProvider != null
        ? responseProvider!()
        : '{"result": "success"}';
  }

  @override
  void close() {}
}

/// Test Serverpod client for unit tests.
class TestServerpodClient extends ServerpodClientShared {
  TestServerpodClient({
    ClientAuthKeyProvider? authKeyProvider,
    ServerpodClientRequestDelegate? requestDelegate,
  }) : super(
          'https://test.com/',
          TestSerializationManager(),
          streamingConnectionTimeout: const Duration(seconds: 5),
          connectionTimeout: const Duration(seconds: 20),
          requestDelegate: requestDelegate,
        ) {
    this.authKeyProvider = authKeyProvider;
  }

  @override
  Map<String, EndpointRef> get endpointRefLookup => {};

  @override
  Map<String, ModuleEndpointCaller> get moduleLookup => {};
}
