// The browser context menu only exists on the web. Run with:
// flutter test --platform chrome test/verification_code_input_web_test.dart
@TestOn('browser')
library;

import 'dart:async';
import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_flutter/widgets.dart';

/// Delays the answers to browser context menu changes until it completes.
///
/// The answers keep the order of the calls, like the web engine's.
Future<void>? _contextMenuReplies;

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    _contextMenuReplies = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.contextMenu, (call) async {
          await _contextMenuReplies;
          return null;
        });
    if (!BrowserContextMenu.enabled) {
      await BrowserContextMenu.enableContextMenu();
    }
  });

  group('Given the browser context menu is enabled,', () {
    testWidgets(
      'when a verification code input gets focus, '
      'then the browser context menu is disabled.',
      (tester) async {
        await tester.pumpWidget(_host(_input()));
        await tester.pump();

        expect(BrowserContextMenu.enabled, isFalse);
        await _disposeInput(tester);
      },
    );

    testWidgets(
      'when a focused verification code input loses focus, '
      'then the browser context menu is enabled again.',
      (tester) async {
        final focusNode = FocusNode();
        addTearDown(focusNode.dispose);
        await tester.pumpWidget(_host(_input(focusNode: focusNode)));
        await tester.pump();

        focusNode.unfocus();
        await tester.pump();

        expect(BrowserContextMenu.enabled, isTrue);
      },
    );

    testWidgets(
      'when the browser context menu is disabled only after the input got '
      'focus, '
      'then a right click on the input shows the paste action of Flutter.',
      (tester) async {
        final replies = Completer<void>();
        _contextMenuReplies = replies.future;
        await tester.pumpWidget(_host(_input()));
        await tester.pump();

        replies.complete();
        await tester.pump();
        await tester.tap(
          find.byType(AnimatedContainer).first,
          buttons: kSecondaryButton,
          kind: PointerDeviceKind.mouse,
        );
        await tester.pump();

        expect(find.text('Paste'), findsOneWidget);
        await _disposeInput(tester);
      },
    );
  });

  testWidgets(
    'Given a verification code input that lost focus, '
    'when it is right-clicked, '
    'then the paste action of Flutter is shown.',
    (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      await tester.pumpWidget(_host(_input(focusNode: focusNode)));
      await tester.pump();
      focusNode.unfocus();
      await tester.pump();

      await tester.tap(
        find.byType(AnimatedContainer).first,
        buttons: kSecondaryButton,
        kind: PointerDeviceKind.mouse,
      );
      await tester.pump();

      expect(find.text('Paste'), findsOneWidget);
      await _disposeInput(tester);
    },
  );

  testWidgets(
    'Given a verification code input for 8 digits, '
    'when pasting a complete code from the context menu of a long press, '
    'then the input holds the code and reports completion once.',
    (tester) async {
      final controller = TextEditingController();
      var completedCount = 0;
      await tester.pumpWidget(
        _host(
          VerificationCodeInput(
            verificationCodeController: controller,
            onCompleted: () => completedCount++,
            isLoading: false,
            length: 8,
            allowedCharactersPattern: RegExp(r'[0-9]'),
          ),
        ),
      );
      await tester.pump();
      final messenger = tester.binding.defaultBinaryMessenger;
      messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
        if (call.method != 'Clipboard.getData') return null;
        return {'text': '12345678'};
      });
      addTearDown(
        () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
      );

      await tester.longPress(find.byType(AnimatedContainer).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Paste'));
      await tester.pumpAndSettle();

      expect(controller.text, '12345678');
      expect(completedCount, 1);
      await _disposeInput(tester);
    },
  );

  testWidgets(
    'Given a verification code input that lost focus while the browser '
    'context menu is still being enabled again, '
    'when the input gets focus again, '
    'then the browser context menu ends up disabled.',
    (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      await tester.pumpWidget(_host(_input(focusNode: focusNode)));
      await tester.pump();
      final replies = Completer<void>();
      _contextMenuReplies = replies.future;
      focusNode.unfocus();
      await tester.pump();

      focusNode.requestFocus();
      await tester.pump();
      replies.complete();
      await tester.pump();

      expect(BrowserContextMenu.enabled, isFalse);
      await _disposeInput(tester);
    },
  );

  testWidgets(
    'Given a code in the clipboard, '
    'when a verification code input is shown and the app resumes, '
    'then the clipboard is not read.',
    (tester) async {
      var clipboardReads = 0;
      final messenger = tester.binding.defaultBinaryMessenger;
      messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
        if (call.method != 'Clipboard.getData') return null;
        clipboardReads++;
        return {'text': '12345678'};
      });
      addTearDown(
        () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
      );

      await tester.pumpWidget(_host(_input()));
      await tester.pump();
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();

      expect(clipboardReads, 0);
      await _disposeInput(tester);
    },
  );

  testWidgets(
    'Given the app disabled the browser context menu, '
    'when a focused verification code input loses focus, '
    'then the browser context menu stays disabled.',
    (tester) async {
      await BrowserContextMenu.disableContextMenu();
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      await tester.pumpWidget(_host(_input(focusNode: focusNode)));
      await tester.pump();

      focusNode.unfocus();
      await tester.pump();

      expect(BrowserContextMenu.enabled, isFalse);
    },
  );

  group('Given text input is handled by the browser,', () {
    testWidgets(
      'when a verification code input gets focus, '
      'then the browser input of the code has a 16px font.',
      (tester) async {
        _useBrowserTextInput(tester);

        await tester.pumpWidget(_host(_input()));
        await tester.pump();

        expect(_computedStyleOf(_browserInput()).fontSize, '16px');
        await _disposeInput(tester);
      },
    );

    testWidgets(
      'when a text field with a 10px font gets focus after a verification '
      'code input was shown, '
      'then the browser input of the text field keeps the 10px font.',
      (tester) async {
        _useBrowserTextInput(tester);
        await tester.pumpWidget(_host(_input()));
        await tester.pump();
        await _disposeInput(tester);

        await tester.pumpWidget(
          _host(
            const TextField(autofocus: true, style: TextStyle(fontSize: 10)),
          ),
        );
        await tester.pump();

        expect(_computedStyleOf(_browserInput()).fontSize, '10px');
        await _disposeInput(tester);
      },
    );
  });
}

Widget _host(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Center(child: SizedBox(width: 320, child: child)),
    ),
  );
}

VerificationCodeInput _input({FocusNode? focusNode}) {
  return VerificationCodeInput(
    verificationCodeController: TextEditingController(),
    onCompleted: () {},
    isLoading: false,
    focusNode: focusNode,
  );
}

/// Disposes the input before the test ends, so the browser context menu change
/// it starts, and the answers of the web engine to text input messages,
/// complete while the test can still process them.
Future<void> _disposeInput(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(Duration.zero);
}

/// Lets the web engine create the browser inputs of focused text fields, as in
/// an app, instead of the fake text input of widget tests.
void _useBrowserTextInput(WidgetTester tester) {
  final environment = ui_web.TestEnvironment.instance;
  ui_web.TestEnvironment.setUp(
    ui_web.TestEnvironment(
      forceTestFonts: environment.forceTestFonts,
      disableFontFallbacks: environment.disableFontFallbacks,
      keepSemanticsDisabledOnUpdate: environment.keepSemanticsDisabledOnUpdate,
      defaultToTestUrlStrategy: environment.defaultToTestUrlStrategy,
    ),
  );
  addTearDown(() => ui_web.TestEnvironment.setUp(environment));
  tester.testTextInput.unregister();
}

/// The browser input the web engine created for the focused text field.
///
/// The engine keeps the inputs of previous autofill groups on the page, so the
/// focused one is the input of the text field.
_Element _browserInput() {
  final input = _document.activeElement;
  if (input == null || input.tagName != 'INPUT') {
    throw StateError('No browser input is focused.');
  }
  return input;
}

@JS('document')
external _Document get _document;

@JS('getComputedStyle')
external _CssStyle _computedStyleOf(_Element element);

extension type _Document._(JSObject _) implements JSObject {
  external _Element? get activeElement;
}

extension type _Element._(JSObject _) implements JSObject {
  external String get tagName;
}

extension type _CssStyle._(JSObject _) implements JSObject {
  external String get fontSize;
}
