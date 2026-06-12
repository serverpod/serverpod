import 'package:sqlite3/common.dart';

import '../../concepts/database_result.dart';

class _SqliteDatabaseResultSchemaColumn implements DatabaseResultSchemaColumn {
  @override
  final String? columnName;

  _SqliteDatabaseResultSchemaColumn({required this.columnName});
}

class _SqliteDatabaseResultSchema implements DatabaseResultSchema {
  final List<String> _columnNames;

  _SqliteDatabaseResultSchema(this._columnNames);

  @override
  Iterable<DatabaseResultSchemaColumn> get columns => _columnNames.map(
    (name) => _SqliteDatabaseResultSchemaColumn(columnName: name),
  );
}

class _SqliteDatabaseResultRow extends DatabaseResultRow {
  final Map<String, dynamic> _columnMap;

  _SqliteDatabaseResultRow(Row row)
    : _columnMap = Map<String, dynamic>.from(row),
      super(row.values);

  @override
  Map<String, dynamic> toColumnMap() => _columnMap;
}

/// A SQLite database result.
class SqliteDatabaseResult extends DatabaseResult {
  final ResultSet _result;

  /// Creates a new database result from a sqlite3 result set.
  SqliteDatabaseResult(this._result)
    : super(_result.map((row) => _SqliteDatabaseResultRow(row)));

  @override
  int get affectedRowCount => _result.length;

  @override
  DatabaseResultSchema get schema =>
      _SqliteDatabaseResultSchema(_result.columnNames);
}
