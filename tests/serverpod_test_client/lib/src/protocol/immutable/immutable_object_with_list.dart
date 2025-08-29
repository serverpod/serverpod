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
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class ImmutableObjectWithList implements _i1.SerializableModel {
  const ImmutableObjectWithList._({required this.listVariable});

  const factory ImmutableObjectWithList({required List<String> listVariable}) =
      _ImmutableObjectWithListImpl;

  factory ImmutableObjectWithList.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ImmutableObjectWithList(
        listVariable: (jsonSerialization['listVariable'] as List)
            .map((e) => e as String)
            .toList());
  }

  final List<String> listVariable;

  /// Returns a shallow copy of this [ImmutableObjectWithList]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ImmutableObjectWithList copyWith({List<String>? listVariable});
  @override
  bool operator ==(Object other) {
    return identical(
          other,
          this,
        ) ||
        other.runtimeType == runtimeType &&
            other is ImmutableObjectWithList &&
            const _i1.DeepCollectionEquality().equals(
              other.listVariable,
              listVariable,
            );
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      const _i1.DeepCollectionEquality().hash(listVariable),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'listVariable': listVariable.toJson()};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ImmutableObjectWithListImpl extends ImmutableObjectWithList {
  const _ImmutableObjectWithListImpl({required List<String> listVariable})
      : super._(listVariable: listVariable);

  /// Returns a shallow copy of this [ImmutableObjectWithList]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ImmutableObjectWithList copyWith({List<String>? listVariable}) {
    return ImmutableObjectWithList(
        listVariable:
            listVariable ?? this.listVariable.map((e0) => e0).toList());
  }
}
