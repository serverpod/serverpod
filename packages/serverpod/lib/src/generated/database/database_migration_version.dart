/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

/// Represents a version of a database migration.
abstract class DatabaseMigrationVersion extends _i1.SerializableEntity {
  DatabaseMigrationVersion._({
    required this.module,
    required this.version,
    this.priority,
    this.timestamp,
  });

  factory DatabaseMigrationVersion({
    required String module,
    required String version,
    int? priority,
    DateTime? timestamp,
  }) = _DatabaseMigrationVersionImpl;

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

  DatabaseMigrationVersion copyWith({
    String? module,
    String? version,
    int? priority,
    DateTime? timestamp,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'module': module,
      'version': version,
      'priority': priority,
      'timestamp': timestamp,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'module': module,
      'version': version,
      'priority': priority,
      'timestamp': timestamp,
    };
  }
}

class _Undefined {}

class _DatabaseMigrationVersionImpl extends DatabaseMigrationVersion {
  _DatabaseMigrationVersionImpl({
    required String module,
    required String version,
    int? priority,
    DateTime? timestamp,
  }) : super._(
          module: module,
          version: version,
          priority: priority,
          timestamp: timestamp,
        );

  @override
  DatabaseMigrationVersion copyWith({
    String? module,
    String? version,
    Object? priority = _Undefined,
    Object? timestamp = _Undefined,
  }) {
    return DatabaseMigrationVersion(
      module: module ?? this.module,
      version: version ?? this.version,
      priority: priority is! int? ? this.priority : priority,
      timestamp: timestamp is! DateTime? ? this.timestamp : timestamp,
    );
  }
}
