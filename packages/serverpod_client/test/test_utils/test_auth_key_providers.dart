import 'dart:async';

import 'package:serverpod_client/serverpod_client.dart';

/// Test auth key provider that supports refresh functionality.
class TestRefresherAuthKeyProvider implements RefresherClientAuthKeyProvider {
  String? _authKey;
  late FutureOr<bool> Function() _refresh;
  int refreshCallCount = 0;

  void setAuthKey(String? key) => _authKey = key?.wrapAsBearerAuthHeader();
  void updateAuthKey() => setAuthKey('refreshed-token-$refreshCallCount');
  void setRefresh(FutureOr<bool> Function() refresh) {
    _refresh = refresh;
  }

  @override
  Future<String?> get authHeaderValue async => _authKey;

  @override
  Future<bool> refreshAuthKey() async {
    refreshCallCount++;
    return _refresh();
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
