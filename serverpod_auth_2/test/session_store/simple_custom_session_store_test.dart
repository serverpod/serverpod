import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_2/additional_data.dart';
import 'package:serverpod_auth_2/serverpod_auth_module/user_session_repository.dart';

void main() {
  test('Simple session storage', () async {
    final ServerpodSessionExample server;
    {
      final sessionHandler = ServerSessionHandler();
      server = ServerpodSessionExample(sessionHandler);

      server.registerEndpoint(
        'login',
        (_, __) => sessionHandler.createSession(5,
            authProvider: '', additionalData: null),
      );

      server.registerEndpoint(
        'greetByUserId',
        (userId, _) => 'Hello #$userId!',
      );
    }

    final client = ServerpodClientExample(
      SharedPreferencesSessionStore(),
      server,
    );

    await client.login();

    expect(
      client._sessionStore.getSessionKey(),
      isNotNull,
    );

    final greeting = await client.getGreeting();

    expect(greeting, 'Hello #5!');
  });
}

class SharedPreferencesSessionStore implements SessionStore {
  String? _sessionKey;

  void setSessionKey(String? sessionKey) {
    _sessionKey = sessionKey;
  }

  @override
  String? getSessionKey() {
    return _sessionKey;
  }
}

class ServerSessionHandler implements SessionRepository {
  var _userIdsBySessionKey = <String, int>{};

  @override
  String createSession(
    int userId, {
    required String authProvider,
    required AdditionalData? additionalData,
  }) {
    final sessionKey = DateTime.now().microsecondsSinceEpoch.toString();

    _userIdsBySessionKey[sessionKey] = userId;

    return sessionKey;
  }

  @override
  int resolveSessionToUserId(String sessionKey) {
    return _userIdsBySessionKey[sessionKey]!;
  }

  @override
  void revokeAllSessionsForUser(int userId) {
    _userIdsBySessionKey.removeWhere((_, id) => id == userId);
  }

  @override
  void revokeSession(String sessionKey) {
    _userIdsBySessionKey.remove(sessionKey);
  }
}

// Client
class ServerpodClientExample {
  ServerpodClientExample(
    this._sessionStore,
    this._server,
  );

  final SharedPreferencesSessionStore _sessionStore;

  final ServerpodSessionExample _server;

  Future<R> _callEndpoint<P, R>(String methodName, P parameter) async {
    final sessionKey = _sessionStore.getSessionKey();

    return _server.callEndpoint(methodName, sessionKey, parameter);
  }

  Future<void> login() async {
    final sessionKey = await _callEndpoint('login', null);

    // post login, the client will have to set the session key themselves
    _sessionStore.setSessionKey(sessionKey);
  }

  Future<String> getGreeting() async {
    return _callEndpoint('greetByUserId', null);
  }
}

// Server endpoint (aggregrate)
class ServerpodSessionExample {
  ServerpodSessionExample(this._sessionHandler);

  final ServerSessionHandler _sessionHandler;

  final _methods = <String, dynamic Function(int? userId, dynamic parameter)>{};

  void registerEndpoint<P, R>(
    String methodName,
    R Function(int? userId, P param) func,
  ) {
    _methods[methodName] = (userId, param) => func(userId, param);
  }

  R callEndpoint<P, R>(String methodName, String? sessionKey, P parameter) {
    return _methods[methodName]!(
      sessionKey == null
          ? null
          : _sessionHandler.resolveSessionToUserId(sessionKey),
      parameter,
    );
  }
}
