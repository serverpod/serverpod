/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../database/database_migration_action_type.dart' as _i2;
import '../database/table_migration.dart' as _i3;
import '../database/table_definition.dart' as _i4;

abstract class DatabaseMigrationAction
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  DatabaseMigrationAction._({
    required this.type,
    this.deleteTable,
    this.alterTable,
    this.createTable,
  });

  factory DatabaseMigrationAction({
    required _i2.DatabaseMigrationActionType type,
    String? deleteTable,
    _i3.TableMigration? alterTable,
    _i4.TableDefinition? createTable,
  }) = _DatabaseMigrationActionImpl;

  factory DatabaseMigrationAction.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return DatabaseMigrationAction(
      type: _i2.DatabaseMigrationActionType.fromJson(
          (jsonSerialization['type'] as String)),
      deleteTable: jsonSerialization['deleteTable'] as String?,
      alterTable: jsonSerialization['alterTable'] == null
          ? null
          : _i3.TableMigration.fromJson(
              (jsonSerialization['alterTable'] as Map<String, dynamic>)),
      createTable: jsonSerialization['createTable'] == null
          ? null
          : _i4.TableDefinition.fromJson(
              (jsonSerialization['createTable'] as Map<String, dynamic>)),
    );
  }

  _i2.DatabaseMigrationActionType type;

  String? deleteTable;

  _i3.TableMigration? alterTable;

  _i4.TableDefinition? createTable;

  /// Returns a shallow copy of this [DatabaseMigrationAction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DatabaseMigrationAction copyWith({
    _i2.DatabaseMigrationActionType? type,
    String? deleteTable,
    _i3.TableMigration? alterTable,
    _i4.TableDefinition? createTable,
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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'type': type.toJson(),
      if (deleteTable != null) 'deleteTable': deleteTable,
      if (alterTable != null) 'alterTable': alterTable?.toJsonForProtocol(),
      if (createTable != null) 'createTable': createTable?.toJsonForProtocol(),
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
    _i3.TableMigration? alterTable,
    _i4.TableDefinition? createTable,
  }) : super._(
          type: type,
          deleteTable: deleteTable,
          alterTable: alterTable,
          createTable: createTable,
        );

  /// Returns a shallow copy of this [DatabaseMigrationAction]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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
      alterTable: alterTable is _i3.TableMigration?
          ? alterTable
          : this.alterTable?.copyWith(),
      createTable: createTable is _i4.TableDefinition?
          ? createTable
          : this.createTable?.copyWith(),
    );
  }
}
