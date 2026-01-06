/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: deprecated_member_use_from_same_package

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _i2;

@_i1.immutable
abstract class ImmutableObjectWithMap implements _i1.SerializableModel {
  const ImmutableObjectWithMap._({required this.mapVariable});

  const factory ImmutableObjectWithMap({
    required Map<String, String> mapVariable,
  }) = _ImmutableObjectWithMapImpl;

  factory ImmutableObjectWithMap.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ImmutableObjectWithMap(
      mapVariable: _i2.Protocol().deserialize<Map<String, String>>(
        jsonSerialization['mapVariable'],
      ),
    );
  }

  final Map<String, String> mapVariable;

  /// Returns a shallow copy of this [ImmutableObjectWithMap]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ImmutableObjectWithMap copyWith({Map<String, String>? mapVariable});
  @override
  bool operator ==(Object other) {
    return identical(
          other,
          this,
        ) ||
        other.runtimeType == runtimeType &&
            other is ImmutableObjectWithMap &&
            const _i1.DeepCollectionEquality().equals(
              other.mapVariable,
              mapVariable,
            );
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      const _i1.DeepCollectionEquality().hash(mapVariable),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ImmutableObjectWithMap',
      'mapVariable': mapVariable.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ImmutableObjectWithMapImpl extends ImmutableObjectWithMap {
  const _ImmutableObjectWithMapImpl({required Map<String, String> mapVariable})
    : super._(mapVariable: mapVariable);

  /// Returns a shallow copy of this [ImmutableObjectWithMap]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ImmutableObjectWithMap copyWith({Map<String, String>? mapVariable}) {
    return ImmutableObjectWithMap(
      mapVariable:
          mapVariable ??
          this.mapVariable.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0,
            ),
          ),
    );
  }
}
