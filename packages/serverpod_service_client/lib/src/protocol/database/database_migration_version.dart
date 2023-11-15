/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Represents a version of a database migration.
abstract class DatabaseMigrationVersion extends _i1.SerializableEntity {
  DatabaseMigrationVersion._({
    this.id,
    required this.module,
    required this.version,
    this.timestamp,
  });

  factory DatabaseMigrationVersion({
    int? id,
    required String module,
    required String version,
    DateTime? timestamp,
  }) = _DatabaseMigrationVersionImpl;

  factory DatabaseMigrationVersion.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return DatabaseMigrationVersion(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      module:
          serializationManager.deserialize<String>(jsonSerialization['module']),
      version: serializationManager
          .deserialize<String>(jsonSerialization['version']),
      timestamp: serializationManager
          .deserialize<DateTime?>(jsonSerialization['timestamp']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The module the migration belongs to.
  String module;

  /// The version of the migration.
  String version;

  /// The timestamp of the migration. Only set if the migration is applied.
  DateTime? timestamp;

  DatabaseMigrationVersion copyWith({
    int? id,
    String? module,
    String? version,
    DateTime? timestamp,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'module': module,
      'version': version,
      'timestamp': timestamp,
    };
  }
}

class _Undefined {}

class _DatabaseMigrationVersionImpl extends DatabaseMigrationVersion {
  _DatabaseMigrationVersionImpl({
    int? id,
    required String module,
    required String version,
    DateTime? timestamp,
  }) : super._(
          id: id,
          module: module,
          version: version,
          timestamp: timestamp,
        );

  @override
  DatabaseMigrationVersion copyWith({
    Object? id = _Undefined,
    String? module,
    String? version,
    Object? timestamp = _Undefined,
  }) {
    return DatabaseMigrationVersion(
      id: id is int? ? id : this.id,
      module: module ?? this.module,
      version: version ?? this.version,
      timestamp: timestamp is DateTime? ? timestamp : this.timestamp,
    );
  }
}
