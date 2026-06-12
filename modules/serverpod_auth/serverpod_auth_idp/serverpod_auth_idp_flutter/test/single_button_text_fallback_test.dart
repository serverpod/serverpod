import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

void main() {
  group('Apple sign-in button localization', () {
    testWidgets(
      'Given default SignInLocalizationProvider with no override, '
      'when building the AppleSignInButton with signup variant, '
      'then the enum-based English fallback is used.',
      (tester) async {
        await tester.pumpWidget(
          const MaterialAppWithAppBundle(
            child: SignInLocalizationProvider(
              child: AppleSignInButton(
                onPressed: null,
                isLoading: false,
                isDisabled: false,
                type: AppleButtonText.signupWith,
              ),
            ),
          ),
        );

        final button = tester.widget<SignInWithAppleButton>(
          find.byType(SignInWithAppleButton),
        );
        expect(button.text, 'Sign up with Apple');
      },
    );

    testWidgets(
      'Given SignInLocalizationProvider with Apple sign-in button label override, '
      'when building the AppleSignInButton with sign-in variant, '
      'then the override label is shown instead of the enum fallback.',
      (tester) async {
        await tester.pumpWidget(
          const MaterialAppWithAppBundle(
            child: SignInLocalizationProvider(
              apple: AppleSignInTexts(signInButton: 'Use Apple account'),
              child: AppleSignInButton(
                onPressed: null,
                isLoading: false,
                isDisabled: false,
                type: AppleButtonText.signinWith,
              ),
            ),
          ),
        );

        final button = tester.widget<SignInWithAppleButton>(
          find.byType(SignInWithAppleButton),
        );
        expect(button.text, 'Use Apple account');
      },
    );
  });

  group('Google sign-in button localization', () {
    testWidgets(
      'Given default SignInLocalizationProvider with no override, '
      'when building the GoogleSignInNativeButton with sign-in variant while loading, '
      'then the enum-based English fallback is used.',
      (tester) async {
        await tester.pumpWidget(
          const MaterialAppWithAppBundle(
            child: SignInLocalizationProvider(
              child: GoogleSignInNativeButton(
                onPressed: null,
                isLoading: true,
                isDisabled: false,
                text: GSIButtonText.signinWith,
              ),
            ),
          ),
        );

        expect(find.text('Sign in with Google'), findsOneWidget);
      },
    );

    testWidgets(
      'Given SignInLocalizationProvider with Google sign-in button label override, '
      'when building the GoogleSignInNativeButton with sign-up variant while loading, '
      'then the override label is shown instead of the enum fallback.',
      (tester) async {
        await tester.pumpWidget(
          const MaterialAppWithAppBundle(
            child: SignInLocalizationProvider(
              google: GoogleSignInTexts(signInButton: 'Use Google account'),
              child: GoogleSignInNativeButton(
                onPressed: null,
                isLoading: true,
                isDisabled: false,
                text: GSIButtonText.signupWith,
              ),
            ),
          ),
        );

        expect(find.text('Use Google account'), findsOneWidget);
        expect(find.text('Sign up with Google'), findsNothing);
      },
    );
  });

  group('GitHub sign-in button localization', () {
    testWidgets(
      'Given default SignInLocalizationProvider with no override, '
      'when building the GitHubSignInButton with sign-up variant, '
      'then the enum-based English fallback is used.',
      (tester) async {
        await tester.pumpWidget(
          const MaterialAppWithAppBundle(
            child: SignInLocalizationProvider(
              child: GitHubSignInButton(
                onPressed: null,
                isLoading: false,
                isDisabled: false,
                text: GitHubButtonText.signUp,
              ),
            ),
          ),
        );

        await tester.pump();
        expect(find.text('Sign up with GitHub'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Given SignInLocalizationProvider with GitHub sign-in button label override, '
      'when building the GitHubSignInButton with continue-with variant, '
      'then the override label is shown instead of the enum fallback.',
      (tester) async {
        await tester.pumpWidget(
          const MaterialAppWithAppBundle(
            child: SignInLocalizationProvider(
              github: GitHubSignInTexts(signInButton: 'Use GitHub account'),
              child: GitHubSignInButton(
                onPressed: null,
                isLoading: false,
                isDisabled: false,
                text: GitHubButtonText.continueWith,
              ),
            ),
          ),
        );

        await tester.pump();
        expect(find.text('Use GitHub account'), findsOneWidget);
        expect(find.text('Continue with GitHub'), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  });

  group('Microsoft sign-in button localization', () {
    testWidgets(
      'Given default SignInLocalizationProvider with no override, '
      'when building the MicrosoftSignInButton with sign-up variant, '
      'then the enum-based English fallback is used.',
      (tester) async {
        await tester.pumpWidget(
          const MaterialAppWithAppBundle(
            child: SignInLocalizationProvider(
              child: MicrosoftSignInButton(
                onPressed: null,
                isLoading: false,
                isDisabled: false,
                text: MicrosoftButtonText.signUp,
              ),
            ),
          ),
        );

        await tester.pump();
        expect(find.text('Sign up with Microsoft'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Given SignInLocalizationProvider with Microsoft sign-in button label override, '
      'when building the MicrosoftSignInButton with continue-with variant, '
      'then the override label is shown instead of the enum fallback.',
      (tester) async {
        await tester.pumpWidget(
          const MaterialAppWithAppBundle(
            child: SignInLocalizationProvider(
              microsoft: MicrosoftSignInTexts(
                signInButton: 'Use Microsoft account',
              ),
              child: MicrosoftSignInButton(
                onPressed: null,
                isLoading: false,
                isDisabled: false,
                text: MicrosoftButtonText.continueWith,
              ),
            ),
          ),
        );

        await tester.pump();
        expect(find.text('Use Microsoft account'), findsOneWidget);
        expect(find.text('Continue with Microsoft'), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  });

  group('Anonymous sign-in button localization', () {
    testWidgets(
      'Given default SignInLocalizationProvider with no override and a test AnonymousAuthController, '
      'when building the AnonymousSignInWidget, '
      'then the built-in English default button label is used.',
      (tester) async {
        final controller = AnonymousAuthController(client: _TestClient());
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SignInLocalizationProvider(
                child: AnonymousSignInWidget(controller: controller),
              ),
            ),
          ),
        );

        expect(find.text('Continue without account'), findsOneWidget);
      },
    );

    testWidgets(
      'Given SignInLocalizationProvider with anonymous sign-in button label override and a test AnonymousAuthController, '
      'when building the AnonymousSignInWidget, '
      'then the override label is shown instead of the default.',
      (tester) async {
        final controller = AnonymousAuthController(client: _TestClient());
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SignInLocalizationProvider(
                anonymous: const AnonymousSignInTexts(
                  signInButton: 'Continue as guest',
                ),
                child: AnonymousSignInWidget(controller: controller),
              ),
            ),
          ),
        );

        expect(find.text('Continue as guest'), findsOneWidget);
        expect(find.text('Continue without account'), findsNothing);
      },
    );
  });
}

/// [MaterialApp] wrapped with [DefaultAssetBundle] so SVG assets resolve in tests.
class MaterialAppWithAppBundle extends StatelessWidget {
  const MaterialAppWithAppBundle({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DefaultAssetBundle(
      bundle: _SvgAssetBundle(),
      child: MaterialApp(
        home: Scaffold(
          body: child,
        ),
      ),
    );
  }
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
