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
  }) async {
    _mockData.email = email;
    _mockData.registrationCode = 'a1b2c3d4';
    _mockData.registrationToken = null;

    final accountRequestId = const Uuid().v7obj();
    _mockData.registrationRequestId = accountRequestId;
    return accountRequestId;
  }

  @override
  Future<String> verifyRegistrationCode({
    required UuidValue accountRequestId,
    required String verificationCode,
  }) async {
    if (accountRequestId != _mockData.registrationRequestId ||
        verificationCode != _mockData.registrationCode) {
      throw EmailAccountRequestException(
        reason: EmailAccountRequestExceptionReason.invalid,
      );
    }

    final registrationToken = const Uuid().v7();
    _mockData.registrationToken = registrationToken;
    return registrationToken;
  }

  @override
  Future<AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) async {
    if (registrationToken != _mockData.registrationToken) {
      throw EmailAccountRequestException(
        reason: EmailAccountRequestExceptionReason.invalid,
      );
    }
    _mockData.password = password;
    _mockData.registrationToken = null;
    return _mockData.authSuccess;
  }

  @override
  Future<UuidValue> startPasswordReset({required String email}) async {
    _mockData.email = email;
    _mockData.passwordResetCode = 'a1b2c3d4';
    _mockData.passwordResetToken = null;

    final passwordResetRequestId = const Uuid().v7obj();
    _mockData.passwordResetRequestId = passwordResetRequestId;
    return passwordResetRequestId;
  }

  @override
  Future<String> verifyPasswordResetCode({
    required UuidValue passwordResetRequestId,
    required String verificationCode,
  }) async {
    if (passwordResetRequestId != _mockData.passwordResetRequestId ||
        verificationCode != _mockData.passwordResetCode) {
      throw EmailAccountRequestException(
        reason: EmailAccountRequestExceptionReason.invalid,
      );
    }
    final finishPasswordResetToken = const Uuid().v7();
    _mockData.passwordResetToken = finishPasswordResetToken;
    return finishPasswordResetToken;
  }

  @override
  Future<AuthSuccess> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) async {
    if (finishPasswordResetToken != _mockData.passwordResetToken) {
      throw EmailAccountRequestException(
        reason: EmailAccountRequestExceptionReason.invalid,
      );
    }
    _mockData.password = newPassword;
    _mockData.passwordResetToken = null;
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
  }) => Future.value(_mockData.authSuccess);
}

class AppleIDPEndpoint extends EndpointAppleIDPBase {
  AppleIDPEndpoint(super.caller);

  final _mockData = MockAuthData();

  @override
  String get name => 'appleIDP';

  @override
  Future<AuthSuccess> login({
    required String identityToken,
    required String authorizationCode,
    required bool isNativeApplePlatformSignIn,
    String? firstName,
    String? lastName,
  }) => Future.value(_mockData.authSuccess);
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
    appleIDP = AppleIDPEndpoint(this);
    modules = Modules(this);
  }

  late final EndpointAuthEmail authEmail;

  late final GoogleIDPEndpoint googleIDP;

  late final AppleIDPEndpoint appleIDP;

  late final Modules modules;

  @override
  Map<String, EndpointRef> get endpointRefLookup => {
    'emailAuth': authEmail,
    'googleIDP': googleIDP,
    'appleIDP': appleIDP,
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

  final authUserId = const Uuid().v7obj();

  String? email;
  String? password;
  String? registrationCode;
  String? passwordResetCode;
  String? registrationToken;
  String? passwordResetToken;

  UuidValue? registrationRequestId;
  UuidValue? passwordResetRequestId;

  AuthSuccess get authSuccess => AuthSuccess(
    authStrategy: AuthStrategy.session.name,
    token: 'session-key',
    authUserId: authUserId,
    scopeNames: {},
  );
}
