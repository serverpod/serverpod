import '../../utils/default_code_generators.dart'
    as shared_default_code_generators;

/// Returns a secure random numeric string to be used for passwordless
/// verification codes.
///
/// Excludes the digit 0 to avoid confusion with the letter 'o'.
String defaultPasswordlessVerificationCodeGenerator({final int length = 8}) {
  return shared_default_code_generators.defaultNumericVerificationCodeGenerator(
    length: length,
  );
}
