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
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod/src/generated/protocol.dart' as _i2;

/// Result of applying database migrations via the Insights endpoint.
abstract class MigrationApplyResult
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  MigrationApplyResult._({
    this.repairMigrationApplied,
    this.migrationsApplied,
  });

  factory MigrationApplyResult({
    String? repairMigrationApplied,
    List<String>? migrationsApplied,
  }) = _MigrationApplyResultImpl;

  factory MigrationApplyResult.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return MigrationApplyResult(
      repairMigrationApplied:
          jsonSerialization['repairMigrationApplied'] as String?,
      migrationsApplied: jsonSerialization['migrationsApplied'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['migrationsApplied'],
            ),
    );
  }

  /// Version name of the repair migration that was applied, or `null` if
  /// `applyRepairMigration` was false, no repair migration file exists, or
  /// the repair migration was already applied to this database.
  String? repairMigrationApplied;

  /// Versions of regular migrations that were applied, or `null` if
  /// `applyMigrations` was false or the database was already at the latest
  /// version.
  List<String>? migrationsApplied;

  /// Returns a shallow copy of this [MigrationApplyResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MigrationApplyResult copyWith({
    String? repairMigrationApplied,
    List<String>? migrationsApplied,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.MigrationApplyResult',
      if (repairMigrationApplied != null)
        'repairMigrationApplied': repairMigrationApplied,
      if (migrationsApplied != null)
        'migrationsApplied': migrationsApplied?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod.MigrationApplyResult',
      if (repairMigrationApplied != null)
        'repairMigrationApplied': repairMigrationApplied,
      if (migrationsApplied != null)
        'migrationsApplied': migrationsApplied?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MigrationApplyResultImpl extends MigrationApplyResult {
  _MigrationApplyResultImpl({
    String? repairMigrationApplied,
    List<String>? migrationsApplied,
  }) : super._(
         repairMigrationApplied: repairMigrationApplied,
         migrationsApplied: migrationsApplied,
       );

  /// Returns a shallow copy of this [MigrationApplyResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MigrationApplyResult copyWith({
    Object? repairMigrationApplied = _Undefined,
    Object? migrationsApplied = _Undefined,
  }) {
    return MigrationApplyResult(
      repairMigrationApplied: repairMigrationApplied is String?
          ? repairMigrationApplied
          : this.repairMigrationApplied,
      migrationsApplied: migrationsApplied is List<String>?
          ? migrationsApplied
          : this.migrationsApplied?.map((e0) => e0).toList(),
    );
  }
}
