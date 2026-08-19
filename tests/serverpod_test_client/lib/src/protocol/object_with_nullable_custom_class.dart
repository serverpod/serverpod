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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _ilwf0zl1;

abstract class ObjectWithNullableCustomClass
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ObjectWithNullableCustomClass._({
    this.nullableCustomClassWithoutProtocolSerialization,
    this.nullableCustomClassWithProtocolSerialization,
    this.nullableCustomClassWithProtocolSerializationMethod,
    required this.nonNullableCustomClass,
  });

  factory ObjectWithNullableCustomClass({
    _ilwf0zl1.CustomClassWithoutProtocolSerialization?
    nullableCustomClassWithoutProtocolSerialization,
    _ilwf0zl1.CustomClassWithProtocolSerialization?
    nullableCustomClassWithProtocolSerialization,
    _ilwf0zl1.CustomClassWithProtocolSerializationMethod?
    nullableCustomClassWithProtocolSerializationMethod,
    required _ilwf0zl1.CustomClassWithProtocolSerialization
    nonNullableCustomClass,
  }) = _ObjectWithNullableCustomClassImpl;

  factory ObjectWithNullableCustomClass.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ObjectWithNullableCustomClass(
      nullableCustomClassWithoutProtocolSerialization:
          jsonSerialization['nullableCustomClassWithoutProtocolSerialization'] ==
              null
          ? null
          : _ilwf0zl1.CustomClassWithoutProtocolSerialization.fromJson(
              jsonSerialization['nullableCustomClassWithoutProtocolSerialization'],
            ),
      nullableCustomClassWithProtocolSerialization:
          jsonSerialization['nullableCustomClassWithProtocolSerialization'] ==
              null
          ? null
          : _ilwf0zl1.CustomClassWithProtocolSerialization.fromJson(
              jsonSerialization['nullableCustomClassWithProtocolSerialization'],
            ),
      nullableCustomClassWithProtocolSerializationMethod:
          jsonSerialization['nullableCustomClassWithProtocolSerializationMethod'] ==
              null
          ? null
          : _ilwf0zl1.CustomClassWithProtocolSerializationMethod.fromJson(
              jsonSerialization['nullableCustomClassWithProtocolSerializationMethod'],
            ),
      nonNullableCustomClass:
          _ilwf0zl1.CustomClassWithProtocolSerialization.fromJson(
            jsonSerialization['nonNullableCustomClass'],
          ),
    );
  }

  _ilwf0zl1.CustomClassWithoutProtocolSerialization?
  nullableCustomClassWithoutProtocolSerialization;

  _ilwf0zl1.CustomClassWithProtocolSerialization?
  nullableCustomClassWithProtocolSerialization;

  _ilwf0zl1.CustomClassWithProtocolSerializationMethod?
  nullableCustomClassWithProtocolSerializationMethod;

  _ilwf0zl1.CustomClassWithProtocolSerialization nonNullableCustomClass;

  /// Returns a shallow copy of this [ObjectWithNullableCustomClass]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ObjectWithNullableCustomClass copyWith({
    _ilwf0zl1.CustomClassWithoutProtocolSerialization?
    nullableCustomClassWithoutProtocolSerialization,
    _ilwf0zl1.CustomClassWithProtocolSerialization?
    nullableCustomClassWithProtocolSerialization,
    _ilwf0zl1.CustomClassWithProtocolSerializationMethod?
    nullableCustomClassWithProtocolSerializationMethod,
    _ilwf0zl1.CustomClassWithProtocolSerialization? nonNullableCustomClass,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithNullableCustomClass',
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
      '__className__': 'ObjectWithNullableCustomClass',
      if (nullableCustomClassWithoutProtocolSerialization != null)
        'nullableCustomClassWithoutProtocolSerialization':
            // ignore: unnecessary_type_check
            nullableCustomClassWithoutProtocolSerialization
                is _isc.ProtocolSerialization
            ? (nullableCustomClassWithoutProtocolSerialization
                      as _isc.ProtocolSerialization)
                  .toJsonForProtocol()
            :
              // ignore: dead_code
              nullableCustomClassWithoutProtocolSerialization?.toJson(),
      if (nullableCustomClassWithProtocolSerialization != null)
        'nullableCustomClassWithProtocolSerialization':
            // ignore: unnecessary_type_check
            nullableCustomClassWithProtocolSerialization
                is _isc.ProtocolSerialization
            ? (nullableCustomClassWithProtocolSerialization
                      as _isc.ProtocolSerialization)
                  .toJsonForProtocol()
            :
              // ignore: dead_code
              nullableCustomClassWithProtocolSerialization?.toJson(),
      if (nullableCustomClassWithProtocolSerializationMethod != null)
        'nullableCustomClassWithProtocolSerializationMethod':
            // ignore: unnecessary_type_check
            nullableCustomClassWithProtocolSerializationMethod
                is _isc.ProtocolSerialization
            ? (nullableCustomClassWithProtocolSerializationMethod
                      as _isc.ProtocolSerialization)
                  .toJsonForProtocol()
            :
              // ignore: dead_code
              nullableCustomClassWithProtocolSerializationMethod?.toJson(),
      'nonNullableCustomClass':
          // ignore: unnecessary_type_check
          nonNullableCustomClass is _isc.ProtocolSerialization
          ? (nonNullableCustomClass as _isc.ProtocolSerialization)
                .toJsonForProtocol()
          :
            // ignore: dead_code
            nonNullableCustomClass.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithNullableCustomClassImpl extends ObjectWithNullableCustomClass {
  _ObjectWithNullableCustomClassImpl({
    _ilwf0zl1.CustomClassWithoutProtocolSerialization?
    nullableCustomClassWithoutProtocolSerialization,
    _ilwf0zl1.CustomClassWithProtocolSerialization?
    nullableCustomClassWithProtocolSerialization,
    _ilwf0zl1.CustomClassWithProtocolSerializationMethod?
    nullableCustomClassWithProtocolSerializationMethod,
    required _ilwf0zl1.CustomClassWithProtocolSerialization
    nonNullableCustomClass,
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
  @_isc.useResult
  @override
  ObjectWithNullableCustomClass copyWith({
    Object? nullableCustomClassWithoutProtocolSerialization = _Undefined,
    Object? nullableCustomClassWithProtocolSerialization = _Undefined,
    Object? nullableCustomClassWithProtocolSerializationMethod = _Undefined,
    _ilwf0zl1.CustomClassWithProtocolSerialization? nonNullableCustomClass,
  }) {
    return ObjectWithNullableCustomClass(
      nullableCustomClassWithoutProtocolSerialization:
          nullableCustomClassWithoutProtocolSerialization
              is _ilwf0zl1.CustomClassWithoutProtocolSerialization?
          ? nullableCustomClassWithoutProtocolSerialization
          : this.nullableCustomClassWithoutProtocolSerialization?.copyWith(),
      nullableCustomClassWithProtocolSerialization:
          nullableCustomClassWithProtocolSerialization
              is _ilwf0zl1.CustomClassWithProtocolSerialization?
          ? nullableCustomClassWithProtocolSerialization
          : this.nullableCustomClassWithProtocolSerialization?.copyWith(),
      nullableCustomClassWithProtocolSerializationMethod:
          nullableCustomClassWithProtocolSerializationMethod
              is _ilwf0zl1.CustomClassWithProtocolSerializationMethod?
          ? nullableCustomClassWithProtocolSerializationMethod
          : this.nullableCustomClassWithProtocolSerializationMethod?.copyWith(),
      nonNullableCustomClass:
          nonNullableCustomClass ?? this.nonNullableCustomClass.copyWith(),
    );
  }
}
