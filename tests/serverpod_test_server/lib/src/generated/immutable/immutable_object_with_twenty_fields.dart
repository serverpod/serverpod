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
abstract class ImmutableObjectWithTwentyFields
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  const ImmutableObjectWithTwentyFields._({
    this.variable1,
    this.variable2,
    this.variable3,
    this.variable4,
    this.variable5,
    this.variable6,
    this.variable7,
    this.variable8,
    this.variable9,
    this.variable10,
    this.variable11,
    this.variable12,
    this.variable13,
    this.variable14,
    this.variable15,
    this.variable16,
    this.variable17,
    this.variable18,
    this.variable19,
    this.variable20,
  });

  const factory ImmutableObjectWithTwentyFields({
    String? variable1,
    String? variable2,
    String? variable3,
    String? variable4,
    String? variable5,
    String? variable6,
    String? variable7,
    String? variable8,
    String? variable9,
    String? variable10,
    String? variable11,
    String? variable12,
    String? variable13,
    String? variable14,
    String? variable15,
    String? variable16,
    String? variable17,
    String? variable18,
    String? variable19,
    String? variable20,
  }) = _ImmutableObjectWithTwentyFieldsImpl;

  factory ImmutableObjectWithTwentyFields.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ImmutableObjectWithTwentyFields(
      variable1: jsonSerialization['variable1'] as String?,
      variable2: jsonSerialization['variable2'] as String?,
      variable3: jsonSerialization['variable3'] as String?,
      variable4: jsonSerialization['variable4'] as String?,
      variable5: jsonSerialization['variable5'] as String?,
      variable6: jsonSerialization['variable6'] as String?,
      variable7: jsonSerialization['variable7'] as String?,
      variable8: jsonSerialization['variable8'] as String?,
      variable9: jsonSerialization['variable9'] as String?,
      variable10: jsonSerialization['variable10'] as String?,
      variable11: jsonSerialization['variable11'] as String?,
      variable12: jsonSerialization['variable12'] as String?,
      variable13: jsonSerialization['variable13'] as String?,
      variable14: jsonSerialization['variable14'] as String?,
      variable15: jsonSerialization['variable15'] as String?,
      variable16: jsonSerialization['variable16'] as String?,
      variable17: jsonSerialization['variable17'] as String?,
      variable18: jsonSerialization['variable18'] as String?,
      variable19: jsonSerialization['variable19'] as String?,
      variable20: jsonSerialization['variable20'] as String?,
    );
  }

  final String? variable1;

  final String? variable2;

  final String? variable3;

  final String? variable4;

  final String? variable5;

  final String? variable6;

  final String? variable7;

  final String? variable8;

  final String? variable9;

  final String? variable10;

  final String? variable11;

  final String? variable12;

  final String? variable13;

  final String? variable14;

  final String? variable15;

  final String? variable16;

  final String? variable17;

  final String? variable18;

  final String? variable19;

  final String? variable20;

  /// Returns a shallow copy of this [ImmutableObjectWithTwentyFields]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ImmutableObjectWithTwentyFields copyWith({
    String? variable1,
    String? variable2,
    String? variable3,
    String? variable4,
    String? variable5,
    String? variable6,
    String? variable7,
    String? variable8,
    String? variable9,
    String? variable10,
    String? variable11,
    String? variable12,
    String? variable13,
    String? variable14,
    String? variable15,
    String? variable16,
    String? variable17,
    String? variable18,
    String? variable19,
    String? variable20,
  });
  @override
  bool operator ==(Object other) {
    return identical(
          other,
          this,
        ) ||
        other.runtimeType == runtimeType &&
            other is ImmutableObjectWithTwentyFields &&
            (identical(
                  other.variable1,
                  variable1,
                ) ||
                other.variable1 == variable1) &&
            (identical(
                  other.variable2,
                  variable2,
                ) ||
                other.variable2 == variable2) &&
            (identical(
                  other.variable3,
                  variable3,
                ) ||
                other.variable3 == variable3) &&
            (identical(
                  other.variable4,
                  variable4,
                ) ||
                other.variable4 == variable4) &&
            (identical(
                  other.variable5,
                  variable5,
                ) ||
                other.variable5 == variable5) &&
            (identical(
                  other.variable6,
                  variable6,
                ) ||
                other.variable6 == variable6) &&
            (identical(
                  other.variable7,
                  variable7,
                ) ||
                other.variable7 == variable7) &&
            (identical(
                  other.variable8,
                  variable8,
                ) ||
                other.variable8 == variable8) &&
            (identical(
                  other.variable9,
                  variable9,
                ) ||
                other.variable9 == variable9) &&
            (identical(
                  other.variable10,
                  variable10,
                ) ||
                other.variable10 == variable10) &&
            (identical(
                  other.variable11,
                  variable11,
                ) ||
                other.variable11 == variable11) &&
            (identical(
                  other.variable12,
                  variable12,
                ) ||
                other.variable12 == variable12) &&
            (identical(
                  other.variable13,
                  variable13,
                ) ||
                other.variable13 == variable13) &&
            (identical(
                  other.variable14,
                  variable14,
                ) ||
                other.variable14 == variable14) &&
            (identical(
                  other.variable15,
                  variable15,
                ) ||
                other.variable15 == variable15) &&
            (identical(
                  other.variable16,
                  variable16,
                ) ||
                other.variable16 == variable16) &&
            (identical(
                  other.variable17,
                  variable17,
                ) ||
                other.variable17 == variable17) &&
            (identical(
                  other.variable18,
                  variable18,
                ) ||
                other.variable18 == variable18) &&
            (identical(
                  other.variable19,
                  variable19,
                ) ||
                other.variable19 == variable19) &&
            (identical(
                  other.variable20,
                  variable20,
                ) ||
                other.variable20 == variable20);
  }

  @override
  int get hashCode {
    return Object.hashAll([
      runtimeType,
      variable1,
      variable2,
      variable3,
      variable4,
      variable5,
      variable6,
      variable7,
      variable8,
      variable9,
      variable10,
      variable11,
      variable12,
      variable13,
      variable14,
      variable15,
      variable16,
      variable17,
      variable18,
      variable19,
      variable20,
    ]);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      if (variable1 != null) 'variable1': variable1,
      if (variable2 != null) 'variable2': variable2,
      if (variable3 != null) 'variable3': variable3,
      if (variable4 != null) 'variable4': variable4,
      if (variable5 != null) 'variable5': variable5,
      if (variable6 != null) 'variable6': variable6,
      if (variable7 != null) 'variable7': variable7,
      if (variable8 != null) 'variable8': variable8,
      if (variable9 != null) 'variable9': variable9,
      if (variable10 != null) 'variable10': variable10,
      if (variable11 != null) 'variable11': variable11,
      if (variable12 != null) 'variable12': variable12,
      if (variable13 != null) 'variable13': variable13,
      if (variable14 != null) 'variable14': variable14,
      if (variable15 != null) 'variable15': variable15,
      if (variable16 != null) 'variable16': variable16,
      if (variable17 != null) 'variable17': variable17,
      if (variable18 != null) 'variable18': variable18,
      if (variable19 != null) 'variable19': variable19,
      if (variable20 != null) 'variable20': variable20,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (variable1 != null) 'variable1': variable1,
      if (variable2 != null) 'variable2': variable2,
      if (variable3 != null) 'variable3': variable3,
      if (variable4 != null) 'variable4': variable4,
      if (variable5 != null) 'variable5': variable5,
      if (variable6 != null) 'variable6': variable6,
      if (variable7 != null) 'variable7': variable7,
      if (variable8 != null) 'variable8': variable8,
      if (variable9 != null) 'variable9': variable9,
      if (variable10 != null) 'variable10': variable10,
      if (variable11 != null) 'variable11': variable11,
      if (variable12 != null) 'variable12': variable12,
      if (variable13 != null) 'variable13': variable13,
      if (variable14 != null) 'variable14': variable14,
      if (variable15 != null) 'variable15': variable15,
      if (variable16 != null) 'variable16': variable16,
      if (variable17 != null) 'variable17': variable17,
      if (variable18 != null) 'variable18': variable18,
      if (variable19 != null) 'variable19': variable19,
      if (variable20 != null) 'variable20': variable20,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ImmutableObjectWithTwentyFieldsImpl
    extends ImmutableObjectWithTwentyFields {
  const _ImmutableObjectWithTwentyFieldsImpl({
    String? variable1,
    String? variable2,
    String? variable3,
    String? variable4,
    String? variable5,
    String? variable6,
    String? variable7,
    String? variable8,
    String? variable9,
    String? variable10,
    String? variable11,
    String? variable12,
    String? variable13,
    String? variable14,
    String? variable15,
    String? variable16,
    String? variable17,
    String? variable18,
    String? variable19,
    String? variable20,
  }) : super._(
         variable1: variable1,
         variable2: variable2,
         variable3: variable3,
         variable4: variable4,
         variable5: variable5,
         variable6: variable6,
         variable7: variable7,
         variable8: variable8,
         variable9: variable9,
         variable10: variable10,
         variable11: variable11,
         variable12: variable12,
         variable13: variable13,
         variable14: variable14,
         variable15: variable15,
         variable16: variable16,
         variable17: variable17,
         variable18: variable18,
         variable19: variable19,
         variable20: variable20,
       );

  /// Returns a shallow copy of this [ImmutableObjectWithTwentyFields]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ImmutableObjectWithTwentyFields copyWith({
    Object? variable1 = _Undefined,
    Object? variable2 = _Undefined,
    Object? variable3 = _Undefined,
    Object? variable4 = _Undefined,
    Object? variable5 = _Undefined,
    Object? variable6 = _Undefined,
    Object? variable7 = _Undefined,
    Object? variable8 = _Undefined,
    Object? variable9 = _Undefined,
    Object? variable10 = _Undefined,
    Object? variable11 = _Undefined,
    Object? variable12 = _Undefined,
    Object? variable13 = _Undefined,
    Object? variable14 = _Undefined,
    Object? variable15 = _Undefined,
    Object? variable16 = _Undefined,
    Object? variable17 = _Undefined,
    Object? variable18 = _Undefined,
    Object? variable19 = _Undefined,
    Object? variable20 = _Undefined,
  }) {
    return ImmutableObjectWithTwentyFields(
      variable1: variable1 is String? ? variable1 : this.variable1,
      variable2: variable2 is String? ? variable2 : this.variable2,
      variable3: variable3 is String? ? variable3 : this.variable3,
      variable4: variable4 is String? ? variable4 : this.variable4,
      variable5: variable5 is String? ? variable5 : this.variable5,
      variable6: variable6 is String? ? variable6 : this.variable6,
      variable7: variable7 is String? ? variable7 : this.variable7,
      variable8: variable8 is String? ? variable8 : this.variable8,
      variable9: variable9 is String? ? variable9 : this.variable9,
      variable10: variable10 is String? ? variable10 : this.variable10,
      variable11: variable11 is String? ? variable11 : this.variable11,
      variable12: variable12 is String? ? variable12 : this.variable12,
      variable13: variable13 is String? ? variable13 : this.variable13,
      variable14: variable14 is String? ? variable14 : this.variable14,
      variable15: variable15 is String? ? variable15 : this.variable15,
      variable16: variable16 is String? ? variable16 : this.variable16,
      variable17: variable17 is String? ? variable17 : this.variable17,
      variable18: variable18 is String? ? variable18 : this.variable18,
      variable19: variable19 is String? ? variable19 : this.variable19,
      variable20: variable20 is String? ? variable20 : this.variable20,
    );
  }
}
