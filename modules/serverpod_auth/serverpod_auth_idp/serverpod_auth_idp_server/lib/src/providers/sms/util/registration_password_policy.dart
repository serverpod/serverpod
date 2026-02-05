/// The default password policy for SMS registration.
///
/// Enforces no outer whitespace and a minimum length of 8 characters.
bool defaultSmsRegistrationPasswordValidationFunction(final String password) {
  return password.trim() == password && password.length >= 8;
}
