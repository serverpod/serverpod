/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../protocol.dart' as _i2;

class BulkData extends _i1.SerializableEntity {
  BulkData({
    required this.tableDefinition,
    required this.data,
  });

  factory BulkData.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return BulkData(
      tableDefinition: serializationManager.deserialize<_i2.TableDefinition>(
          jsonSerialization['tableDefinition']),
      data: serializationManager.deserialize<String>(jsonSerialization['data']),
    );
  }

  _i2.TableDefinition tableDefinition;

  String data;

  @override
  Map<String, dynamic> toJson() {
    return {
      'tableDefinition': tableDefinition,
      'data': data,
    };
  }
}
