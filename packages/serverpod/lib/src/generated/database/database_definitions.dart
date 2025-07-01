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

/// Defines the current state of the database, including information about
/// installed modules and migrations.
abstract class DatabaseDefinitions
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  DatabaseDefinitions._({
    required this.target,
    required this.live,
    required this.installedMigrations,
    required this.latestAvailableMigrations,
  });

  factory DatabaseDefinitions({
    required List<_i2.TableDefinition> target,
    required List<_i2.TableDefinition> live,
    required List<_i3.DatabaseMigrationVersion> installedMigrations,
    required List<_i3.DatabaseMigrationVersion> latestAvailableMigrations,
  }) = _DatabaseDefinitionsImpl;

  factory DatabaseDefinitions.fromJson(Map<String, dynamic> jsonSerialization) {
    return DatabaseDefinitions(
      target: (jsonSerialization['target'] as List)
          .map((e) => _i2.TableDefinition.fromJson((e as Map<String, dynamic>)))
          .toList(),
      live: (jsonSerialization['live'] as List)
          .map((e) => _i2.TableDefinition.fromJson((e as Map<String, dynamic>)))
          .toList(),
      installedMigrations: (jsonSerialization['installedMigrations'] as List)
          .map((e) => _i3.DatabaseMigrationVersion.fromJson(
              (e as Map<String, dynamic>)))
          .toList(),
      latestAvailableMigrations:
          (jsonSerialization['latestAvailableMigrations'] as List)
              .map((e) => _i3.DatabaseMigrationVersion.fromJson(
                  (e as Map<String, dynamic>)))
              .toList(),
    );
  }

  /// The target database definition.
  List<_i2.TableDefinition> target;

  /// A definition of the database as it is currently.
  List<_i2.TableDefinition> live;

  /// The migrations that are installed in the database.
  List<_i3.DatabaseMigrationVersion> installedMigrations;

  /// The latest available migrations that can be applied.
  List<_i3.DatabaseMigrationVersion> latestAvailableMigrations;

  /// Returns a shallow copy of this [DatabaseDefinitions]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DatabaseDefinitions copyWith({
    List<_i2.TableDefinition>? target,
    List<_i2.TableDefinition>? live,
    List<_i3.DatabaseMigrationVersion>? installedMigrations,
    List<_i3.DatabaseMigrationVersion>? latestAvailableMigrations,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'target': target.toJson(valueToJson: (v) => v.toJson()),
      'live': live.toJson(valueToJson: (v) => v.toJson()),
      'installedMigrations':
          installedMigrations.toJson(valueToJson: (v) => v.toJson()),
      'latestAvailableMigrations':
          latestAvailableMigrations.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'target': target.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'live': live.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'installedMigrations':
          installedMigrations.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'latestAvailableMigrations': latestAvailableMigrations.toJson(
          valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _DatabaseDefinitionsImpl extends DatabaseDefinitions {
  _DatabaseDefinitionsImpl({
    required List<_i2.TableDefinition> target,
    required List<_i2.TableDefinition> live,
    required List<_i3.DatabaseMigrationVersion> installedMigrations,
    required List<_i3.DatabaseMigrationVersion> latestAvailableMigrations,
  }) : super._(
          target: target,
          live: live,
          installedMigrations: installedMigrations,
          latestAvailableMigrations: latestAvailableMigrations,
        );

  /// Returns a shallow copy of this [DatabaseDefinitions]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DatabaseDefinitions copyWith({
    List<_i2.TableDefinition>? target,
    List<_i2.TableDefinition>? live,
    List<_i3.DatabaseMigrationVersion>? installedMigrations,
    List<_i3.DatabaseMigrationVersion>? latestAvailableMigrations,
  }) {
    return DatabaseDefinitions(
      target: target ?? this.target.map((e0) => e0.copyWith()).toList(),
      live: live ?? this.live.map((e0) => e0.copyWith()).toList(),
      installedMigrations: installedMigrations ??
          this.installedMigrations.map((e0) => e0.copyWith()).toList(),
      latestAvailableMigrations: latestAvailableMigrations ??
          this.latestAvailableMigrations.map((e0) => e0.copyWith()).toList(),
    );
  }
}
