import 'package:serverpod_database/serverpod_database.dart';

/// The table name without its schema.
String unqualifiedTableName(String tableName) =>
    parseQualifiedTableName(tableName).name;

/// Resolves a `parent=` reference against the known [tableNames].
///
/// The name is matched as written first, then prefixed with [defaultSchema]
/// when it is unqualified. Returns every match, so an empty list means the
/// table was not found and two entries mean the reference is ambiguous.
List<String> matchParentTable(
  String parentTable, {
  required String? defaultSchema,
  required Iterable<String> tableNames,
}) {
  var candidates = [
    parentTable,
    if (defaultSchema != null &&
        parseQualifiedTableName(parentTable).schema == null)
      '$defaultSchema.$parentTable',
  ];

  return candidates.where(tableNames.contains).toList();
}
