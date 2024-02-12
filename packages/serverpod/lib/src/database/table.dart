import 'package:serverpod/database.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';

/// Holds data corresponding to a row in the database. Concrete classes are
/// typically generated. Instances of [TableRow] can also be serialized and
/// either passed to clients or cached.
abstract class TableRow extends SerializableEntity {
  /// Create a new TableRow object.
  TableRow([this.id]);

  /// The id column of the row. Can be null if this row is not yet stored in
  /// the database.
  int? id;

  /// The table that this row belongs to.
  Table get table;
}
