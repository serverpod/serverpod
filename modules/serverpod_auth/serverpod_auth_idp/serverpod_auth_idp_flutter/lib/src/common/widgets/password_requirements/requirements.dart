import 'texts.dart';

// Convenience exports for external use.
export 'texts.dart';

/// Represents a single password requirement.
///
/// Use the named factories ([PasswordRequirement.minLength], etc.) for
/// built-in rules, or `PasswordRequirement(description:, validator:)` for a
/// custom description and validator. Built-in rules use typed subclasses so
/// localization can switch
/// on the concrete type; custom rules localize by matching [description]
/// against [PasswordRequirementTexts.defaults] when possible.
abstract class PasswordRequirement {
  const PasswordRequirement._();

  /// The text description of the requirement (e.g., "At least 1 uppercase").
  ///
  /// For built-in factories this matches [PasswordRequirementTexts.defaults].
  /// For display, [PasswordRequirement.localized] replaces known English
  /// defaults with the active [PasswordRequirementTexts] localization. Custom
  /// strings are matched when possible, otherwise shown as-is.
  String get description;

  /// Returns whether [password] satisfies this requirement.
  bool validate(String password);

  /// Function to check if the password meets this requirement.
  bool Function(String password) get validator => validate;

  /// Regular expression for lowercase letters.
  static final lowercaseLetters = RegExp(r'[a-z]');

  /// Regular expression for uppercase letters.
  static final uppercaseLetters = RegExp(r'[A-Z]');

  /// Regular expression for numbers.
  static final numbers = RegExp(r'[0-9]');

  /// Regular expression for special characters.
  ///
  /// Matches the OWASP-recommended printable ASCII special character set.
  /// See https://owasp.org/www-community/password-special-characters
  static final specialCharacters = RegExp(
    r'''[ !"#$%&'()*+,\-./:;<=>?@\[\\\]^_`{|}~]''',
  );

  /// Regular expression for all allowed characters.
  ///
  /// Matches letters, digits, and the OWASP-recommended printable ASCII
  /// special character set.
  static final allowedCharacters = RegExp(
    r'''[a-zA-Z0-9 !"#$%&'()*+,\-./:;<=>?@\[\\\]^_`{|}~]''',
  );

  /// Creates a custom requirement with a free-form [description] and
  /// [validator].
  factory PasswordRequirement({
    required String description,
    required bool Function(String password) validator,
  }) = CustomPasswordRequirement.new;

  /// Creates a [PasswordRequirement] for a minimum length.
  factory PasswordRequirement.minLength(int length) =>
      MinLengthPasswordRequirement(length);

  /// Creates a [PasswordRequirement] for a maximum length.
  factory PasswordRequirement.maxLength(int length) =>
      MaxLengthPasswordRequirement(length);

  /// Creates a [PasswordRequirement] for at least one lowercase letter.
  factory PasswordRequirement.containsLowercase() =>
      const ContainsLowercasePasswordRequirement();

  /// Creates a [PasswordRequirement] for at least one uppercase letter.
  factory PasswordRequirement.containsUppercase() =>
      const ContainsUppercasePasswordRequirement();

  /// Creates a [PasswordRequirement] for at least one number.
  factory PasswordRequirement.containsNumber() =>
      const ContainsNumberPasswordRequirement();

  /// Creates a [PasswordRequirement] for at least one special character.
  factory PasswordRequirement.containsSpecialCharacter() =>
      const ContainsSpecialCharacterPasswordRequirement();

  /// Static list of default password requirements.
  static final List<PasswordRequirement> defaultRequirements = [
    PasswordRequirement.minLength(12),
    PasswordRequirement.containsUppercase(),
    PasswordRequirement.containsLowercase(),
    PasswordRequirement.containsNumber(),
    PasswordRequirement.containsSpecialCharacter(),
  ];

  /// Localized label for [requirement] using [texts].
  ///
  /// Built-in requirement types are mapped by class. Custom requirements and
  /// user-defined subclasses fall back to matching [description] against
  /// [PasswordRequirementTexts.defaults] (same behavior as legacy APIs).
  static String localized(
    PasswordRequirement requirement,
    PasswordRequirementTexts texts,
  ) {
    return switch (requirement) {
      MinLengthPasswordRequirement(:final length) => texts.minLength(length),
      MaxLengthPasswordRequirement(:final length) => texts.maxLength(length),
      ContainsLowercasePasswordRequirement() => texts.containsLowercase,
      ContainsUppercasePasswordRequirement() => texts.containsUppercase,
      ContainsNumberPasswordRequirement() => texts.containsNumber,
      ContainsSpecialCharacterPasswordRequirement() =>
        texts.containsSpecialCharacter,
      _ => requirement.description,
    };
  }
}

/// Minimum password length.
final class MinLengthPasswordRequirement extends PasswordRequirement {
  /// Creates a minimum-length requirement.
  const MinLengthPasswordRequirement(this.length) : super._();

  /// Required minimum number of characters.
  final int length;

  @override
  String get description => PasswordRequirementTexts.defaults.minLength(length);

  @override
  bool validate(String password) => password.length >= length;
}

/// Maximum password length.
final class MaxLengthPasswordRequirement extends PasswordRequirement {
  /// Creates a maximum-length requirement.
  const MaxLengthPasswordRequirement(this.length) : super._();

  /// Allowed maximum number of characters.
  final int length;

  @override
  String get description => PasswordRequirementTexts.defaults.maxLength(length);

  @override
  bool validate(String password) => password.length <= length;
}

/// At least one lowercase letter.
final class ContainsLowercasePasswordRequirement extends PasswordRequirement {
  /// Creates a lowercase-letter requirement.
  const ContainsLowercasePasswordRequirement() : super._();

  @override
  String get description => PasswordRequirementTexts.defaults.containsLowercase;

  @override
  bool validate(String password) =>
      password.contains(PasswordRequirement.lowercaseLetters);
}

/// At least one uppercase letter.
final class ContainsUppercasePasswordRequirement extends PasswordRequirement {
  /// Creates an uppercase-letter requirement.
  const ContainsUppercasePasswordRequirement() : super._();

  @override
  String get description => PasswordRequirementTexts.defaults.containsUppercase;

  @override
  bool validate(String password) =>
      password.contains(PasswordRequirement.uppercaseLetters);
}

/// At least one digit.
final class ContainsNumberPasswordRequirement extends PasswordRequirement {
  /// Creates a digit requirement.
  const ContainsNumberPasswordRequirement() : super._();

  @override
  String get description => PasswordRequirementTexts.defaults.containsNumber;

  @override
  bool validate(String password) =>
      password.contains(PasswordRequirement.numbers);
}

/// At least one special character.
final class ContainsSpecialCharacterPasswordRequirement
    extends PasswordRequirement {
  /// Creates a special-character requirement.
  const ContainsSpecialCharacterPasswordRequirement() : super._();

  @override
  String get description =>
      PasswordRequirementTexts.defaults.containsSpecialCharacter;

  @override
  bool validate(String password) =>
      password.contains(PasswordRequirement.specialCharacters);
}

/// Custom requirement from a [description] string and [validator] closure.
class CustomPasswordRequirement extends PasswordRequirement {
  /// Creates a custom password requirement.
  CustomPasswordRequirement({
    required this.description,
    required bool Function(String password) validator,
  }) : _validator = validator,
       super._();

  @override
  final String description;

  final bool Function(String) _validator;

  @override
  bool validate(String password) => _validator(password);
}

/// Extension on [List<PasswordRequirement>] to provide convenience methods.
extension PasswordRequirementsExtension on List<PasswordRequirement> {
  /// Returns true if the password is empty or meets all requirements.
  bool isValid(String password) =>
      isEmpty ||
      (isNotEmpty && every((requirement) => requirement.validator(password)));
}
