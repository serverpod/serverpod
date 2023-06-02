/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../protocol.dart' as _i2;

class DatabaseMigration extends _i1.SerializableEntity {
  DatabaseMigration({
    required this.actions,
    required this.warnings,
    required this.priority,
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
      priority:
          serializationManager.deserialize<int>(jsonSerialization['priority']),
    );
  }

  List<_i2.DatabaseMigrationAction> actions;

  List<_i2.DatabaseMigrationWarning> warnings;

  int priority;

  @override
  Map<String, dynamic> toJson() {
    return {
      'actions': actions,
      'warnings': warnings,
      'priority': priority,
    };
  }
}
