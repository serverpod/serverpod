import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'test_utils.dart';

void main() {
  // Resolves the ButtonStyle of the ElevatedButton inside the anonymous
  // button.
  ButtonStyle styleOf(WidgetTester tester) {
    return tester
        .widget<ElevatedButton>(
          find.descendant(
            of: find.byType(AnonymousSignInButton),
            matching: find.byType(ElevatedButton),
          ),
        )
        .style!;
  }

  testWidgets(
    'Given an AnonymousSignInButton with no shared style, '
    'when building the button, '
    'then it has a transparent background and no border.',
    (tester) async {
      await tester.pumpWidget(
        const SignInButtonHost(
          child: AnonymousSignInButton(
            onPressed: null,
            isLoading: false,
            isDisabled: false,
          ),
        ),
      );

      final style = styleOf(tester);
      expect(style.backgroundColor?.resolve({}), Colors.transparent);
      final shape = style.shape?.resolve({}) as RoundedRectangleBorder;
      expect(shape.side, BorderSide.none);
    },
  );

  testWidgets(
    'Given an AnonymousSignInButton inside a shared SignInButtonStyle scope '
    'with a background color, '
    'when building the button, '
    'then it stays flat with a transparent background and no border.',
    (tester) async {
      await tester.pumpWidget(
        const SignInButtonHost(
          style: SignInButtonStyle(backgroundColor: Colors.blue),
          child: AnonymousSignInButton(
            onPressed: null,
            isLoading: false,
            isDisabled: false,
          ),
        ),
      );

      final style = styleOf(tester);
      expect(style.backgroundColor?.resolve({}), Colors.transparent);
      final shape = style.shape?.resolve({}) as RoundedRectangleBorder;
      expect(shape.side, BorderSide.none);
    },
  );

  testWidgets(
    'Given a disabled AnonymousSignInButton, '
    'when building the button, '
    'then the background stays transparent.',
    (tester) async {
      await tester.pumpWidget(
        const SignInButtonHost(
          child: AnonymousSignInButton(
            onPressed: null,
            isLoading: false,
            isDisabled: true,
          ),
        ),
      );

      final style = styleOf(tester);
      expect(
        style.backgroundColor?.resolve({WidgetState.disabled}),
        Colors.transparent,
      );
    },
  );
}
