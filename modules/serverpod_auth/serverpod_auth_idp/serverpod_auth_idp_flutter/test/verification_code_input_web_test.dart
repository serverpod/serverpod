// The browser context menu only exists on the web. Run with:
// flutter test --platform chrome test/verification_code_input_web_test.dart
@TestOn('browser')
library;

import 'dart:async';
import 'dart:js_interop';

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

  group('Given a verification code input was shown,', () {
    testWidgets(
      'when the browser has an input for a one-time code with a 1px font, '
      'then the font size of that input is 16px.',
      (tester) async {
        await tester.pumpWidget(_host(_input()));
        await tester.pump();

        final input = _addBrowserInput(autocomplete: 'one-time-code');

        expect(_computedStyleOf(input).fontSize, '16px');
        await _disposeInput(tester);
      },
    );

    testWidgets(
      'when the browser has an input for other text with a 1px font, '
      'then the font size of that input stays 1px.',
      (tester) async {
        await tester.pumpWidget(_host(_input()));
        await tester.pump();

        final input = _addBrowserInput(autocomplete: 'on');

        expect(_computedStyleOf(input).fontSize, '1px');
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
/// it starts completes while the test can still process it.
Future<void> _disposeInput(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump();
}

/// Adds a browser input like the one Flutter creates for a focused text field
/// with the [autocomplete] hint, with the 1px font of Pinput's hidden text.
_Element _addBrowserInput({required String autocomplete}) {
  final input = _document.createElement('input')
    ..setAttribute('autocomplete', autocomplete)
    ..style.font = '400 1px sans-serif';
  final host = _document.createElement('flt-text-editing-host')..append(input);
  _document.body.append(host);
  addTearDown(() => host.remove());
  return input;
}

@JS('document')
external _Document get _document;

@JS('getComputedStyle')
external _CssStyle _computedStyleOf(_Element element);

extension type _Document._(JSObject _) implements JSObject {
  external _Element get body;
  external _Element createElement(String tagName);
}

extension type _Element._(JSObject _) implements JSObject {
  external _CssStyle get style;
  external void setAttribute(String name, String value);
  external void append(_Element node);
  external void remove();
}

extension type _CssStyle._(JSObject _) implements JSObject {
  external set font(String value);
  external String get fontSize;
}
