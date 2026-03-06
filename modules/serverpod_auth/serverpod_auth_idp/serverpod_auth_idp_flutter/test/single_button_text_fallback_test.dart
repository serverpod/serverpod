import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

void main() {
  group('Apple sign-in button localization', () {
    testWidgets('falls back to enum-based text when override is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrapInApp(
          child: const AppleSignInButton(
            onPressed: null,
            isLoading: false,
            isDisabled: false,
            type: AppleButtonText.signupWith,
          ),
        ),
      );

      final button = tester.widget<SignInWithAppleButton>(
        find.byType(SignInWithAppleButton),
      );
      expect(button.text, 'Sign up with Apple');
    });

    testWidgets('uses provider override when set', (tester) async {
      await tester.pumpWidget(
        _wrapInApp(
          apple: const AppleSignInTexts(signInButton: 'Use Apple account'),
          child: const AppleSignInButton(
            onPressed: null,
            isLoading: false,
            isDisabled: false,
            type: AppleButtonText.signinWith,
          ),
        ),
      );

      final button = tester.widget<SignInWithAppleButton>(
        find.byType(SignInWithAppleButton),
      );
      expect(button.text, 'Use Apple account');
    });
  });

  group('Google sign-in button localization', () {
    testWidgets('falls back to enum-based text when override is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrapInApp(
          child: const GoogleSignInNativeButton(
            onPressed: null,
            isLoading: true,
            isDisabled: false,
            text: GSIButtonText.signinWith,
          ),
        ),
      );

      expect(find.text('Sign in with Google'), findsOneWidget);
    });

    testWidgets('uses provider override when set', (tester) async {
      await tester.pumpWidget(
        _wrapInApp(
          google: const GoogleSignInTexts(signInButton: 'Use Google account'),
          child: const GoogleSignInNativeButton(
            onPressed: null,
            isLoading: true,
            isDisabled: false,
            text: GSIButtonText.signupWith,
          ),
        ),
      );

      expect(find.text('Use Google account'), findsOneWidget);
    });
  });

  group('GitHub sign-in button localization', () {
    testWidgets('falls back to enum-based text when override is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrapInApp(
          child: const GitHubSignInButton(
            onPressed: null,
            isLoading: false,
            isDisabled: false,
            text: GitHubButtonText.signUp,
          ),
        ),
      );

      await tester.pump();
      expect(find.text('Sign up with GitHub'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('uses provider override when set', (tester) async {
      await tester.pumpWidget(
        _wrapInApp(
          github: const GitHubSignInTexts(signInButton: 'Use GitHub account'),
          child: const GitHubSignInButton(
            onPressed: null,
            isLoading: false,
            isDisabled: false,
            text: GitHubButtonText.continueWith,
          ),
        ),
      );

      await tester.pump();
      expect(find.text('Use GitHub account'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('Anonymous sign-in button localization', () {
    testWidgets('falls back to default text when override is null', (
      tester,
    ) async {
      final controller = AnonymousAuthController(client: _TestClient());
      await tester.pumpWidget(
        _wrapInApp(
          child: AnonymousSignInWidget(controller: controller),
        ),
      );

      expect(find.text('Continue without account'), findsOneWidget);
    });

    testWidgets('uses provider override when set', (tester) async {
      final controller = AnonymousAuthController(client: _TestClient());
      await tester.pumpWidget(
        _wrapInApp(
          anonymous: const AnonymousSignInTexts(
            signInButton: 'Continue as guest',
          ),
          child: AnonymousSignInWidget(controller: controller),
        ),
      );

      expect(find.text('Continue as guest'), findsOneWidget);
    });
  });
}

Widget _wrapInApp({
  required Widget child,
  AppleSignInTexts? apple,
  GoogleSignInTexts? google,
  GitHubSignInTexts? github,
  AnonymousSignInTexts? anonymous,
}) {
  return DefaultAssetBundle(
    bundle: _SvgAssetBundle(),
    child: MaterialApp(
      home: Scaffold(
        body: SignInLocalizationProvider(
          apple: apple ?? AppleSignInTexts.defaults,
          google: google ?? GoogleSignInTexts.defaults,
          github: github ?? GitHubSignInTexts.defaults,
          anonymous: anonymous ?? AnonymousSignInTexts.defaults,
          child: child,
        ),
      ),
    ),
  );
}

class _SvgAssetBundle extends CachingAssetBundle {
  static const _svgContent =
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">'
      '<rect width="24" height="24" fill="#000000"/>'
      '</svg>';

  @override
  Future<ByteData> load(String key) async {
    final bytes = Uint8List.fromList(utf8.encode(_svgContent));
    return ByteData.view(bytes.buffer);
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    return _svgContent;
  }
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
