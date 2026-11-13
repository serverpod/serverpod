import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_auth_idp_flutter/widgets.dart';

void main() {
  group('Given a dark theme without a registered AuthIdpTheme,', () {
    late ThemeData theme;

    setUpAll(() {
      theme = ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
      );
    });

    group('when reading the idp theme,', () {
      late AuthIdpTheme idpTheme;

      setUpAll(() {
        idpTheme = theme.idpTheme;
      });

      test(
        'then the default pin is filled with the surface container color.',
        () {
          final decoration = idpTheme.defaultPinTheme.decoration!;

          expect(decoration.color, theme.colorScheme.surfaceContainerHighest);
        },
      );

      test('then the focused pin has a 2px border in the primary color.', () {
        final decoration = idpTheme.focusedPinTheme.decoration!;

        expect(
          decoration.border,
          Border.all(color: theme.colorScheme.primary, width: 2),
        );
      });

      test('then the error pin uses the error colors.', () {
        final decoration = idpTheme.errorPinTheme.decoration!;

        expect(decoration.color, theme.colorScheme.errorContainer);
        expect(
          decoration.border,
          Border.all(color: theme.colorScheme.error, width: 2),
        );
      });
    });
  });

  test(
    'Given a theme with a registered AuthIdpTheme, '
    'when reading the idp theme, '
    'then the registered theme is returned.',
    () {
      final registered = AuthIdpTheme.defaultTheme(borderColor: Colors.orange);
      final theme = ThemeData(extensions: [registered]);

      expect(theme.idpTheme, same(registered));
    },
  );

  test(
    'Given a color scheme and a border color, '
    'when creating the default theme, '
    'then the focused pin border uses the border color.',
    () {
      final idpTheme = AuthIdpTheme.defaultTheme(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        borderColor: Colors.orange,
      );

      expect(
        idpTheme.focusedPinTheme.decoration!.border,
        Border.all(color: Colors.orange, width: 2),
      );
    },
  );

  test(
    'Given no color scheme, '
    'when creating the default theme, '
    'then the default pin keeps the original fill color.',
    () {
      final idpTheme = AuthIdpTheme.defaultTheme();

      expect(
        idpTheme.defaultPinTheme.decoration!.color,
        const Color.fromRGBO(222, 231, 240, .57),
      );
    },
  );

  group('Given a focused empty verification code input,', () {
    testWidgets(
      'when it is shown, '
      'then a cursor in the primary color is shown in the first pin.',
      (tester) async {
        final theme = ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        );
        await tester.pumpWidget(
          _VerificationCodeInputHost(
            theme: theme,
            child: VerificationCodeInput(
              verificationCodeController: TextEditingController(),
              onCompleted: () {},
              isLoading: false,
            ),
          ),
        );
        await tester.pump();

        expect(
          find.descendant(
            of: find.byType(AnimatedContainer).first,
            matching: _cursorFinder(theme.colorScheme.primary),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'when pumping frames until none are scheduled, '
      'then the frames settle while the cursor blinks.',
      (tester) async {
        await tester.pumpWidget(
          _VerificationCodeInputHost(
            child: VerificationCodeInput(
              verificationCodeController: TextEditingController(),
              onCompleted: () {},
              isLoading: false,
            ),
          ),
        );

        final pumpCount = await tester.pumpAndSettle();

        expect(pumpCount, isPositive);
      },
    );

    testWidgets(
      'when the input loses focus, '
      'then no cursor is shown.',
      (tester) async {
        final theme = ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        );
        final focusNode = FocusNode();
        addTearDown(focusNode.dispose);
        await tester.pumpWidget(
          _VerificationCodeInputHost(
            theme: theme,
            child: VerificationCodeInput(
              verificationCodeController: TextEditingController(),
              onCompleted: () {},
              isLoading: false,
              focusNode: focusNode,
            ),
          ),
        );
        await tester.pump();

        focusNode.unfocus();
        await tester.pumpAndSettle();

        expect(_cursorFinder(theme.colorScheme.primary), findsNothing);
      },
    );
  });

  testWidgets(
    'Given a verification code input for 8 digits, '
    'when pasting a complete code from the context menu, '
    'then the input holds the code and reports completion once.',
    (tester) async {
      final controller = TextEditingController();
      var completedCount = 0;
      await tester.pumpWidget(
        _VerificationCodeInputHost(
          child: _digitsInput(
            controller: controller,
            onCompleted: () => completedCount++,
          ),
        ),
      );
      await tester.pump();

      _mockClipboard(tester, text: '12345678');
      await tester.longPress(find.byType(AnimatedContainer).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Paste'));
      await tester.pumpAndSettle();

      expect(controller.text, '12345678');
      expect(completedCount, 1);
    },
    // The browser test covers the context menu on the web.
    skip: kIsWeb,
  );
}

class _VerificationCodeInputHost extends StatelessWidget {
  const _VerificationCodeInputHost({required this.child, this.theme});

  final Widget child;
  final ThemeData? theme;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: Scaffold(
        body: Center(child: SizedBox(width: 320, child: child)),
      ),
    );
  }
}

VerificationCodeInput _digitsInput({
  required TextEditingController controller,
  required VoidCallback onCompleted,
}) {
  return VerificationCodeInput(
    verificationCodeController: controller,
    onCompleted: onCompleted,
    isLoading: false,
    length: 8,
    allowedCharactersPattern: RegExp(r'[0-9]'),
  );
}

Finder _cursorFinder(Color color) => find.byWidgetPredicate(
  (widget) => widget is ColoredBox && widget.color == color,
);

/// Answers clipboard reads with [text].
///
/// Install it after pumping the input: on native platforms Pinput reads the
/// clipboard when it is mounted, which would mix that read into the scenario.
void _mockClipboard(WidgetTester tester, {required String text}) {
  final messenger = tester.binding.defaultBinaryMessenger;
  messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
    return switch (call.method) {
      'Clipboard.hasStrings' => {'value': true},
      'Clipboard.getData' => {'text': text},
      _ => null,
    };
  });
  addTearDown(
    () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
  );
}
