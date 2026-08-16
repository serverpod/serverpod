import '../../../serverpod_database.dart';

/// Extension methods for [ColumnType] to convert default values to SQLite.
extension SqliteTypeDefinition on ColumnType {
  /// Converts abstract default values to SQLite column default SQL.
  String? getSqliteColumnDefault(dynamic defaultValue) {
    if (defaultValue == null) return null;

    if ((this == ColumnType.integer || this == ColumnType.bigint) &&
        defaultValue == defaultIntSerial) {
      return 'AUTOINCREMENT';
    }

    switch (this) {
      case ColumnType.timestampWithoutTimeZone:
        if (defaultValue is! String) {
          throw StateError('Invalid DateTime default value: $defaultValue');
        }
        if (defaultValue == defaultDateTimeValueNow) {
          return _sqliteNowExpression;
        }
        final dateTime = DateTime.parse(defaultValue).toUtc();
        return '${dateTime.millisecondsSinceEpoch}';
      case ColumnType.boolean:
        return defaultValue == defaultBooleanTrue ? '1' : '0';
      case ColumnType.uuid:
        if (defaultValue is! String) {
          throw StateError('Invalid UUID default value: $defaultValue');
        }
        return switch (defaultValue) {
          defaultUuidValueRandom => _generateRandomUuid,
          defaultUuidValueRandomV7 => _generateRandomUuidV7,
          _ => "X${defaultValue.replaceAll('-', '')}",
        };
      default:
        return '$defaultValue';
    }
  }
}

/// Converts SQLite column_default SQL to dialect-neutral abstract default.
///
/// This is the inverse of [SqliteTypeDefinition.getSqliteColumnDefault] to be
/// used when parsing the database definition from the database to compare with
/// the dialect-neutral target database definition.
String? sqliteSqlToAbstractDefault(
  String? sql,
  ColumnType columnType,
) {
  if (sql == null || sql.isEmpty) return null;

  switch (columnType) {
    case ColumnType.integer:
    case ColumnType.bigint:
      if (sql == 'AUTOINCREMENT') return defaultIntSerial;
      return sql;
    case ColumnType.boolean:
      return sql == '1' ? defaultBooleanTrue : defaultBooleanFalse;
    case ColumnType.timestampWithoutTimeZone:
      if (sql == _sqliteNowExpression) {
        return defaultDateTimeValueNow;
      }
      return DateTime.fromMillisecondsSinceEpoch(
        int.parse(sql),
        isUtc: true,
      ).toIso8601String();
    case ColumnType.uuid:
      if (sql.contains("|| '4'")) return defaultUuidValueRandom;
      if (sql.contains("|| '7'")) return defaultUuidValueRandomV7;

      // Remove the X' and add dashes to the UUID.
      return sql
          .substring(1, sql.length)
          .replaceFirstMapped(
            RegExp(r"^('.{8})(.{4})(.{4})(.{4})(.{12}')$"),
            (m) => '${m[1]}-${m[2]}-${m[3]}-${m[4]}-${m[5]}',
          );
    default:
      return sql;
  }
}

const _sqliteNowExpression = "CAST(unixepoch('subsecond') * 1000 AS INTEGER)";

const _generateRandomUuid =
    'unhex(' // conversion to blob
    'hex(randomblob(6)) || ' // 48 random bits
    "'4' || " // version nibble (4 for UUID v4)
    'substr(hex(randomblob(2)), 2, 3) || ' // 12 random bits
    "substr('89AB', 1 + (abs(random()) % 4), 1) || " // random variant nibble (10xx)
    'substr(hex(randomblob(8)), 2, 15)' // 60 random bits
    ')';

const _generateRandomUuidV7 =
    'unhex(' // conversion to blob
    "printf('%012x', CAST(unixepoch('now', 'subsecond') * 1000 AS INTEGER)) || " // 48-bit timestamp
    "'7' || " // version nibble (7 for UUID v7)
    'substr(hex(randomblob(2)), 2, 3) || ' // 12 random bits
    "substr('89AB', 1 + (abs(random()) % 4), 1) || " // variant nibble (10xx)
    'substr(hex(randomblob(8)), 2, 15)' // 60 random bits
    ')';
