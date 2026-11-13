import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

import '../../theme.dart';
import '../text_formatters.dart';

/// A widget for entering one-time verification codes (OTP).
///
/// Displays a row of pin inputs and a paste-from-clipboard button. The callback
/// [onCompleted] is invoked when the input reaches the configured [length].
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
    super.key,
  });

  @override
  State<VerificationCodeInput> createState() => _VerificationCodeInputState();
}

class _VerificationCodeInputState extends State<VerificationCodeInput>
    with WidgetsBindingObserver {
  /// Codes completed in any verification code input of the app, which are not
  /// filled in from the clipboard again, e.g. the code of a previous sign-in
  /// that is still in the clipboard when signing in again.
  static final _completedCodes = <String>{};

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
    WidgetsBinding.instance.addObserver(this);
    unawaited(_fillInFromClipboard());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(_fillInFromClipboard());
  }

  Future<void> _fillInFromClipboard() async {
    final value = (await Clipboard.getData(Clipboard.kTextPlain))?.text;
    if (!mounted || value == null || value.length != widget.length) return;
    final formattedValue = _inputFormatters.apply(value);
    if (formattedValue.length != value.length) return;
    if (_completedCodes.contains(formattedValue)) return;

    setState(() {
      widget.verificationCodeController.setText(formattedValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = constraints.maxWidth / widget.length;

        final idpTheme = Theme.of(context).idpTheme;
        final defaultPinTheme = idpTheme.defaultPinTheme.copyWith(
          width: itemWidth,
        );
        final focusedPinTheme = idpTheme.focusedPinTheme.copyWith(
          width: itemWidth,
        );
        final errorPinTheme = idpTheme.errorPinTheme.copyWith(width: itemWidth);

        return Container(
          height: math.max(itemWidth, 48),
          alignment: Alignment.center,
          child: Pinput(
            controller: widget.verificationCodeController,
            length: widget.length,
            cursor: const PinCursor.hidden(),
            enableInteractiveSelection: true,
            keyboard: PinKeyboard(
              keyboardType: widget.keyboardType,
              textCapitalization:
                  widget.allowedLetterCase == LetterCase.uppercase
                  ? TextCapitalization.characters
                  : TextCapitalization.none,
            ),
            inputFormatters: _inputFormatters,
            layout: PinLayout(
              separatorBuilder: (context, index) => idpTheme.separator,
            ),
            autofocus: true,
            inputMode: widget.isLoading
                ? PinInputMode.disabled
                : PinInputMode.editable,
            focusNode: widget.focusNode,
            theme: PinThemes(
              fallback: defaultPinTheme,
              focused: focusedPinTheme,
              error: errorPinTheme,
            ),
            onCompleted: (code) {
              _completedCodes.add(code);
              widget.onCompleted();
            },
          ),
        );
      },
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
