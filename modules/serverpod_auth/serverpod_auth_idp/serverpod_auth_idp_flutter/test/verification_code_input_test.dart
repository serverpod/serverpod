import 'package:flutter/gestures.dart';
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

    testWidgets(
      'when the paste button is tapped with a mouse, '
      'then the input keeps the focus.',
      (tester) async {
        final focusNode = FocusNode();
        addTearDown(focusNode.dispose);
        await tester.pumpWidget(
          _VerificationCodeInputHost(
            child: VerificationCodeInput(
              verificationCodeController: TextEditingController(),
              onCompleted: () {},
              isLoading: false,
              focusNode: focusNode,
            ),
          ),
        );
        await tester.pump();

        _mockClipboard(tester, text: '');
        await tester.tap(
          find.byTooltip('Paste'),
          kind: PointerDeviceKind.mouse,
        );
        await tester.pump();

        expect(focusNode.hasFocus, isTrue);
      },
    );
  });

  group('Given a verification code input for 8 digits,', () {
    testWidgets(
      'when pasting a code surrounded by whitespace, '
      'then the input holds the code without the whitespace.',
      (tester) async {
        final controller = TextEditingController();
        await tester.pumpWidget(
          _VerificationCodeInputHost(
            child: _digitsInput(controller: controller, onCompleted: () {}),
          ),
        );

        _mockClipboard(tester, text: ' 1234 5678\n');
        await tester.tap(find.byTooltip('Paste'));
        await tester.pump();

        expect(controller.text, '12345678');
      },
    );

    testWidgets(
      'when pasting a complete code, '
      'then completion is reported once.',
      (tester) async {
        var completedCount = 0;
        await tester.pumpWidget(
          _VerificationCodeInputHost(
            child: _digitsInput(
              controller: TextEditingController(),
              onCompleted: () => completedCount++,
            ),
          ),
        );

        _mockClipboard(tester, text: '12345678');
        await tester.tap(find.byTooltip('Paste'));
        await tester.pump();

        expect(completedCount, 1);
      },
    );

    testWidgets(
      'when pasting text with only 4 allowed characters, '
      'then the input holds those characters without reporting completion.',
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

        _mockClipboard(tester, text: 'Code: 1234');
        await tester.tap(find.byTooltip('Paste'));
        await tester.pump();

        expect(controller.text, '1234');
        expect(completedCount, 0);
      },
    );

    testWidgets(
      'when pasting a code with 12 digits, '
      'then the input holds the first 8 digits.',
      (tester) async {
        final controller = TextEditingController();
        await tester.pumpWidget(
          _VerificationCodeInputHost(
            child: _digitsInput(controller: controller, onCompleted: () {}),
          ),
        );

        _mockClipboard(tester, text: '123456789012');
        await tester.tap(find.byTooltip('Paste'));
        await tester.pump();

        expect(controller.text, '12345678');
      },
    );

    testWidgets(
      'when pasting text without allowed characters, '
      'then the entered code is kept.',
      (tester) async {
        final controller = TextEditingController(text: '12');
        await tester.pumpWidget(
          _VerificationCodeInputHost(
            child: _digitsInput(controller: controller, onCompleted: () {}),
          ),
        );

        _mockClipboard(tester, text: 'hello');
        await tester.tap(find.byTooltip('Paste'));
        await tester.pump();

        expect(controller.text, '12');
      },
    );

    testWidgets(
      'when the clipboard cannot be read, '
      'then the entered code is kept.',
      (tester) async {
        final controller = TextEditingController(text: '12');
        await tester.pumpWidget(
          _VerificationCodeInputHost(
            child: _digitsInput(controller: controller, onCompleted: () {}),
          ),
        );

        _mockClipboard(tester, error: PlatformException(code: 'denied'));
        await tester.tap(find.byTooltip('Paste'));
        await tester.pump();

        expect(controller.text, '12');
      },
    );
  });

  testWidgets(
    'Given a loading verification code input, '
    'when it is shown, '
    'then the paste button is disabled.',
    (tester) async {
      await tester.pumpWidget(
        _VerificationCodeInputHost(
          child: VerificationCodeInput(
            verificationCodeController: TextEditingController(),
            onCompleted: () {},
            isLoading: true,
          ),
        ),
      );

      final button = tester.widget<IconButton>(
        find.ancestor(
          of: find.byTooltip('Paste'),
          matching: find.byType(IconButton),
        ),
      );

      expect(button.onPressed, isNull);
    },
  );

  testWidgets(
    'Given a verification code input with the paste button hidden, '
    'when it is shown, '
    'then no paste button is shown.',
    (tester) async {
      await tester.pumpWidget(
        _VerificationCodeInputHost(
          child: VerificationCodeInput(
            verificationCodeController: TextEditingController(),
            onCompleted: () {},
            isLoading: false,
            showPasteButton: false,
          ),
        ),
      );

      expect(find.byTooltip('Paste'), findsNothing);
    },
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

/// Answers clipboard reads with [text] or throws [error].
///
/// Install it after pumping the input: on native platforms Pinput reads the
/// clipboard when it is mounted, which would mix that read into the scenario.
void _mockClipboard(
  WidgetTester tester, {
  String? text,
  PlatformException? error,
}) {
  final messenger = tester.binding.defaultBinaryMessenger;
  messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
    if (call.method != 'Clipboard.getData') return null;
    if (error != null) throw error;
    return {'text': text};
  });
  addTearDown(
    () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
  );
}
