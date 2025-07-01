/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

part of 'sealed_parent.dart';

abstract class SealedGrandChild extends _i1.SealedChild
    implements _i2.SerializableModel, _i2.ProtocolSerialization {
  SealedGrandChild._({
    required super.sealedInt,
    required super.sealedString,
    super.nullableInt,
    required this.sealedGrandchildField,
  });

  factory SealedGrandChild({
    required int sealedInt,
    required String sealedString,
    int? nullableInt,
    required String sealedGrandchildField,
  }) = _SealedGrandChildImpl;

  factory SealedGrandChild.fromJson(Map<String, dynamic> jsonSerialization) {
    return SealedGrandChild(
      sealedInt: jsonSerialization['sealedInt'] as int,
      sealedString: jsonSerialization['sealedString'] as String,
      nullableInt: jsonSerialization['nullableInt'] as int?,
      sealedGrandchildField:
          jsonSerialization['sealedGrandchildField'] as String,
    );
  }

  String sealedGrandchildField;

  /// Returns a shallow copy of this [SealedGrandChild]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  SealedGrandChild copyWith({
    int? sealedInt,
    String? sealedString,
    Object? nullableInt,
    String? sealedGrandchildField,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'sealedInt': sealedInt,
      'sealedString': sealedString,
      if (nullableInt != null) 'nullableInt': nullableInt,
      'sealedGrandchildField': sealedGrandchildField,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'sealedInt': sealedInt,
      'sealedString': sealedString,
      if (nullableInt != null) 'nullableInt': nullableInt,
      'sealedGrandchildField': sealedGrandchildField,
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _SealedGrandChildImpl extends SealedGrandChild {
  _SealedGrandChildImpl({
    required int sealedInt,
    required String sealedString,
    int? nullableInt,
    required String sealedGrandchildField,
  }) : super._(
          sealedInt: sealedInt,
          sealedString: sealedString,
          nullableInt: nullableInt,
          sealedGrandchildField: sealedGrandchildField,
        );

  /// Returns a shallow copy of this [SealedGrandChild]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  SealedGrandChild copyWith({
    int? sealedInt,
    String? sealedString,
    Object? nullableInt = _Undefined,
    String? sealedGrandchildField,
  }) {
    return SealedGrandChild(
      sealedInt: sealedInt ?? this.sealedInt,
      sealedString: sealedString ?? this.sealedString,
      nullableInt: nullableInt is int? ? nullableInt : this.nullableInt,
      sealedGrandchildField:
          sealedGrandchildField ?? this.sealedGrandchildField,
    );
  }
}
