import 'package:serverpod/protocol.dart';
import 'package:serverpod_shared/serverpod_shared.dart';

/// Extensions on the [ColumnType] enum.
extension ExtendedColumnType on ColumnType {
  /// Get a [ColumnType] from a type used in SQL.
  /// If [type] is not known, returns [ColumnType.unknown].
  static ColumnType fromSqlType(String type) {
    var target = databaseTypeToLowerCamelCase(type);
    for (var value in ColumnType.values) {
      if (value.name == target) {
        return value;
      }
    }
    if (target == 'serial') {
      return ColumnType.integer;
    }
    return ColumnType.unknown;
  }
}
