/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../protocol.dart' as _i2;

class _Undefined {}

class DatabaseMigrationAction extends _i1.SerializableEntity {
  DatabaseMigrationAction({
    required this.type,
    this.deleteTable,
    this.alterTable,
    this.createTable,
  });

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

  final _i2.DatabaseMigrationActionType type;

  final String? deleteTable;

  final _i2.TableMigration? alterTable;

  final _i2.TableDefinition? createTable;

  late Function({
    _i2.DatabaseMigrationActionType? type,
    String? deleteTable,
    _i2.TableMigration? alterTable,
    _i2.TableDefinition? createTable,
  }) copyWith = _copyWith;

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'deleteTable': deleteTable,
      'alterTable': alterTable,
      'createTable': createTable,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is DatabaseMigrationAction &&
            (identical(
                  other.type,
                  type,
                ) ||
                other.type == type) &&
            (identical(
                  other.deleteTable,
                  deleteTable,
                ) ||
                other.deleteTable == deleteTable) &&
            (identical(
                  other.alterTable,
                  alterTable,
                ) ||
                other.alterTable == alterTable) &&
            (identical(
                  other.createTable,
                  createTable,
                ) ||
                other.createTable == createTable));
  }

  @override
  int get hashCode => Object.hash(
        type,
        deleteTable,
        alterTable,
        createTable,
      );

  DatabaseMigrationAction _copyWith({
    _i2.DatabaseMigrationActionType? type,
    Object? deleteTable = _Undefined,
    Object? alterTable = _Undefined,
    Object? createTable = _Undefined,
  }) {
    return DatabaseMigrationAction(
      type: type ?? this.type,
      deleteTable: deleteTable == _Undefined
          ? this.deleteTable
          : (deleteTable as String?),
      alterTable: alterTable == _Undefined
          ? this.alterTable
          : (alterTable as _i2.TableMigration?),
      createTable: createTable == _Undefined
          ? this.createTable
          : (createTable as _i2.TableDefinition?),
    );
  }
}
