/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../protocol.dart' as _i2;
import 'package:collection/collection.dart' as _i3;

abstract class TableMigration extends _i1.SerializableEntity {
  const TableMigration._();

  const factory TableMigration({
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
  }) = _TableMigration;

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
  String get name;
  String? get dartName;
  String? get module;
  String get schema;
  List<_i2.ColumnDefinition> get addColumns;
  List<String> get deleteColumns;
  List<_i2.ColumnMigration> get modifyColumns;
  List<_i2.IndexDefinition> get addIndexes;
  List<String> get deleteIndexes;
  List<_i2.ForeignKeyDefinition> get addForeignKeys;
  List<String> get deleteForeignKeys;
  List<_i2.DatabaseMigrationWarning> get warnings;
}

class _Undefined {}

class _TableMigration extends TableMigration {
  const _TableMigration({
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
  }) : super._();

  @override
  final String name;

  @override
  final String? dartName;

  @override
  final String? module;

  @override
  final String schema;

  @override
  final List<_i2.ColumnDefinition> addColumns;

  @override
  final List<String> deleteColumns;

  @override
  final List<_i2.ColumnMigration> modifyColumns;

  @override
  final List<_i2.IndexDefinition> addIndexes;

  @override
  final List<String> deleteIndexes;

  @override
  final List<_i2.ForeignKeyDefinition> addForeignKeys;

  @override
  final List<String> deleteForeignKeys;

  @override
  final List<_i2.DatabaseMigrationWarning> warnings;

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

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is TableMigration &&
            (identical(
                  other.name,
                  name,
                ) ||
                other.name == name) &&
            (identical(
                  other.dartName,
                  dartName,
                ) ||
                other.dartName == dartName) &&
            (identical(
                  other.module,
                  module,
                ) ||
                other.module == module) &&
            (identical(
                  other.schema,
                  schema,
                ) ||
                other.schema == schema) &&
            const _i3.DeepCollectionEquality().equals(
              addColumns,
              other.addColumns,
            ) &&
            const _i3.DeepCollectionEquality().equals(
              deleteColumns,
              other.deleteColumns,
            ) &&
            const _i3.DeepCollectionEquality().equals(
              modifyColumns,
              other.modifyColumns,
            ) &&
            const _i3.DeepCollectionEquality().equals(
              addIndexes,
              other.addIndexes,
            ) &&
            const _i3.DeepCollectionEquality().equals(
              deleteIndexes,
              other.deleteIndexes,
            ) &&
            const _i3.DeepCollectionEquality().equals(
              addForeignKeys,
              other.addForeignKeys,
            ) &&
            const _i3.DeepCollectionEquality().equals(
              deleteForeignKeys,
              other.deleteForeignKeys,
            ) &&
            const _i3.DeepCollectionEquality().equals(
              warnings,
              other.warnings,
            ));
  }

  @override
  int get hashCode => Object.hash(
        name,
        dartName,
        module,
        schema,
        const _i3.DeepCollectionEquality().hash(addColumns),
        const _i3.DeepCollectionEquality().hash(deleteColumns),
        const _i3.DeepCollectionEquality().hash(modifyColumns),
        const _i3.DeepCollectionEquality().hash(addIndexes),
        const _i3.DeepCollectionEquality().hash(deleteIndexes),
        const _i3.DeepCollectionEquality().hash(addForeignKeys),
        const _i3.DeepCollectionEquality().hash(deleteForeignKeys),
        const _i3.DeepCollectionEquality().hash(warnings),
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
      dartName: dartName == _Undefined ? this.dartName : (dartName as String?),
      module: module == _Undefined ? this.module : (module as String?),
      schema: schema ?? this.schema,
      addColumns: addColumns ?? this.addColumns,
      deleteColumns: deleteColumns ?? this.deleteColumns,
      modifyColumns: modifyColumns ?? this.modifyColumns,
      addIndexes: addIndexes ?? this.addIndexes,
      deleteIndexes: deleteIndexes ?? this.deleteIndexes,
      addForeignKeys: addForeignKeys ?? this.addForeignKeys,
      deleteForeignKeys: deleteForeignKeys ?? this.deleteForeignKeys,
      warnings: warnings ?? this.warnings,
    );
  }
}
