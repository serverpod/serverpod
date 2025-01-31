/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _i2;

abstract class ObjectWithCustomClass
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ObjectWithCustomClass._({
    required this.customClassWithoutProtocolSerialization,
    required this.customClassWithProtocolSerialization,
    required this.customClassWithProtocolSerializationMethod,
  });

  factory ObjectWithCustomClass({
    required _i2.CustomClassWithoutProtocolSerialization
        customClassWithoutProtocolSerialization,
    required _i2.CustomClassWithProtocolSerialization
        customClassWithProtocolSerialization,
    required _i2.CustomClassWithProtocolSerializationMethod
        customClassWithProtocolSerializationMethod,
  }) = _ObjectWithCustomClassImpl;

  factory ObjectWithCustomClass.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return ObjectWithCustomClass(
      customClassWithoutProtocolSerialization:
          _i2.CustomClassWithoutProtocolSerialization.fromJson(
              jsonSerialization['customClassWithoutProtocolSerialization']),
      customClassWithProtocolSerialization:
          _i2.CustomClassWithProtocolSerialization.fromJson(
              jsonSerialization['customClassWithProtocolSerialization']),
      customClassWithProtocolSerializationMethod:
          _i2.CustomClassWithProtocolSerializationMethod.fromJson(
              jsonSerialization['customClassWithProtocolSerializationMethod']),
    );
  }

  _i2.CustomClassWithoutProtocolSerialization
      customClassWithoutProtocolSerialization;

  _i2.CustomClassWithProtocolSerialization customClassWithProtocolSerialization;

  _i2.CustomClassWithProtocolSerializationMethod
      customClassWithProtocolSerializationMethod;

  /// Returns a shallow copy of this [ObjectWithCustomClass]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithCustomClass copyWith({
    _i2.CustomClassWithoutProtocolSerialization?
        customClassWithoutProtocolSerialization,
    _i2.CustomClassWithProtocolSerialization?
        customClassWithProtocolSerialization,
    _i2.CustomClassWithProtocolSerializationMethod?
        customClassWithProtocolSerializationMethod,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'customClassWithoutProtocolSerialization':
          customClassWithoutProtocolSerialization.toJson(),
      'customClassWithProtocolSerialization':
          customClassWithProtocolSerialization.toJson(),
      'customClassWithProtocolSerializationMethod':
          customClassWithProtocolSerializationMethod.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'customClassWithoutProtocolSerialization':
// ignore: unnecessary_type_check
          customClassWithoutProtocolSerialization is _i1.ProtocolSerialization
              ? (customClassWithoutProtocolSerialization
                      as _i1.ProtocolSerialization)
                  .toJsonForProtocol()
              : customClassWithoutProtocolSerialization.toJson(),
      'customClassWithProtocolSerialization':
// ignore: unnecessary_type_check
          customClassWithProtocolSerialization is _i1.ProtocolSerialization
              ? (customClassWithProtocolSerialization
                      as _i1.ProtocolSerialization)
                  .toJsonForProtocol()
              : customClassWithProtocolSerialization.toJson(),
      'customClassWithProtocolSerializationMethod':
// ignore: unnecessary_type_check
          customClassWithProtocolSerializationMethod
                  is _i1.ProtocolSerialization
              ? (customClassWithProtocolSerializationMethod
                      as _i1.ProtocolSerialization)
                  .toJsonForProtocol()
              : customClassWithProtocolSerializationMethod.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ObjectWithCustomClassImpl extends ObjectWithCustomClass {
  _ObjectWithCustomClassImpl({
    required _i2.CustomClassWithoutProtocolSerialization
        customClassWithoutProtocolSerialization,
    required _i2.CustomClassWithProtocolSerialization
        customClassWithProtocolSerialization,
    required _i2.CustomClassWithProtocolSerializationMethod
        customClassWithProtocolSerializationMethod,
  }) : super._(
          customClassWithoutProtocolSerialization:
              customClassWithoutProtocolSerialization,
          customClassWithProtocolSerialization:
              customClassWithProtocolSerialization,
          customClassWithProtocolSerializationMethod:
              customClassWithProtocolSerializationMethod,
        );

  /// Returns a shallow copy of this [ObjectWithCustomClass]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithCustomClass copyWith({
    _i2.CustomClassWithoutProtocolSerialization?
        customClassWithoutProtocolSerialization,
    _i2.CustomClassWithProtocolSerialization?
        customClassWithProtocolSerialization,
    _i2.CustomClassWithProtocolSerializationMethod?
        customClassWithProtocolSerializationMethod,
  }) {
    return ObjectWithCustomClass(
      customClassWithoutProtocolSerialization:
          customClassWithoutProtocolSerialization ??
              this.customClassWithoutProtocolSerialization.copyWith(),
      customClassWithProtocolSerialization:
          customClassWithProtocolSerialization ??
              this.customClassWithProtocolSerialization.copyWith(),
      customClassWithProtocolSerializationMethod:
          customClassWithProtocolSerializationMethod ??
              this.customClassWithProtocolSerializationMethod.copyWith(),
    );
  }
}
