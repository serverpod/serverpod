import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as idp;
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_auth_idp_flutter/widgets.dart';

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
      expect(surface.color, Colors.transparent);
      expect(surface.borderRadius, isNull);
      expect(surface.shape, isNull);
      expect(surface.clipBehavior, Clip.none);
    },
  );

  testWidgets(
    'Given a SignInWidget configured with a shared button style, '
    'when building the available sign-in options, '
    'then the style is exposed to the buttons through a provider.',
    (tester) async {
      const style = SignInButtonStyle(shape: SignInButtonShape.pill);

      await tester.pumpWidget(
        MaterialApp(
          home: SignInWidget(client: _TestClient(), buttonStyle: style),
        ),
      );

      final provider = tester.widget<SignInButtonStyleProvider>(
        find.byType(SignInButtonStyleProvider),
      );
      expect(provider.style, style);
    },
  );

  testWidgets(
    'Given a SignInWidget configured without a shared button style, '
    'when building the available sign-in options, '
    'then a default style provider is inserted so buttons share the common style.',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: SignInWidget(client: _TestClient())),
      );

      final provider = tester.widget<SignInButtonStyleProvider>(
        find.byType(SignInButtonStyleProvider),
      );
      expect(provider.style, const SignInButtonStyle());
    },
  );

  testWidgets(
    'Given a SignInWidget in linking mode, '
    'when building the available sign-in options, '
    'then anonymous sign-in is hidden because it carries no credential to link.',
    (tester) async {
      final client = _TestClient();

      await tester.pumpWidget(
        MaterialApp(
          home: SignInWidget(
            client: client,
            accountLinking: AccountLinkingController(client: client),
          ),
        ),
      );

      expect(find.byType(AnonymousSignInWidget), findsNothing);
    },
  );

  testWidgets(
    'Given a SignInWidget without linking mode, '
    'when building the available sign-in options, '
    'then anonymous sign-in is shown.',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: SignInWidget(client: _TestClient())),
      );

      expect(find.byType(AnonymousSignInWidget), findsOneWidget);
    },
  );

  testWidgets(
    'Given a SignInWidget in linking mode with Email IdP, '
    'when building the available sign-in options, '
    'then EmailSignInWidget receives accountLinking.',
    (tester) async {
      final client = _TestClient(withEmail: true);
      final controller = AccountLinkingController(client: client);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SignInWidget(
              client: client,
              accountLinking: controller,
            ),
          ),
        ),
      );

      final emailWidget = tester.widget<EmailSignInWidget>(
        find.byType(EmailSignInWidget),
      );
      expect(emailWidget.accountLinking, same(controller));
    },
  );

  testWidgets(
    'Given a SignInWidget in linking mode, '
    'when mounting, '
    'then account linking is not started.',
    (tester) async {
      final client = _TestClient(withEmail: true);
      final controller = AccountLinkingController(client: client);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SignInWidget(
              client: client,
              accountLinking: controller,
            ),
          ),
        ),
      );

      expect(controller.state, AccountLinkingState.idle);
    },
  );

  testWidgets(
    'Given a SignInWidget in linking mode, '
    'when account linking is busy, '
    'then interactions are absorbed and opacity is lowered.',
    (tester) async {
      final client = _TestClient();
      final controller = AccountLinkingController(client: client);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SignInWidget(
              client: client,
              accountLinking: controller,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final absorbFinder = find.ancestor(
        of: find.byType(SignInWidgetsColumn),
        matching: find.byType(AbsorbPointer),
      );
      expect(absorbFinder, findsOneWidget);
      expect(tester.widget<AbsorbPointer>(absorbFinder).absorbing, isFalse);
    },
  );
}

class _TestClient extends ServerpodClientShared {
  _TestClient({this.withEmail = false})
    : super(
        'http://localhost:8080/',
        _TestSerializationManager(),
        streamingConnectionTimeout: null,
        connectionTimeout: null,
      ) {
    _caller = Caller(this);
    _anonymousIdp = _TestAnonymousIdp(_caller);
    if (withEmail) {
      _emailIdp = _TestEmailIdp(_caller);
    }
    authKeyProvider = FlutterAuthSessionManager(caller: _caller);
  }

  final bool withEmail;
  late final Caller _caller;
  late final idp.EndpointAnonymousIdpBase _anonymousIdp;
  late final idp.EndpointEmailIdpBase _emailIdp;

  @override
  Map<String, EndpointRef> get endpointRefLookup => {
    'anonymous': _anonymousIdp,
    if (withEmail) 'email': _emailIdp,
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
    if (endpoint == 'serverpod_auth_core.accountLinking') {
      return null as T;
    }
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

class _TestEmailIdp extends idp.EndpointEmailIdpBase {
  _TestEmailIdp(super.caller);

  @override
  String get name => 'email';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _TestSerializationManager extends SerializationManager {}
