import '../../../serverpod_database.dart';

/// Collects SQLite table names that should trigger a typed [Database.watch]
/// re-query.
///
/// The queried [table], [where], [orderBy], and [include] graph are inspected.
/// [extraTables] is added to that set. Raw [Expression] SQL is not inspected.
Set<String> collectWatchTriggerTables({
  required Table table,
  Expression? where,
  List<Order>? orderBy,
  Include? include,
  Iterable<Table>? extraTables,
}) {
  var tables = <String>{};
  _addWatchTriggerTable(tables, table);
  _addWatchTriggerExpression(tables, where);
  orderBy?.forEach((column) => _addWatchTriggerColumn(tables, column));
  _addWatchTriggerInclude(tables, include);
  extraTables?.forEach((table) {
    tables.add(table.unqualifiedTableName);
  });
  return tables;
}

void _addWatchTriggerTable(Set<String> tables, Table? table) {
  if (table == null) return;
  if (!tables.add(table.unqualifiedTableName)) return;
  var relation = table.tableRelation;
  if (relation == null) return;
  for (var hop in relation.getRelations) {
    _addWatchTriggerTable(tables, hop.fieldTable);
    _addWatchTriggerTable(tables, hop.foreignTable);
  }
}

void _addWatchTriggerColumn(Set<String> tables, Column? column) {
  if (column == null) return;
  if (column is Order) {
    _addWatchTriggerColumn(tables, column.column);
    return;
  }
  _addWatchTriggerTable(tables, column.table);
  if (column is ColumnCount) {
    _addWatchTriggerExpression(tables, column.innerWhere);
  }
}

void _addWatchTriggerExpression(Set<String> tables, Expression? expression) {
  if (expression == null) return;
  for (var column in expression.columns) {
    _addWatchTriggerColumn(tables, column);
  }
}

void _addWatchTriggerInclude(Set<String> tables, Include? include) {
  if (include == null) return;
  _addWatchTriggerTable(tables, include.table);
  if (include is IncludeList) {
    _addWatchTriggerExpression(tables, include.where);
    _addWatchTriggerColumn(tables, include.orderBy);
    include.orderByList?.forEach(
      (column) => _addWatchTriggerColumn(tables, column),
    );
    _addWatchTriggerInclude(tables, include.include);
  }
  for (var value in include.includes.values) {
    _addWatchTriggerInclude(tables, value);
  }
}
