import 'package:serverpod/src/database/concepts/columns.dart';
import 'package:serverpod/src/database/concepts/table.dart';

/// A function that returns a list of [ColumnValue]s for a [Table].
typedef ColumnValueListBuilder<T extends Table> = List<ColumnValue> Function(T);

/// Represents a column-value pair for database updates.
class ColumnValue<T> {
  /// The column to update.
  final Column<T> column;

  /// The value to set.
  final T? value;

  /// Creates a new [ColumnValue] with the specified column and value.
  const ColumnValue(this.column, this.value);
}

/// Extension to add value setting methods to columns.
extension ColumnValueExtension<T> on Column<T> {
  /// Creates a [ColumnValue] with the specified value for this column.
  ColumnValue<T> call(T? value) => ColumnValue(this, value);
}
