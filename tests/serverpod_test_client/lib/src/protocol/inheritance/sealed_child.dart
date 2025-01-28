/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

part of 'sealed_parent.dart';

class SealedChild extends _i1.SealedParent implements _i2.SerializableModel {
  SealedChild({
    required super.sealedInt,
    required super.sealedString,
    this.nullableInt,
  });

  factory SealedChild.fromJson(Map<String, dynamic> jsonSerialization) {
    return SealedChild(
      sealedInt: jsonSerialization['sealedInt'] as int,
      sealedString: jsonSerialization['sealedString'] as String,
      nullableInt: jsonSerialization['nullableInt'] as int?,
    );
  }

  int? nullableInt;

  /// Returns a shallow copy of this [SealedChild]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  SealedChild copyWith({
    int? sealedInt,
    String? sealedString,
    Object? nullableInt = _Undefined,
  }) {
    return SealedChild(
      sealedInt: sealedInt ?? this.sealedInt,
      sealedString: sealedString ?? this.sealedString,
      nullableInt: nullableInt is int? ? nullableInt : this.nullableInt,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'sealedInt': sealedInt,
      'sealedString': sealedString,
      if (nullableInt != null) 'nullableInt': nullableInt,
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}
