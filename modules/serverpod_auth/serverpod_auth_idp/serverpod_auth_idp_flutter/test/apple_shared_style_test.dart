import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'test_utils.dart';

void main() {
  // Resolves the rendered native Apple button.
  SignInWithAppleButton appleButtonOf(WidgetTester tester) {
    return tester.widget<SignInWithAppleButton>(
      find.byType(SignInWithAppleButton),
    );
  }

  testWidgets(
    'Given an AppleSignInButton with no shared style and no arguments when built then it uses Apple built-in defaults',
    (tester) async {
      await tester.pumpWidget(
        const SignInButtonHost(
          child: AppleSignInButton(
            onPressed: null,
            isLoading: false,
            isDisabled: false,
          ),
        ),
      );

      expect(appleButtonOf(tester).text, 'Continue with Apple');
    },
  );

  group('Given a shared SignInButtonStyle in scope', () {
    testWidgets(
      'when built then the shared text variant is used',
      (tester) async {
        await tester.pumpWidget(
          const SignInButtonHost(
            style: SignInButtonStyle(text: SignInButtonTextVariant.signUpWith),
            child: AppleSignInButton(
              onPressed: null,
              isLoading: false,
              isDisabled: false,
            ),
          ),
        );

        expect(appleButtonOf(tester).text, 'Sign up with Apple');
      },
    );

    testWidgets(
      'when both the button and the shared style set the text then the shared style wins',
      (tester) async {
        await tester.pumpWidget(
          const SignInButtonHost(
            style: SignInButtonStyle(text: SignInButtonTextVariant.signUpWith),
            child: AppleSignInButton(
              onPressed: null,
              isLoading: false,
              isDisabled: false,
              type: AppleButtonText.continueWith,
            ),
          ),
        );

        expect(appleButtonOf(tester).text, 'Sign up with Apple');
      },
    );

    testWidgets(
      'when the shared style sets a rectangular shape then the button border radius follows it',
      (tester) async {
        await tester.pumpWidget(
          const SignInButtonHost(
            style: SignInButtonStyle(shape: SignInButtonShape.rectangular),
            child: AppleSignInButton(
              onPressed: null,
              isLoading: false,
              isDisabled: false,
              size: AppleButtonSize.large,
            ),
          ),
        );

        // Rectangular resolves to a 4px radius (vs the pill default).
        expect(
          appleButtonOf(tester).borderRadius,
          BorderRadius.circular(4),
        );
      },
    );

    testWidgets(
      'when the shared style sets a rounded shape then the button uses the shared 8px radius',
      (tester) async {
        await tester.pumpWidget(
          const SignInButtonHost(
            style: SignInButtonStyle(shape: SignInButtonShape.rounded),
            child: AppleSignInButton(
              onPressed: null,
              isLoading: false,
              isDisabled: false,
              size: AppleButtonSize.large,
            ),
          ),
        );

        expect(
          appleButtonOf(tester).borderRadius,
          BorderRadius.circular(8),
        );
      },
    );
  });
}
