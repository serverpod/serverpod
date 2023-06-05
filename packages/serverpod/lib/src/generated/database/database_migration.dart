/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../protocol.dart' as _i2;
import 'package:collection/collection.dart' as _i3;

abstract class DatabaseMigration extends _i1.SerializableEntity {
  const DatabaseMigration._();

  const factory DatabaseMigration({
    required List<_i2.DatabaseMigrationAction> actions,
    required List<_i2.DatabaseMigrationWarning> warnings,
    required int priority,
  }) = _DatabaseMigration;

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
      priority:
          serializationManager.deserialize<int>(jsonSerialization['priority']),
    );
  }

  DatabaseMigration copyWith({
    List<_i2.DatabaseMigrationAction>? actions,
    List<_i2.DatabaseMigrationWarning>? warnings,
    int? priority,
  });
  List<_i2.DatabaseMigrationAction> get actions;
  List<_i2.DatabaseMigrationWarning> get warnings;
  int get priority;
}

class _DatabaseMigration extends DatabaseMigration {
  const _DatabaseMigration({
    required this.actions,
    required this.warnings,
    required this.priority,
  }) : super._();

  @override
  final List<_i2.DatabaseMigrationAction> actions;

  @override
  final List<_i2.DatabaseMigrationWarning> warnings;

  @override
  final int priority;

  @override
  Map<String, dynamic> toJson() {
    return {
      'actions': actions,
      'warnings': warnings,
      'priority': priority,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is DatabaseMigration &&
            (identical(
                  other.priority,
                  priority,
                ) ||
                other.priority == priority) &&
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
        priority,
        const _i3.DeepCollectionEquality().hash(actions),
        const _i3.DeepCollectionEquality().hash(warnings),
      );

  @override
  DatabaseMigration copyWith({
    List<_i2.DatabaseMigrationAction>? actions,
    List<_i2.DatabaseMigrationWarning>? warnings,
    int? priority,
  }) {
    return DatabaseMigration(
      actions: actions ?? this.actions,
      warnings: warnings ?? this.warnings,
      priority: priority ?? this.priority,
    );
  }
}
