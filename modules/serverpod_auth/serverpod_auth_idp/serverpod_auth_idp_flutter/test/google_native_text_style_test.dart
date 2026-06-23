import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

void main() {
  // Resolves the label Text widget rendered inside the native Google button.
  Text labelOf(WidgetTester tester) {
    return tester.widget<Text>(
      find.descendant(
        of: find.byType(GoogleSignInNativeButton),
        matching: find.byType(Text),
      ),
    );
  }

  group('Given a GoogleSignInNativeButton with no textStyle', () {
    testWidgets(
      'when built then it renders the default label without forcing a font family',
      (tester) async {
        await tester.pumpWidget(
          const _Host(
            child: GoogleSignInNativeButton(
              onPressed: null,
              isLoading: false,
              isDisabled: false,
            ),
          ),
        );

        expect(find.text('Continue with Google'), findsOneWidget);
        // No hardcoded font family, so the label inherits the app theme font.
        expect(labelOf(tester).style?.fontFamily, isNull);
      },
    );
  });

  group('Given a GoogleSignInNativeButton with a textStyle', () {
    testWidgets(
      'when built then the label merges it over the default font',
      (tester) async {
        await tester.pumpWidget(
          const _Host(
            child: GoogleSignInNativeButton(
              onPressed: null,
              isLoading: false,
              isDisabled: false,
              textStyle: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );

        final style = labelOf(tester).style;
        expect(style?.fontWeight, FontWeight.bold);
        // The default large size (16) is preserved since textStyle set none.
        expect(style?.fontSize, 16);
      },
    );
  });
}

/// Hosts a widget with an asset bundle so the Google SVG resolves in tests.
class _Host extends StatelessWidget {
  const _Host({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DefaultAssetBundle(
      bundle: _SvgAssetBundle(),
      child: MaterialApp(
        home: Scaffold(
          body: SignInLocalizationProvider(child: child),
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
