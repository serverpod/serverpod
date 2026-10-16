// This package is only being used to mock the client, since this example does
// not have a real server to connect to.
// ignore_for_file: depend_on_referenced_packages

import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    hide Caller, Protocol;

class AnonymousIdpEndpoint extends EndpointAnonymousIdpBase {
  AnonymousIdpEndpoint(super.caller);

  final _mockData = MockAuthData();

  @override
  String get name => 'anonymousIdp';

  @override
  Future<AuthSuccess> login({final String? token}) =>
      Future.value(_mockData.authSuccess);
}

class EndpointAuthEmail extends EndpointEmailOtpIdpBase {
  EndpointAuthEmail(super.caller);

  final _mockData = MockAuthData();

  /// Mirrors `EmailIdpConfig.allowPasswordOnOtpRegistration` on the server.
  bool allowPasswordOnOtpRegistration = false;

  /// How long each call takes to respond, to explore the loading states.
  ///
  /// Read when a call starts, so changing it does not affect pending calls.
  Duration responseDelay = Duration.zero;

  /// Whether the next completion of a passwordless sign-in is rejected, like
  /// the server does for tokens that were already used.
  bool rejectNextOtpLogin = false;

  /// Creates the mock account with [email] and [password], so that signing in
  /// with them or with a one-time password for [email] succeeds.
  void seedAccount({required String email, required String password}) {
    _mockData
      ..email = email
      ..password = password
      ..hasAccount = true;
  }

  /// Forgets the mock account, so the next passwordless sign-in continues to
  /// account creation.
  void forgetAccount() => _mockData
    ..email = null
    ..password = null
    ..hasAccount = false;

  Future<void> _respond() async {
    final delay = responseDelay;
    if (delay > Duration.zero) await Future<void>.delayed(delay);
  }

  @override
  String get name => 'emailAuth';

  @override
  Future<AuthSuccess> login({
    required String email,
    required String password,
  }) async {
    await _respond();
    if (email != _mockData.email || password != _mockData.password) {
      throw EmailAccountLoginException(
        reason: EmailAccountLoginExceptionReason.invalidCredentials,
      );
    }
    _mockData.hasAccount = true;
    return _mockData.authSuccess;
  }

  @override
  Future<UuidValue> startRegistration({
    required String email,
  }) async {
    await _respond();
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
    await _respond();
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
    await _respond();
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
    await _respond();
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
    await _respond();
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
    await _respond();
    if (finishPasswordResetToken != _mockData.passwordResetToken) {
      throw EmailAccountRequestException(
        reason: EmailAccountRequestExceptionReason.invalid,
      );
    }
    _mockData.password = newPassword;
    _mockData.passwordResetToken = null;
    return _mockData.authSuccess;
  }

  @override
  Future<UuidValue> startOtpLogin({required String email}) async {
    await _respond();
    _mockData.email = email;
    _mockData.otpCode = '123456';
    _mockData.otpToken = null;

    final otpLoginRequestId = const Uuid().v7obj();
    _mockData.otpLoginRequestId = otpLoginRequestId;
    return otpLoginRequestId;
  }

  @override
  Future<EmailAccountOtpVerificationResult> verifyOtpLoginCode({
    required UuidValue otpLoginRequestId,
    required String verificationCode,
  }) async {
    await _respond();
    if (otpLoginRequestId != _mockData.otpLoginRequestId ||
        verificationCode != _mockData.otpCode) {
      throw EmailAccountRequestException(
        reason: EmailAccountRequestExceptionReason.invalid,
      );
    }

    final otpToken = const Uuid().v7();
    _mockData.otpToken = otpToken;
    return EmailAccountOtpVerificationResult(
      token: otpToken,
      accountExists: _mockData.hasAccount,
      allowPassword: allowPasswordOnOtpRegistration,
    );
  }

  @override
  Future<AuthSuccess> finishOtpLogin({required String otpLoginToken}) async {
    await _respond();
    if (rejectNextOtpLogin) {
      rejectNextOtpLogin = false;
      throw EmailAccountRequestException(
        reason: EmailAccountRequestExceptionReason.invalid,
      );
    }
    if (otpLoginToken != _mockData.otpToken || !_mockData.hasAccount) {
      throw EmailAccountRequestException(
        reason: EmailAccountRequestExceptionReason.invalid,
      );
    }
    _mockData.otpToken = null;
    return _mockData.authSuccess;
  }

  @override
  Future<AuthSuccess> finishOtpRegistration({
    required String otpLoginToken,
    String? password,
  }) async {
    await _respond();
    if (otpLoginToken != _mockData.otpToken || _mockData.hasAccount) {
      throw EmailAccountRequestException(
        reason: EmailAccountRequestExceptionReason.invalid,
      );
    }
    if (password != null && !allowPasswordOnOtpRegistration) {
      throw EmailAccountRequestException(
        reason: EmailAccountRequestExceptionReason.policyViolation,
      );
    }
    _mockData.password = password;
    _mockData.otpToken = null;
    _mockData.hasAccount = true;
    return _mockData.authSuccess;
  }

  @override
  Future<bool> hasAccount() async => _mockData.hasAccount;
}

class GoogleIdpEndpoint extends EndpointGoogleIdpBase {
  GoogleIdpEndpoint(super.caller);

  final _mockData = MockAuthData();

  @override
  String get name => 'googleIdp';

  @override
  Future<AuthSuccess> login({
    required String idToken,
    required String? accessToken,
  }) async {
    _mockData.hasAccount = true;
    return _mockData.authSuccess;
  }

  @override
  Future<AuthSuccess> loginWithCode({
    required String code,
    required String codeVerifier,
    required String redirectUri,
  }) async {
    _mockData.hasAccount = true;
    return _mockData.authSuccess;
  }

  @override
  Future<bool> hasAccount() async => _mockData.hasAccount;
}

class AppleIdpEndpoint extends EndpointAppleIdpBase {
  AppleIdpEndpoint(super.caller);

  final _mockData = MockAuthData();

  @override
  String get name => 'appleIdp';

  @override
  Future<AuthSuccess> login({
    required String identityToken,
    required String authorizationCode,
    required bool isNativeApplePlatformSignIn,
    String? firstName,
    String? lastName,
  }) async {
    _mockData.hasAccount = true;
    return _mockData.authSuccess;
  }

  @override
  Future<bool> hasAccount() async => _mockData.hasAccount;
}

class FacebookIdpEndpoint extends EndpointFacebookIdpBase {
  FacebookIdpEndpoint(super.caller);

  final _mockData = MockAuthData();

  @override
  String get name => 'facebookIdp';

  @override
  Future<AuthSuccess> login({
    required String accessToken,
  }) => Future.value(_mockData.authSuccess);

  @override
  Future<bool> hasAccount() async => _mockData.hasAccount;
}

class GitHubIdpEndpoint extends EndpointGitHubIdpBase {
  GitHubIdpEndpoint(super.caller);

  final _mockData = MockAuthData();

  @override
  String get name => 'githubIdp';

  @override
  Future<AuthSuccess> login({
    required String code,
    required String codeVerifier,
    required String redirectUri,
  }) => Future.value(_mockData.authSuccess);

  @override
  Future<bool> hasAccount() async => _mockData.hasAccount;
}

class MicrosoftIdpEndpoint extends EndpointMicrosoftIdpBase {
  MicrosoftIdpEndpoint(super.caller);

  final _mockData = MockAuthData();

  @override
  String get name => 'microsoftIdp';

  @override
  Future<AuthSuccess> login({
    required String code,
    required String codeVerifier,
    required String redirectUri,
    required bool isWebPlatform,
  }) => Future.value(_mockData.authSuccess);

  @override
  Future<bool> hasAccount() async => _mockData.hasAccount;
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
    anonymousIdp = AnonymousIdpEndpoint(this);
    authEmail = EndpointAuthEmail(this);
    googleIdp = GoogleIdpEndpoint(this);
    appleIdp = AppleIdpEndpoint(this);
    facebookIdp = FacebookIdpEndpoint(this);
    githubIdp = GitHubIdpEndpoint(this);
    microsoftIdp = MicrosoftIdpEndpoint(this);
    modules = Modules(this);
  }

  late final AnonymousIdpEndpoint anonymousIdp;

  late final EndpointAuthEmail authEmail;

  late final GoogleIdpEndpoint googleIdp;

  late final AppleIdpEndpoint appleIdp;

  late final FacebookIdpEndpoint facebookIdp;

  late final GitHubIdpEndpoint githubIdp;

  late final MicrosoftIdpEndpoint microsoftIdp;

  late final Modules modules;

  @override
  Map<String, EndpointRef> get endpointRefLookup => {
    'anonymousIdp': anonymousIdp,
    'emailAuth': authEmail,
    'googleIdp': googleIdp,
    'appleIdp': appleIdp,
    'facebookIdp': facebookIdp,
    'githubIdp': githubIdp,
    'microsoftIdp': microsoftIdp,
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
    throw const ServerpodClientNetworkException('This is a mock client.');
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
  String? otpCode;
  String? otpToken;
  bool hasAccount = false;

  UuidValue? registrationRequestId;
  UuidValue? passwordResetRequestId;
  UuidValue? otpLoginRequestId;

  AuthSuccess get authSuccess => AuthSuccess(
    authStrategy: AuthStrategy.session.name,
    token: 'session-key',
    authUserId: authUserId,
    scopeNames: {},
  );
}
