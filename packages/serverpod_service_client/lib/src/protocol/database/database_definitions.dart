/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../protocol.dart' as _i2;

/// Defines the current state of the database, including information about
/// installed modules and migrations.
class DatabaseDefinitions extends _i1.SerializableEntity {
  DatabaseDefinitions({
    required this.target,
    required this.live,
    required this.installedMigrations,
    required this.latestAvailableMigrations,
  });

  factory DatabaseDefinitions.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return DatabaseDefinitions(
      target: serializationManager
          .deserialize<_i2.DatabaseDefinition>(jsonSerialization['target']),
      live: serializationManager
          .deserialize<_i2.DatabaseDefinition>(jsonSerialization['live']),
      installedMigrations:
          serializationManager.deserialize<List<_i2.DatabaseMigrationVersion>>(
              jsonSerialization['installedMigrations']),
      latestAvailableMigrations:
          serializationManager.deserialize<List<_i2.DatabaseMigrationVersion>>(
              jsonSerialization['latestAvailableMigrations']),
    );
  }

  /// The target database definition.
  _i2.DatabaseDefinition target;

  /// A definition of the database as it is currently.
  _i2.DatabaseDefinition live;

  /// The migrations that are installed in the database.
  List<_i2.DatabaseMigrationVersion> installedMigrations;

  /// The latest available migrations that can be applied.
  List<_i2.DatabaseMigrationVersion> latestAvailableMigrations;

  @override
  Map<String, dynamic> toJson() {
    return {
      'target': target,
      'live': live,
      'installedMigrations': installedMigrations,
      'latestAvailableMigrations': latestAvailableMigrations,
    };
  }
}
