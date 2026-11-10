import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

import '../../theme.dart';
import '../text_formatters.dart';

/// A widget for entering one-time verification codes (OTP).
///
/// Displays a row of pin inputs and a paste-from-clipboard button. The callback
/// [onCompleted] is invoked when the input reaches the configured [length].
///
/// On the web, the browser context menu is disabled while the input has focus
/// or is pressed, so a long press or right click on it shows Flutter's text
/// selection toolbar, which has a paste action. The browser context menu is
/// restored when the input loses focus, unless the app had disabled it itself.
class VerificationCodeInput extends StatefulWidget {
  /// Controller that holds the entered verification code.
  final TextEditingController verificationCodeController;

  /// Callback invoked when the code entry is complete.
  final VoidCallback onCompleted;

  /// When true, disables input while an operation is in progress.
  final bool isLoading;

  /// Number of digits/characters expected for the code. Defaults to 6.
  final int length;

  /// The keyboard type to use for the verification code input.
  final TextInputType keyboardType;

  /// The case of letters allowed in the verification code input.
  final LetterCase allowedLetterCase;

  /// A pattern of the allowed characters in the verification code input.
  final Pattern? allowedCharactersPattern;

  /// The focus node for the verification code input.
  final FocusNode? focusNode;

  /// Whether to show the button that pastes the code from the clipboard.
  final bool showPasteButton;

  /// Creates a [VerificationCodeInput] widget.
  const VerificationCodeInput({
    required this.onCompleted,
    required this.verificationCodeController,
    required this.isLoading,
    this.length = 8,
    this.keyboardType = TextInputType.text,
    this.allowedLetterCase = LetterCase.mixed,
    this.allowedCharactersPattern,
    this.focusNode,
    this.showPasteButton = true,
    super.key,
  });

  @override
  State<VerificationCodeInput> createState() => _VerificationCodeInputState();
}

class _VerificationCodeInputState extends State<VerificationCodeInput> {
  /// Codes completed in any verification code input of the app, which are not
  /// filled in from the clipboard again, e.g. the code of a previous sign-in
  /// that is still in the clipboard when signing in again.
  static final _completedCodes = <String>{};

  FocusNode? _ownedFocusNode;
  late FocusNode _focusNode;

  /// Whether this input holds the browser context menu disabled.
  bool _holdsBrowserContextMenu = false;

  /// The pointers pressed on the pins, which hold the browser context menu
  /// disabled until the gesture focuses the input.
  int _pressedPointers = 0;

  /// The context menu of the input, same as Pinput's default.
  ///
  /// [EditableText] decides whether to show Flutter's menu or leave it to the
  /// browser when it creates its selection overlay, which can happen before the
  /// browser menu is disabled. A new builder makes it create the overlay again.
  EditableTextContextMenuBuilder _contextMenuBuilder = _buildContextMenu;

  static Widget _buildContextMenu(
    BuildContext context,
    EditableTextState editableTextState,
  ) {
    return AdaptiveTextSelectionToolbar.editableText(
      editableTextState: editableTextState,
    );
  }

  List<TextInputFormatter> get _inputFormatters {
    final allowedCharactersPattern = widget.allowedCharactersPattern;
    return [
      LetterCaseTextFormatter(letterCase: widget.allowedLetterCase),
      if (allowedCharactersPattern != null)
        FilteringTextInputFormatter.allow(allowedCharactersPattern),
    ];
  }

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? (_ownedFocusNode = FocusNode());
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void didUpdateWidget(VerificationCodeInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.focusNode != oldWidget.focusNode) {
      _focusNode.removeListener(_handleFocusChange);
      _focusNode = widget.focusNode ?? (_ownedFocusNode ??= FocusNode());
      _focusNode.addListener(_handleFocusChange);
      _updateBrowserContextMenuHold();
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _setHoldsBrowserContextMenu(false);
    _ownedFocusNode?.dispose();
    super.dispose();
  }

  void _handleFocusChange() => _updateBrowserContextMenuHold();

  void _updateBrowserContextMenuHold() {
    _setHoldsBrowserContextMenu(_focusNode.hasFocus || _pressedPointers > 0);
  }

  // A right click or long press on an unfocused input asks for the toolbar in
  // the same gesture that focuses the input. Disabling the browser menu when
  // the pointer goes down lets that request see the menu already disabled.
  void _handlePointerDown(PointerDownEvent event) {
    if (!kIsWeb) return;
    _pressedPointers++;
    _updateBrowserContextMenuHold();
  }

  void _handlePointerUpOrCancel(PointerEvent event) {
    if (!kIsWeb || _pressedPointers == 0) return;
    _pressedPointers--;
    // The gesture focuses the input after the pointer goes up, so the hold is
    // updated after the next frame, once that focus change has been applied.
    WidgetsBinding.instance
      ..addPostFrameCallback((_) {
        if (mounted) _updateBrowserContextMenuHold();
      })
      ..scheduleFrame();
  }

  void _setHoldsBrowserContextMenu(bool holds) {
    if (!kIsWeb || holds == _holdsBrowserContextMenu) return;
    _holdsBrowserContextMenu = holds;
    if (!holds) {
      _BrowserContextMenuGuard.release();
      return;
    }

    unawaited(
      _BrowserContextMenuGuard.acquire().then((_) {
        if (!mounted || !_holdsBrowserContextMenu) return;
        setState(() {
          _contextMenuBuilder = (context, editableTextState) =>
              _buildContextMenu(context, editableTextState);
        });
      }),
    );
  }

  /// Replaces the current code with the clipboard text.
  ///
  /// The text is filtered with the same rules as typed input and cut to
  /// [VerificationCodeInput.length], so it behaves like pasting into the
  /// field. Whitespace is removed first, so codes copied with surrounding
  /// spaces or line breaks still fit.
  Future<void> _pasteFromClipboard() async {
    final ClipboardData? data;
    try {
      data = await Clipboard.getData(Clipboard.kTextPlain);
    } on PlatformException {
      // The clipboard can't be read, e.g. the user denied the permission.
      return;
    }
    if (!mounted || widget.isLoading) return;

    final text = data?.text;
    if (text == null) return;

    final code = _inputFormatters
        .apply(text.replaceAll(RegExp(r'\s'), ''))
        .characters
        .take(widget.length)
        .toString();
    if (code.isEmpty) return;

    widget.verificationCodeController.value = TextEditingValue(
      text: code,
      selection: TextSelection.collapsed(offset: code.length),
    );

    if (code.characters.length < widget.length) {
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cursorColor =
        TextSelectionTheme.of(context).cursorColor ?? theme.colorScheme.primary;

    final pinInput = LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = constraints.maxWidth / widget.length;

        final idpTheme = theme.idpTheme;
        final defaultPinTheme = idpTheme.defaultPinTheme.copyWith(
          width: itemWidth,
        );
        final focusedPinTheme = idpTheme.focusedPinTheme.copyWith(
          width: itemWidth,
        );
        final errorPinTheme = idpTheme.errorPinTheme.copyWith(width: itemWidth);

        final inputFormatters = _inputFormatters;
        final fontSize =
            (focusedPinTheme.textStyle ?? DefaultTextStyle.of(context).style)
                .fontSize ??
            14;

        return Container(
          height: math.max(itemWidth, 48),
          alignment: Alignment.center,
          child: Listener(
            onPointerDown: _handlePointerDown,
            onPointerUp: _handlePointerUpOrCancel,
            onPointerCancel: _handlePointerUpOrCancel,
            child: Pinput(
              controller: widget.verificationCodeController,
              length: widget.length,
              showCursor: true,
              // The cursor blinks by itself, see [_PinCursor].
              isCursorAnimationEnabled: false,
              cursor: _PinCursor(color: cursorColor, height: fontSize * 1.4),
              enableInteractiveSelection: true,
              contextMenuBuilder: _contextMenuBuilder,
              keyboardType: widget.keyboardType,
              textCapitalization:
                  widget.allowedLetterCase == LetterCase.uppercase
                  ? TextCapitalization.characters
                  : TextCapitalization.none,
              inputFormatters: inputFormatters,
              // Pinput reads the clipboard when it is mounted and when the app
              // resumes. Browsers only allow clipboard reads after a user
              // gesture, so on the web this would ask for the clipboard
              // permission when the form opens, or fail. The paste button
              // covers the web instead.
              onClipboardFound: kIsWeb
                  ? null
                  : (value) {
                      if (value.length != widget.length) return;
                      final formattedValue = inputFormatters.apply(value);
                      if (formattedValue.length != value.length) return;
                      if (_completedCodes.contains(formattedValue)) return;

                      setState(() {
                        widget.verificationCodeController.text = formattedValue;
                      });
                    },
              separatorBuilder: (index) => idpTheme.separator,
              autofocus: true,
              enabled: !widget.isLoading,
              focusNode: _focusNode,
              defaultPinTheme: defaultPinTheme,
              onCompleted: (code) {
                _completedCodes.add(code);
                widget.onCompleted();
              },
              focusedPinTheme: focusedPinTheme,
              errorPinTheme: errorPinTheme,
            ),
          ),
        );
      },
    );

    if (!widget.showPasteButton) return pinInput;

    // The button sits next to the pins instead of below them, so the input
    // keeps its height in forms with a fixed height.
    return Row(
      children: [
        Expanded(child: pinInput),
        // Keeps the input focused when the button is tapped, so the keyboard
        // stays open on mobile.
        TextFieldTapRegion(
          child: IconButton(
            onPressed: widget.isLoading ? null : _pasteFromClipboard,
            tooltip: MaterialLocalizations.of(context).pasteButtonLabel,
            icon: const Icon(Icons.content_paste),
          ),
        ),
      ],
    );
  }
}

/// The text cursor shown in the active pin while the input is focused.
///
/// Blinks with a timer, like [EditableText], instead of a repeating animation,
/// so `WidgetTester.pumpAndSettle` still settles while the input is focused.
/// Does not blink when the platform asks to disable animations.
class _PinCursor extends StatefulWidget {
  const _PinCursor({required this.color, required this.height});

  final Color color;
  final double height;

  @override
  State<_PinCursor> createState() => _PinCursorState();
}

class _PinCursorState extends State<_PinCursor> {
  static const _blinkHalfPeriod = Duration(milliseconds: 500);

  Timer? _blinkTimer;
  bool _visible = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _blinkTimer?.cancel();
    _visible = true;
    _blinkTimer = MediaQuery.disableAnimationsOf(context)
        ? null
        : Timer.periodic(_blinkHalfPeriod, (_) {
            setState(() => _visible = !_visible);
          });
  }

  @override
  void dispose() {
    _blinkTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 2,
      height: widget.height,
      child: _visible ? ColoredBox(color: widget.color) : null,
    );
  }
}

/// Disables the browser context menu on the web while at least one
/// [VerificationCodeInput] holds it.
///
/// Flutter only shows its own text selection toolbar, which has the paste
/// action, when the browser context menu is disabled. In iOS Safari the
/// browser menu never opens on the input either, so without this a long press
/// offers no way to paste.
///
/// The menu is only enabled again if this guard disabled it. Changing the menu
/// is asynchronous, and [BrowserContextMenu.enabled] only changes when a change
/// completes, so an enable of the guard that is still running does not count
/// as the app having disabled the menu.
abstract final class _BrowserContextMenuGuard {
  static int _holders = 0;
  static bool _disabledByGuard = false;
  static Future<void> _disabling = Future<void>.value();
  static Future<void>? _enabling;

  /// Adds a holder and completes when the browser menu is disabled.
  static Future<void> acquire() {
    _holders++;
    if (_disabledByGuard) return _disabling;
    if (_enabling == null && !BrowserContextMenu.enabled) {
      // The app disabled the menu itself.
      return Future<void>.value();
    }
    _disabledByGuard = true;
    return _disabling = BrowserContextMenu.disableContextMenu();
  }

  /// Removes a holder and enables the browser menu again after the last one.
  static void release() {
    _holders--;
    if (_holders > 0 || !_disabledByGuard) return;
    _disabledByGuard = false;
    final enabling = _enabling = BrowserContextMenu.enableContextMenu();
    unawaited(
      enabling.whenComplete(() {
        if (identical(_enabling, enabling)) _enabling = null;
      }),
    );
  }
}

extension on List<TextInputFormatter> {
  String apply(String value) {
    var formatted = TextEditingValue(text: value);
    for (var formatter in this) {
      formatted = formatter.formatEditUpdate(formatted, formatted);
    }
    return formatted.text;
  }
}
