import 'package:serverpod/src/database/concepts/database_result.dart';
import 'package:postgres/postgres.dart' as pg;

class _PostgresDatabaseResultSchemaColumn
    implements DatabaseResultSchemaColumn {
  @override
  final String? columnName;

  _PostgresDatabaseResultSchemaColumn({required this.columnName});
}

class _PostgresDatabaseResultSchema implements DatabaseResultSchema {
  final pg.PostgreSQLResult _result;

  _PostgresDatabaseResultSchema(this._result);

  @override
  Iterable<DatabaseResultSchemaColumn> get columns => _result.columnDescriptions
      .map((columnDescription) => _PostgresDatabaseResultSchemaColumn(
            columnName: columnDescription.columnName,
          ));
}

class _PostgresDatabaseResultRow extends DatabaseResultRow {
  final pg.PostgreSQLResultRow _row;

  _PostgresDatabaseResultRow(pg.PostgreSQLResultRow super.row) : _row = row;

  @override
  Map<String, dynamic> toColumnMap() {
    return _row.toColumnMap();
  }
}

/// A postgres database result.
class PostgresDatabaseResult extends DatabaseResult {
  final pg.PostgreSQLResult _result;

  /// Creates a new database result from a postgres result.
  PostgresDatabaseResult(pg.PostgreSQLResult result)
      : _result = result,
        super(result.map((row) => _PostgresDatabaseResultRow(row)));

  @override
  int get affectedRowCount => _result.affectedRowCount;

  @override
  DatabaseResultSchema get schema => _PostgresDatabaseResultSchema(_result);
}
