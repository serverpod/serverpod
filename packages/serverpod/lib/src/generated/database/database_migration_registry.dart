/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Defines a registry over migrations for a database.
abstract class DatabaseMigrationRegistry extends _i1.SerializableEntity {
  DatabaseMigrationRegistry._({required this.migrations});

  factory DatabaseMigrationRegistry({required List<String> migrations}) =
      _DatabaseMigrationRegistryImpl;

  factory DatabaseMigrationRegistry.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return DatabaseMigrationRegistry(
        migrations: serializationManager
            .deserialize<List<String>>(jsonSerialization['migrations']));
  }

  /// List of migrations for the database.
  List<String> migrations;

  DatabaseMigrationRegistry copyWith({List<String>? migrations});
  @override
  Map<String, dynamic> toJson() {
    return {'migrations': migrations};
  }

  @override
  Map<String, dynamic> allToJson() {
    return {'migrations': migrations};
  }
}

class _DatabaseMigrationRegistryImpl extends DatabaseMigrationRegistry {
  _DatabaseMigrationRegistryImpl({required List<String> migrations})
      : super._(migrations: migrations);

  @override
  DatabaseMigrationRegistry copyWith({List<String>? migrations}) {
    return DatabaseMigrationRegistry(
        migrations: migrations ?? this.migrations.clone());
  }
}
