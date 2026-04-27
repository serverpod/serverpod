import '../../serverpod_database.dart';

/// Restrictions on the database definition for the current dialect.
class DatabaseDefinitionRestrictions {
  /// Creates a new [DatabaseDefinitionRestrictions] for the current dialect.
  const DatabaseDefinitionRestrictions({this.supportedIndexTypes});

  /// List of supported index types for the current dialect.
  ///
  /// If null, all index types are supported (default).
  final List<String>? supportedIndexTypes;
}

/// Extensions on [DatabaseDefinitionRestrictions] to adapt the database
/// definition for the current dialect.
extension DatabaseDefinitionRestrictionsEx on DatabaseDefinition {
  /// Gets the database definition for the current dialect.
  ///
  /// Pass a [logWarnings] function to log warnings about unsupported elements
  /// on SQL generation.
  DatabaseDefinition forDialect(
    DatabaseDialect dialect, {
    required Function(String)? logWarnings,
  }) => copyWith(
    tables: tables.forDialect(dialect, logWarnings: logWarnings),
  );
}

/// Extensions on [TableDefinition] to adapt the table definition for the
/// current dialect.
extension TableDefinitionRestrictionsEx on List<TableDefinition> {
  /// Gets the table definition for the current dialect.
  ///
  /// Pass a [logWarnings] function to log warnings about unsupported indexes.
  /// This should only be used when calling [forDialect] from a context where
  /// migration SQL is being generated.
  List<TableDefinition> forDialect(
    DatabaseDialect dialect, {
    Function(String)? logWarnings,
  }) {
    final provider = DatabaseProvider.forDialect(dialect);
    final restrictions = provider.definitionRestrictions;
    final supportedIndexTypes = restrictions.supportedIndexTypes;

    if (supportedIndexTypes == null) {
      return this;
    }

    final unsupportedIndexes = map(
      (t) => t.indexes
          .where((i) => !supportedIndexTypes.contains(i.type))
          .toList(),
    ).expand((t) => t).toList();

    if (unsupportedIndexes.isEmpty) return this;

    logWarnings?.call(
      'The following indexes will be skipped due to unsupported types by the '
      'database dialect "${dialect.name}":\n'
      '${unsupportedIndexes.map((i) => '  - ${i.indexName} (${i.type})').join('\n')}',
    );

    return [
      for (var t in this)
        t.copyWith(
          indexes: t.indexes
              .where((i) => supportedIndexTypes.contains(i.type))
              .toList(),
        ),
    ];
  }
}
