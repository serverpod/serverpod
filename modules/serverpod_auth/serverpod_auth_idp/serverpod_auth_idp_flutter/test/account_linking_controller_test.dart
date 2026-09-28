import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

void main() {
  group('AccountLinkingController', () {
    late _FakeAccountLinkingClient client;

    setUp(() {
      client = _FakeAccountLinkingClient();
    });

    test('starts in idle state', () {
      final controller = AccountLinkingController(client: client);
      expect(controller.state, AccountLinkingState.idle);
      expect(controller.isBusy, isFalse);
    });

    test(
      'start transitions to busy then awaitingSignIn and calls server',
      () async {
        final controller = AccountLinkingController(client: client);
        final states = <AccountLinkingState>[];
        controller.addListener(() => states.add(controller.state));

        await controller.start();

        expect(client.createLinkRequestCalls, 1);
        expect(controller.state, AccountLinkingState.awaitingSignIn);
        expect(controller.isBusy, isFalse);
        expect(states, [
          AccountLinkingState.busy,
          AccountLinkingState.awaitingSignIn,
        ]);
      },
    );

    test('start is idempotent when already awaiting sign in', () async {
      final controller = AccountLinkingController(client: client);
      await controller.start();
      expect(client.createLinkRequestCalls, 1);

      await controller.start();
      expect(client.createLinkRequestCalls, 1);
      expect(controller.state, AccountLinkingState.awaitingSignIn);
    });

    test('start is idempotent when already busy', () async {
      client.createLinkRequestCompleter = Completer<void>();
      final controller = AccountLinkingController(client: client);

      final firstStart = controller.start();
      expect(controller.state, AccountLinkingState.busy);

      final secondStart = controller.start();
      expect(client.createLinkRequestCalls, 1);

      client.createLinkRequestCompleter!.complete();
      await firstStart;
      await secondStart;

      expect(client.createLinkRequestCalls, 1);
      expect(controller.state, AccountLinkingState.awaitingSignIn);
    });

    test('start resets to idle and reports error on server failure', () async {
      client.createLinkRequestError = Exception('Network error');
      Object? capturedError;
      final controller = AccountLinkingController(
        client: client,
        onError: (err) => capturedError = err,
      );

      await controller.start();

      expect(controller.state, AccountLinkingState.idle);
      expect(capturedError, client.createLinkRequestError);
    });

    test('handleAuthSuccess directly links when status is linked', () async {
      var linkedCalled = false;
      final controller = AccountLinkingController(
        client: client,
        onLinked: () => linkedCalled = true,
      );
      await controller.start();

      final authSuccess = _createAuthSuccess('token-123');
      client.nextExecuteResult = AccountLinkResult(
        status: AccountLinkStatus.linked,
      );

      await controller.handleAuthSuccess(authSuccess);

      expect(client.executeLinkRequestCalls.length, 1);
      expect(client.executeLinkRequestCalls.first.proofToken, 'token-123');
      expect(client.executeLinkRequestCalls.first.approveMerge, isFalse);
      expect(controller.state, AccountLinkingState.linked);
      expect(linkedCalled, isTrue);
    });

    test(
      'handleAuthSuccess prompts merge and completes when confirmed',
      () async {
        AccountLinkConflict? capturedConflict;
        var linkedCalled = false;
        var cancelledCalled = false;

        final conflict = AccountLinkConflict(
          authUserId: UuidValue.fromString(
            '00000000-0000-0000-0000-000000000001',
          ),
          createdAt: DateTime.now(),
          method: 'google',
        );

        client.executeLinkRequestResponses = [
          AccountLinkResult(
            status: AccountLinkStatus.mergeRequired,
            conflict: conflict,
          ),
          AccountLinkResult(
            status: AccountLinkStatus.merged,
            conflict: conflict,
          ),
        ];

        final controller = AccountLinkingController(
          client: client,
          confirmMerge: (c) async {
            capturedConflict = c;
            return true;
          },
          onLinked: () => linkedCalled = true,
          onCancelled: () => cancelledCalled = true,
        );
        await controller.start();

        final authSuccess = _createAuthSuccess('token-merge');
        await controller.handleAuthSuccess(authSuccess);

        expect(capturedConflict, conflict);
        expect(client.executeLinkRequestCalls.length, 2);
        expect(client.executeLinkRequestCalls[0].approveMerge, isFalse);
        expect(client.executeLinkRequestCalls[1].approveMerge, isTrue);
        expect(controller.state, AccountLinkingState.linked);
        expect(linkedCalled, isTrue);
        expect(cancelledCalled, isFalse);
      },
    );

    test(
      'handleAuthSuccess cancels and calls onCancelled when merge declined',
      () async {
        var linkedCalled = false;
        var cancelledCalled = false;

        final conflict = AccountLinkConflict(
          authUserId: UuidValue.fromString(
            '00000000-0000-0000-0000-000000000001',
          ),
          createdAt: DateTime.now(),
          method: 'apple',
        );

        client.executeLinkRequestResponses = [
          AccountLinkResult(
            status: AccountLinkStatus.mergeRequired,
            conflict: conflict,
          ),
        ];

        final controller = AccountLinkingController(
          client: client,
          confirmMerge: (c) async => false,
          onLinked: () => linkedCalled = true,
          onCancelled: () => cancelledCalled = true,
        );
        await controller.start();

        final authSuccess = _createAuthSuccess('token-declined');
        await controller.handleAuthSuccess(authSuccess);

        expect(client.executeLinkRequestCalls.length, 1);
        expect(client.cancelLinkRequestCalls, 1);
        expect(controller.state, AccountLinkingState.idle);
        expect(linkedCalled, isFalse);
        expect(cancelledCalled, isTrue);
      },
    );

    test(
      'handleAuthSuccess reports error and calls onCancelled when confirmMerge is null',
      () async {
        Object? capturedError;
        var linkedCalled = false;
        var cancelledCalled = false;

        final conflict = AccountLinkConflict(
          authUserId: UuidValue.fromString(
            '00000000-0000-0000-0000-000000000001',
          ),
          createdAt: DateTime.now(),
          method: 'github',
        );

        client.executeLinkRequestResponses = [
          AccountLinkResult(
            status: AccountLinkStatus.mergeRequired,
            conflict: conflict,
          ),
        ];

        final controller = AccountLinkingController(
          client: client,
          confirmMerge: null,
          onLinked: () => linkedCalled = true,
          onCancelled: () => cancelledCalled = true,
          onError: (err) => capturedError = err,
        );
        await controller.start();

        final authSuccess = _createAuthSuccess('token-no-confirm');
        await controller.handleAuthSuccess(authSuccess);

        expect(capturedError, isA<AccountMergeNotConfiguredException>());
        expect(client.cancelLinkRequestCalls, 1);
        expect(controller.state, AccountLinkingState.idle);
        expect(linkedCalled, isFalse);
        expect(cancelledCalled, isTrue);
      },
    );

    test('cancel calls server and resets state to idle', () async {
      final controller = AccountLinkingController(client: client);
      await controller.start();
      expect(controller.state, AccountLinkingState.awaitingSignIn);

      await controller.cancel();

      expect(client.cancelLinkRequestCalls, 1);
      expect(controller.state, AccountLinkingState.idle);
    });

    test('cancel does nothing if state is idle or linked', () async {
      final controller = AccountLinkingController(client: client);
      await controller.cancel();
      expect(client.cancelLinkRequestCalls, 0);

      client.nextExecuteResult = AccountLinkResult(
        status: AccountLinkStatus.linked,
      );
      await controller.start();
      await controller.handleAuthSuccess(_createAuthSuccess('tok'));
      expect(controller.state, AccountLinkingState.linked);

      await controller.cancel();
      expect(client.cancelLinkRequestCalls, 0);
    });

    test('dispose cancels link request if awaiting sign in', () async {
      final controller = AccountLinkingController(client: client);
      await controller.start();

      controller.dispose();

      expect(client.cancelLinkRequestCalls, 1);
    });

    test(
      'dispose cancels link request if start finishes after disposal',
      () async {
        client.createLinkRequestCompleter = Completer<void>();
        final controller = AccountLinkingController(client: client);

        final startFuture = controller.start();
        controller.dispose();

        client.createLinkRequestCompleter!.complete();
        await startFuture;

        expect(client.cancelLinkRequestCalls, 1);
        expect(controller.state, AccountLinkingState.busy);
      },
    );
  });
}

AuthSuccess _createAuthSuccess(String token) {
  return AuthSuccess(
    authStrategy: 'bearer',
    token: token,
    authUserId: UuidValue.fromString('00000000-0000-0000-0000-000000000002'),
    scopeNames: {},
  );
}

class _FakeAccountLinkingClient extends ServerpodClientShared {
  _FakeAccountLinkingClient()
    : super(
        'http://localhost:8080/',
        _TestSerializationManager(),
        streamingConnectionTimeout: null,
        connectionTimeout: null,
      ) {
    _caller = Caller(this);
    authKeyProvider = FlutterAuthSessionManager(caller: _caller);
  }

  late final Caller _caller;

  int createLinkRequestCalls = 0;
  int cancelLinkRequestCalls = 0;
  List<({String proofToken, bool approveMerge})> executeLinkRequestCalls = [];

  Completer<void>? createLinkRequestCompleter;
  List<AccountLinkResult> executeLinkRequestResponses = [];
  AccountLinkResult? nextExecuteResult;
  Object? createLinkRequestError;
  Object? executeLinkRequestError;

  @override
  Map<String, EndpointRef> get endpointRefLookup => {};

  @override
  Map<String, ModuleEndpointCaller> get moduleLookup => {};

  @override
  Future<T> callServerEndpoint<T>(
    String endpoint,
    String method,
    Map<String, dynamic> args, {
    bool authenticated = true,
  }) async {
    if (endpoint == 'serverpod_auth_core.accountLinking') {
      if (method == 'createLinkRequest') {
        createLinkRequestCalls++;
        if (createLinkRequestError != null) throw createLinkRequestError!;
        if (createLinkRequestCompleter != null) {
          await createLinkRequestCompleter!.future;
        }
        return null as T;
      }
      if (method == 'cancelLinkRequest') {
        cancelLinkRequestCalls++;
        return null as T;
      }
      if (method == 'executeLinkRequest') {
        final proofToken = args['proofToken'] as String;
        final approveMerge = args['approveMerge'] as bool;
        executeLinkRequestCalls.add((
          proofToken: proofToken,
          approveMerge: approveMerge,
        ));
        if (executeLinkRequestError != null) throw executeLinkRequestError!;
        if (executeLinkRequestResponses.isNotEmpty) {
          return executeLinkRequestResponses.removeAt(0) as T;
        }
        return (nextExecuteResult ??
                AccountLinkResult(status: AccountLinkStatus.linked))
            as T;
      }
    }
    throw UnimplementedError('Unexpected endpoint call: $endpoint.$method');
  }

  @override
  dynamic callStreamingServerEndpoint<T, G>(
    String endpoint,
    String method,
    Map<String, dynamic> args,
    Map<String, Stream> streams, {
    bool authenticated = true,
  }) {
    throw UnimplementedError();
  }
}

class _TestSerializationManager extends SerializationManager {}
