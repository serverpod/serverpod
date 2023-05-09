/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../protocol.dart' as _i2;

class DatabaseMigration extends _i1.SerializableEntity {
  DatabaseMigration({
    required this.addTables,
    required this.deleteTables,
    required this.modifyTables,
  });

  factory DatabaseMigration.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return DatabaseMigration(
      addTables: serializationManager.deserialize<List<_i2.TableDefinition>>(
          jsonSerialization['addTables']),
      deleteTables: serializationManager
          .deserialize<List<String>>(jsonSerialization['deleteTables']),
      modifyTables: serializationManager.deserialize<List<_i2.TableMigration>>(
          jsonSerialization['modifyTables']),
    );
  }

  List<_i2.TableDefinition> addTables;

  List<String> deleteTables;

  List<_i2.TableMigration> modifyTables;

  @override
  Map<String, dynamic> toJson() {
    return {
      'addTables': addTables,
      'deleteTables': deleteTables,
      'modifyTables': modifyTables,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'addTables': addTables,
      'deleteTables': deleteTables,
      'modifyTables': modifyTables,
    };
  }
}
