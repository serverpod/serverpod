import 'package:serverpod_shared/serverpod_shared.dart';

import '../../serverpod_database.dart';

/// Extensions on the [ColumnType] enum.
extension ExtendedColumnType on ColumnType {
  /// Get a [ColumnType] from a type used in SQL.
  /// If [type] is not known, returns [ColumnType.unknown].
  static ColumnType fromSqlType(String type) {
    var target = databaseTypeToLowerCamelCase(type);
    // PostgreSQL always reports 'numeric' in information_schema even when
    // the column was created with DECIMAL (they are synonyms).
    if (target == 'numeric') target = 'decimal';
    for (var value in ColumnType.values) {
      if (value.name == target) {
        return value;
      }
    }
    return ColumnType.unknown;
  }
}
