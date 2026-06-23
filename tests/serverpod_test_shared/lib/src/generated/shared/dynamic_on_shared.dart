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
import 'package:serverpod_serialization/serverpod_serialization.dart' as _i1;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _i2;

abstract class DynamicOnShared implements _i1.SerializableModel {
  DynamicOnShared._({
    required this.name,
    required this.data,
  });

  factory DynamicOnShared({
    required String name,
    required dynamic data,
  }) = _DynamicOnSharedImpl;

  factory DynamicOnShared.fromJson(Map<String, dynamic> jsonSerialization) {
    return DynamicOnShared(
      name: jsonSerialization['name'] as String,
      data: _i2.Protocol().deserializeDynamicFieldValue(
        jsonSerialization['data'],
      ),
    );
  }

  String name;

  dynamic data;

  /// Returns a shallow copy of this [DynamicOnShared]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DynamicOnShared copyWith({
    String? name,
    dynamic data,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DynamicOnShared',
      'name': name,
      'data': _i2.Protocol().dynamicFieldToJson(data),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DynamicOnSharedImpl extends DynamicOnShared {
  _DynamicOnSharedImpl({
    required String name,
    required dynamic data,
  }) : super._(
         name: name,
         data: data,
       );

  /// Returns a shallow copy of this [DynamicOnShared]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DynamicOnShared copyWith({
    String? name,
    Object? data = _Undefined,
  }) {
    return DynamicOnShared(
      name: name ?? this.name,
      data: data != _Undefined ? data : this.data,
    );
  }
}
