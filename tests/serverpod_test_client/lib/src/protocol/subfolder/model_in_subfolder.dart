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
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _iza9lbb5;
import 'package:serverpod_test_module_client/serverpod_test_module_client.dart'
    as _i89s5423;
import '../nullability.dart' as _ikr9iqn0;
import '../test_enum_stringified.dart' as _i105ky7k;

abstract class ModelInSubfolder
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ModelInSubfolder._({
    this.classField,
    this.enumField,
    this.enumListField,
    this.enumRecordField,
    this.enumRecordListField,
    this.moduleClassRecordField,
    this.classRecordField,
    this.enumNamedRecordField,
    this.enumNamedRecordListField,
    this.moduleClassNamedRecordField,
    this.classNamedRecordField,
  });

  factory ModelInSubfolder({
    _ikr9iqn0.Nullability? classField,
    _i105ky7k.TestEnumStringified? enumField,
    List<_i105ky7k.TestEnumStringified>? enumListField,
    (_i105ky7k.TestEnumStringified,)? enumRecordField,
    List<(_i105ky7k.TestEnumStringified,)>? enumRecordListField,
    (_i89s5423.ModuleClass,)? moduleClassRecordField,
    (_ikr9iqn0.Nullability,)? classRecordField,
    ({_i105ky7k.TestEnumStringified value})? enumNamedRecordField,
    List<({_i105ky7k.TestEnumStringified value})>? enumNamedRecordListField,
    ({_i89s5423.ModuleClass value})? moduleClassNamedRecordField,
    ({_ikr9iqn0.Nullability value})? classNamedRecordField,
  }) = _ModelInSubfolderImpl;

  factory ModelInSubfolder.fromJson(Map<String, dynamic> jsonSerialization) {
    return ModelInSubfolder(
      classField: jsonSerialization['classField'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<_ikr9iqn0.Nullability>(
              jsonSerialization['classField'],
            ),
      enumField: jsonSerialization['enumField'] == null
          ? null
          : _i105ky7k.TestEnumStringified.fromJson(
              (jsonSerialization['enumField'] as String),
            ),
      enumListField: jsonSerialization['enumListField'] == null
          ? null
          : _iza9lbb5.Protocol()
                .deserialize<List<_i105ky7k.TestEnumStringified>>(
                  jsonSerialization['enumListField'],
                ),
      enumRecordField: jsonSerialization['enumRecordField'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<(_i105ky7k.TestEnumStringified,)?>(
              (jsonSerialization['enumRecordField'] as Map<String, dynamic>),
            ),
      enumRecordListField: jsonSerialization['enumRecordListField'] == null
          ? null
          : _iza9lbb5.Protocol()
                .deserialize<List<(_i105ky7k.TestEnumStringified,)>>(
                  jsonSerialization['enumRecordListField'],
                ),
      moduleClassRecordField:
          jsonSerialization['moduleClassRecordField'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<(_i89s5423.ModuleClass,)?>(
              (jsonSerialization['moduleClassRecordField']
                  as Map<String, dynamic>),
            ),
      classRecordField: jsonSerialization['classRecordField'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<(_ikr9iqn0.Nullability,)?>(
              (jsonSerialization['classRecordField'] as Map<String, dynamic>),
            ),
      enumNamedRecordField: jsonSerialization['enumNamedRecordField'] == null
          ? null
          : _iza9lbb5.Protocol()
                .deserialize<({_i105ky7k.TestEnumStringified value})?>(
                  (jsonSerialization['enumNamedRecordField']
                      as Map<String, dynamic>),
                ),
      enumNamedRecordListField:
          jsonSerialization['enumNamedRecordListField'] == null
          ? null
          : _iza9lbb5.Protocol()
                .deserialize<List<({_i105ky7k.TestEnumStringified value})>>(
                  jsonSerialization['enumNamedRecordListField'],
                ),
      moduleClassNamedRecordField:
          jsonSerialization['moduleClassNamedRecordField'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<({_i89s5423.ModuleClass value})?>(
              (jsonSerialization['moduleClassNamedRecordField']
                  as Map<String, dynamic>),
            ),
      classNamedRecordField: jsonSerialization['classNamedRecordField'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<({_ikr9iqn0.Nullability value})?>(
              (jsonSerialization['classNamedRecordField']
                  as Map<String, dynamic>),
            ),
    );
  }

  _ikr9iqn0.Nullability? classField;

  _i105ky7k.TestEnumStringified? enumField;

  List<_i105ky7k.TestEnumStringified>? enumListField;

  (_i105ky7k.TestEnumStringified,)? enumRecordField;

  List<(_i105ky7k.TestEnumStringified,)>? enumRecordListField;

  (_i89s5423.ModuleClass,)? moduleClassRecordField;

  (_ikr9iqn0.Nullability,)? classRecordField;

  ({_i105ky7k.TestEnumStringified value})? enumNamedRecordField;

  List<({_i105ky7k.TestEnumStringified value})>? enumNamedRecordListField;

  ({_i89s5423.ModuleClass value})? moduleClassNamedRecordField;

  ({_ikr9iqn0.Nullability value})? classNamedRecordField;

  /// Returns a shallow copy of this [ModelInSubfolder]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ModelInSubfolder copyWith({
    _ikr9iqn0.Nullability? classField,
    _i105ky7k.TestEnumStringified? enumField,
    List<_i105ky7k.TestEnumStringified>? enumListField,
    (_i105ky7k.TestEnumStringified,)? enumRecordField,
    List<(_i105ky7k.TestEnumStringified,)>? enumRecordListField,
    (_i89s5423.ModuleClass,)? moduleClassRecordField,
    (_ikr9iqn0.Nullability,)? classRecordField,
    ({_i105ky7k.TestEnumStringified value})? enumNamedRecordField,
    List<({_i105ky7k.TestEnumStringified value})>? enumNamedRecordListField,
    ({_i89s5423.ModuleClass value})? moduleClassNamedRecordField,
    ({_ikr9iqn0.Nullability value})? classNamedRecordField,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ModelInSubfolder',
      if (classField != null) 'classField': classField?.toJson(),
      if (enumField != null) 'enumField': enumField?.toJson(),
      if (enumListField != null)
        'enumListField': enumListField?.toJson(valueToJson: (v) => v.toJson()),
      if (enumRecordField != null)
        'enumRecordField': _iza9lbb5.Protocol().mapRecordToJson(
          enumRecordField,
        ),
      if (enumRecordListField != null)
        'enumRecordListField': _iza9lbb5.Protocol().mapContainerToJson(
          enumRecordListField!,
        ),
      if (moduleClassRecordField != null)
        'moduleClassRecordField': _iza9lbb5.Protocol().mapRecordToJson(
          moduleClassRecordField,
        ),
      if (classRecordField != null)
        'classRecordField': _iza9lbb5.Protocol().mapRecordToJson(
          classRecordField,
        ),
      if (enumNamedRecordField != null)
        'enumNamedRecordField': _iza9lbb5.Protocol().mapRecordToJson(
          enumNamedRecordField,
        ),
      if (enumNamedRecordListField != null)
        'enumNamedRecordListField': _iza9lbb5.Protocol().mapContainerToJson(
          enumNamedRecordListField!,
        ),
      if (moduleClassNamedRecordField != null)
        'moduleClassNamedRecordField': _iza9lbb5.Protocol().mapRecordToJson(
          moduleClassNamedRecordField,
        ),
      if (classNamedRecordField != null)
        'classNamedRecordField': _iza9lbb5.Protocol().mapRecordToJson(
          classNamedRecordField,
        ),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ModelInSubfolder',
      if (classField != null) 'classField': classField?.toJsonForProtocol(),
      if (enumField != null) 'enumField': enumField?.toJson(),
      if (enumListField != null)
        'enumListField': enumListField?.toJson(valueToJson: (v) => v.toJson()),
      if (enumRecordField != null)
        'enumRecordField': _iza9lbb5.Protocol().mapRecordToJson(
          enumRecordField,
        ),
      if (enumRecordListField != null)
        'enumRecordListField': _iza9lbb5.Protocol().mapContainerToJson(
          enumRecordListField!,
        ),
      if (moduleClassRecordField != null)
        'moduleClassRecordField': _iza9lbb5.Protocol().mapRecordToJson(
          moduleClassRecordField,
        ),
      if (classRecordField != null)
        'classRecordField': _iza9lbb5.Protocol().mapRecordToJson(
          classRecordField,
        ),
      if (enumNamedRecordField != null)
        'enumNamedRecordField': _iza9lbb5.Protocol().mapRecordToJson(
          enumNamedRecordField,
        ),
      if (enumNamedRecordListField != null)
        'enumNamedRecordListField': _iza9lbb5.Protocol().mapContainerToJson(
          enumNamedRecordListField!,
        ),
      if (moduleClassNamedRecordField != null)
        'moduleClassNamedRecordField': _iza9lbb5.Protocol().mapRecordToJson(
          moduleClassNamedRecordField,
        ),
      if (classNamedRecordField != null)
        'classNamedRecordField': _iza9lbb5.Protocol().mapRecordToJson(
          classNamedRecordField,
        ),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ModelInSubfolderImpl extends ModelInSubfolder {
  _ModelInSubfolderImpl({
    _ikr9iqn0.Nullability? classField,
    _i105ky7k.TestEnumStringified? enumField,
    List<_i105ky7k.TestEnumStringified>? enumListField,
    (_i105ky7k.TestEnumStringified,)? enumRecordField,
    List<(_i105ky7k.TestEnumStringified,)>? enumRecordListField,
    (_i89s5423.ModuleClass,)? moduleClassRecordField,
    (_ikr9iqn0.Nullability,)? classRecordField,
    ({_i105ky7k.TestEnumStringified value})? enumNamedRecordField,
    List<({_i105ky7k.TestEnumStringified value})>? enumNamedRecordListField,
    ({_i89s5423.ModuleClass value})? moduleClassNamedRecordField,
    ({_ikr9iqn0.Nullability value})? classNamedRecordField,
  }) : super._(
         classField: classField,
         enumField: enumField,
         enumListField: enumListField,
         enumRecordField: enumRecordField,
         enumRecordListField: enumRecordListField,
         moduleClassRecordField: moduleClassRecordField,
         classRecordField: classRecordField,
         enumNamedRecordField: enumNamedRecordField,
         enumNamedRecordListField: enumNamedRecordListField,
         moduleClassNamedRecordField: moduleClassNamedRecordField,
         classNamedRecordField: classNamedRecordField,
       );

  /// Returns a shallow copy of this [ModelInSubfolder]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ModelInSubfolder copyWith({
    Object? classField = _Undefined,
    Object? enumField = _Undefined,
    Object? enumListField = _Undefined,
    Object? enumRecordField = _Undefined,
    Object? enumRecordListField = _Undefined,
    Object? moduleClassRecordField = _Undefined,
    Object? classRecordField = _Undefined,
    Object? enumNamedRecordField = _Undefined,
    Object? enumNamedRecordListField = _Undefined,
    Object? moduleClassNamedRecordField = _Undefined,
    Object? classNamedRecordField = _Undefined,
  }) {
    return ModelInSubfolder(
      classField: classField is _ikr9iqn0.Nullability?
          ? classField
          : this.classField?.copyWith(),
      enumField: enumField is _i105ky7k.TestEnumStringified?
          ? enumField
          : this.enumField,
      enumListField: enumListField is List<_i105ky7k.TestEnumStringified>?
          ? enumListField
          : this.enumListField?.map((e0) => e0).toList(),
      enumRecordField: enumRecordField is (_i105ky7k.TestEnumStringified,)?
          ? enumRecordField
          : this.enumRecordField == null
          ? null
          : (this.enumRecordField!.$1,),
      enumRecordListField:
          enumRecordListField is List<(_i105ky7k.TestEnumStringified,)>?
          ? enumRecordListField
          : this.enumRecordListField?.map((e0) => (e0.$1,)).toList(),
      moduleClassRecordField:
          moduleClassRecordField is (_i89s5423.ModuleClass,)?
          ? moduleClassRecordField
          : this.moduleClassRecordField == null
          ? null
          : (this.moduleClassRecordField!.$1.copyWith(),),
      classRecordField: classRecordField is (_ikr9iqn0.Nullability,)?
          ? classRecordField
          : this.classRecordField == null
          ? null
          : (this.classRecordField!.$1.copyWith(),),
      enumNamedRecordField:
          enumNamedRecordField is ({_i105ky7k.TestEnumStringified value})?
          ? enumNamedRecordField
          : this.enumNamedRecordField == null
          ? null
          : (
              value: this.enumNamedRecordField!.value,
            ),
      enumNamedRecordListField:
          enumNamedRecordListField
              is List<({_i105ky7k.TestEnumStringified value})>?
          ? enumNamedRecordListField
          : this.enumNamedRecordListField
                ?.map(
                  (e0) => (
                    value: e0.value,
                  ),
                )
                .toList(),
      moduleClassNamedRecordField:
          moduleClassNamedRecordField is ({_i89s5423.ModuleClass value})?
          ? moduleClassNamedRecordField
          : this.moduleClassNamedRecordField == null
          ? null
          : (
              value: this.moduleClassNamedRecordField!.value.copyWith(),
            ),
      classNamedRecordField:
          classNamedRecordField is ({_ikr9iqn0.Nullability value})?
          ? classNamedRecordField
          : this.classNamedRecordField == null
          ? null
          : (
              value: this.classNamedRecordField!.value.copyWith(),
            ),
    );
  }
}
