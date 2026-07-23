import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'test_utils.dart';

void main() {
  // Resolves the button's corner radius from its rendered shape.
  BorderRadius? borderRadiusOf(WidgetTester tester) {
    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    final shape = button.style?.shape?.resolve({}) as RoundedRectangleBorder?;
    return shape?.borderRadius as BorderRadius?;
  }

  testWidgets(
    'Given an AppleSignInButton with no shared style and no arguments, '
    'when building the button, '
    'then it uses Apple built-in defaults.',
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

      expect(find.text('Continue with Apple'), findsOneWidget);
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
              child: AppleSignInButton(
                onPressed: null,
                isLoading: false,
                isDisabled: false,
              ),
            ),
          );

          expect(find.text('Sign up with Apple'), findsOneWidget);
        },
      );

      testWidgets(
        'when building the button with its own text, '
        'then the shared style still wins.',
        (tester) async {
          await tester.pumpWidget(
            const SignInButtonHost(
              style: style,
              child: AppleSignInButton(
                onPressed: null,
                isLoading: false,
                isDisabled: false,
                text: SignInButtonTextVariant.continueWith,
              ),
            ),
          );

          expect(find.text('Sign up with Apple'), findsOneWidget);
          expect(find.text('Continue with Apple'), findsNothing);
        },
      );
    },
  );

  testWidgets(
    'Given a shared SignInButtonStyle with a rectangular shape in scope, '
    'when building the button, '
    'then the border radius follows it.',
    (tester) async {
      await tester.pumpWidget(
        const SignInButtonHost(
          style: SignInButtonStyle(shape: SignInButtonShape.rectangular),
          child: AppleSignInButton(
            onPressed: null,
            isLoading: false,
            isDisabled: false,
            size: SignInButtonSize.large,
          ),
        ),
      );

      // Rectangular resolves to a 4px radius (vs the pill default).
      expect(borderRadiusOf(tester), BorderRadius.circular(4));
    },
  );

  testWidgets(
    'Given a shared SignInButtonStyle with a rounded shape in scope, '
    'when building the button, '
    'then the button uses the shared 8px radius.',
    (tester) async {
      await tester.pumpWidget(
        const SignInButtonHost(
          style: SignInButtonStyle(shape: SignInButtonShape.rounded),
          child: AppleSignInButton(
            onPressed: null,
            isLoading: false,
            isDisabled: false,
            size: SignInButtonSize.large,
          ),
        ),
      );

      expect(borderRadiusOf(tester), BorderRadius.circular(8));
    },
  );
}
