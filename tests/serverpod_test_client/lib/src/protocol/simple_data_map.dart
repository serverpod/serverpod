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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _iza9lbb5;
import 'simple_data.dart' as _i0zisc0t;

abstract class SimpleDataMap
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SimpleDataMap._({required this.data});

  factory SimpleDataMap({required Map<String, _i0zisc0t.SimpleData> data}) =
      _SimpleDataMapImpl;

  factory SimpleDataMap.fromJson(Map<String, dynamic> jsonSerialization) {
    return SimpleDataMap(
      data: _iza9lbb5.Protocol().deserialize<Map<String, _i0zisc0t.SimpleData>>(
        jsonSerialization['data'],
      ),
    );
  }

  Map<String, _i0zisc0t.SimpleData> data;

  /// Returns a shallow copy of this [SimpleDataMap]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SimpleDataMap copyWith({Map<String, _i0zisc0t.SimpleData>? data});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SimpleDataMap',
      'data': data.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SimpleDataMap',
      'data': data.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _SimpleDataMapImpl extends SimpleDataMap {
  _SimpleDataMapImpl({required Map<String, _i0zisc0t.SimpleData> data})
    : super._(data: data);

  /// Returns a shallow copy of this [SimpleDataMap]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SimpleDataMap copyWith({Map<String, _i0zisc0t.SimpleData>? data}) {
    return SimpleDataMap(
      data:
          data ??
          this.data.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0.copyWith(),
            ),
          ),
    );
  }
}
