import 'package:serverpod/src/database/columns.dart';
import 'package:serverpod/src/database/expressions.dart';

/// A function that returns a Column for a Table to be used with order by
typedef OrderByBuilder<T extends Table> = Column Function(T);

/// A function that returns a list of [Order] for a [Table] to be used with
/// order by list.
typedef OrderByListBuilder<T extends Table> = List<Order> Function(T);

/// Defines how to order a database [column].
class Order {
  /// The columns to order by.
  final Column column;

  /// Whether the column should be ordered ascending or descending.
  final bool orderDescending;

  /// Creates a new [Order] definition for a specific [column] and whether it
  /// should be ordered descending or ascending.
  Order({required this.column, this.orderDescending = false});

  @override
  String toString() {
    var str = '$column';
    if (orderDescending) str += ' DESC';
    return str;
  }
}
