import '../../utils/default_code_generators.dart'
    as shared_default_code_generators;

/// Returns a secure random string to be used for short-lived verification codes.
///
/// Excludes the digit 0 to avoid confusion with the letter 'o'.
String defaultVerificationCodeGenerator({final int length = 8}) {
  return shared_default_code_generators.defaultNumericVerificationCodeGenerator(
    length: length,
  );
}
