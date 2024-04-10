/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../protocol.dart' as _i2;
import 'package:serverpod_serialization/serverpod_serialization.dart';

abstract class DatabaseMigration extends _i1.SerializableEntity {
  DatabaseMigration._({
    required this.actions,
    required this.warnings,
    required this.migrationApiVersion,
  });

  factory DatabaseMigration({
    required List<_i2.DatabaseMigrationAction> actions,
    required List<_i2.DatabaseMigrationWarning> warnings,
    required int migrationApiVersion,
  }) = _DatabaseMigrationImpl;

  factory DatabaseMigration.fromJson(Map<String, dynamic> jsonSerialization) {
    return DatabaseMigration(
      actions: (jsonSerialization['actions'] as List)
          .map((e) =>
              _i2.DatabaseMigrationAction.fromJson((e as Map<String, dynamic>)))
          .toList(),
      warnings: (jsonSerialization['warnings'] as List)
          .map((e) => _i2.DatabaseMigrationWarning.fromJson(
              (e as Map<String, dynamic>)))
          .toList(),
      migrationApiVersion: jsonSerialization['migrationApiVersion'] as int,
    );
  }

  List<_i2.DatabaseMigrationAction> actions;

  List<_i2.DatabaseMigrationWarning> warnings;

  int migrationApiVersion;

  DatabaseMigration copyWith({
    List<_i2.DatabaseMigrationAction>? actions,
    List<_i2.DatabaseMigrationWarning>? warnings,
    int? migrationApiVersion,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'actions': actions.toJson(valueToJson: (v) => v.toJson()),
      'warnings': warnings.toJson(valueToJson: (v) => v.toJson()),
      'migrationApiVersion': migrationApiVersion,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'actions': actions.toJson(valueToJson: (v) => v.allToJson()),
      'warnings': warnings.toJson(valueToJson: (v) => v.allToJson()),
      'migrationApiVersion': migrationApiVersion,
    };
  }
}

class _DatabaseMigrationImpl extends DatabaseMigration {
  _DatabaseMigrationImpl({
    required List<_i2.DatabaseMigrationAction> actions,
    required List<_i2.DatabaseMigrationWarning> warnings,
    required int migrationApiVersion,
  }) : super._(
          actions: actions,
          warnings: warnings,
          migrationApiVersion: migrationApiVersion,
        );

  @override
  DatabaseMigration copyWith({
    List<_i2.DatabaseMigrationAction>? actions,
    List<_i2.DatabaseMigrationWarning>? warnings,
    int? migrationApiVersion,
  }) {
    return DatabaseMigration(
      actions: actions ?? this.actions.clone(),
      warnings: warnings ?? this.warnings.clone(),
      migrationApiVersion: migrationApiVersion ?? this.migrationApiVersion,
    );
  }
}
