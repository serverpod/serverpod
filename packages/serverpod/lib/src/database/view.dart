import 'package:serverpod/serverpod.dart';

/// Holds data corresponding to a row in the database view. Concrete classes are
/// typically generated. Instances of [ViewRow] can also be serialized and
/// either passed to clients or cached.
abstract class ViewRow extends TableRow {
  /// The name of the table that contains this row.
  String get viewName;

  @override
  String get tableName => viewName;
}
