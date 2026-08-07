import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

void main() {
  testWidgets(
    'Given an EmailSignInWidget with a custom theme canvas color, '
    'when the registration screen is shown, '
    'then the shared axis transition uses a transparent fill color.',
    (tester) async {
      final controller = EmailAuthController(client: _TestClient());

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(canvasColor: Colors.red),
          home: Scaffold(
            body: SignInLocalizationProvider(
              child: EmailSignInWidget(
                controller: controller,
              ),
            ),
          ),
        ),
      );

      final transition = tester.widget<SharedAxisTransition>(
        find.byType(SharedAxisTransition),
      );

      expect(transition.fillColor, Colors.transparent);
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
      );

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
