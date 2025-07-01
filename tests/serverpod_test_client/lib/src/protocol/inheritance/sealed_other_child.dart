/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

part of 'sealed_parent.dart';

abstract class SealedOtherChild extends _i1.SealedParent
    implements _i2.SerializableModel {
  SealedOtherChild._({
    required super.sealedInt,
    required super.sealedString,
    required this.sealedOtherChildField,
  });

  factory SealedOtherChild({
    required int sealedInt,
    required String sealedString,
    required int sealedOtherChildField,
  }) = _SealedOtherChildImpl;

  factory SealedOtherChild.fromJson(Map<String, dynamic> jsonSerialization) {
    return SealedOtherChild(
      sealedInt: jsonSerialization['sealedInt'] as int,
      sealedString: jsonSerialization['sealedString'] as String,
      sealedOtherChildField: jsonSerialization['sealedOtherChildField'] as int,
    );
  }

  int sealedOtherChildField;

  /// Returns a shallow copy of this [SealedOtherChild]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  SealedOtherChild copyWith({
    int? sealedInt,
    String? sealedString,
    int? sealedOtherChildField,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'sealedInt': sealedInt,
      'sealedString': sealedString,
      'sealedOtherChildField': sealedOtherChildField,
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _SealedOtherChildImpl extends SealedOtherChild {
  _SealedOtherChildImpl({
    required int sealedInt,
    required String sealedString,
    required int sealedOtherChildField,
  }) : super._(
          sealedInt: sealedInt,
          sealedString: sealedString,
          sealedOtherChildField: sealedOtherChildField,
        );

  /// Returns a shallow copy of this [SealedOtherChild]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  SealedOtherChild copyWith({
    int? sealedInt,
    String? sealedString,
    int? sealedOtherChildField,
  }) {
    return SealedOtherChild(
      sealedInt: sealedInt ?? this.sealedInt,
      sealedString: sealedString ?? this.sealedString,
      sealedOtherChildField:
          sealedOtherChildField ?? this.sealedOtherChildField,
    );
  }
}
