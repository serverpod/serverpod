/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../protocol.dart' as _i2;
import 'package:serverpod_serialization/serverpod_serialization.dart';

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

  factory TableMigration.fromJson(Map<String, dynamic> jsonSerialization) {
    return TableMigration(
      name: jsonSerialization['name'] as String,
      dartName: jsonSerialization['dartName'] as String?,
      module: jsonSerialization['module'] as String?,
      schema: jsonSerialization['schema'] as String,
      addColumns: (jsonSerialization['addColumns'] as List)
          .map(
              (e) => _i2.ColumnDefinition.fromJson((e as Map<String, dynamic>)))
          .toList(),
      deleteColumns: (jsonSerialization['deleteColumns'] as List)
          .map((e) => e as String)
          .toList(),
      modifyColumns: (jsonSerialization['modifyColumns'] as List)
          .map((e) => _i2.ColumnMigration.fromJson((e as Map<String, dynamic>)))
          .toList(),
      addIndexes: (jsonSerialization['addIndexes'] as List)
          .map((e) => _i2.IndexDefinition.fromJson((e as Map<String, dynamic>)))
          .toList(),
      deleteIndexes: (jsonSerialization['deleteIndexes'] as List)
          .map((e) => e as String)
          .toList(),
      addForeignKeys: (jsonSerialization['addForeignKeys'] as List)
          .map((e) =>
              _i2.ForeignKeyDefinition.fromJson((e as Map<String, dynamic>)))
          .toList(),
      deleteForeignKeys: (jsonSerialization['deleteForeignKeys'] as List)
          .map((e) => e as String)
          .toList(),
      warnings: (jsonSerialization['warnings'] as List)
          .map((e) => _i2.DatabaseMigrationWarning.fromJson(
              (e as Map<String, dynamic>)))
          .toList(),
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

  @override
  Map<String, dynamic> allToJson() {
    return {
      'name': name,
      if (dartName != null) 'dartName': dartName,
      if (module != null) 'module': module,
      'schema': schema,
      'addColumns': addColumns.toJson(valueToJson: (v) => v.allToJson()),
      'deleteColumns': deleteColumns.toJson(),
      'modifyColumns': modifyColumns.toJson(valueToJson: (v) => v.allToJson()),
      'addIndexes': addIndexes.toJson(valueToJson: (v) => v.allToJson()),
      'deleteIndexes': deleteIndexes.toJson(),
      'addForeignKeys':
          addForeignKeys.toJson(valueToJson: (v) => v.allToJson()),
      'deleteForeignKeys': deleteForeignKeys.toJson(),
      'warnings': warnings.toJson(valueToJson: (v) => v.allToJson()),
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
