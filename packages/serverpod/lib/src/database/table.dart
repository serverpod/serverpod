import 'package:serverpod/database.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';

/// Holds data corresponding to a row in the database. Concrete classes are
/// typically generated. Instances of [TableRow] can also be serialized and
/// either passed to clients or cached.
abstract class TableRow extends SerializableModel {
  /// Create a new TableRow object.
  TableRow([this.id]);

  /// The id column of the row. Can be null if this row is not yet stored in
  /// the database.
  int? id;

  /// The table that this row belongs to.
  Table get table;

  /// The name of the table that contains this row.
  @Deprecated('Use: table.tableName instead, will be removed in 2.0.0.')
  String get tableName => table.tableName;

  /// Will create a serialization of with the fields that are stored in the
  /// database only.
  @Deprecated('Will be removed in 2.0.0.')
  Map<String, dynamic> toJsonForDatabase();

  /// Sets the value of a column by its name. Used in communication with the
  /// database.
  void setColumn(String columnName, dynamic value);
}
