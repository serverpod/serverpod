import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_auth_idp_flutter_facebook/serverpod_auth_idp_flutter_facebook.dart';

void main() {
  // Resolves the label Text widget rendered inside the Facebook button.
  Text labelOf(WidgetTester tester) {
    return tester.widget<Text>(
      find.descendant(
        of: find.byType(FacebookSignInButton),
        matching: find.byType(Text),
      ),
    );
  }

  testWidgets(
    'Given a FacebookSignInButton with no shared style and no arguments when built then it uses Facebook built-in defaults',
    (tester) async {
      await tester.pumpWidget(
        const _Host(
          child: FacebookSignInButton(
            onPressed: null,
            isLoading: false,
            isDisabled: false,
          ),
        ),
      );

      expect(find.text('Continue with Facebook'), findsOneWidget);
    },
  );

  // The shared style is provided by the main package; these tests confirm it
  // crosses the package boundary into this separate Facebook package.
  group(
    'Given a shared SignInButtonStyle from the main package with the signUpWith text variant',
    () {
      const style = SignInButtonStyle(text: SignInButtonTextVariant.signUpWith);

      testWidgets(
        'when built then the button uses it',
        (tester) async {
          await tester.pumpWidget(
            const _Host(
              style: style,
              child: FacebookSignInButton(
                onPressed: null,
                isLoading: false,
                isDisabled: false,
              ),
            ),
          );

          expect(find.text('Sign up with Facebook'), findsOneWidget);
        },
      );

      testWidgets(
        'when the button sets its own text then the shared style still wins',
        (tester) async {
          await tester.pumpWidget(
            const _Host(
              style: style,
              child: FacebookSignInButton(
                onPressed: null,
                isLoading: false,
                isDisabled: false,
                type: FacebookButtonText.continueWith,
              ),
            ),
          );

          expect(find.text('Sign up with Facebook'), findsOneWidget);
          expect(find.text('Continue with Facebook'), findsNothing);
        },
      );
    },
  );

  // The shared style is provided by the main package; this test confirms it
  // crosses the package boundary into this separate Facebook package.
  testWidgets(
    'Given a shared SignInButtonStyle from the main package with a custom textStyle when built then the label adopts its font weight',
    (tester) async {
      await tester.pumpWidget(
        const _Host(
          style: SignInButtonStyle(
            textStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
          child: FacebookSignInButton(
            onPressed: null,
            isLoading: false,
            isDisabled: false,
          ),
        ),
      );

      expect(labelOf(tester).style?.fontWeight, FontWeight.bold);
    },
  );
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
