/// The default password policy for registration.
///
/// Enforcing no outer whitespace and a minimum length of 8 characters.
bool defaultRegistrationPasswordValidationFunction(final String password) {
  return password.trim() == password && password.length >= 8;
}
