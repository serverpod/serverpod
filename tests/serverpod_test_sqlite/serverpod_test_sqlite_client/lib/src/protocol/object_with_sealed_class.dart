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
import 'package:serverpod_test_sqlite_client/src/protocol/protocol.dart'
    as _i0ntutnq;
import 'inheritance/sealed_parent.dart' as _ij7m744x;

abstract class ObjectWithSealedClass
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ObjectWithSealedClass._({
    required this.sealedField,
    this.nullableSealedField,
    required this.sealedList,
  });

  factory ObjectWithSealedClass({
    required _ij7m744x.SealedParent sealedField,
    _ij7m744x.SealedParent? nullableSealedField,
    required List<_ij7m744x.SealedParent> sealedList,
  }) = _ObjectWithSealedClassImpl;

  factory ObjectWithSealedClass.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ObjectWithSealedClass(
      sealedField: _i0ntutnq.Protocol().deserialize<_ij7m744x.SealedParent>(
        jsonSerialization['sealedField'],
      ),
      nullableSealedField: jsonSerialization['nullableSealedField'] == null
          ? null
          : _i0ntutnq.Protocol().deserialize<_ij7m744x.SealedParent>(
              jsonSerialization['nullableSealedField'],
            ),
      sealedList: _i0ntutnq.Protocol()
          .deserialize<List<_ij7m744x.SealedParent>>(
            jsonSerialization['sealedList'],
          ),
    );
  }

  _ij7m744x.SealedParent sealedField;

  _ij7m744x.SealedParent? nullableSealedField;

  List<_ij7m744x.SealedParent> sealedList;

  /// Returns a shallow copy of this [ObjectWithSealedClass]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ObjectWithSealedClass copyWith({
    _ij7m744x.SealedParent? sealedField,
    _ij7m744x.SealedParent? nullableSealedField,
    List<_ij7m744x.SealedParent>? sealedList,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithSealedClass',
      'sealedField': sealedField.toJson(),
      if (nullableSealedField != null)
        'nullableSealedField': nullableSealedField?.toJson(),
      'sealedList': sealedList.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ObjectWithSealedClass',
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
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ObjectWithSealedClassImpl extends ObjectWithSealedClass {
  _ObjectWithSealedClassImpl({
    required _ij7m744x.SealedParent sealedField,
    _ij7m744x.SealedParent? nullableSealedField,
    required List<_ij7m744x.SealedParent> sealedList,
  }) : super._(
         sealedField: sealedField,
         nullableSealedField: nullableSealedField,
         sealedList: sealedList,
       );

  /// Returns a shallow copy of this [ObjectWithSealedClass]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ObjectWithSealedClass copyWith({
    _ij7m744x.SealedParent? sealedField,
    Object? nullableSealedField = _Undefined,
    List<_ij7m744x.SealedParent>? sealedList,
  }) {
    return ObjectWithSealedClass(
      sealedField: sealedField ?? this.sealedField.copyWith(),
      nullableSealedField: nullableSealedField is _ij7m744x.SealedParent?
          ? nullableSealedField
          : this.nullableSealedField?.copyWith(),
      sealedList:
          sealedList ?? this.sealedList.map((e0) => e0.copyWith()).toList(),
    );
  }
}
