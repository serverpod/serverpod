import 'package:serverpod/serverpod.dart';

/// A wrapper class that contains a [TableRow] and its computed distance from
/// a vector distance query.
///
/// This is used by the `findWithDistance` method when querying models with
/// vector fields and computing distances.
class RowWithDistance<T extends TableRow> {
  /// Creates a new [RowWithDistance] with the given [row] and [distance].
  const RowWithDistance(this.row, this.distance);

  /// The database row returned from the query.
  final T row;

  /// The computed distance from the query vector.
  final double distance;

  @override
  String toString() => 'RowWithDistance(row: $row, distance: $distance)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RowWithDistance<T> &&
          runtimeType == other.runtimeType &&
          row == other.row &&
          distance == other.distance;

  @override
  int get hashCode => Object.hash(row, distance);
}
