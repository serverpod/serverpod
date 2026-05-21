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
import 'package:serverpod_database/serverpod_database.dart' as _i2;

/// Result of applying database migrations via the Insights endpoint.
abstract class MigrationsApplyResult implements _i1.SerializableModel {
  MigrationsApplyResult._({
    this.migrationsApplied,
    this.repairMigrationApplied,
    required this.databaseMatchesTargetState,
  });

  factory MigrationsApplyResult({
    List<String>? migrationsApplied,
    String? repairMigrationApplied,
    required bool databaseMatchesTargetState,
  }) = _MigrationsApplyResultImpl;

  factory MigrationsApplyResult.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return MigrationsApplyResult(
      migrationsApplied: jsonSerialization['migrationsApplied'] == null
          ? null
          : _i2.Protocol().deserialize<List<String>>(
              jsonSerialization['migrationsApplied'],
            ),
      repairMigrationApplied:
          jsonSerialization['repairMigrationApplied'] as String?,
      databaseMatchesTargetState: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['databaseMatchesTargetState'],
      ),
    );
  }

  /// Versions of regular migrations that were applied. An empty list means
  /// `applyMigrations` was true but the database was already at the latest
  /// version. `null` means `applyMigrations` was false — no attempt was
  /// made to apply regular migrations.
  List<String>? migrationsApplied;

  /// Version name of the repair migration that was applied, or `null` if
  /// `applyRepairMigration` was false, no repair migration file exists, or
  /// the repair migration was already applied to this database.
  String? repairMigrationApplied;

  /// Whether the live database schema matches the target schema after
  /// applying migrations. `false` indicates either schema drift between
  /// the code's target tables and the live database, or that verification
  /// could not run to completion.
  bool databaseMatchesTargetState;

  /// Returns a shallow copy of this [MigrationsApplyResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MigrationsApplyResult copyWith({
    List<String>? migrationsApplied,
    String? repairMigrationApplied,
    bool? databaseMatchesTargetState,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.MigrationsApplyResult',
      if (migrationsApplied != null)
        'migrationsApplied': migrationsApplied?.toJson(),
      if (repairMigrationApplied != null)
        'repairMigrationApplied': repairMigrationApplied,
      'databaseMatchesTargetState': databaseMatchesTargetState,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MigrationsApplyResultImpl extends MigrationsApplyResult {
  _MigrationsApplyResultImpl({
    List<String>? migrationsApplied,
    String? repairMigrationApplied,
    required bool databaseMatchesTargetState,
  }) : super._(
         migrationsApplied: migrationsApplied,
         repairMigrationApplied: repairMigrationApplied,
         databaseMatchesTargetState: databaseMatchesTargetState,
       );

  /// Returns a shallow copy of this [MigrationsApplyResult]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MigrationsApplyResult copyWith({
    Object? migrationsApplied = _Undefined,
    Object? repairMigrationApplied = _Undefined,
    bool? databaseMatchesTargetState,
  }) {
    return MigrationsApplyResult(
      migrationsApplied: migrationsApplied is List<String>?
          ? migrationsApplied
          : this.migrationsApplied?.map((e0) => e0).toList(),
      repairMigrationApplied: repairMigrationApplied is String?
          ? repairMigrationApplied
          : this.repairMigrationApplied,
      databaseMatchesTargetState:
          databaseMatchesTargetState ?? this.databaseMatchesTargetState,
    );
  }
}
