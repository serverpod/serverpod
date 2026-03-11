/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

part of 'sealed_parent_nullable_field.dart';

abstract class SealedChildOnlyRequired extends _i1.SealedParentNullableField
    implements _i2.SerializableModel, _i2.ProtocolSerialization {
  SealedChildOnlyRequired._({
    super.nullableField,
    required this.requiredField,
  });

  factory SealedChildOnlyRequired({
    String? nullableField,
    required String requiredField,
  }) = _SealedChildOnlyRequiredImpl;

  factory SealedChildOnlyRequired.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return SealedChildOnlyRequired(
      nullableField: jsonSerialization['nullableField'] as String?,
      requiredField: jsonSerialization['requiredField'] as String,
    );
  }

  String requiredField;

  /// Returns a shallow copy of this [SealedChildOnlyRequired]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  SealedChildOnlyRequired copyWith({
    Object? nullableField,
    String? requiredField,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SealedChildOnlyRequired',
      if (nullableField != null) 'nullableField': nullableField,
      'requiredField': requiredField,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SealedChildOnlyRequired',
      if (nullableField != null) 'nullableField': nullableField,
      'requiredField': requiredField,
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _SealedChildOnlyRequiredImpl extends SealedChildOnlyRequired {
  _SealedChildOnlyRequiredImpl({
    String? nullableField,
    required String requiredField,
  }) : super._(
         nullableField: nullableField,
         requiredField: requiredField,
       );

  /// Returns a shallow copy of this [SealedChildOnlyRequired]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  SealedChildOnlyRequired copyWith({
    Object? nullableField = _Undefined,
    String? requiredField,
  }) {
    return SealedChildOnlyRequired(
      nullableField: nullableField is String?
          ? nullableField
          : this.nullableField,
      requiredField: requiredField ?? this.requiredField,
    );
  }
}
