// This package is only being used to mock the client, since this example does
// not have a real server to connect to.
// ignore_for_file: depend_on_referenced_packages

import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    hide Caller, Protocol;

class EndpointAuthEmail extends EndpointEmailIDPBase {
  EndpointAuthEmail(super.caller);

  final _mockData = MockAuthData();

  @override
  String get name => 'emailAuth';

  @override
  Future<AuthSuccess> login({
    required String email,
    required String password,
  }) async {
    if (email != _mockData.email || password != _mockData.password) {
      throw EmailAccountLoginException(
        reason: EmailAccountLoginExceptionReason.invalidCredentials,
      );
    }
    return _mockData.authSuccess;
  }

  @override
  Future<UuidValue> startRegistration({
    required String email,
    required String password,
  }) async {
    _mockData.email = email;
    _mockData.password = password;
    _mockData.verificationCode = 'A1b2C3';

    final accountRequestId = const Uuid().v4obj();
    _mockData.accountRequestId = accountRequestId;
    return accountRequestId;
  }

  @override
  Future<AuthSuccess> finishRegistration({
    required UuidValue accountRequestId,
    required String verificationCode,
  }) async {
    if (accountRequestId != _mockData.accountRequestId ||
        verificationCode != _mockData.verificationCode) {
      throw EmailAccountRequestException(
        reason: EmailAccountRequestExceptionReason.invalid,
      );
    }
    return _mockData.authSuccess;
  }

  @override
  Future<UuidValue> startPasswordReset({required String email}) async {
    _mockData.email = email;
    _mockData.passwordResetCode = 'A1b2C3';

    final passwordResetRequestId = const Uuid().v4obj();
    _mockData.passwordResetRequestId = passwordResetRequestId;
    return passwordResetRequestId;
  }

  @override
  Future<AuthSuccess> finishPasswordReset({
    required UuidValue passwordResetRequestId,
    required String verificationCode,
    required String newPassword,
  }) async {
    if (passwordResetRequestId != _mockData.passwordResetRequestId ||
        verificationCode != _mockData.passwordResetCode) {
      throw EmailAccountRequestException(
        reason: EmailAccountRequestExceptionReason.invalid,
      );
    }
    _mockData.password = newPassword;
    return _mockData.authSuccess;
  }
}

class GoogleIDPEndpoint extends EndpointGoogleIDPBase {
  GoogleIDPEndpoint(super.caller);

  final _mockData = MockAuthData();

  @override
  String get name => 'googleIDP';

  @override
  Future<AuthSuccess> login({
    required String idToken,
    required String? accessToken,
  }) =>
      Future.value(_mockData.authSuccess);
}

class Modules {
  Modules(Client client) {
    auth = Caller(client);
  }

  late final Caller auth;
}

class Client extends ServerpodClientShared {
  Client(String host)
      : super(
          host,
          Protocol(),
          connectionTimeout: const Duration(seconds: 1),
          streamingConnectionTimeout: const Duration(seconds: 1),
        ) {
    authEmail = EndpointAuthEmail(this);
    googleIDP = GoogleIDPEndpoint(this);
    modules = Modules(this);
  }

  late final EndpointAuthEmail authEmail;

  late final GoogleIDPEndpoint googleIDP;

  late final Modules modules;

  @override
  Map<String, EndpointRef> get endpointRefLookup => {
        'emailAuth': authEmail,
        'googleIDP': googleIDP,
      };

  @override
  Map<String, ModuleEndpointCaller> get moduleLookup => {
        'serverpod_auth_core': modules.auth,
      };

  @override
  Future<T> callServerEndpoint<T>(
    String endpoint,
    String method,
    Map<String, dynamic> args, {
    bool authenticated = true,
  }) async {
    throw const ServerpodClientException('This is a mock client.', -1);
  }
}

class MockAuthData {
  MockAuthData();

  final authUserId = const Uuid().v4obj();

  String? email;
  String? password;
  String? verificationCode;
  String? passwordResetCode;

  UuidValue? accountRequestId;
  UuidValue? passwordResetRequestId;

  AuthSuccess get authSuccess => AuthSuccess(
        authStrategy: AuthStrategy.session.name,
        token: 'session-key',
        authUserId: authUserId,
        scopeNames: {},
      );
}
