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
import 'package:serverpod_serialization/serverpod_serialization.dart' as _i1;
import 'package:serverpod_database/serverpod_database.dart' as _i2;

/// Defines the structure of the database used by Serverpod.
abstract class DatabaseDefinition implements _i1.SerializableModel {
  DatabaseDefinition._({
    int? schemaVersion,
    this.name,
    required this.moduleName,
    required this.tables,
    required this.installedModules,
    required this.migrationApiVersion,
  }) : schemaVersion = schemaVersion ?? 1;

  factory DatabaseDefinition({
    int? schemaVersion,
    String? name,
    required String moduleName,
    required List<_i2.TableDefinition> tables,
    required List<_i2.DatabaseMigrationVersionModel> installedModules,
    required int migrationApiVersion,
  }) = _DatabaseDefinitionImpl;

  factory DatabaseDefinition.fromJson(Map<String, dynamic> jsonSerialization) {
    return DatabaseDefinition(
      schemaVersion: jsonSerialization['schemaVersion'] as int?,
      name: jsonSerialization['name'] as String?,
      moduleName: jsonSerialization['moduleName'] as String,
      tables: _i2.Protocol().deserialize<List<_i2.TableDefinition>>(
        jsonSerialization['tables'],
      ),
      installedModules: _i2.Protocol()
          .deserialize<List<_i2.DatabaseMigrationVersionModel>>(
            jsonSerialization['installedModules'],
          ),
      migrationApiVersion: jsonSerialization['migrationApiVersion'] as int,
    );
  }

  /// Schema version of the definition format.
  int schemaVersion;

  /// The name of the database.
  /// Null if the name is not available.
  String? name;

  /// The name of the module that defines the database.
  String moduleName;

  /// The tables of the database.
  List<_i2.TableDefinition> tables;

  /// Modules installed in the database, together with their version. Only
  /// set if known.
  List<_i2.DatabaseMigrationVersionModel> installedModules;

  /// The version of the database definition.
  int migrationApiVersion;

  /// Returns a shallow copy of this [DatabaseDefinition]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DatabaseDefinition copyWith({
    int? schemaVersion,
    String? name,
    String? moduleName,
    List<_i2.TableDefinition>? tables,
    List<_i2.DatabaseMigrationVersionModel>? installedModules,
    int? migrationApiVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.DatabaseDefinition',
      'schemaVersion': schemaVersion,
      if (name != null) 'name': name,
      'moduleName': moduleName,
      'tables': tables.toJson(valueToJson: (v) => v.toJson()),
      'installedModules': installedModules.toJson(
        valueToJson: (v) => v.toJson(),
      ),
      'migrationApiVersion': migrationApiVersion,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DatabaseDefinitionImpl extends DatabaseDefinition {
  _DatabaseDefinitionImpl({
    int? schemaVersion,
    String? name,
    required String moduleName,
    required List<_i2.TableDefinition> tables,
    required List<_i2.DatabaseMigrationVersionModel> installedModules,
    required int migrationApiVersion,
  }) : super._(
         schemaVersion: schemaVersion,
         name: name,
         moduleName: moduleName,
         tables: tables,
         installedModules: installedModules,
         migrationApiVersion: migrationApiVersion,
       );

  /// Returns a shallow copy of this [DatabaseDefinition]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DatabaseDefinition copyWith({
    int? schemaVersion,
    Object? name = _Undefined,
    String? moduleName,
    List<_i2.TableDefinition>? tables,
    List<_i2.DatabaseMigrationVersionModel>? installedModules,
    int? migrationApiVersion,
  }) {
    return DatabaseDefinition(
      schemaVersion: schemaVersion ?? this.schemaVersion,
      name: name is String? ? name : this.name,
      moduleName: moduleName ?? this.moduleName,
      tables: tables ?? this.tables.map((e0) => e0.copyWith()).toList(),
      installedModules:
          installedModules ??
          this.installedModules.map((e0) => e0.copyWith()).toList(),
      migrationApiVersion: migrationApiVersion ?? this.migrationApiVersion,
    );
  }
}
