import 'dart:mirrors';

import 'package:serverpod_serialization/serverpod_serialization.dart';

/// Holds data corresponding to a row in the database. Concrete classes are
/// typically generated. Instances of [TableRow] can also be serialized and
/// either passed to clients or cached.
abstract class TableRow extends SerializableEntity {
  /// The id column of the row. Can be null if this row is not yet stored in
  /// the database.
  int? id;

  /// The name of the table that contains this row.
  String get tableName;

  /// Will create a serialization of with the fields that are stored in the
  /// database only.
  Map<String, dynamic> serializeForDatabase();

  /// Sets the value of a column by its name. Used in communication with the
  /// database.
  void setColumn(String columnName, dynamic value) {
    var instance = reflect(this);
    instance.setField(Symbol(columnName), value);
  }
}
