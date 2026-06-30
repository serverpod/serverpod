import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'test_utils.dart';

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
          const SignInButtonHost(
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
          const SignInButtonHost(
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
