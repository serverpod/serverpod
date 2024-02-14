import 'package:serverpod/database.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// Prepares a query result for serverpod serialization.
/// This is typically only used internally by the serverpod framework.
Map<String, dynamic>? resolvePrefixedQueryRow(
  Table table,
  Map<String, dynamic> rawRow,
  Map<String, Map<int, List<dynamic>>> resolvedListRelations, {
  Include? include,
}) {
  // Resolve this object.
  var resolvedTableRow = _createColumnMapFromQueryAliasColumns(
    table.columns,
    rawRow,
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
        throw ArgumentError('Cannot resolve list relation without id.');
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

/// Maps a list of query results to each id of the parent table relation by
/// the query prefix.
Map<String, Map<int, List<Map<String, dynamic>>>> mapListToQueryById(
  List<Map<String, dynamic>> resolvedList,
  Table relativeRelationTable,
  String foreignFieldName,
) {
  var mappedLists = resolvedList.fold<Map<int, List<Map<String, dynamic>>>>(
    {},
    (mappedResult, row) {
      var id = row[foreignFieldName];

      mappedResult.update(
        id,
        (value) => [...value, row],
        ifAbsent: () => [row],
      );
      return mappedResult;
    },
  );

  return {relativeRelationTable.queryPrefix: mappedLists};
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
    var queryKey = truncateIdentifier(
      column.queryAlias,
      DatabaseConstants.pgsqlMaxNameLimitation,
    );
    var columnData = rawTableRow[queryKey];
    if (columnData != null) {
      columnMap[column.columnName] = columnData;
    }
  }

  return columnMap;
}
