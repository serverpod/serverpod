import 'dart:collection';

/// Database result schema column.
abstract interface class DatabaseResultSchemaColumn {
  /// Returns the name of the column.
  String? get columnName;
}

/// Database result schema.
abstract interface class DatabaseResultSchema {
  /// Returns the columns schemas of the result.
  Iterable<DatabaseResultSchemaColumn> get columns;
}

/// Database result row.
abstract class DatabaseResultRow extends UnmodifiableListView<dynamic> {
  /// Creates a new database result row.
  DatabaseResultRow(super.values);

  /// Returns a single-level map that maps the column name to the value
  /// returned on that position. When multiple columns have the same name,
  /// the later may override the previous values.
  Map<String, dynamic> toColumnMap();
}

/// Database result.
abstract class DatabaseResult extends UnmodifiableListView<DatabaseResultRow> {
  /// Creates a new database result.
  DatabaseResult(super.rows);

  /// Returns the number of rows that where affected by the query.
  int get affectedRowCount;

  /// Returns the schema of the result.
  DatabaseResultSchema get schema;
}
