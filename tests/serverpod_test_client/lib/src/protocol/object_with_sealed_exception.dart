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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'inheritance/exception/sealed_app_exception.dart' as _i2;
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _i3;

abstract class ObjectWithSealedException implements _i1.SerializableModel {
  ObjectWithSealedException._({
    required this.sealedField,
    this.nullableSealedField,
    required this.sealedList,
  });

  factory ObjectWithSealedException({
    required _i2.SealedAppException sealedField,
    _i2.SealedAppException? nullableSealedField,
    required List<_i2.SealedAppException> sealedList,
  }) = _ObjectWithSealedExceptionImpl;

  factory ObjectWithSealedException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ObjectWithSealedException(
      sealedField: _i3.Protocol().deserialize<_i2.SealedAppException>(
        jsonSerialization['sealedField'],
      ),
      nullableSealedField: jsonSerialization['nullableSealedField'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.SealedAppException>(
              jsonSerialization['nullableSealedField'],
            ),
      sealedList: _i3.Protocol().deserialize<List<_i2.SealedAppException>>(
        jsonSerialization['sealedList'],
      ),
    );
  }

  _i2.SealedAppException sealedField;

  _i2.SealedAppException? nullableSealedField;

  List<_i2.SealedAppException> sealedList;

  /// Returns a shallow copy of this [ObjectWithSealedException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithSealedException copyWith({
    _i2.SealedAppException? sealedField,
    _i2.SealedAppException? nullableSealedField,
    List<_i2.SealedAppException>? sealedList,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithSealedException',
      'sealedField': sealedField.toJson(),
      if (nullableSealedField != null)
        'nullableSealedField': nullableSealedField?.toJson(),
      'sealedList': sealedList.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithSealedExceptionImpl extends ObjectWithSealedException {
  _ObjectWithSealedExceptionImpl({
    required _i2.SealedAppException sealedField,
    _i2.SealedAppException? nullableSealedField,
    required List<_i2.SealedAppException> sealedList,
  }) : super._(
         sealedField: sealedField,
         nullableSealedField: nullableSealedField,
         sealedList: sealedList,
       );

  /// Returns a shallow copy of this [ObjectWithSealedException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithSealedException copyWith({
    _i2.SealedAppException? sealedField,
    Object? nullableSealedField = _Undefined,
    List<_i2.SealedAppException>? sealedList,
  }) {
    return ObjectWithSealedException(
      sealedField: sealedField ?? this.sealedField.copyWith(),
      nullableSealedField: nullableSealedField is _i2.SealedAppException?
          ? nullableSealedField
          : this.nullableSealedField?.copyWith(),
      sealedList:
          sealedList ?? this.sealedList.map((e0) => e0.copyWith()).toList(),
    );
  }
}
