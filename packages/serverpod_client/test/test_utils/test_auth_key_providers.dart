import 'package:serverpod_client/serverpod_client.dart';

/// Test auth key provider that supports refresh functionality.
class TestRefresherAuthKeyProvider extends RefresherClientAuthKeyProvider {
  String? _authKey;
  bool? _refreshResult;
  final List<String> refreshLog = [];
  int refreshCallCount = 0;

  TestRefresherAuthKeyProvider({
    String? initialAuthKey,
  }) : _authKey = initialAuthKey?.wrapAsBearerAuthHeader();

  @override
  Future<String?> get notLockedAuthHeaderValue async => _authKey;

  @override
  Future<bool> refreshAuthKey() async {
    refreshCallCount++;
    refreshLog.add('Refresh attempt $refreshCallCount');

    final refreshResult = _refreshResult;
    if (refreshResult == null) {
      throw StateError(
        'Refresh result not set. Call "setRefreshResult" on the test provider '
        'before refreshing.',
      );
    } else if (refreshResult) {
      _authKey = 'refreshed-token-$refreshCallCount'.wrapAsBearerAuthHeader();
    }

    return refreshResult;
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

extension on String {
  String wrapAsBearerAuthHeader() {
    return wrapAsBearerAuthHeaderValue(this);
  }
}
