import '../../serverpod_database.dart';

/// A function that returns a Column for a Table to be used with order by
typedef OrderByBuilder<T extends Table> = Column Function(T);

/// A function that returns a list of [Column] for a [Table] to be used with
/// order by list. Use [Column.desc()] to change the order to descending.
typedef OrderByListBuilder<T extends Table> = List<Column> Function(T);

/// Defines how to order a database [column].
class Order implements Column {
  /// The columns to order by.
  final Column column;

  /// Whether the column should be ordered ascending or descending.
  final bool orderDescending;

  @override
  String get columnName => column.columnName;

  @override
  String get fieldName => column.fieldName;

  @override
  String get fieldQueryAlias => column.fieldQueryAlias;

  @override
  bool get hasDefault => column.hasDefault;

  @override
  Table get table => column.table;

  @override
  String get queryAlias => column.queryAlias;

  @override
  Type get type => column.type;

  Order._({required this.column, this.orderDescending = false});

  /// Creates a new [Order] definition for a specific [column] and whether it
  /// should be ordered descending or ascending.
  @Deprecated('Use the helpers asc() and desc() on the column instead.')
  factory Order({required Column column, bool orderDescending}) = Order._;

  @override
  Expression hasChanged() => column.hasChanged();

  @override
  String toString() {
    var str = '$column';
    if (orderDescending) str += ' DESC';
    return str;
  }
}

/// Extension providing ordering operations for columns.
extension ColumnOrderingOperations<T> on Column<T> {
  /// Creates an [Order] with the column ordered ascending.
  Order asc() => Order._(column: this, orderDescending: false);

  /// Creates an [Order] with the column ordered descending.
  Order desc() => Order._(column: this, orderDescending: true);
}

/// Extension providing a method to convert a list of [Column]s to a list of [Order]s.
extension ConvertToOrderBy on List<Column> {
  /// Converts the list of [Column]s to a list of [Order]s.
  List<Order> asOrderBy() {
    return [
      for (final c in this) c is Order ? c : c.asc(),
    ];
  }
}
