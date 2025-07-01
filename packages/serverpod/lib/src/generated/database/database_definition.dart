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
import '../database/table_definition.dart' as _i2;
import '../database/database_migration_version.dart' as _i3;

/// Defines the structure of the database used by Serverpod.
abstract class DatabaseDefinition
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
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
    required List<_i3.DatabaseMigrationVersion> installedModules,
    required int migrationApiVersion,
  }) = _DatabaseDefinitionImpl;

  factory DatabaseDefinition.fromJson(Map<String, dynamic> jsonSerialization) {
    return DatabaseDefinition(
      name: jsonSerialization['name'] as String?,
      moduleName: jsonSerialization['moduleName'] as String,
      tables: (jsonSerialization['tables'] as List)
          .map((e) => _i2.TableDefinition.fromJson((e as Map<String, dynamic>)))
          .toList(),
      installedModules: (jsonSerialization['installedModules'] as List)
          .map((e) => _i3.DatabaseMigrationVersion.fromJson(
              (e as Map<String, dynamic>)))
          .toList(),
      migrationApiVersion: jsonSerialization['migrationApiVersion'] as int,
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
  List<_i3.DatabaseMigrationVersion> installedModules;

  /// The version of the database definition.
  int migrationApiVersion;

  /// Returns a shallow copy of this [DatabaseDefinition]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DatabaseDefinition copyWith({
    String? name,
    String? moduleName,
    List<_i2.TableDefinition>? tables,
    List<_i3.DatabaseMigrationVersion>? installedModules,
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

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (name != null) 'name': name,
      'moduleName': moduleName,
      'tables': tables.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'installedModules':
          installedModules.toJson(valueToJson: (v) => v.toJsonForProtocol()),
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
    String? name,
    required String moduleName,
    required List<_i2.TableDefinition> tables,
    required List<_i3.DatabaseMigrationVersion> installedModules,
    required int migrationApiVersion,
  }) : super._(
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
    Object? name = _Undefined,
    String? moduleName,
    List<_i2.TableDefinition>? tables,
    List<_i3.DatabaseMigrationVersion>? installedModules,
    int? migrationApiVersion,
  }) {
    return DatabaseDefinition(
      name: name is String? ? name : this.name,
      moduleName: moduleName ?? this.moduleName,
      tables: tables ?? this.tables.map((e0) => e0.copyWith()).toList(),
      installedModules: installedModules ??
          this.installedModules.map((e0) => e0.copyWith()).toList(),
      migrationApiVersion: migrationApiVersion ?? this.migrationApiVersion,
    );
  }
}
