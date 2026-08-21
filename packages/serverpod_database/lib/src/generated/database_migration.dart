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

abstract class DatabaseMigration
    implements _iss.SerializableModel, _iss.ProtocolSerialization {
  DatabaseMigration._({
    required this.actions,
    required this.warnings,
    required this.migrationApiVersion,
  });

  factory DatabaseMigration({
    required List<_isd.DatabaseMigrationAction> actions,
    required List<_isd.DatabaseMigrationWarning> warnings,
    required int migrationApiVersion,
  }) = _DatabaseMigrationImpl;

  factory DatabaseMigration.fromJson(Map<String, dynamic> jsonSerialization) {
    return DatabaseMigration(
      actions: _isd.Protocol().deserialize<List<_isd.DatabaseMigrationAction>>(
        jsonSerialization['actions'],
      ),
      warnings: _isd.Protocol()
          .deserialize<List<_isd.DatabaseMigrationWarning>>(
            jsonSerialization['warnings'],
          ),
      migrationApiVersion: jsonSerialization['migrationApiVersion'] as int,
    );
  }

  List<_isd.DatabaseMigrationAction> actions;

  List<_isd.DatabaseMigrationWarning> warnings;

  int migrationApiVersion;

  /// Returns a shallow copy of this [DatabaseMigration]
  /// with some or all fields replaced by the given arguments.
  @_iss.useResult
  DatabaseMigration copyWith({
    List<_isd.DatabaseMigrationAction>? actions,
    List<_isd.DatabaseMigrationWarning>? warnings,
    int? migrationApiVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.DatabaseMigration',
      'actions': actions.toJson(valueToJson: (v) => v.toJson()),
      'warnings': warnings.toJson(valueToJson: (v) => v.toJson()),
      'migrationApiVersion': migrationApiVersion,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod.DatabaseMigration',
      'actions': actions.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'warnings': warnings.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'migrationApiVersion': migrationApiVersion,
    };
  }

  @override
  String toString() {
    return _iss.SerializationManager.encode(this);
  }
}

class _DatabaseMigrationImpl extends DatabaseMigration {
  _DatabaseMigrationImpl({
    required List<_isd.DatabaseMigrationAction> actions,
    required List<_isd.DatabaseMigrationWarning> warnings,
    required int migrationApiVersion,
  }) : super._(
         actions: actions,
         warnings: warnings,
         migrationApiVersion: migrationApiVersion,
       );

  /// Returns a shallow copy of this [DatabaseMigration]
  /// with some or all fields replaced by the given arguments.
  @_iss.useResult
  @override
  DatabaseMigration copyWith({
    List<_isd.DatabaseMigrationAction>? actions,
    List<_isd.DatabaseMigrationWarning>? warnings,
    int? migrationApiVersion,
  }) {
    return DatabaseMigration(
      actions: actions ?? this.actions.map((e0) => e0.copyWith()).toList(),
      warnings: warnings ?? this.warnings.map((e0) => e0.copyWith()).toList(),
      migrationApiVersion: migrationApiVersion ?? this.migrationApiVersion,
    );
  }
}
