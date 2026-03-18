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

/// Represents a version of a database migration.
class DatabaseMigrationVersionModel implements _i1.SerializableModel {
  DatabaseMigrationVersionModel({
    required this.module,
    required this.version,
    this.timestamp,
  });

  factory DatabaseMigrationVersionModel.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DatabaseMigrationVersionModel(
      module: jsonSerialization['module'] as String,
      version: jsonSerialization['version'] as String,
      timestamp: jsonSerialization['timestamp'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['timestamp']),
    );
  }

  /// The module the migration belongs to.
  String module;

  /// The version of the migration.
  String version;

  /// The timestamp of the migration. Only set if the migration is applied.
  DateTime? timestamp;

  /// Returns a shallow copy of this [DatabaseMigrationVersionModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DatabaseMigrationVersionModel copyWith({
    String? module,
    String? version,
    Object? timestamp = _Undefined,
  }) {
    return DatabaseMigrationVersionModel(
      module: module ?? this.module,
      version: version ?? this.version,
      timestamp: timestamp is DateTime? ? timestamp : this.timestamp,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.DatabaseMigrationVersionModel',
      'module': module,
      'version': version,
      if (timestamp != null) 'timestamp': timestamp?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}
