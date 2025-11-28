import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

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
class DatabaseGeneratorOptions {
  /// Defines how the transaction parameter should be generated in repository
  /// methods.
  final TransactionParameterMode transactionParameterMode;

  const DatabaseGeneratorOptions({
    this.transactionParameterMode = TransactionParameterMode.optional,
  });

  /// Default database generator options with optional transaction parameters.
  static const defaultOptions = DatabaseGeneratorOptions();

  /// Parses [DatabaseGeneratorOptions] from a YAML database config map.
  static DatabaseGeneratorOptions parse(Map? database) {
    if (database == null) return defaultOptions;

    var transactionParameterMode = _parseTransactionParameterMode(database);

    return DatabaseGeneratorOptions(
      transactionParameterMode: transactionParameterMode,
    );
  }

  static TransactionParameterMode _parseTransactionParameterMode(
    Map database,
  ) {
    var transactionParameter = database['transaction_parameter'];
    if (transactionParameter == null) return TransactionParameterMode.optional;

    if (transactionParameter == 'required') {
      return TransactionParameterMode.required;
    } else if (transactionParameter == 'optional') {
      return TransactionParameterMode.optional;
    } else {
      log.warning(
        'Invalid value \'$transactionParameter\' for '
        '\'generator.database.transaction_parameter\'. '
        'Expected \'required\' or \'optional\'. '
        'Using default value \'optional\'.',
      );
      return TransactionParameterMode.optional;
    }
  }
}

/// Container for all generator options parsed from the `generator` section
/// of the configuration file.
///
/// This class provides a structured way to access various generator options
/// and can be expanded with additional sub-option classes in the future.
class GeneratorOptions {
  /// Database-specific generator options.
  final DatabaseGeneratorOptions database;

  const GeneratorOptions({
    this.database = DatabaseGeneratorOptions.defaultOptions,
  });

  /// Default generator options.
  static const defaultOptions = GeneratorOptions();

  /// Parses [GeneratorOptions] from a YAML config map.
  static GeneratorOptions parse(Map config) {
    var generator = config['generator'];
    if (generator is! Map) return defaultOptions;

    var database = generator['database'];
    var databaseOptions = DatabaseGeneratorOptions.parse(
      database is Map ? database : null,
    );

    return GeneratorOptions(database: databaseOptions);
  }
}
