/// Defines how the transaction parameter should be generated in repository methods.
enum TransactionParameterMode {
  /// The transaction parameter is optional and can be omitted.
  optional,

  /// The transaction parameter is required but nullable.
  /// This forces developers to explicitly pass null or a transaction object.
  required,
}

/// Configuration options for database-related code generation.
///
/// This class encapsulates database-specific generator settings and can be
/// expanded with additional options without bloating the main [GeneratorConfig].
class DatabaseConfig {
  /// Defines how the transaction parameter should be generated in repository
  /// methods.
  final TransactionParameterMode transactionParameterMode;

  const DatabaseConfig({
    this.transactionParameterMode = TransactionParameterMode.optional,
  });

  /// Default database configuration with optional transaction parameters.
  static const defaultConfig = DatabaseConfig();
}
