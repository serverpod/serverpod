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
import 'package:serverpod_serialization/serverpod_serialization.dart';

/// Defines the structure of the database used by Serverpod.
abstract class DatabaseDefinition extends _i1.SerializableEntity {
  DatabaseDefinition._({
    this.name,
    required this.moduleName,
    required this.tables,
    required this.installedModules,
    required this.migrationApiVersion,
  });

  factory DatabaseDefinition({
    String? name,
    required String moduleName,
    required List<_i2.TableDefinition> tables,
    required List<_i2.DatabaseMigrationVersion> installedModules,
    required int migrationApiVersion,
  }) = _DatabaseDefinitionImpl;

  factory DatabaseDefinition.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return DatabaseDefinition(
      name:
          serializationManager.deserialize<String?>(jsonSerialization['name']),
      moduleName: serializationManager
          .deserialize<String>(jsonSerialization['moduleName']),
      tables: serializationManager
          .deserialize<List<_i2.TableDefinition>>(jsonSerialization['tables']),
      installedModules:
          serializationManager.deserialize<List<_i2.DatabaseMigrationVersion>>(
              jsonSerialization['installedModules']),
      migrationApiVersion: serializationManager
          .deserialize<int>(jsonSerialization['migrationApiVersion']),
    );
  }

  /// The name of the database.
  /// Null if the name is not available.
  String? name;

  /// The name of the module that defines the database.
  String moduleName;

  /// The tables of the database.
  List<_i2.TableDefinition> tables;

  /// Modules installed in the database, together with their version. Only
  /// set if known.
  List<_i2.DatabaseMigrationVersion> installedModules;

  /// The version of the database definition.
  int migrationApiVersion;

  DatabaseDefinition copyWith({
    String? name,
    String? moduleName,
    List<_i2.TableDefinition>? tables,
    List<_i2.DatabaseMigrationVersion>? installedModules,
    int? migrationApiVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      'moduleName': moduleName,
      'tables': tables.toJson(valueToJson: (v) => v.toJson()),
      'installedModules':
          installedModules.toJson(valueToJson: (v) => v.toJson()),
      'migrationApiVersion': migrationApiVersion,
    };
  }
}

class _Undefined {}

class _DatabaseDefinitionImpl extends DatabaseDefinition {
  _DatabaseDefinitionImpl({
    String? name,
    required String moduleName,
    required List<_i2.TableDefinition> tables,
    required List<_i2.DatabaseMigrationVersion> installedModules,
    required int migrationApiVersion,
  }) : super._(
          name: name,
          moduleName: moduleName,
          tables: tables,
          installedModules: installedModules,
          migrationApiVersion: migrationApiVersion,
        );

  @override
  DatabaseDefinition copyWith({
    Object? name = _Undefined,
    String? moduleName,
    List<_i2.TableDefinition>? tables,
    List<_i2.DatabaseMigrationVersion>? installedModules,
    int? migrationApiVersion,
  }) {
    return DatabaseDefinition(
      name: name is String? ? name : this.name,
      moduleName: moduleName ?? this.moduleName,
      tables: tables ?? this.tables.clone(),
      installedModules: installedModules ?? this.installedModules.clone(),
      migrationApiVersion: migrationApiVersion ?? this.migrationApiVersion,
    );
  }
}
