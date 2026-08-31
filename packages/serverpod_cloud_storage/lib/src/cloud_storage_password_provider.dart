/// Password callbacks used by storage providers that load credential.
///
/// [getPassword] retrieves a password by its configured key. [loadPasswords] registers mappings
/// between environment variable names and password aliases.
class CloudStoragePasswordProvider {
  /// Creates a password provider backed by [getPassword] and [loadPasswords].
  const CloudStoragePasswordProvider({
    required this.getPassword,
    required this.loadPasswords,
  });

  /// Retrieves a password by key, returning `null` when it is unavailable.
  final String? Function(String key) getPassword;

  /// Registers environment variable names and their corresponding aliases.
  final void Function(List<({String envName, String alias})> envPasswords)
  loadPasswords;
}
