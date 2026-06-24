import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

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

  group('Given a GitHubSignInButton with no shared style and no arguments', () {
    testWidgets(
      'when built then it uses GitHub built-in defaults',
      (tester) async {
        await tester.pumpWidget(
          const _Host(
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
  });

  group('Given a shared SignInButtonStyle in scope', () {
    testWidgets(
      'when the button sets no arguments then the shared text variant is used',
      (tester) async {
        await tester.pumpWidget(
          const _Host(
            style: SignInButtonStyle(text: SignInButtonTextVariant.signUpWith),
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
      'when the button sets its own text then the argument wins over the shared style',
      (tester) async {
        await tester.pumpWidget(
          const _Host(
            style: SignInButtonStyle(text: SignInButtonTextVariant.signUpWith),
            child: GitHubSignInButton(
              onPressed: null,
              isLoading: false,
              isDisabled: false,
              text: GitHubButtonText.continueWith,
            ),
          ),
        );

        expect(find.text('Continue with GitHub'), findsOneWidget);
        expect(find.text('Sign up with GitHub'), findsNothing);
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
      'when the shared style sets a textStyle then GitHub size-based fontSize is preserved',
      (tester) async {
        await tester.pumpWidget(
          const _Host(
            style: SignInButtonStyle(
              textStyle: TextStyle(fontWeight: FontWeight.bold),
            ),
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
  });

  group('Given a GitHubSignInButton', () {
    Color? backgroundOf(WidgetTester tester) {
      final button = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      return button.style?.backgroundColor?.resolve({});
    }

    testWidgets(
      'when there is no shared style then it keeps its GitHub brand colors',
      (tester) async {
        await tester.pumpWidget(
          const _Host(
            child: GitHubSignInButton(
              onPressed: null,
              isLoading: false,
              isDisabled: false,
            ),
          ),
        );

        // The brand background is not the common (light theme) white.
        expect(backgroundOf(tester), isNot(const Color(0xFFFFFFFF)));
      },
    );

    testWidgets(
      'when a shared style is in scope then it adopts the common colors',
      (tester) async {
        await tester.pumpWidget(
          const _Host(
            style: SignInButtonStyle(),
            child: GitHubSignInButton(
              onPressed: null,
              isLoading: false,
              isDisabled: false,
            ),
          ),
        );

        expect(backgroundOf(tester), const Color(0xFFFFFFFF));
      },
    );
  });
}

/// Hosts a widget with an optional shared [SignInButtonStyle] and an asset
/// bundle so the GitHub SVG resolves in tests.
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
