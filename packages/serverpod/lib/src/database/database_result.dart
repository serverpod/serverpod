import 'package:serverpod/database.dart';

/// Prepares a query result for serverpod serialization.
Map<String, dynamic>? resolvePrefixedQueryRow(
  Table table,
  Map<String, Map<String, dynamic>> rawRow, {
  Include? include,
  bool lookupWithColumnName = false,
}) {
  // Resolve this object.
  var rawTableRow = rawRow[table.tableName];
  if (rawTableRow == null) return null;

  var resolvedTableRow = _createColumnMapFromPrefixedColumns(
    table.columns,
    rawTableRow,
    lookupWithColumnName,
  );

  if (resolvedTableRow.isEmpty) {
    return null;
  }

  // Resolve all includes for the object.
  include?.includes.forEach((relationField, relationInclude) {
    if (relationInclude == null) return;

    var relationTable = table.getRelationTable(relationField);
    if (relationTable == null) return;

    resolvedTableRow[relationField] = resolvePrefixedQueryRow(
      relationTable,
      rawRow,
      include: relationInclude,
    );
  });

  return resolvedTableRow;
}

Map<String, dynamic> _createColumnMapFromPrefixedColumns(
  List<Column> columns,
  Map<String, dynamic> rawTableRow,
  lookupWithColumnName,
) {
  var columnMap = <String, dynamic>{};
  for (var column in columns) {
    var columnData = lookupWithColumnName
        ? rawTableRow[column.columnName]
        : rawTableRow[column.queryAlias];
    if (columnData != null) {
      columnMap[column.columnName] = columnData;
    }
  }

  return columnMap;
}
