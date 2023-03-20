/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../protocol.dart' as _i2;

/// The definition of a (desired) table in the database.
class TableDefinition extends _i1.SerializableEntity {
  TableDefinition({
    required this.name,
    required this.columns,
    this.primaryKey,
    required this.foreignKeys,
    required this.indexes,
  });

  factory TableDefinition.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return TableDefinition(
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      columns: serializationManager.deserialize<List<_i2.ColumnDefinition>>(
          jsonSerialization['columns']),
      primaryKey: serializationManager
          .deserialize<List<String>?>(jsonSerialization['primaryKey']),
      foreignKeys:
          serializationManager.deserialize<List<_i2.ForeignKeyDefinition>>(
              jsonSerialization['foreignKeys']),
      indexes: serializationManager
          .deserialize<List<_i2.IndexDefinition>>(jsonSerialization['indexes']),
    );
  }

  /// The table name
  String name;

  /// All the columns of this table.
  List<_i2.ColumnDefinition> columns;

  /// The elements are the columns.
  List<String>? primaryKey;

  /// All the foreign keys.
  List<_i2.ForeignKeyDefinition> foreignKeys;

  /// All the indexes of this table.
  List<_i2.IndexDefinition> indexes;

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'columns': columns,
      'primaryKey': primaryKey,
      'foreignKeys': foreignKeys,
      'indexes': indexes,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'name': name,
      'columns': columns,
      'primaryKey': primaryKey,
      'foreignKeys': foreignKeys,
      'indexes': indexes,
    };
  }
}
