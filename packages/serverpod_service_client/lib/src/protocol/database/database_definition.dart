/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../protocol.dart' as _i2;

/// Defines the structure of the database used by Serverpod.
class DatabaseDefinition extends _i1.SerializableEntity {
  DatabaseDefinition({
    this.name,
    required this.tables,
    this.priority,
    this.installedModules,
  });

  factory DatabaseDefinition.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return DatabaseDefinition(
      name:
          serializationManager.deserialize<String?>(jsonSerialization['name']),
      tables: serializationManager
          .deserialize<List<_i2.TableDefinition>>(jsonSerialization['tables']),
      priority:
          serializationManager.deserialize<int?>(jsonSerialization['priority']),
      installedModules: serializationManager.deserialize<Map<String, String>?>(
          jsonSerialization['installedModules']),
    );
  }

  /// The name of the database.
  /// Null if the name is not available.
  String? name;

  /// The tables of the database.
  List<_i2.TableDefinition> tables;

  /// The priority of this database definition. Determines the order in which
  /// the database definitions are applied. Only valid if the definition
  /// defines a single module.
  int? priority;

  /// Modules installed in the database, together with their version. Only
  /// set if known.
  Map<String, String>? installedModules;

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'tables': tables,
      'priority': priority,
      'installedModules': installedModules,
    };
  }
}
