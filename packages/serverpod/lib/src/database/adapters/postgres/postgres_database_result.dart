import 'package:serverpod/src/database/concepts/database_result.dart';
import 'package:postgres/postgres.dart' as pg;

class _PostgresDatabaseResultSchemaColumn
    implements DatabaseResultSchemaColumn {
  @override
  final String? columnName;

  _PostgresDatabaseResultSchemaColumn({required this.columnName});
}

class _PostgresDatabaseResultSchema implements DatabaseResultSchema {
  final pg.ResultSchema _schema;

  _PostgresDatabaseResultSchema(this._schema);

  @override
  Iterable<DatabaseResultSchemaColumn> get columns =>
      _schema.columns.map((columnSchema) => _PostgresDatabaseResultSchemaColumn(
            columnName: columnSchema.columnName,
          ));
}

class _PostgresDatabaseResultRow extends DatabaseResultRow {
  final pg.ResultRow _row;

  _PostgresDatabaseResultRow(pg.ResultRow super.row) : _row = row;

  @override
  Map<String, dynamic> toColumnMap() {
    return _row.toColumnMap();
  }
}

/// A postgres database result.
class PostgresDatabaseResult extends DatabaseResult {
  final pg.Result _result;

  /// Creates a new database result from a postgres result.
  PostgresDatabaseResult(pg.Result result)
      : _result = result,
        super(result.map((row) => _PostgresDatabaseResultRow(row)));

  @override
  int get affectedRowCount => _result.affectedRows;

  @override
  DatabaseResultSchema get schema =>
      _PostgresDatabaseResultSchema(_result.schema);
}
