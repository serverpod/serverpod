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
import 'package:serverpod_serialization/serverpod_serialization.dart' as _iss;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _ilwf0zl1;

abstract class SharedObjectWithSealedException
    implements _iss.SerializableModel, _iss.ProtocolSerialization {
  SharedObjectWithSealedException._({
    required this.sealedField,
    this.nullableSealedField,
    required this.sealedList,
  });

  factory SharedObjectWithSealedException({
    required _ilwf0zl1.SharedSealedAppException sealedField,
    _ilwf0zl1.SharedSealedAppException? nullableSealedField,
    required List<_ilwf0zl1.SharedSealedAppException> sealedList,
  }) = _SharedObjectWithSealedExceptionImpl;

  factory SharedObjectWithSealedException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return SharedObjectWithSealedException(
      sealedField: _ilwf0zl1.Protocol()
          .deserialize<_ilwf0zl1.SharedSealedAppException>(
            jsonSerialization['sealedField'],
          ),
      nullableSealedField: jsonSerialization['nullableSealedField'] == null
          ? null
          : _ilwf0zl1.Protocol()
                .deserialize<_ilwf0zl1.SharedSealedAppException>(
                  jsonSerialization['nullableSealedField'],
                ),
      sealedList: _ilwf0zl1.Protocol()
          .deserialize<List<_ilwf0zl1.SharedSealedAppException>>(
            jsonSerialization['sealedList'],
          ),
    );
  }

  _ilwf0zl1.SharedSealedAppException sealedField;

  _ilwf0zl1.SharedSealedAppException? nullableSealedField;

  List<_ilwf0zl1.SharedSealedAppException> sealedList;

  /// Returns a shallow copy of this [SharedObjectWithSealedException]
  /// with some or all fields replaced by the given arguments.
  @_iss.useResult
  SharedObjectWithSealedException copyWith({
    _ilwf0zl1.SharedSealedAppException? sealedField,
    _ilwf0zl1.SharedSealedAppException? nullableSealedField,
    List<_ilwf0zl1.SharedSealedAppException>? sealedList,
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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SharedObjectWithSealedException',
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
    return _iss.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SharedObjectWithSealedExceptionImpl
    extends SharedObjectWithSealedException {
  _SharedObjectWithSealedExceptionImpl({
    required _ilwf0zl1.SharedSealedAppException sealedField,
    _ilwf0zl1.SharedSealedAppException? nullableSealedField,
    required List<_ilwf0zl1.SharedSealedAppException> sealedList,
  }) : super._(
         sealedField: sealedField,
         nullableSealedField: nullableSealedField,
         sealedList: sealedList,
       );

  /// Returns a shallow copy of this [SharedObjectWithSealedException]
  /// with some or all fields replaced by the given arguments.
  @_iss.useResult
  @override
  SharedObjectWithSealedException copyWith({
    _ilwf0zl1.SharedSealedAppException? sealedField,
    Object? nullableSealedField = _Undefined,
    List<_ilwf0zl1.SharedSealedAppException>? sealedList,
  }) {
    return SharedObjectWithSealedException(
      sealedField: sealedField ?? this.sealedField.copyWith(),
      nullableSealedField:
          nullableSealedField is _ilwf0zl1.SharedSealedAppException?
          ? nullableSealedField
          : this.nullableSealedField?.copyWith(),
      sealedList:
          sealedList ?? this.sealedList.map((e0) => e0.copyWith()).toList(),
    );
  }
}
