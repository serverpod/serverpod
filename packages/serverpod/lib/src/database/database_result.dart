import 'package:serverpod/database.dart';

/// Prepares a query result for serverpod serialization.
/// This is typically only used internally by the serverpod framework.
Map<String, dynamic>? resolvePrefixedQueryRow(
  Table table,
  Map<String, Map<String, dynamic>> rawRow,
  Map<String, Map<int, List<dynamic>>> resolvedListRelations, {
  Include? include,
}) {
  // Resolve this object.
  var rawTableRow = rawRow[table.tableName];
  if (rawTableRow == null) return null;

  var resolvedTableRow = _createColumnMapFromQueryAliasColumns(
    table.columns,
    rawTableRow,
  );

  if (resolvedTableRow.isEmpty) {
    return null;
  }

  // Resolve all includes for the object.
  include?.includes.forEach((relationField, relationInclude) {
    if (relationInclude == null) return;

    var relationTable = table.getRelationTable(relationField);
    if (relationTable == null) return;

    if (relationInclude is IncludeList) {
      var primaryKey = resolvedTableRow['id'];
      if (primaryKey is! int) {
        throw Exception('Cannot resolve list relation without id.');
      }

      resolvedTableRow[relationField] = _extractRelationalList(
        primaryKey,
        relationTable,
        resolvedListRelations,
      );
    } else {
      resolvedTableRow[relationField] = resolvePrefixedQueryRow(
        relationTable,
        rawRow,
        resolvedListRelations,
        include: relationInclude,
      );
    }
  });

  return resolvedTableRow;
}

List<dynamic> _extractRelationalList(
  int primaryKey,
  Table relationTable,
  Map<String, Map<int, List<dynamic>>> resolvedListRelations,
) {
  return resolvedListRelations[relationTable.queryPrefix]?[primaryKey] ?? [];
}

Map<String, dynamic> _createColumnMapFromQueryAliasColumns(
  List<Column> columns,
  Map<String, dynamic> rawTableRow,
) {
  var columnMap = <String, dynamic>{};
  for (var column in columns) {
    var columnData = rawTableRow[column.queryAlias];
    if (columnData != null) {
      columnMap[column.columnName] = columnData;
    }
  }

  return columnMap;
}
