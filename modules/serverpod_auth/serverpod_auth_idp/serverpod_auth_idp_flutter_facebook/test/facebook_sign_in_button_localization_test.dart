import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'package:serverpod_auth_idp_flutter_facebook/serverpod_auth_idp_flutter_facebook.dart';

void main() {
  testWidgets(
    'Given default SignInLocalizationProvider with no override, '
    'when building the FacebookSignInButton with sign-up variant, '
    'then the enum-based English fallback is used.',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SignInLocalizationProvider(
              child: FacebookSignInButton(
                onPressed: null,
                isLoading: false,
                isDisabled: false,
                type: FacebookButtonText.signupWith,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Sign up with Facebook'), findsOneWidget);
    },
  );

  testWidgets(
    'Given SignInLocalizationProvider with Facebook sign-in button label override, '
    'when building the FacebookSignInButton with continue-with variant, '
    'then the override label is shown instead of the enum fallback.',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SignInLocalizationProvider(
              facebook: FacebookSignInTexts(
                signInButton: 'Use Facebook account',
              ),
              child: FacebookSignInButton(
                onPressed: null,
                isLoading: false,
                isDisabled: false,
                type: FacebookButtonText.continueWith,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Use Facebook account'), findsOneWidget);
      expect(find.text('Continue with Facebook'), findsNothing);
    },
  );
}
