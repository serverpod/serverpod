import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

void main() {
  group('Given a SignInButtonStyleProvider in the tree', () {
    late SignInButtonStyle captured;

    setUp(() {
      captured = SignInButtonStyle.defaults;
    });

    testWidgets(
      'when a descendant reads context.signInButtonStyle '
      'then it returns the provided style',
      (tester) async {
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
  });

  group('Given no SignInButtonStyleProvider in the tree', () {
    late SignInButtonStyle captured;

    setUp(() {
      captured = const SignInButtonStyle(size: SignInButtonSize.large);
    });

    testWidgets(
      'when a descendant reads context.signInButtonStyle '
      'then it returns the empty defaults',
      (tester) async {
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
  });

  group('Given a SignInButtonStyle', () {
    test('when copyWith replaces a field then other fields are preserved', () {
      const original = SignInButtonStyle(
        size: SignInButtonSize.large,
        shape: SignInButtonShape.rounded,
      );

      final updated = original.copyWith(shape: SignInButtonShape.pill);

      expect(updated.size, SignInButtonSize.large);
      expect(updated.shape, SignInButtonShape.pill);
    });

    test('when fields match then instances are equal', () {
      const a = SignInButtonStyle(minimumWidth: 300);
      const b = SignInButtonStyle(minimumWidth: 300);

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('when minimumWidth is out of range then the assertion fails', () {
      expect(
        () => SignInButtonStyle(minimumWidth: 500),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
