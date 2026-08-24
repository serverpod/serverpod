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
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_test_server/src/generated/protocol.dart' as _igqrxdcj;
import 'inheritance/exception/sealed_app_exception.dart' as _iaxkp5y4;

abstract class ObjectWithSealedException
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ObjectWithSealedException._({
    required this.sealedField,
    this.nullableSealedField,
    required this.sealedList,
  });

  factory ObjectWithSealedException({
    required _iaxkp5y4.SealedAppException sealedField,
    _iaxkp5y4.SealedAppException? nullableSealedField,
    required List<_iaxkp5y4.SealedAppException> sealedList,
  }) = _ObjectWithSealedExceptionImpl;

  factory ObjectWithSealedException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ObjectWithSealedException(
      sealedField: _igqrxdcj.Protocol()
          .deserialize<_iaxkp5y4.SealedAppException>(
            jsonSerialization['sealedField'],
          ),
      nullableSealedField: jsonSerialization['nullableSealedField'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<_iaxkp5y4.SealedAppException>(
              jsonSerialization['nullableSealedField'],
            ),
      sealedList: _igqrxdcj.Protocol()
          .deserialize<List<_iaxkp5y4.SealedAppException>>(
            jsonSerialization['sealedList'],
          ),
    );
  }

  _iaxkp5y4.SealedAppException sealedField;

  _iaxkp5y4.SealedAppException? nullableSealedField;

  List<_iaxkp5y4.SealedAppException> sealedList;

  /// Returns a shallow copy of this [ObjectWithSealedException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ObjectWithSealedException copyWith({
    _iaxkp5y4.SealedAppException? sealedField,
    _iaxkp5y4.SealedAppException? nullableSealedField,
    List<_iaxkp5y4.SealedAppException>? sealedList,
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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithSealedException',
      'sealedField': sealedField.toJsonForProtocol(),
      if (nullableSealedField != null)
        'nullableSealedField': nullableSealedField?.toJsonForProtocol(),
      'sealedList': sealedList.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithSealedExceptionImpl extends ObjectWithSealedException {
  _ObjectWithSealedExceptionImpl({
    required _iaxkp5y4.SealedAppException sealedField,
    _iaxkp5y4.SealedAppException? nullableSealedField,
    required List<_iaxkp5y4.SealedAppException> sealedList,
  }) : super._(
         sealedField: sealedField,
         nullableSealedField: nullableSealedField,
         sealedList: sealedList,
       );

  /// Returns a shallow copy of this [ObjectWithSealedException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ObjectWithSealedException copyWith({
    _iaxkp5y4.SealedAppException? sealedField,
    Object? nullableSealedField = _Undefined,
    List<_iaxkp5y4.SealedAppException>? sealedList,
  }) {
    return ObjectWithSealedException(
      sealedField: sealedField ?? this.sealedField.copyWith(),
      nullableSealedField: nullableSealedField is _iaxkp5y4.SealedAppException?
          ? nullableSealedField
          : this.nullableSealedField?.copyWith(),
      sealedList:
          sealedList ?? this.sealedList.map((e0) => e0.copyWith()).toList(),
    );
  }
}
