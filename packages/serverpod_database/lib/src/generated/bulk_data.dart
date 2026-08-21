/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import 'package:serverpod_serialization/serverpod_serialization.dart' as _iss;

abstract class BulkData
    implements _iss.SerializableModel, _iss.ProtocolSerialization {
  BulkData._({
    required this.tableDefinition,
    required this.data,
  });

  factory BulkData({
    required _isd.TableDefinition tableDefinition,
    required String data,
  }) = _BulkDataImpl;

  factory BulkData.fromJson(Map<String, dynamic> jsonSerialization) {
    return BulkData(
      tableDefinition: _isd.Protocol().deserialize<_isd.TableDefinition>(
        jsonSerialization['tableDefinition'],
      ),
      data: jsonSerialization['data'] as String,
    );
  }

  _isd.TableDefinition tableDefinition;

  String data;

  /// Returns a shallow copy of this [BulkData]
  /// with some or all fields replaced by the given arguments.
  @_iss.useResult
  BulkData copyWith({
    _isd.TableDefinition? tableDefinition,
    String? data,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod.BulkData',
      'tableDefinition': tableDefinition.toJson(),
      'data': data,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'serverpod.BulkData',
      'tableDefinition': tableDefinition.toJsonForProtocol(),
      'data': data,
    };
  }

  @override
  String toString() {
    return _iss.SerializationManager.encode(this);
  }
}

class _BulkDataImpl extends BulkData {
  _BulkDataImpl({
    required _isd.TableDefinition tableDefinition,
    required String data,
  }) : super._(
         tableDefinition: tableDefinition,
         data: data,
       );

  /// Returns a shallow copy of this [BulkData]
  /// with some or all fields replaced by the given arguments.
  @_iss.useResult
  @override
  BulkData copyWith({
    _isd.TableDefinition? tableDefinition,
    String? data,
  }) {
    return BulkData(
      tableDefinition: tableDefinition ?? this.tableDefinition.copyWith(),
      data: data ?? this.data,
    );
  }
}
