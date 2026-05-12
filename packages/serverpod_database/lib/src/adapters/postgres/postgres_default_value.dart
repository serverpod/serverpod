import '../../../serverpod_database.dart';

/// Extension methods for [ColumnType] to convert default values to PostgreSQL.
extension PostgresColumnTypeDefault on ColumnType {
  /// Converts abstract default values to PostgreSQL column default SQL.
  String? getPgColumnDefault(dynamic defaultValue, String tableName) {
    if (defaultValue == null) return null;

    if ((this == ColumnType.integer || this == ColumnType.bigint) &&
        defaultValue == defaultIntSerial) {
      return "nextval('${tableName}_id_seq'::regclass)";
    }

    switch (this) {
      case ColumnType.timestampWithoutTimeZone:
        if (defaultValue is! String) {
          throw StateError('Invalid DateTime default value: $defaultValue');
        }
        if (defaultValue == defaultDateTimeValueNow) {
          return 'CURRENT_TIMESTAMP';
        }
        var dateTime = DateTime.parse(defaultValue);
        // Date format: 'yyyy-MM-dd HH:mm:ss.SSS'
        var formatted = dateTime
            .toIso8601String()
            .replaceAll('T', ' ')
            .substring(0, 23);
        return "'$formatted'::timestamp without time zone";
      case ColumnType.boolean:
      case ColumnType.integer:
      case ColumnType.doublePrecision:
      case ColumnType.bigint:
        return '$defaultValue';
      case ColumnType.text:
      case ColumnType.json:
        return '$defaultValue::text';
      case ColumnType.uuid:
        return switch (defaultValue) {
          defaultUuidValueRandom => 'gen_random_uuid()',
          defaultUuidValueRandomV7 => 'gen_random_uuid_v7()',
          _ => '$defaultValue::uuid',
        };
      default:
        return '$defaultValue::text';
    }
  }
}

/// Converts PostgreSQL column_default SQL to dialect-neutral abstract default.
///
/// This is the inverse of [PostgresColumnTypeDefault.getPgColumnDefault] to be
/// used when parsing the database definition from the database to compare with
/// the dialect-neutral target database definition.
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
