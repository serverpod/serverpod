/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'simple_data.dart' as _i2;

abstract class SimpleDataMap
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  SimpleDataMap._({required this.data});

  factory SimpleDataMap({required Map<String, _i2.SimpleData> data}) =
      _SimpleDataMapImpl;

  factory SimpleDataMap.fromJson(Map<String, dynamic> jsonSerialization) {
    return SimpleDataMap(
        data: (jsonSerialization['data'] as Map).map((k, v) => MapEntry(
              k as String,
              _i2.SimpleData.fromJson((v as Map<String, dynamic>)),
            )));
  }

  Map<String, _i2.SimpleData> data;

  /// Returns a shallow copy of this [SimpleDataMap]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SimpleDataMap copyWith({Map<String, _i2.SimpleData>? data});
  @override
  Map<String, dynamic> toJson() {
    return {'data': data.toJson(valueToJson: (v) => v.toJson())};
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {'data': data.toJson(valueToJson: (v) => v.toJsonForProtocol())};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _SimpleDataMapImpl extends SimpleDataMap {
  _SimpleDataMapImpl({required Map<String, _i2.SimpleData> data})
      : super._(data: data);

  /// Returns a shallow copy of this [SimpleDataMap]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SimpleDataMap copyWith({Map<String, _i2.SimpleData>? data}) {
    return SimpleDataMap(
        data: data ??
            this.data.map((
                  key0,
                  value0,
                ) =>
                    MapEntry(
                      key0,
                      value0.copyWith(),
                    )));
  }
}
