import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

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
  group(
    'Given a MicrosoftSignInButton with no shared style and no arguments',
    () {
      testWidgets(
        'when built then it uses Microsoft built-in defaults',
        (tester) async {
          await tester.pumpWidget(
            const _Host(
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
    },
  );

  group('Given a shared SignInButtonStyle in scope', () {
    testWidgets(
      'when the button sets no arguments then the shared text variant is used',
      (tester) async {
        await tester.pumpWidget(
          const _Host(
            style: SignInButtonStyle(text: SignInButtonTextVariant.signUpWith),
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
      'when both the button and the shared style set the text then the shared style wins',
      (tester) async {
        await tester.pumpWidget(
          const _Host(
            style: SignInButtonStyle(text: SignInButtonTextVariant.signUpWith),
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

    testWidgets(
      'when the shared style sets a textStyle then the label adopts its font weight',
      (tester) async {
        await tester.pumpWidget(
          const _Host(
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
  });
}

/// Hosts a widget with an optional shared [SignInButtonStyle] and an asset
/// bundle so the Microsoft SVG resolves in tests.
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
    return DefaultAssetBundle(
      bundle: _SvgAssetBundle(),
      child: MaterialApp(home: Scaffold(body: tree)),
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
