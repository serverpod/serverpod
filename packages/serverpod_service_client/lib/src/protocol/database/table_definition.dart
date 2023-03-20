/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../protocol.dart' as _i2;

/// The definition of a (desired) table in the database.
class TableDefinition extends _i1.SerializableEntity {
  TableDefinition({
    required this.name,
    required this.schema,
    this.tableSpace,
    required this.columns,
    required this.foreignKeys,
    required this.indexes,
  });

  factory TableDefinition.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return TableDefinition(
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      schema:
          serializationManager.deserialize<String>(jsonSerialization['schema']),
      tableSpace: serializationManager
          .deserialize<String?>(jsonSerialization['tableSpace']),
      columns: serializationManager.deserialize<List<_i2.ColumnDefinition>>(
          jsonSerialization['columns']),
      foreignKeys:
          serializationManager.deserialize<List<_i2.ForeignKeyDefinition>>(
              jsonSerialization['foreignKeys']),
      indexes: serializationManager
          .deserialize<List<_i2.IndexDefinition>>(jsonSerialization['indexes']),
    );
  }

  /// The table name.
  String name;

  /// The schema this table is in.
  String schema;

  /// The tablespace this table is stored in.
  /// If null, the table is in the databases default tablespace.
  String? tableSpace;

  /// All the columns of this table.
  List<_i2.ColumnDefinition> columns;

  /// All the foreign keys.
  List<_i2.ForeignKeyDefinition> foreignKeys;

  /// All the indexes of this table.
  List<_i2.IndexDefinition> indexes;

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'schema': schema,
      'tableSpace': tableSpace,
      'columns': columns,
      'foreignKeys': foreignKeys,
      'indexes': indexes,
    };
  }
}
