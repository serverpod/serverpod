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
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _i2;

abstract class ObjectWithNullableCustomClass
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ObjectWithNullableCustomClass._({
    this.nullableCustomClassWithoutProtocolSerialization,
    this.nullableCustomClassWithProtocolSerialization,
    this.nullableCustomClassWithProtocolSerializationMethod,
    required this.nonNullableCustomClass,
  });

  factory ObjectWithNullableCustomClass({
    _i2.CustomClassWithoutProtocolSerialization?
        nullableCustomClassWithoutProtocolSerialization,
    _i2.CustomClassWithProtocolSerialization?
        nullableCustomClassWithProtocolSerialization,
    _i2.CustomClassWithProtocolSerializationMethod?
        nullableCustomClassWithProtocolSerializationMethod,
    required _i2.CustomClassWithProtocolSerialization nonNullableCustomClass,
  }) = _ObjectWithNullableCustomClassImpl;

  factory ObjectWithNullableCustomClass.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ObjectWithNullableCustomClass(
      nullableCustomClassWithoutProtocolSerialization: jsonSerialization[
                  'nullableCustomClassWithoutProtocolSerialization'] ==
              null
          ? null
          : _i2.CustomClassWithoutProtocolSerialization.fromJson(
              jsonSerialization[
                  'nullableCustomClassWithoutProtocolSerialization']),
      nullableCustomClassWithProtocolSerialization:
          jsonSerialization['nullableCustomClassWithProtocolSerialization'] ==
                  null
              ? null
              : _i2.CustomClassWithProtocolSerialization.fromJson(
                  jsonSerialization[
                      'nullableCustomClassWithProtocolSerialization']),
      nullableCustomClassWithProtocolSerializationMethod: jsonSerialization[
                  'nullableCustomClassWithProtocolSerializationMethod'] ==
              null
          ? null
          : _i2.CustomClassWithProtocolSerializationMethod.fromJson(
              jsonSerialization[
                  'nullableCustomClassWithProtocolSerializationMethod']),
      nonNullableCustomClass: _i2.CustomClassWithProtocolSerialization.fromJson(
          jsonSerialization['nonNullableCustomClass']),
    );
  }

  _i2.CustomClassWithoutProtocolSerialization?
      nullableCustomClassWithoutProtocolSerialization;

  _i2.CustomClassWithProtocolSerialization?
      nullableCustomClassWithProtocolSerialization;

  _i2.CustomClassWithProtocolSerializationMethod?
      nullableCustomClassWithProtocolSerializationMethod;

  _i2.CustomClassWithProtocolSerialization nonNullableCustomClass;

  /// Returns a shallow copy of this [ObjectWithNullableCustomClass]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithNullableCustomClass copyWith({
    _i2.CustomClassWithoutProtocolSerialization?
        nullableCustomClassWithoutProtocolSerialization,
    _i2.CustomClassWithProtocolSerialization?
        nullableCustomClassWithProtocolSerialization,
    _i2.CustomClassWithProtocolSerializationMethod?
        nullableCustomClassWithProtocolSerializationMethod,
    _i2.CustomClassWithProtocolSerialization? nonNullableCustomClass,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (nullableCustomClassWithoutProtocolSerialization != null)
        'nullableCustomClassWithoutProtocolSerialization':
            nullableCustomClassWithoutProtocolSerialization?.toJson(),
      if (nullableCustomClassWithProtocolSerialization != null)
        'nullableCustomClassWithProtocolSerialization':
            nullableCustomClassWithProtocolSerialization?.toJson(),
      if (nullableCustomClassWithProtocolSerializationMethod != null)
        'nullableCustomClassWithProtocolSerializationMethod':
            nullableCustomClassWithProtocolSerializationMethod?.toJson(),
      'nonNullableCustomClass': nonNullableCustomClass.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (nullableCustomClassWithoutProtocolSerialization != null)
        'nullableCustomClassWithoutProtocolSerialization':
// ignore: unnecessary_type_check
            nullableCustomClassWithoutProtocolSerialization
                    is _i1.ProtocolSerialization
                ? (nullableCustomClassWithoutProtocolSerialization
                        as _i1.ProtocolSerialization)
                    .toJsonForProtocol()
                : nullableCustomClassWithoutProtocolSerialization?.toJson(),
      if (nullableCustomClassWithProtocolSerialization != null)
        'nullableCustomClassWithProtocolSerialization':
// ignore: unnecessary_type_check
            nullableCustomClassWithProtocolSerialization
                    is _i1.ProtocolSerialization
                ? (nullableCustomClassWithProtocolSerialization
                        as _i1.ProtocolSerialization)
                    .toJsonForProtocol()
                : nullableCustomClassWithProtocolSerialization?.toJson(),
      if (nullableCustomClassWithProtocolSerializationMethod != null)
        'nullableCustomClassWithProtocolSerializationMethod':
// ignore: unnecessary_type_check
            nullableCustomClassWithProtocolSerializationMethod
                    is _i1.ProtocolSerialization
                ? (nullableCustomClassWithProtocolSerializationMethod
                        as _i1.ProtocolSerialization)
                    .toJsonForProtocol()
                : nullableCustomClassWithProtocolSerializationMethod?.toJson(),
      'nonNullableCustomClass':
// ignore: unnecessary_type_check
          nonNullableCustomClass is _i1.ProtocolSerialization
              ? (nonNullableCustomClass as _i1.ProtocolSerialization)
                  .toJsonForProtocol()
              : nonNullableCustomClass.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithNullableCustomClassImpl extends ObjectWithNullableCustomClass {
  _ObjectWithNullableCustomClassImpl({
    _i2.CustomClassWithoutProtocolSerialization?
        nullableCustomClassWithoutProtocolSerialization,
    _i2.CustomClassWithProtocolSerialization?
        nullableCustomClassWithProtocolSerialization,
    _i2.CustomClassWithProtocolSerializationMethod?
        nullableCustomClassWithProtocolSerializationMethod,
    required _i2.CustomClassWithProtocolSerialization nonNullableCustomClass,
  }) : super._(
          nullableCustomClassWithoutProtocolSerialization:
              nullableCustomClassWithoutProtocolSerialization,
          nullableCustomClassWithProtocolSerialization:
              nullableCustomClassWithProtocolSerialization,
          nullableCustomClassWithProtocolSerializationMethod:
              nullableCustomClassWithProtocolSerializationMethod,
          nonNullableCustomClass: nonNullableCustomClass,
        );

  /// Returns a shallow copy of this [ObjectWithNullableCustomClass]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithNullableCustomClass copyWith({
    Object? nullableCustomClassWithoutProtocolSerialization = _Undefined,
    Object? nullableCustomClassWithProtocolSerialization = _Undefined,
    Object? nullableCustomClassWithProtocolSerializationMethod = _Undefined,
    _i2.CustomClassWithProtocolSerialization? nonNullableCustomClass,
  }) {
    return ObjectWithNullableCustomClass(
      nullableCustomClassWithoutProtocolSerialization:
          nullableCustomClassWithoutProtocolSerialization
                  is _i2.CustomClassWithoutProtocolSerialization?
              ? nullableCustomClassWithoutProtocolSerialization
              : this
                  .nullableCustomClassWithoutProtocolSerialization
                  ?.copyWith(),
      nullableCustomClassWithProtocolSerialization:
          nullableCustomClassWithProtocolSerialization
                  is _i2.CustomClassWithProtocolSerialization?
              ? nullableCustomClassWithProtocolSerialization
              : this.nullableCustomClassWithProtocolSerialization?.copyWith(),
      nullableCustomClassWithProtocolSerializationMethod:
          nullableCustomClassWithProtocolSerializationMethod
                  is _i2.CustomClassWithProtocolSerializationMethod?
              ? nullableCustomClassWithProtocolSerializationMethod
              : this
                  .nullableCustomClassWithProtocolSerializationMethod
                  ?.copyWith(),
      nonNullableCustomClass:
          nonNullableCustomClass ?? this.nonNullableCustomClass.copyWith(),
    );
  }
}
