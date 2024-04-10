/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
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

  factory BulkData.fromJson(Map<String, dynamic> jsonSerialization) {
    return BulkData(
      tableDefinition: _i2.TableDefinition.fromJson(
          (jsonSerialization['tableDefinition'] as Map<String, dynamic>)),
      data: jsonSerialization['data'] as String,
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
      'tableDefinition': tableDefinition.toJson(),
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
