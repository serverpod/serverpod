import 'package:serverpod/src/database/table_relation.dart';

/// Extracts all the primary keys from the result set that are referenced by
/// the given [relationTable].
Set<T> extractPrimaryKeyForRelation<T>(
  List<Map<String, Map<String, dynamic>>> resultSet,
  TableRelation tableRelation,
) {
  var foreignTableName = tableRelation.tableName;
  var idFieldName = unescape(tableRelation.lastJoiningField);

  var ids = resultSet
      .map((e) => e[foreignTableName]?[idFieldName] as T?)
      .whereType<T>()
      .toSet();
  return ids;
}

/// Takes an escaped query alias column name and returns the unescaped version.
String unescape(String escapedName) {
  return escapedName.replaceAll('"', '');
}
