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

abstract class ObjectWithCustomClass
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ObjectWithCustomClass._({
    required this.customClassWithoutProtocolSerialization,
    required this.customClassWithProtocolSerialization,
    required this.customClassWithProtocolSerializationMethod,
  });

  factory ObjectWithCustomClass({
    required _ilwf0zl1.CustomClassWithoutProtocolSerialization
    customClassWithoutProtocolSerialization,
    required _ilwf0zl1.CustomClassWithProtocolSerialization
    customClassWithProtocolSerialization,
    required _ilwf0zl1.CustomClassWithProtocolSerializationMethod
    customClassWithProtocolSerializationMethod,
  }) = _ObjectWithCustomClassImpl;

  factory ObjectWithCustomClass.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ObjectWithCustomClass(
      customClassWithoutProtocolSerialization:
          _ilwf0zl1.CustomClassWithoutProtocolSerialization.fromJson(
            jsonSerialization['customClassWithoutProtocolSerialization'],
          ),
      customClassWithProtocolSerialization:
          _ilwf0zl1.CustomClassWithProtocolSerialization.fromJson(
            jsonSerialization['customClassWithProtocolSerialization'],
          ),
      customClassWithProtocolSerializationMethod:
          _ilwf0zl1.CustomClassWithProtocolSerializationMethod.fromJson(
            jsonSerialization['customClassWithProtocolSerializationMethod'],
          ),
    );
  }

  _ilwf0zl1.CustomClassWithoutProtocolSerialization
  customClassWithoutProtocolSerialization;

  _ilwf0zl1.CustomClassWithProtocolSerialization
  customClassWithProtocolSerialization;

  _ilwf0zl1.CustomClassWithProtocolSerializationMethod
  customClassWithProtocolSerializationMethod;

  /// Returns a shallow copy of this [ObjectWithCustomClass]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ObjectWithCustomClass copyWith({
    _ilwf0zl1.CustomClassWithoutProtocolSerialization?
    customClassWithoutProtocolSerialization,
    _ilwf0zl1.CustomClassWithProtocolSerialization?
    customClassWithProtocolSerialization,
    _ilwf0zl1.CustomClassWithProtocolSerializationMethod?
    customClassWithProtocolSerializationMethod,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithCustomClass',
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
      '__className__': 'ObjectWithCustomClass',
      'customClassWithoutProtocolSerialization':
          // ignore: unnecessary_type_check
          customClassWithoutProtocolSerialization is _isc.ProtocolSerialization
          ? (customClassWithoutProtocolSerialization
                    as _isc.ProtocolSerialization)
                .toJsonForProtocol()
          :
            // ignore: dead_code
            customClassWithoutProtocolSerialization.toJson(),
      'customClassWithProtocolSerialization':
          // ignore: unnecessary_type_check
          customClassWithProtocolSerialization is _isc.ProtocolSerialization
          ? (customClassWithProtocolSerialization as _isc.ProtocolSerialization)
                .toJsonForProtocol()
          :
            // ignore: dead_code
            customClassWithProtocolSerialization.toJson(),
      'customClassWithProtocolSerializationMethod':
          // ignore: unnecessary_type_check
          customClassWithProtocolSerializationMethod
              is _isc.ProtocolSerialization
          ? (customClassWithProtocolSerializationMethod
                    as _isc.ProtocolSerialization)
                .toJsonForProtocol()
          :
            // ignore: dead_code
            customClassWithProtocolSerializationMethod.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _ObjectWithCustomClassImpl extends ObjectWithCustomClass {
  _ObjectWithCustomClassImpl({
    required _ilwf0zl1.CustomClassWithoutProtocolSerialization
    customClassWithoutProtocolSerialization,
    required _ilwf0zl1.CustomClassWithProtocolSerialization
    customClassWithProtocolSerialization,
    required _ilwf0zl1.CustomClassWithProtocolSerializationMethod
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
  @_isc.useResult
  @override
  ObjectWithCustomClass copyWith({
    _ilwf0zl1.CustomClassWithoutProtocolSerialization?
    customClassWithoutProtocolSerialization,
    _ilwf0zl1.CustomClassWithProtocolSerialization?
    customClassWithProtocolSerialization,
    _ilwf0zl1.CustomClassWithProtocolSerializationMethod?
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
