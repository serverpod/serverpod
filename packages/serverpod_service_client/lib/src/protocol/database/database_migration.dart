/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../protocol.dart' as _i2;
import 'package:collection/collection.dart' as _i3;

class _Undefined {}

class DatabaseMigration extends _i1.SerializableEntity {
  DatabaseMigration({
    required this.actions,
    required this.warnings,
  });

  factory DatabaseMigration.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return DatabaseMigration(
      actions:
          serializationManager.deserialize<List<_i2.DatabaseMigrationAction>>(
              jsonSerialization['actions']),
      warnings:
          serializationManager.deserialize<List<_i2.DatabaseMigrationWarning>>(
              jsonSerialization['warnings']),
    );
  }

  final List<_i2.DatabaseMigrationAction> actions;

  final List<_i2.DatabaseMigrationWarning> warnings;

  late Function({
    List<_i2.DatabaseMigrationAction>? actions,
    List<_i2.DatabaseMigrationWarning>? warnings,
  }) copyWith = _copyWith;

  @override
  Map<String, dynamic> toJson() {
    return {
      'actions': actions,
      'warnings': warnings,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is DatabaseMigration &&
            const _i3.DeepCollectionEquality().equals(
              actions,
              other.actions,
            ) &&
            const _i3.DeepCollectionEquality().equals(
              warnings,
              other.warnings,
            ));
  }

  @override
  int get hashCode => Object.hash(
        const _i3.DeepCollectionEquality().hash(actions),
        const _i3.DeepCollectionEquality().hash(warnings),
      );

  DatabaseMigration _copyWith({
    List<_i2.DatabaseMigrationAction>? actions,
    List<_i2.DatabaseMigrationWarning>? warnings,
  }) {
    return DatabaseMigration(
      actions: actions ?? this.actions,
      warnings: warnings ?? this.warnings,
    );
  }
}
