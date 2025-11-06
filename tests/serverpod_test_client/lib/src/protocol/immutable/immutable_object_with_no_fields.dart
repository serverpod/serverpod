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

@_i1.immutable
abstract class ImmutableObjectWithNoFields implements _i1.SerializableModel {
  const ImmutableObjectWithNoFields._();

  const factory ImmutableObjectWithNoFields() =
      _ImmutableObjectWithNoFieldsImpl;

  factory ImmutableObjectWithNoFields.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ImmutableObjectWithNoFields();
  }

  /// Returns a shallow copy of this [ImmutableObjectWithNoFields]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ImmutableObjectWithNoFields copyWith();
  @override
  bool operator ==(Object other) {
    return identical(other, this) ||
        other.runtimeType == runtimeType &&
            other is ImmutableObjectWithNoFields;
  }

  @override
  int get hashCode {
    return runtimeType.hashCode;
  }

  @override
  Map<String, dynamic> toJson() {
    return {};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ImmutableObjectWithNoFieldsImpl extends ImmutableObjectWithNoFields {
  const _ImmutableObjectWithNoFieldsImpl() : super._();

  /// Returns a shallow copy of this [ImmutableObjectWithNoFields]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ImmutableObjectWithNoFields copyWith() {
    return ImmutableObjectWithNoFields();
  }
}
