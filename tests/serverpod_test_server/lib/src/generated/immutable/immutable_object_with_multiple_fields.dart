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
import 'package:serverpod/serverpod.dart' as _i1;

@_i1.immutable
abstract class ImmutableObjectWithMultipleFields
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  const ImmutableObjectWithMultipleFields._({
    this.anInt,
    this.aBool,
    this.aDouble,
    this.aDateTime,
    this.aString,
  });

  const factory ImmutableObjectWithMultipleFields({
    int? anInt,
    bool? aBool,
    double? aDouble,
    DateTime? aDateTime,
    String? aString,
  }) = _ImmutableObjectWithMultipleFieldsImpl;

  factory ImmutableObjectWithMultipleFields.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ImmutableObjectWithMultipleFields(
      anInt: jsonSerialization['anInt'] as int?,
      aBool: jsonSerialization['aBool'] as bool?,
      aDouble: (jsonSerialization['aDouble'] as num?)?.toDouble(),
      aDateTime: jsonSerialization['aDateTime'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['aDateTime']),
      aString: jsonSerialization['aString'] as String?,
    );
  }

  final int? anInt;

  final bool? aBool;

  final double? aDouble;

  final DateTime? aDateTime;

  final String? aString;

  /// Returns a shallow copy of this [ImmutableObjectWithMultipleFields]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ImmutableObjectWithMultipleFields copyWith({
    int? anInt,
    bool? aBool,
    double? aDouble,
    DateTime? aDateTime,
    String? aString,
  });
  @override
  bool operator ==(Object other) {
    return identical(
          other,
          this,
        ) ||
        other.runtimeType == runtimeType &&
            other is ImmutableObjectWithMultipleFields &&
            (identical(
                  other.anInt,
                  anInt,
                ) ||
                other.anInt == anInt) &&
            (identical(
                  other.aBool,
                  aBool,
                ) ||
                other.aBool == aBool) &&
            (identical(
                  other.aDouble,
                  aDouble,
                ) ||
                other.aDouble == aDouble) &&
            (identical(
                  other.aDateTime,
                  aDateTime,
                ) ||
                other.aDateTime == aDateTime) &&
            (identical(
                  other.aString,
                  aString,
                ) ||
                other.aString == aString);
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      anInt,
      aBool,
      aDouble,
      aDateTime,
      aString,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      if (anInt != null) 'anInt': anInt,
      if (aBool != null) 'aBool': aBool,
      if (aDouble != null) 'aDouble': aDouble,
      if (aDateTime != null) 'aDateTime': aDateTime?.toJson(),
      if (aString != null) 'aString': aString,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (anInt != null) 'anInt': anInt,
      if (aBool != null) 'aBool': aBool,
      if (aDouble != null) 'aDouble': aDouble,
      if (aDateTime != null) 'aDateTime': aDateTime?.toJson(),
      if (aString != null) 'aString': aString,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ImmutableObjectWithMultipleFieldsImpl
    extends ImmutableObjectWithMultipleFields {
  const _ImmutableObjectWithMultipleFieldsImpl({
    int? anInt,
    bool? aBool,
    double? aDouble,
    DateTime? aDateTime,
    String? aString,
  }) : super._(
          anInt: anInt,
          aBool: aBool,
          aDouble: aDouble,
          aDateTime: aDateTime,
          aString: aString,
        );

  /// Returns a shallow copy of this [ImmutableObjectWithMultipleFields]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ImmutableObjectWithMultipleFields copyWith({
    Object? anInt = _Undefined,
    Object? aBool = _Undefined,
    Object? aDouble = _Undefined,
    Object? aDateTime = _Undefined,
    Object? aString = _Undefined,
  }) {
    return ImmutableObjectWithMultipleFields(
      anInt: anInt is int? ? anInt : this.anInt,
      aBool: aBool is bool? ? aBool : this.aBool,
      aDouble: aDouble is double? ? aDouble : this.aDouble,
      aDateTime: aDateTime is DateTime? ? aDateTime : this.aDateTime,
      aString: aString is String? ? aString : this.aString,
    );
  }
}
