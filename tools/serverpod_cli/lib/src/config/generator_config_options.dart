/// Defines how the transaction parameter should be generated in repository methods.
enum TransactionParameterMode {
  /// The transaction parameter is optional and can be omitted.
  optional,

  /// The transaction parameter is required but nullable.
  /// This forces developers to explicitly pass null or a transaction object.
  required,
}
