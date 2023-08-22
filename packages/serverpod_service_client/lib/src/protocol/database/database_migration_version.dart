/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Represents a version of a database migration.
class DatabaseMigrationVersion extends _i1.SerializableEntity {
  DatabaseMigrationVersion({
    required this.module,
    required this.version,
    this.priority,
    this.timestamp,
  });

  factory DatabaseMigrationVersion.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return DatabaseMigrationVersion(
      module:
          serializationManager.deserialize<String>(jsonSerialization['module']),
      version: serializationManager
          .deserialize<String>(jsonSerialization['version']),
      priority:
          serializationManager.deserialize<int?>(jsonSerialization['priority']),
      timestamp: serializationManager
          .deserialize<DateTime?>(jsonSerialization['timestamp']),
    );
  }

  /// The module the migration belongs to.
  String module;

  /// The version of the migration.
  String version;

  /// The priority of the migration. Determines the order in which the
  /// migrations are applied.
  int? priority;

  /// The timestamp of the migration. Only set if the migration is applied.
  DateTime? timestamp;

  @override
  Map<String, dynamic> toJson() {
    return {
      'module': module,
      'version': version,
      'priority': priority,
      'timestamp': timestamp,
    };
  }
}
