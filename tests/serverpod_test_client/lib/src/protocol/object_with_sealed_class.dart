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
import 'inheritance/sealed_parent.dart' as _i2;
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _i3;

abstract class ObjectWithSealedClass implements _i1.SerializableModel {
  ObjectWithSealedClass._({
    this.id,
    required this.sealedField,
    this.nullableSealedField,
    required this.sealedList,
  });

  factory ObjectWithSealedClass({
    int? id,
    required _i2.SealedParent sealedField,
    _i2.SealedParent? nullableSealedField,
    required List<_i2.SealedParent> sealedList,
  }) = _ObjectWithSealedClassImpl;

  factory ObjectWithSealedClass.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ObjectWithSealedClass(
      id: jsonSerialization['id'] as int?,
      sealedField: _i3.Protocol().deserialize<_i2.SealedParent>(
        jsonSerialization['sealedField'],
      ),
      nullableSealedField: jsonSerialization['nullableSealedField'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.SealedParent>(
              jsonSerialization['nullableSealedField'],
            ),
      sealedList: _i3.Protocol().deserialize<List<_i2.SealedParent>>(
        jsonSerialization['sealedList'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i2.SealedParent sealedField;

  _i2.SealedParent? nullableSealedField;

  List<_i2.SealedParent> sealedList;

  /// Returns a shallow copy of this [ObjectWithSealedClass]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ObjectWithSealedClass copyWith({
    int? id,
    _i2.SealedParent? sealedField,
    _i2.SealedParent? nullableSealedField,
    List<_i2.SealedParent>? sealedList,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ObjectWithSealedClass',
      if (id != null) 'id': id,
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

class _ObjectWithSealedClassImpl extends ObjectWithSealedClass {
  _ObjectWithSealedClassImpl({
    int? id,
    required _i2.SealedParent sealedField,
    _i2.SealedParent? nullableSealedField,
    required List<_i2.SealedParent> sealedList,
  }) : super._(
         id: id,
         sealedField: sealedField,
         nullableSealedField: nullableSealedField,
         sealedList: sealedList,
       );

  /// Returns a shallow copy of this [ObjectWithSealedClass]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ObjectWithSealedClass copyWith({
    Object? id = _Undefined,
    _i2.SealedParent? sealedField,
    Object? nullableSealedField = _Undefined,
    List<_i2.SealedParent>? sealedList,
  }) {
    return ObjectWithSealedClass(
      id: id is int? ? id : this.id,
      sealedField: sealedField ?? this.sealedField.copyWith(),
      nullableSealedField: nullableSealedField is _i2.SealedParent?
          ? nullableSealedField
          : this.nullableSealedField?.copyWith(),
      sealedList:
          sealedList ?? this.sealedList.map((e0) => e0.copyWith()).toList(),
    );
  }
}
