import 'package:flutter/services.dart';

/// The case of letters allowed in the text formatter.
enum LetterCase {
  /// Only lowercase letters are allowed.
  lowercase,

  /// Only uppercase letters are allowed.
  uppercase,

  /// Both lowercase and uppercase letters are allowed.
  mixed,
}

/// A text formatter that converts the input to the specified letter case.
class LetterCaseTextFormatter extends TextInputFormatter {
  /// The case of letters allowed in the text formatter.
  final LetterCase letterCase;

  /// Creates a new [LetterCaseTextFormatter].
  const LetterCaseTextFormatter({
    required this.letterCase,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    switch (letterCase) {
      case LetterCase.lowercase:
        return newValue.copyWith(text: newValue.text.toLowerCase());
      case LetterCase.uppercase:
        return newValue.copyWith(text: newValue.text.toUpperCase());
      case LetterCase.mixed:
        return newValue;
    }
  }
}
