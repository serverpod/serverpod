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

abstract class DatabaseMigrationAction implements _i1.SerializableModel {
  DatabaseMigrationAction._({
    required this.type,
    this.deleteTable,
    this.alterTable,
    this.createTable,
  });

  factory DatabaseMigrationAction({
    required _i2.DatabaseMigrationActionType type,
    String? deleteTable,
    _i2.TableMigration? alterTable,
    _i2.TableDefinition? createTable,
  }) = _DatabaseMigrationActionImpl;

  factory DatabaseMigrationAction.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return DatabaseMigrationAction(
      type: _i2.DatabaseMigrationActionType.fromJson(
          (jsonSerialization['type'] as String)),
      deleteTable: jsonSerialization['deleteTable'] as String?,
      alterTable: jsonSerialization['alterTable'] == null
          ? null
          : _i2.TableMigration.fromJson(
              (jsonSerialization['alterTable'] as Map<String, dynamic>)),
      createTable: jsonSerialization['createTable'] == null
          ? null
          : _i2.TableDefinition.fromJson(
              (jsonSerialization['createTable'] as Map<String, dynamic>)),
    );
  }

  _i2.DatabaseMigrationActionType type;

  String? deleteTable;

  _i2.TableMigration? alterTable;

  _i2.TableDefinition? createTable;

  DatabaseMigrationAction copyWith({
    _i2.DatabaseMigrationActionType? type,
    String? deleteTable,
    _i2.TableMigration? alterTable,
    _i2.TableDefinition? createTable,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type.toJson(),
      if (deleteTable != null) 'deleteTable': deleteTable,
      if (alterTable != null) 'alterTable': alterTable?.toJson(),
      if (createTable != null) 'createTable': createTable?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DatabaseMigrationActionImpl extends DatabaseMigrationAction {
  _DatabaseMigrationActionImpl({
    required _i2.DatabaseMigrationActionType type,
    String? deleteTable,
    _i2.TableMigration? alterTable,
    _i2.TableDefinition? createTable,
  }) : super._(
          type: type,
          deleteTable: deleteTable,
          alterTable: alterTable,
          createTable: createTable,
        );

  @override
  DatabaseMigrationAction copyWith({
    _i2.DatabaseMigrationActionType? type,
    Object? deleteTable = _Undefined,
    Object? alterTable = _Undefined,
    Object? createTable = _Undefined,
  }) {
    return DatabaseMigrationAction(
      type: type ?? this.type,
      deleteTable: deleteTable is String? ? deleteTable : this.deleteTable,
      alterTable: alterTable is _i2.TableMigration?
          ? alterTable
          : this.alterTable?.copyWith(),
      createTable: createTable is _i2.TableDefinition?
          ? createTable
          : this.createTable?.copyWith(),
    );
  }
}
