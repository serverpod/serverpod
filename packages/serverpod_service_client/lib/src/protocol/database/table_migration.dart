/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../protocol.dart' as _i2;

class TableMigration extends _i1.SerializableEntity {
  TableMigration({
    required this.name,
    this.dartName,
    this.module,
    required this.schema,
    required this.addColumns,
    required this.deleteColumns,
    required this.modifyColumns,
    required this.addIndexes,
    required this.deleteIndexes,
    required this.addForeignKeys,
    required this.deleteForeignKeys,
    required this.warnings,
  });

  factory TableMigration.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return TableMigration(
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      dartName: serializationManager
          .deserialize<String?>(jsonSerialization['dartName']),
      module: serializationManager
          .deserialize<String?>(jsonSerialization['module']),
      schema:
          serializationManager.deserialize<String>(jsonSerialization['schema']),
      addColumns: serializationManager.deserialize<List<_i2.ColumnDefinition>>(
          jsonSerialization['addColumns']),
      deleteColumns: serializationManager
          .deserialize<List<String>>(jsonSerialization['deleteColumns']),
      modifyColumns:
          serializationManager.deserialize<List<_i2.ColumnMigration>>(
              jsonSerialization['modifyColumns']),
      addIndexes: serializationManager.deserialize<List<_i2.IndexDefinition>>(
          jsonSerialization['addIndexes']),
      deleteIndexes: serializationManager
          .deserialize<List<String>>(jsonSerialization['deleteIndexes']),
      addForeignKeys:
          serializationManager.deserialize<List<_i2.ForeignKeyDefinition>>(
              jsonSerialization['addForeignKeys']),
      deleteForeignKeys: serializationManager
          .deserialize<List<String>>(jsonSerialization['deleteForeignKeys']),
      warnings:
          serializationManager.deserialize<List<_i2.DatabaseMigrationWarning>>(
              jsonSerialization['warnings']),
    );
  }

  String name;

  String? dartName;

  String? module;

  String schema;

  List<_i2.ColumnDefinition> addColumns;

  List<String> deleteColumns;

  List<_i2.ColumnMigration> modifyColumns;

  List<_i2.IndexDefinition> addIndexes;

  List<String> deleteIndexes;

  List<_i2.ForeignKeyDefinition> addForeignKeys;

  List<String> deleteForeignKeys;

  List<_i2.DatabaseMigrationWarning> warnings;

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dartName': dartName,
      'module': module,
      'schema': schema,
      'addColumns': addColumns,
      'deleteColumns': deleteColumns,
      'modifyColumns': modifyColumns,
      'addIndexes': addIndexes,
      'deleteIndexes': deleteIndexes,
      'addForeignKeys': addForeignKeys,
      'deleteForeignKeys': deleteForeignKeys,
      'warnings': warnings,
    };
  }
}
