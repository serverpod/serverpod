import 'package:serverpod_shared/serverpod_shared.dart';

import '../../protocol.dart';

/// Extensions on the [ColumnType] enum.
extension ExtendedColumnType on ColumnType {
  /// Get a [ColumnType] from a type used in SQL.
  /// If [type] is not known, returns [ColumnType.unknown].
  static ColumnType fromSqlType(String type) {
    final target = databaseTypeToLowerCamelCase(type);
    for (final value in ColumnType.values) {
      if (value.name == target) {
        return value;
      }
    }
    return ColumnType.unknown;
  }
}
