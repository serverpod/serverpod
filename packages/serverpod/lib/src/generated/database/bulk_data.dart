/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../protocol.dart' as _i2;

abstract class BulkData extends _i1.SerializableEntity {
  BulkData._({
    required this.tableDefinition,
    required this.data,
  });

  factory BulkData({
    required _i2.TableDefinition tableDefinition,
    required String data,
  }) = _BulkDataImpl;

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

  BulkData copyWith({
    _i2.TableDefinition? tableDefinition,
    String? data,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'tableDefinition': tableDefinition,
      'data': data,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'tableDefinition': tableDefinition,
      'data': data,
    };
  }
}

class _BulkDataImpl extends BulkData {
  _BulkDataImpl({
    required _i2.TableDefinition tableDefinition,
    required String data,
  }) : super._(
          tableDefinition: tableDefinition,
          data: data,
        );

  @override
  BulkData copyWith({
    _i2.TableDefinition? tableDefinition,
    String? data,
  }) {
    return BulkData(
      tableDefinition: tableDefinition ?? this.tableDefinition.copyWith(),
      data: data ?? this.data,
    );
  }
}
