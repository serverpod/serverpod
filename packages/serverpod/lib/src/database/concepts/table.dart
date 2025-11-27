import 'package:serverpod/database.dart';
import 'package:serverpod/src/database/concepts/table_relation.dart';
import 'package:serverpod_serialization/serverpod_serialization.dart';

/// Holds data corresponding to a row in the database. Concrete classes are
/// typically generated. Instances of [TableRow] can also be serialized and
/// either passed to clients or cached.
abstract interface class TableRow<T_ID> implements SerializableModel {
  TableRow();

  /// The id column of the row. Can be null if this row is not yet stored in
  /// the database.
  T_ID get id;

  /// The table that this row belongs to.
  Table<T_ID> get table;
}

/// Represents a database table.
class Table<T_ID> {
  /// Name of the table as used in the database.
  final String tableName;

  /// The database id.
  late final ColumnComparable<T_ID> id;

  /// List of [Column] used by the table.
  List<Column> get columns => [id];

  /// List of [Column] that are managed by this table.
  /// This is mostly used to exclude columns created by implicit relations.
  List<Column> get managedColumns => columns;

  /// Query prefix for [Column]s of the table.
  String get queryPrefix {
    return tableRelation?.relationQueryAlias ?? tableName;
  }

  /// Table relation for [Column]s of the table.
  final TableRelation? tableRelation;

  /// Creates a new [Table]. Typically, this is done only by generated code.
  Table({
    required this.tableName,
    this.tableRelation,
  }) {
    if (T_ID == dynamic) {
      throw Exception(
        'Can not create a table without passing an id type. Use the format '
        'Table<int?>(...) or Table<UuidValue>(...) to specify the id type.',
      );
    }
    if (equalsType<T_ID, int>()) {
      id =
          ColumnInt(
                'id',
                this,
                hasDefault: true,
              )
              as ColumnComparable<T_ID>;
    } else if (equalsType<T_ID, UuidValue>()) {
      id =
          ColumnUuid(
                'id',
                this,
                hasDefault: true,
              )
              as ColumnComparable<T_ID>;
    } else {
      throw Exception('Unsupported id type: $T_ID');
    }
  }

  /// Returns [TableColumnRelation] for the given [relationField]. If no relation
  /// exists, returns null. The return must be dynamic to allow for relations
  /// with different id types.
  Table? getRelationTable(String relationField) {
    return null;
  }

  @override
  String toString() {
    var str = '$tableName\n';
    for (var col in columns) {
      str += '  ${col.columnName} (${col.type})\n';
    }
    return str;
  }
}

/// Creates a new [Table] containing [TableRelation] with information
/// about how the tables are joined.
///
/// [relationFieldName] is the reference name of the table join.
/// [field] is the [Column] of the table that is used to join the tables.
/// [foreignField] is the [Column] of the foreign table that is used to join
/// table.
/// [tableRelation] is the [TableRelation] of the table that is used to join
/// the tables.
T createRelationTable<T>({
  required String relationFieldName,
  required Column field,
  required Column foreignField,
  TableRelation? tableRelation,
  required T Function(
    TableRelation foreignTableRelation,
  )
  createTable,
}) {
  var relationDefinition = TableRelationEntry(
    relationAlias: relationFieldName,
    field: field,
    foreignField: foreignField,
  );

  if (tableRelation == null) {
    return createTable(TableRelation([relationDefinition]));
  }

  return createTable(
    tableRelation.copyAndAppend(relationDefinition),
  );
}

/// Checks if the type [T] is equal to type [Y] (nullable or non-nullable).
bool equalsType<T_ID, Y>() => _equalsType<T_ID, Y>() || _equalsType<T_ID, Y?>();
bool _equalsType<T, Y>() => T == Y;
