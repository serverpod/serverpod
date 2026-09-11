import 'package:serverpod_database/serverpod_database.dart';

/// The table name without its schema.
String unqualifiedTableName(String tableName) =>
    parseQualifiedTableName(tableName).name;

/// The tables a `parent=` reference matches: as written, and prefixed with
/// [defaultSchema] when unqualified. Two matches mean the reference is
/// ambiguous.
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
