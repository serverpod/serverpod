import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

void main() {
  testWidgets(
    'Given a SignInButtonStyleProvider in the tree, '
    'when a descendant reads context.signInButtonStyle, '
    'then it returns the provided style.',
    (tester) async {
      SignInButtonStyle? captured;
      const style = SignInButtonStyle(
        size: SignInButtonSize.small,
        shape: SignInButtonShape.pill,
      );

      await tester.pumpWidget(
        SignInButtonStyleProvider(
          style: style,
          child: Builder(
            builder: (context) {
              captured = context.signInButtonStyle;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(captured, style);
    },
  );

  testWidgets(
    'Given no SignInButtonStyleProvider in the tree, '
    'when a descendant reads context.signInButtonStyle, '
    'then it returns the empty defaults.',
    (tester) async {
      SignInButtonStyle? captured;

      await tester.pumpWidget(
        Builder(
          builder: (context) {
            captured = context.signInButtonStyle;
            return const SizedBox();
          },
        ),
      );

      expect(captured, SignInButtonStyle.defaults);
    },
  );

  test(
    'Given a SignInButtonStyle with size large and shape rounded, '
    'when copyWith replaces the shape, '
    'then other fields are preserved.',
    () {
      const original = SignInButtonStyle(
        size: SignInButtonSize.large,
        shape: SignInButtonShape.rounded,
      );

      final updated = original.copyWith(shape: SignInButtonShape.pill);

      expect(updated.size, SignInButtonSize.large);
      expect(updated.shape, SignInButtonShape.pill);
    },
  );

  test(
    'Given two SignInButtonStyle instances with the same minimumWidth, '
    'when compared for equality, '
    'then they are equal.',
    () {
      const a = SignInButtonStyle(minimumWidth: 300);
      const b = SignInButtonStyle(minimumWidth: 300);

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    },
  );

  test(
    'Given a minimumWidth above the allowed maximum, '
    'when constructing a SignInButtonStyle, '
    'then the assertion fails.',
    () {
      expect(
        () => SignInButtonStyle(minimumWidth: 500),
        throwsA(isA<AssertionError>()),
      );
    },
  );
}
