import 'dart:async';

import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as idp;
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

final fakeAuthSuccess = AuthSuccess(
  authStrategy: 'session',
  token: 'token',
  authUserId: UuidValue.fromString('00000000-0000-4000-8000-000000000001'),
  scopeNames: {},
);

class InMemoryAuthStorage implements ClientAuthSuccessStorage {
  AuthSuccess? _value;

  @override
  Future<AuthSuccess?> get() async => _value;

  @override
  Future<void> set(AuthSuccess? data) async => _value = data;
}

/// An email endpoint that records the passwordless login calls and can be told
/// to fail. The password methods are not implemented.
class FakeEmailEndpoint extends idp.EndpointEmailIdpBase {
  FakeEmailEndpoint(super.caller);

  final startedEmails = <String>[];
  final finishedRequests = <({UuidValue id, String code})>[];

  UuidValue nextRequestId = UuidValue.fromString(
    '00000000-0000-4000-8000-0000000000aa',
  );
  Object? startError;
  Object? finishError;

  /// When set, calls complete only once the completer does.
  Completer<void>? startGate;
  Completer<void>? finishGate;

  @override
  String get name => 'emailAccount';

  @override
  Future<UuidValue> startPasswordlessLogin({required String email}) async {
    startedEmails.add(email);
    await startGate?.future;
    final error = startError;
    if (error != null) throw error;
    return nextRequestId;
  }

  @override
  Future<AuthSuccess> finishPasswordlessLogin({
    required UuidValue loginRequestId,
    required String verificationCode,
  }) async {
    finishedRequests.add((id: loginRequestId, code: verificationCode));
    await finishGate?.future;
    final error = finishError;
    if (error != null) throw error;
    return fakeAuthSuccess;
  }

  @override
  Future<AuthSuccess> login({
    required String email,
    required String password,
  }) => throw UnimplementedError();

  @override
  Future<UuidValue> startRegistration({required String email}) =>
      throw UnimplementedError();

  @override
  Future<String> verifyRegistrationCode({
    required UuidValue accountRequestId,
    required String verificationCode,
  }) => throw UnimplementedError();

  @override
  Future<AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => throw UnimplementedError();

  @override
  Future<UuidValue> startPasswordReset({required String email}) =>
      throw UnimplementedError();

  @override
  Future<String> verifyPasswordResetCode({
    required UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => throw UnimplementedError();

  @override
  Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => throw UnimplementedError();

  @override
  Future<bool> hasAccount() async => false;
}

class EmailTestClient extends ServerpodClientShared {
  EmailTestClient({bool withEmail = true})
    : super(
        'http://localhost:8080/',
        _TestSerializationManager(),
        streamingConnectionTimeout: null,
        connectionTimeout: null,
      ) {
    _caller = Caller(this);
    authKeyProvider = FlutterAuthSessionManager(
      caller: _caller,
      storage: InMemoryAuthStorage(),
    );
    if (withEmail) email = FakeEmailEndpoint(_caller);
  }

  late final Caller _caller;
  FakeEmailEndpoint? email;

  @override
  Map<String, EndpointRef> get endpointRefLookup => {'emailAccount': ?email};

  @override
  Map<String, ModuleEndpointCaller> get moduleLookup => {};

  @override
  Future<T> callServerEndpoint<T>(
    String endpoint,
    String method,
    Map<String, dynamic> args, {
    bool authenticated = true,
  }) async {
    throw UnimplementedError('Not used by this test.');
  }

  @override
  dynamic callStreamingServerEndpoint<T, G>(
    String endpoint,
    String method,
    Map<String, dynamic> args,
    Map<String, Stream> streams, {
    bool authenticated = true,
  }) {
    throw UnimplementedError('Not used by this test.');
  }
}

class _TestSerializationManager extends SerializationManager {}
