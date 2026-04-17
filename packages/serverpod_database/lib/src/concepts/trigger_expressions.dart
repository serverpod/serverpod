import '../../serverpod_database.dart';

/// An [Expression] that evaluates to true when a column's value has changed
/// between the OLD and NEW row in a PostgreSQL trigger.
///
/// Produces SQL: `OLD."column_name" IS DISTINCT FROM NEW."column_name"`
///
/// This expression is only valid in trigger `WHEN` clauses and should not be
/// used in regular queries. It can be composed with other expressions using
/// `&` (AND) and `|` (OR) operators:
///
/// ```dart
/// // React when sensorHeight changes AND temperature exceeds threshold
/// Sensor.t.sensorHeight.hasChanged() &
///     Sensor.t.sensorTemperature.greaterThan(100)
/// ```
class HasChangedExpression extends Expression {
  final Column _column;

  /// Creates a new [HasChangedExpression] for the given [column].
  HasChangedExpression(this._column) : super('');

  @override
  String toString() =>
      'OLD."${_column.columnName}" IS DISTINCT FROM NEW."${_column.columnName}"';

  @override
  List<Column> get columns => [_column];
}
