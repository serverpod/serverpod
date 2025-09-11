import 'package:serverpod/src/database/concepts/columns.dart';

/// A function that returns a list of [ColumnValue]s for a [UpdateTable].
typedef ColumnValueListBuilder<T> = List<ColumnValue> Function(T);

/// Represents a column-value pair for database updates.
class ColumnValue<T, V> {
  /// The column to update.
  final Column<T> column;

  /// The value to set.
  final V? value;

  /// Creates a new [ColumnValue] with the specified column and value.
  const ColumnValue(this.column, this.value);
}
