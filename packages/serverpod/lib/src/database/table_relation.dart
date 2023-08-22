import 'package:meta/meta.dart';
import 'package:serverpod/src/database/expressions.dart';

class _TempColumn extends Column<String> {
  _TempColumn(super.columnName, {super.queryPrefix});
}

/// Records the relation between two tables.
@internal
class TableRelation {
  /// Name of table.
  final String tableName;

  /// Foreign table relation column.
  final Column foreignTableColumn;

  /// Relation column.
  final Column column;

  /// Query prefix for the relation.
  final String queryPrefix;

  /// Retrieves the name of the table with the query prefix applied.
  String get tableNameWithQueryPrefix => '$queryPrefix$tableName';

  /// Creates a new [TableRelation] from the perspective of the foreign table.
  factory TableRelation.foreign({
    required String foreignTableName,
    required Column column,
    required String foreignColumnName,
    required String relationQueryPrefix,
  }) {
    return TableRelation(
      tableName: foreignTableName,
      foreignTableColumn: column,
      column: _TempColumn(
        foreignColumnName,
        queryPrefix: '$relationQueryPrefix$foreignTableName',
      ),
      queryPrefix: relationQueryPrefix,
    );
  }

  /// Creates a new [TableRelation].
  const TableRelation({
    required this.tableName,
    required this.foreignTableColumn,
    required this.column,
    required this.queryPrefix,
  });
}
