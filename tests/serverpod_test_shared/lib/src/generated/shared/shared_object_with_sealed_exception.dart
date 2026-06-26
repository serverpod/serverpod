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
import 'package:serverpod_serialization/serverpod_serialization.dart' as _i1;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _i2;

abstract class SharedObjectWithSealedException
    implements _i1.SerializableModel {
  SharedObjectWithSealedException._({
    required this.sealedField,
    this.nullableSealedField,
    required this.sealedList,
  });

  factory SharedObjectWithSealedException({
    required _i2.SharedSealedAppException sealedField,
    _i2.SharedSealedAppException? nullableSealedField,
    required List<_i2.SharedSealedAppException> sealedList,
  }) = _SharedObjectWithSealedExceptionImpl;

  factory SharedObjectWithSealedException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return SharedObjectWithSealedException(
      sealedField: _i2.Protocol().deserialize<_i2.SharedSealedAppException>(
        jsonSerialization['sealedField'],
      ),
      nullableSealedField: jsonSerialization['nullableSealedField'] == null
          ? null
          : _i2.Protocol().deserialize<_i2.SharedSealedAppException>(
              jsonSerialization['nullableSealedField'],
            ),
      sealedList: _i2.Protocol()
          .deserialize<List<_i2.SharedSealedAppException>>(
            jsonSerialization['sealedList'],
          ),
    );
  }

  _i2.SharedSealedAppException sealedField;

  _i2.SharedSealedAppException? nullableSealedField;

  List<_i2.SharedSealedAppException> sealedList;

  /// Returns a shallow copy of this [SharedObjectWithSealedException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SharedObjectWithSealedException copyWith({
    _i2.SharedSealedAppException? sealedField,
    _i2.SharedSealedAppException? nullableSealedField,
    List<_i2.SharedSealedAppException>? sealedList,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SharedObjectWithSealedException',
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

class _SharedObjectWithSealedExceptionImpl
    extends SharedObjectWithSealedException {
  _SharedObjectWithSealedExceptionImpl({
    required _i2.SharedSealedAppException sealedField,
    _i2.SharedSealedAppException? nullableSealedField,
    required List<_i2.SharedSealedAppException> sealedList,
  }) : super._(
         sealedField: sealedField,
         nullableSealedField: nullableSealedField,
         sealedList: sealedList,
       );

  /// Returns a shallow copy of this [SharedObjectWithSealedException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SharedObjectWithSealedException copyWith({
    _i2.SharedSealedAppException? sealedField,
    Object? nullableSealedField = _Undefined,
    List<_i2.SharedSealedAppException>? sealedList,
  }) {
    return SharedObjectWithSealedException(
      sealedField: sealedField ?? this.sealedField.copyWith(),
      nullableSealedField: nullableSealedField is _i2.SharedSealedAppException?
          ? nullableSealedField
          : this.nullableSealedField?.copyWith(),
      sealedList:
          sealedList ?? this.sealedList.map((e0) => e0.copyWith()).toList(),
    );
  }
}
