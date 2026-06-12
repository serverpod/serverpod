import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as idp;
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

void main() {
  testWidgets(
    'Given a SignInWidget without an external Material ancestor, '
    'when building the available sign-in options, '
    'then the full component renders on its own default Material surface.',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ColoredBox(
            color: Colors.red,
            child: SignInWidget(client: _TestClient()),
          ),
        ),
      );

      expect(tester.takeException(), isNull);

      final surfaceFinder = find.ancestor(
        of: find.byType(AnonymousSignInWidget),
        matching: find.byType(Material),
      );
      final surface = tester.widget<Material>(surfaceFinder.first);

      expect(surface.type, MaterialType.transparency);
      expect(surface.borderRadius, isNull);
      expect(surface.shape, isNull);
      expect(surface.clipBehavior, Clip.none);
    },
  );
}

class _TestClient extends ServerpodClientShared {
  _TestClient()
    : super(
        'http://localhost:8080/',
        _TestSerializationManager(),
        streamingConnectionTimeout: null,
        connectionTimeout: null,
      ) {
    _caller = Caller(this);
    _anonymousIdp = _TestAnonymousIdp(_caller);
    authKeyProvider = FlutterAuthSessionManager(caller: _caller);
  }

  late final Caller _caller;
  late final idp.EndpointAnonymousIdpBase _anonymousIdp;

  @override
  Map<String, EndpointRef> get endpointRefLookup => {
    'anonymous': _anonymousIdp,
  };

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

class _TestAnonymousIdp extends idp.EndpointAnonymousIdpBase {
  _TestAnonymousIdp(super.caller);

  @override
  String get name => 'anonymous';

  @override
  Future<AuthSuccess> login({String? token}) async {
    throw UnimplementedError('Not used by this test.');
  }
}

class _TestSerializationManager extends SerializationManager {}
