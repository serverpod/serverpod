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

/// Defines the current state of the database, including information about
/// installed modules and migrations.
abstract class DatabaseDefinitions
    implements _iss.SerializableModel, _iss.ProtocolSerialization {
  DatabaseDefinitions._({
    required this.target,
    required this.live,
    required this.installedMigrations,
    required this.latestAvailableMigrations,
  });

  factory DatabaseDefinitions({
    required List<_isd.TableDefinition> target,
    required List<_isd.TableDefinition> live,
    required List<_isd.DatabaseMigrationVersionModel> installedMigrations,
    required List<_isd.DatabaseMigrationVersionModel> latestAvailableMigrations,
  }) = _DatabaseDefinitionsImpl;

  factory DatabaseDefinitions.fromJson(Map<String, dynamic> jsonSerialization) {
    return DatabaseDefinitions(
      target: _isd.Protocol().deserialize<List<_isd.TableDefinition>>(
        jsonSerialization['target'],
      ),
      live: _isd.Protocol().deserialize<List<_isd.TableDefinition>>(
        jsonSerialization['live'],
      ),
      installedMigrations: _isd.Protocol()
          .deserialize<List<_isd.DatabaseMigrationVersionModel>>(
            jsonSerialization['installedMigrations'],
          ),
      latestAvailableMigrations: _isd.Protocol()
          .deserialize<List<_isd.DatabaseMigrationVersionModel>>(
            jsonSerialization['latestAvailableMigrations'],
          ),
    );
  }

  /// The target database definition.
  List<_isd.TableDefinition> target;

  /// A definition of the database as it is currently.
  List<_isd.TableDefinition> live;

  /// The migrations that are installed in the database.
  List<_isd.DatabaseMigrationVersionModel> installedMigrations;

  /// The latest available migrations that can be applied.
  List<_isd.DatabaseMigrationVersionModel> latestAvailableMigrations;

  /// Returns a shallow copy of this [DatabaseDefinitions]
  /// with some or all fields replaced by the given arguments.
  @_iss.useResult
  DatabaseDefinitions copyWith({
    List<_isd.TableDefinition>? target,
    List<_isd.TableDefinition>? live,
    List<_isd.DatabaseMigrationVersionModel>? installedMigrations,
    List<_isd.DatabaseMigrationVersionModel>? latestAvailableMigrations,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.DatabaseDefinitions',
      'target': target.toJson(valueToJson: (v) => v.toJson()),
      'live': live.toJson(valueToJson: (v) => v.toJson()),
      'installedMigrations': installedMigrations.toJson(
        valueToJson: (v) => v.toJson(),
      ),
      'latestAvailableMigrations': latestAvailableMigrations.toJson(
        valueToJson: (v) => v.toJson(),
      ),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod.DatabaseDefinitions',
      'target': target.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'live': live.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'installedMigrations': installedMigrations.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'latestAvailableMigrations': latestAvailableMigrations.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _iss.SerializationManager.encode(this);
  }
}

class _DatabaseDefinitionsImpl extends DatabaseDefinitions {
  _DatabaseDefinitionsImpl({
    required List<_isd.TableDefinition> target,
    required List<_isd.TableDefinition> live,
    required List<_isd.DatabaseMigrationVersionModel> installedMigrations,
    required List<_isd.DatabaseMigrationVersionModel> latestAvailableMigrations,
  }) : super._(
         target: target,
         live: live,
         installedMigrations: installedMigrations,
         latestAvailableMigrations: latestAvailableMigrations,
       );

  /// Returns a shallow copy of this [DatabaseDefinitions]
  /// with some or all fields replaced by the given arguments.
  @_iss.useResult
  @override
  DatabaseDefinitions copyWith({
    List<_isd.TableDefinition>? target,
    List<_isd.TableDefinition>? live,
    List<_isd.DatabaseMigrationVersionModel>? installedMigrations,
    List<_isd.DatabaseMigrationVersionModel>? latestAvailableMigrations,
  }) {
    return DatabaseDefinitions(
      target: target ?? this.target.map((e0) => e0.copyWith()).toList(),
      live: live ?? this.live.map((e0) => e0.copyWith()).toList(),
      installedMigrations:
          installedMigrations ??
          this.installedMigrations.map((e0) => e0.copyWith()).toList(),
      latestAvailableMigrations:
          latestAvailableMigrations ??
          this.latestAvailableMigrations.map((e0) => e0.copyWith()).toList(),
    );
  }
}
