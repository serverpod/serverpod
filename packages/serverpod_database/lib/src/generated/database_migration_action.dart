/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import 'package:serverpod_serialization/serverpod_serialization.dart' as _iss;

abstract class DatabaseMigrationAction
    implements _iss.SerializableModel, _iss.ProtocolSerialization {
  DatabaseMigrationAction._({
    required this.type,
    this.deleteTable,
    this.alterTable,
    this.createTable,
  });

  factory DatabaseMigrationAction({
    required _isd.DatabaseMigrationActionType type,
    String? deleteTable,
    _isd.TableMigration? alterTable,
    _isd.TableDefinition? createTable,
  }) = _DatabaseMigrationActionImpl;

  factory DatabaseMigrationAction.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DatabaseMigrationAction(
      type: _isd.DatabaseMigrationActionType.fromJson(
        (jsonSerialization['type'] as String),
      ),
      deleteTable: jsonSerialization['deleteTable'] as String?,
      alterTable: jsonSerialization['alterTable'] == null
          ? null
          : _isd.Protocol().deserialize<_isd.TableMigration>(
              jsonSerialization['alterTable'],
            ),
      createTable: jsonSerialization['createTable'] == null
          ? null
          : _isd.Protocol().deserialize<_isd.TableDefinition>(
              jsonSerialization['createTable'],
            ),
    );
  }

  _isd.DatabaseMigrationActionType type;

  String? deleteTable;

  _isd.TableMigration? alterTable;

  _isd.TableDefinition? createTable;

  /// Returns a shallow copy of this [DatabaseMigrationAction]
  /// with some or all fields replaced by the given arguments.
  @_iss.useResult
  DatabaseMigrationAction copyWith({
    _isd.DatabaseMigrationActionType? type,
    String? deleteTable,
    _isd.TableMigration? alterTable,
    _isd.TableDefinition? createTable,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.DatabaseMigrationAction',
      'type': type.toJson(),
      if (deleteTable != null) 'deleteTable': deleteTable,
      if (alterTable != null) 'alterTable': alterTable?.toJson(),
      if (createTable != null) 'createTable': createTable?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod.DatabaseMigrationAction',
      'type': type.toJson(),
      if (deleteTable != null) 'deleteTable': deleteTable,
      if (alterTable != null) 'alterTable': alterTable?.toJsonForProtocol(),
      if (createTable != null) 'createTable': createTable?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _iss.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DatabaseMigrationActionImpl extends DatabaseMigrationAction {
  _DatabaseMigrationActionImpl({
    required _isd.DatabaseMigrationActionType type,
    String? deleteTable,
    _isd.TableMigration? alterTable,
    _isd.TableDefinition? createTable,
  }) : super._(
         type: type,
         deleteTable: deleteTable,
         alterTable: alterTable,
         createTable: createTable,
       );

  /// Returns a shallow copy of this [DatabaseMigrationAction]
  /// with some or all fields replaced by the given arguments.
  @_iss.useResult
  @override
  DatabaseMigrationAction copyWith({
    _isd.DatabaseMigrationActionType? type,
    Object? deleteTable = _Undefined,
    Object? alterTable = _Undefined,
    Object? createTable = _Undefined,
  }) {
    return DatabaseMigrationAction(
      type: type ?? this.type,
      deleteTable: deleteTable is String? ? deleteTable : this.deleteTable,
      alterTable: alterTable is _isd.TableMigration?
          ? alterTable
          : this.alterTable?.copyWith(),
      createTable: createTable is _isd.TableDefinition?
          ? createTable
          : this.createTable?.copyWith(),
    );
  }
}
