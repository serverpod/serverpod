/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

part of 'sealed_parent.dart';

abstract class SealedGrandchild extends _i1.SealedChild
    implements _i2.SerializableModel, _i2.ProtocolSerialization {
  SealedGrandchild._({
    required super.sealedInt,
    required super.sealedString,
    super.nullableInt,
    required this.sealedGrandchildField,
  });

  factory SealedGrandchild({
    required int sealedInt,
    required String sealedString,
    int? nullableInt,
    required String sealedGrandchildField,
  }) = _SealedGrandchildImpl;

  factory SealedGrandchild.fromJson(Map<String, dynamic> jsonSerialization) {
    return SealedGrandchild(
      sealedInt: jsonSerialization['sealedInt'] as int,
      sealedString: jsonSerialization['sealedString'] as String,
      nullableInt: jsonSerialization['nullableInt'] as int?,
      sealedGrandchildField:
          jsonSerialization['sealedGrandchildField'] as String,
    );
  }

  String sealedGrandchildField;

  @override
  SealedGrandchild copyWith({
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

class _SealedGrandchildImpl extends SealedGrandchild {
  _SealedGrandchildImpl({
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

  @override
  SealedGrandchild copyWith({
    int? sealedInt,
    String? sealedString,
    Object? nullableInt = _Undefined,
    String? sealedGrandchildField,
  }) {
    return SealedGrandchild(
      sealedInt: sealedInt ?? this.sealedInt,
      sealedString: sealedString ?? this.sealedString,
      nullableInt: nullableInt is int? ? nullableInt : this.nullableInt,
      sealedGrandchildField:
          sealedGrandchildField ?? this.sealedGrandchildField,
    );
  }
}
