import 'package:serverpod/src/database/concepts/column_value.dart';
import 'package:serverpod/src/database/concepts/table.dart';

/// Base class for database table update operations.
///
/// This abstract base class serves as the foundation for type-safe database
/// update operations in Serverpod. It is typically extended by generated
/// classes that provide specific update functionality for each table.
///
/// The class is designed to work with the code generation system to create
/// type-safe update operations. Generated classes extending this base class
/// can be used with [ColumnValueListBuilder] to ensure compile-time type
/// safety when building update queries.
///
/// Example usage in generated code:
/// ```dart
/// class MyTableUpdateTable extends UpdateTable<MyTable> {
///   const MyTableUpdateTable(super.table);
///
///   // Generated methods for type-safe updates would be added here
/// }
/// ```
///
/// The generic type parameter [T] ensures that the update table is strongly
/// typed to work with a specific table type, preventing runtime errors and
/// enabling better IDE support.
abstract class UpdateTable<T extends Table> {
  /// The table instance that this update table operates on.
  ///
  /// This provides access to the table's schema information, including
  /// column definitions and metadata needed for generating update queries.
  final T table;

  /// Creates a new update table instance for the specified [table].
  ///
  /// This constructor is typically called by generated subclasses to
  /// initialize the base functionality.
  const UpdateTable(this.table);
}
