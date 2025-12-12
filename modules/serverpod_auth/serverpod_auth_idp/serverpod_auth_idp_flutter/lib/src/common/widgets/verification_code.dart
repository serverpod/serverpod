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

class _VerificationCodeInputState extends State<VerificationCodeInput> {
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

        final allowedCharactersPattern = widget.allowedCharactersPattern;
        final inputFormatters = [
          LetterCaseTextFormatter(letterCase: widget.allowedLetterCase),
          if (allowedCharactersPattern != null)
            FilteringTextInputFormatter.allow(allowedCharactersPattern),
        ];

        return Container(
          height: math.max(itemWidth, 48),
          alignment: Alignment.center,
          child: Pinput(
            controller: widget.verificationCodeController,
            length: widget.length,
            showCursor: false,
            enableInteractiveSelection: true,
            keyboardType: widget.keyboardType,
            textCapitalization: widget.allowedLetterCase == LetterCase.uppercase
                ? TextCapitalization.characters
                : TextCapitalization.none,
            inputFormatters: inputFormatters,
            onClipboardFound: (value) {
              if (value.length != widget.length) return;
              final formattedValue = inputFormatters.apply(value);
              if (formattedValue.length != value.length) return;

              setState(() {
                widget.verificationCodeController.text = formattedValue;
              });
            },
            separatorBuilder: (index) => idpTheme.separator,
            autofocus: true,
            enabled: !widget.isLoading,
            focusNode: widget.focusNode,
            defaultPinTheme: defaultPinTheme,
            onCompleted: (_) => widget.onCompleted(),
            focusedPinTheme: focusedPinTheme,
            errorPinTheme: errorPinTheme,
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
