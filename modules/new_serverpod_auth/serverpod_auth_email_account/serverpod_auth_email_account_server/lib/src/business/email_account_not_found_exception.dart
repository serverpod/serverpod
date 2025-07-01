/// Exception thrown for operations trying to operate on an email address for which no account exists.
///
/// This is used for internal / admin purposes only and must not be exposed to clients.
class EmailAccountNotFoundException implements Exception {
  /// Creates a new instance.
  const EmailAccountNotFoundException({
    required this.email,
  });

  /// The email address for which no account could be found.
  final String email;

  @override
  String toString() {
    return 'EmailAccountNotFoundException(email: $email)';
  }
}
