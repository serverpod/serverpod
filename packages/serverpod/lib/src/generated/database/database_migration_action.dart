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

abstract class DatabaseMigrationAction extends _i1.SerializableEntity {
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
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return DatabaseMigrationAction(
      type: serializationManager.deserialize<_i2.DatabaseMigrationActionType>(
          jsonSerialization['type']),
      deleteTable: serializationManager
          .deserialize<String?>(jsonSerialization['deleteTable']),
      alterTable: serializationManager
          .deserialize<_i2.TableMigration?>(jsonSerialization['alterTable']),
      createTable: serializationManager
          .deserialize<_i2.TableDefinition?>(jsonSerialization['createTable']),
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
  Map<String, dynamic> allToJson() {
    return {
      'type': type.toJson(),
      if (deleteTable != null) 'deleteTable': deleteTable,
      if (alterTable != null) 'alterTable': alterTable?.toJson(),
      if (createTable != null) 'createTable': createTable?.toJson(),
    };
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
