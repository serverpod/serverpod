import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'test_utils.dart';

void main() {
  // Resolves the label Text widget rendered inside the GitHub button.
  Text labelOf(WidgetTester tester) {
    return tester.widget<Text>(
      find.descendant(
        of: find.byType(GitHubSignInButton),
        matching: find.byType(Text),
      ),
    );
  }

  testWidgets(
    'Given a GitHubSignInButton with no shared style and no arguments, '
    'when building the button, '
    'then it uses GitHub built-in defaults.',
    (tester) async {
      await tester.pumpWidget(
        const SignInButtonHost(
          child: GitHubSignInButton(
            onPressed: null,
            isLoading: false,
            isDisabled: false,
          ),
        ),
      );

      expect(find.text('Continue with GitHub'), findsOneWidget);
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
              child: GitHubSignInButton(
                onPressed: null,
                isLoading: false,
                isDisabled: false,
              ),
            ),
          );

          expect(find.text('Sign up with GitHub'), findsOneWidget);
        },
      );

      testWidgets(
        'when building the button with its own text, '
        'then the shared style still wins.',
        (tester) async {
          await tester.pumpWidget(
            const SignInButtonHost(
              style: style,
              child: GitHubSignInButton(
                onPressed: null,
                isLoading: false,
                isDisabled: false,
                text: GitHubButtonText.continueWith,
              ),
            ),
          );

          expect(find.text('Sign up with GitHub'), findsOneWidget);
          expect(find.text('Continue with GitHub'), findsNothing);
        },
      );
    },
  );

  group(
    'Given a shared SignInButtonStyle with a custom textStyle in scope,',
    () {
      const style = SignInButtonStyle(
        textStyle: TextStyle(fontWeight: FontWeight.bold),
      );

      testWidgets(
        'when building the button, '
        'then the label adopts its font weight.',
        (tester) async {
          await tester.pumpWidget(
            const SignInButtonHost(
              style: style,
              child: GitHubSignInButton(
                onPressed: null,
                isLoading: false,
                isDisabled: false,
              ),
            ),
          );

          expect(labelOf(tester).style?.fontWeight, FontWeight.bold);
        },
      );

      testWidgets(
        'when building the button at large size, '
        'then GitHub size-based fontSize is preserved.',
        (tester) async {
          await tester.pumpWidget(
            const SignInButtonHost(
              style: style,
              child: GitHubSignInButton(
                onPressed: null,
                isLoading: false,
                isDisabled: false,
                size: GitHubButtonSize.large,
              ),
            ),
          );

          // Large keeps its 16px default since the shared style did not set one.
          expect(labelOf(tester).style?.fontSize, 16);
        },
      );
    },
  );

  testWidgets(
    'Given a GitHubSignInButton with no shared style in scope, '
    'when building the button, '
    'then it keeps its GitHub brand colors.',
    (tester) async {
      await tester.pumpWidget(
        const SignInButtonHost(
          child: GitHubSignInButton(
            onPressed: null,
            isLoading: false,
            isDisabled: false,
          ),
        ),
      );

      // The brand background is not the common (light theme) white.
      expect(githubButtonBackgroundOf(tester), isNot(const Color(0xFFFFFFFF)));
    },
  );

  testWidgets(
    'Given a GitHubSignInButton with a shared style in scope, '
    'when building the button, '
    'then it adopts the common colors.',
    (tester) async {
      await tester.pumpWidget(
        const SignInButtonHost(
          style: SignInButtonStyle(),
          child: GitHubSignInButton(
            onPressed: null,
            isLoading: false,
            isDisabled: false,
          ),
        ),
      );

      expect(githubButtonBackgroundOf(tester), const Color(0xFFFFFFFF));
    },
  );
}

Color? githubButtonBackgroundOf(WidgetTester tester) {
  final button = tester.widget<ElevatedButton>(
    find.byType(ElevatedButton),
  );
  return button.style?.backgroundColor?.resolve({});
}
