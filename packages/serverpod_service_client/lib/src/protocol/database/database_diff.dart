/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../protocol.dart' as _i2;

class DatabaseDiff extends _i1.SerializableEntity {
  DatabaseDiff({
    required this.addTables,
    required this.deleteTables,
    required this.modifyTables,
  });

  factory DatabaseDiff.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return DatabaseDiff(
      addTables: serializationManager.deserialize<List<_i2.TableDefinition>>(
          jsonSerialization['addTables']),
      deleteTables: serializationManager
          .deserialize<List<String>>(jsonSerialization['deleteTables']),
      modifyTables: serializationManager
          .deserialize<List<_i2.TableDiff>>(jsonSerialization['modifyTables']),
    );
  }

  List<_i2.TableDefinition> addTables;

  List<String> deleteTables;

  List<_i2.TableDiff> modifyTables;

  @override
  Map<String, dynamic> toJson() {
    return {
      'addTables': addTables,
      'deleteTables': deleteTables,
      'modifyTables': modifyTables,
    };
  }
}
