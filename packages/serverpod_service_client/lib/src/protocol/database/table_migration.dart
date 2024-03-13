/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../protocol.dart' as _i2;

abstract class TableMigration extends _i1.SerializableEntity {
  TableMigration._({
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

  factory TableMigration({
    required String name,
    String? dartName,
    String? module,
    required String schema,
    required List<_i2.ColumnDefinition> addColumns,
    required List<String> deleteColumns,
    required List<_i2.ColumnMigration> modifyColumns,
    required List<_i2.IndexDefinition> addIndexes,
    required List<String> deleteIndexes,
    required List<_i2.ForeignKeyDefinition> addForeignKeys,
    required List<String> deleteForeignKeys,
    required List<_i2.DatabaseMigrationWarning> warnings,
  }) = _TableMigrationImpl;

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

  TableMigration copyWith({
    String? name,
    String? dartName,
    String? module,
    String? schema,
    List<_i2.ColumnDefinition>? addColumns,
    List<String>? deleteColumns,
    List<_i2.ColumnMigration>? modifyColumns,
    List<_i2.IndexDefinition>? addIndexes,
    List<String>? deleteIndexes,
    List<_i2.ForeignKeyDefinition>? addForeignKeys,
    List<String>? deleteForeignKeys,
    List<_i2.DatabaseMigrationWarning>? warnings,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (dartName != null) 'dartName': dartName,
      if (module != null) 'module': module,
      'schema': schema,
      'addColumns': addColumns.toJson(valueToJson: (v) => v.toJson()),
      'deleteColumns': deleteColumns.toJson(),
      'modifyColumns': modifyColumns.toJson(valueToJson: (v) => v.toJson()),
      'addIndexes': addIndexes.toJson(valueToJson: (v) => v.toJson()),
      'deleteIndexes': deleteIndexes.toJson(),
      'addForeignKeys': addForeignKeys.toJson(valueToJson: (v) => v.toJson()),
      'deleteForeignKeys': deleteForeignKeys.toJson(),
      'warnings': warnings.toJson(valueToJson: (v) => v.toJson()),
    };
  }
}

class _Undefined {}

class _TableMigrationImpl extends TableMigration {
  _TableMigrationImpl({
    required String name,
    String? dartName,
    String? module,
    required String schema,
    required List<_i2.ColumnDefinition> addColumns,
    required List<String> deleteColumns,
    required List<_i2.ColumnMigration> modifyColumns,
    required List<_i2.IndexDefinition> addIndexes,
    required List<String> deleteIndexes,
    required List<_i2.ForeignKeyDefinition> addForeignKeys,
    required List<String> deleteForeignKeys,
    required List<_i2.DatabaseMigrationWarning> warnings,
  }) : super._(
          name: name,
          dartName: dartName,
          module: module,
          schema: schema,
          addColumns: addColumns,
          deleteColumns: deleteColumns,
          modifyColumns: modifyColumns,
          addIndexes: addIndexes,
          deleteIndexes: deleteIndexes,
          addForeignKeys: addForeignKeys,
          deleteForeignKeys: deleteForeignKeys,
          warnings: warnings,
        );

  @override
  TableMigration copyWith({
    String? name,
    Object? dartName = _Undefined,
    Object? module = _Undefined,
    String? schema,
    List<_i2.ColumnDefinition>? addColumns,
    List<String>? deleteColumns,
    List<_i2.ColumnMigration>? modifyColumns,
    List<_i2.IndexDefinition>? addIndexes,
    List<String>? deleteIndexes,
    List<_i2.ForeignKeyDefinition>? addForeignKeys,
    List<String>? deleteForeignKeys,
    List<_i2.DatabaseMigrationWarning>? warnings,
  }) {
    return TableMigration(
      name: name ?? this.name,
      dartName: dartName is String? ? dartName : this.dartName,
      module: module is String? ? module : this.module,
      schema: schema ?? this.schema,
      addColumns: addColumns ?? this.addColumns.clone(),
      deleteColumns: deleteColumns ?? this.deleteColumns.clone(),
      modifyColumns: modifyColumns ?? this.modifyColumns.clone(),
      addIndexes: addIndexes ?? this.addIndexes.clone(),
      deleteIndexes: deleteIndexes ?? this.deleteIndexes.clone(),
      addForeignKeys: addForeignKeys ?? this.addForeignKeys.clone(),
      deleteForeignKeys: deleteForeignKeys ?? this.deleteForeignKeys.clone(),
      warnings: warnings ?? this.warnings.clone(),
    );
  }
}
