import 'package:serverpod_serialization/serverpod_serialization.dart';

/// Holds data corresponding to a row in the database. Concrete classes are
/// typically generated. Instances of [TableRow] can also be serialized and
/// either passed to clients or cached.
abstract class TableRow extends SerializableEntity {
  /// Create a new TableRow object.
  const TableRow([this.id]);

  /// The id column of the row. Can be null if this row is not yet stored in
  /// the database.
  final int? id;

  /// The name of the table that contains this row.
  String get tableName;

  /// Will create a serialization of with the fields that are stored in the
  /// database only.
  //TODO: better name
  Map<String, dynamic> toJsonForDatabase();
}
