import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

void main() {
  // Resolves the rendered native Apple button.
  SignInWithAppleButton appleButtonOf(WidgetTester tester) {
    return tester.widget<SignInWithAppleButton>(
      find.byType(SignInWithAppleButton),
    );
  }

  group('Given an AppleSignInButton with no shared style and no arguments', () {
    testWidgets(
      'when built then it uses Apple built-in defaults',
      (tester) async {
        await tester.pumpWidget(
          const _Host(
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
  });

  group('Given a shared SignInButtonStyle in scope', () {
    testWidgets(
      'when the button sets no arguments then the shared text variant is used',
      (tester) async {
        await tester.pumpWidget(
          const _Host(
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
          const _Host(
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
          const _Host(
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
          const _Host(
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

/// Hosts a widget with an optional shared [SignInButtonStyle].
class _Host extends StatelessWidget {
  const _Host({required this.child, this.style});

  final Widget child;
  final SignInButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    Widget tree = SignInLocalizationProvider(child: child);
    final style = this.style;
    if (style != null) {
      tree = SignInButtonStyleProvider(style: style, child: tree);
    }
    return MaterialApp(home: Scaffold(body: tree));
  }
}
