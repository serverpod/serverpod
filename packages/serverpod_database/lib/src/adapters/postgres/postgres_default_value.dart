import '../../../serverpod_database.dart';

/// Converts PostgreSQL column_default SQL to dialect-neutral abstract default.
String? pgSqlToAbstractDefault(
  String? sql,
  ColumnType columnType,
) {
  if (sql == null || sql.isEmpty) return null;

  // nextval('...'::regclass)
  if (RegExp(r"nextval\s*\(\s*'[^']*'::regclass\s*\)").hasMatch(sql)) {
    return defaultIntSerial;
  }
  if (sql == 'CURRENT_TIMESTAMP') return defaultDateTimeValueNow;
  if (sql == 'gen_random_uuid()') return defaultUuidValueRandom;
  if (sql == 'gen_random_uuid_v7()') return defaultUuidValueRandomV7;

  var literal = sql;
  final quotedLiteral = _extractQuotedLiteral(sql);
  if (quotedLiteral != null) {
    literal = quotedLiteral;
  }

  // Remove the quotes from literals to match the original value.
  if ((literal.startsWith('\'') && literal.endsWith('\'')) &&
      [
        ColumnType.timestampWithoutTimeZone,
        ColumnType.bigint,
      ].contains(columnType)) {
    literal = literal.substring(1, literal.length - 1);
  }

  // For timestamp without time zone, convert to DateTime.
  if (columnType == ColumnType.timestampWithoutTimeZone) {
    literal = DateTime.parse('${literal}Z').toIso8601String();
  }

  return literal;
}

/// Remove the type cast and preserve the value that is inside the quotes
/// (with the quotes included).
String? _extractQuotedLiteral(String sql) {
  if (!sql.startsWith("'")) return null;

  final literal = StringBuffer("'");
  for (var i = 1; i < sql.length; i++) {
    final char = sql[i];
    if (char == "'") {
      if (i + 1 < sql.length && sql[i + 1] == "'") {
        literal.write("''");
        i++;
        continue;
      }

      literal.write("'");
      final suffix = sql.substring(i + 1).trimLeft();
      if (suffix.isEmpty || suffix.startsWith('::')) {
        return literal.toString();
      }
      return null;
    }

    literal.write(char);
  }

  return null;
}
