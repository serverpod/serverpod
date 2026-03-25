import 'package:flutter/widgets.dart';

import '../../../localization/sign_in_localization_provider_widget.dart';

/// Localized strings for password rule labels (e.g. minimum length, character
/// classes).
@immutable
class PasswordRequirementTexts {
  /// Creates [PasswordRequirementTexts].
  const PasswordRequirementTexts({
    required this.minLengthTemplate,
    required this.maxLengthTemplate,
    required this.containsLowercase,
    required this.containsUppercase,
    required this.containsNumber,
    required this.containsSpecialCharacter,
  });

  /// Default English strings.
  static const defaults = PasswordRequirementTexts(
    minLengthTemplate: 'At least {length} characters',
    maxLengthTemplate: 'At most {length} characters',
    containsLowercase: 'Contains at least one lowercase letter',
    containsUppercase: 'Contains at least one uppercase letter',
    containsNumber: 'Contains at least one number',
    containsSpecialCharacter: 'Contains at least one special character',
  );

  /// Template for minimum length. Use `{length}` as a placeholder.
  final String minLengthTemplate;

  /// Template for maximum length. Use `{length}` as a placeholder.
  final String maxLengthTemplate;

  /// Label when the password must contain a lowercase letter.
  final String containsLowercase;

  /// Label when the password must contain an uppercase letter.
  final String containsUppercase;

  /// Label when the password must contain a digit.
  final String containsNumber;

  /// Label when the password must contain a special character.
  final String containsSpecialCharacter;

  /// Localized description for a minimum length rule using [minLengthTemplate].
  String minLength(int length) =>
      minLengthTemplate.replaceAll('{length}', '$length');

  /// Localized description for a maximum length rule using [maxLengthTemplate].
  String maxLength(int length) =>
      maxLengthTemplate.replaceAll('{length}', '$length');

  /// Creates a copy with the given fields replaced.
  PasswordRequirementTexts copyWith({
    String? minLengthTemplate,
    String? maxLengthTemplate,
    String? containsLowercase,
    String? containsUppercase,
    String? containsNumber,
    String? containsSpecialCharacter,
  }) {
    return PasswordRequirementTexts(
      minLengthTemplate: minLengthTemplate ?? this.minLengthTemplate,
      maxLengthTemplate: maxLengthTemplate ?? this.maxLengthTemplate,
      containsLowercase: containsLowercase ?? this.containsLowercase,
      containsUppercase: containsUppercase ?? this.containsUppercase,
      containsNumber: containsNumber ?? this.containsNumber,
      containsSpecialCharacter:
          containsSpecialCharacter ?? this.containsSpecialCharacter,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PasswordRequirementTexts &&
        other.minLengthTemplate == minLengthTemplate &&
        other.maxLengthTemplate == maxLengthTemplate &&
        other.containsLowercase == containsLowercase &&
        other.containsUppercase == containsUppercase &&
        other.containsNumber == containsNumber &&
        other.containsSpecialCharacter == containsSpecialCharacter;
  }

  @override
  int get hashCode => Object.hash(
    minLengthTemplate,
    maxLengthTemplate,
    containsLowercase,
    containsUppercase,
    containsNumber,
    containsSpecialCharacter,
  );
}

/// Convenience getter for [PasswordRequirementTexts] on [BuildContext].
extension PasswordRequirementTextsBuildContextExtension on BuildContext {
  /// Returns Apple Sign-In texts from context or defaults.
  PasswordRequirementTexts get passwordRequirementTexts =>
      SignInLocalizationProvider.maybeOf(this)?.passwordRequirementTexts ??
      PasswordRequirementTexts.defaults;
}
