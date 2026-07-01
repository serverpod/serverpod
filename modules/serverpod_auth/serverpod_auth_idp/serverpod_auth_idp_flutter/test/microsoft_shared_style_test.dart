import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'test_utils.dart';

void main() {
  // Resolves the label Text widget rendered inside the Microsoft button.
  Text labelOf(WidgetTester tester) {
    return tester.widget<Text>(
      find.descendant(
        of: find.byType(MicrosoftSignInButton),
        matching: find.byType(Text),
      ),
    );
  }

  // These tests cover text/style precedence, not layout. They render at medium
  // size because the long "Continue with Microsoft" label overflows the button
  // by ~2px at large size under the test font.
  testWidgets(
    'Given a MicrosoftSignInButton with no shared style and no arguments, '
    'when building the button, '
    'then it uses Microsoft built-in defaults.',
    (tester) async {
      await tester.pumpWidget(
        const SignInButtonHost(
          child: MicrosoftSignInButton(
            onPressed: null,
            isLoading: false,
            isDisabled: false,
            size: MicrosoftButtonSize.medium,
          ),
        ),
      );

      expect(find.text('Continue with Microsoft'), findsOneWidget);
    },
  );

  group(
    'Given a shared SignInButtonStyle with the signUpWith text variant in scope,',
    () {
      const style = SignInButtonStyle(text: SignInButtonTextVariant.signUpWith);

      testWidgets(
        'when building the button, '
        'then the button uses it.',
        (tester) async {
          await tester.pumpWidget(
            const SignInButtonHost(
              style: style,
              child: MicrosoftSignInButton(
                onPressed: null,
                isLoading: false,
                isDisabled: false,
                size: MicrosoftButtonSize.medium,
              ),
            ),
          );

          expect(find.text('Sign up with Microsoft'), findsOneWidget);
        },
      );

      testWidgets(
        'when building the button with its own text, '
        'then the shared style still wins.',
        (tester) async {
          await tester.pumpWidget(
            const SignInButtonHost(
              style: style,
              child: MicrosoftSignInButton(
                onPressed: null,
                isLoading: false,
                isDisabled: false,
                size: MicrosoftButtonSize.medium,
                text: MicrosoftButtonText.continueWith,
              ),
            ),
          );

          expect(find.text('Sign up with Microsoft'), findsOneWidget);
          expect(find.text('Continue with Microsoft'), findsNothing);
        },
      );
    },
  );

  testWidgets(
    'Given a shared SignInButtonStyle with a custom textStyle in scope, '
    'when building the button, '
    'then the label adopts its font weight.',
    (tester) async {
      await tester.pumpWidget(
        const SignInButtonHost(
          style: SignInButtonStyle(
            textStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
          child: MicrosoftSignInButton(
            onPressed: null,
            isLoading: false,
            isDisabled: false,
            size: MicrosoftButtonSize.medium,
          ),
        ),
      );

      expect(labelOf(tester).style?.fontWeight, FontWeight.bold);
    },
  );
}
