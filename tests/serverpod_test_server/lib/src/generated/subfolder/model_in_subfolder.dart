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
import '../nullability.dart' as _i2;
import '../test_enum_stringified.dart' as _i3;
import 'package:serverpod_test_module_server/serverpod_test_module_server.dart'
    as _i4;
import 'package:serverpod_test_server/src/generated/protocol.dart' as _i5;

abstract class ModelInSubfolder
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
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
    _i2.Nullability? classField,
    _i3.TestEnumStringified? enumField,
    List<_i3.TestEnumStringified>? enumListField,
    (_i3.TestEnumStringified,)? enumRecordField,
    List<(_i3.TestEnumStringified,)>? enumRecordListField,
    (_i4.ModuleClass,)? moduleClassRecordField,
    (_i2.Nullability,)? classRecordField,
    ({_i3.TestEnumStringified value})? enumNamedRecordField,
    List<({_i3.TestEnumStringified value})>? enumNamedRecordListField,
    ({_i4.ModuleClass value})? moduleClassNamedRecordField,
    ({_i2.Nullability value})? classNamedRecordField,
  }) = _ModelInSubfolderImpl;

  factory ModelInSubfolder.fromJson(Map<String, dynamic> jsonSerialization) {
    return ModelInSubfolder(
      classField: jsonSerialization['classField'] == null
          ? null
          : _i2.Nullability.fromJson(
              (jsonSerialization['classField'] as Map<String, dynamic>)),
      enumField: jsonSerialization['enumField'] == null
          ? null
          : _i3.TestEnumStringified.fromJson(
              (jsonSerialization['enumField'] as String)),
      enumListField: (jsonSerialization['enumListField'] as List?)
          ?.map((e) => _i3.TestEnumStringified.fromJson((e as String)))
          .toList(),
      enumRecordField: jsonSerialization['enumRecordField'] == null
          ? null
          : _i5.Protocol().deserialize<(_i3.TestEnumStringified,)?>(
              (jsonSerialization['enumRecordField'] as Map<String, dynamic>)),
      enumRecordListField: (jsonSerialization['enumRecordListField'] as List?)
          ?.map((e) => _i5.Protocol().deserialize<(_i3.TestEnumStringified,)>(
              (e as Map<String, dynamic>)))
          .toList(),
      moduleClassRecordField:
          jsonSerialization['moduleClassRecordField'] == null
              ? null
              : _i5.Protocol().deserialize<(_i4.ModuleClass,)?>(
                  (jsonSerialization['moduleClassRecordField']
                      as Map<String, dynamic>)),
      classRecordField: jsonSerialization['classRecordField'] == null
          ? null
          : _i5.Protocol().deserialize<(_i2.Nullability,)?>(
              (jsonSerialization['classRecordField'] as Map<String, dynamic>)),
      enumNamedRecordField: jsonSerialization['enumNamedRecordField'] == null
          ? null
          : _i5.Protocol().deserialize<({_i3.TestEnumStringified value})?>(
              (jsonSerialization['enumNamedRecordField']
                  as Map<String, dynamic>)),
      enumNamedRecordListField:
          (jsonSerialization['enumNamedRecordListField'] as List?)
              ?.map((e) => _i5.Protocol()
                  .deserialize<({_i3.TestEnumStringified value})>(
                      (e as Map<String, dynamic>)))
              .toList(),
      moduleClassNamedRecordField:
          jsonSerialization['moduleClassNamedRecordField'] == null
              ? null
              : _i5.Protocol().deserialize<({_i4.ModuleClass value})?>(
                  (jsonSerialization['moduleClassNamedRecordField']
                      as Map<String, dynamic>)),
      classNamedRecordField: jsonSerialization['classNamedRecordField'] == null
          ? null
          : _i5.Protocol().deserialize<({_i2.Nullability value})?>(
              (jsonSerialization['classNamedRecordField']
                  as Map<String, dynamic>)),
    );
  }

  _i2.Nullability? classField;

  _i3.TestEnumStringified? enumField;

  List<_i3.TestEnumStringified>? enumListField;

  (_i3.TestEnumStringified,)? enumRecordField;

  List<(_i3.TestEnumStringified,)>? enumRecordListField;

  (_i4.ModuleClass,)? moduleClassRecordField;

  (_i2.Nullability,)? classRecordField;

  ({_i3.TestEnumStringified value})? enumNamedRecordField;

  List<({_i3.TestEnumStringified value})>? enumNamedRecordListField;

  ({_i4.ModuleClass value})? moduleClassNamedRecordField;

  ({_i2.Nullability value})? classNamedRecordField;

  /// Returns a shallow copy of this [ModelInSubfolder]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ModelInSubfolder copyWith({
    _i2.Nullability? classField,
    _i3.TestEnumStringified? enumField,
    List<_i3.TestEnumStringified>? enumListField,
    (_i3.TestEnumStringified,)? enumRecordField,
    List<(_i3.TestEnumStringified,)>? enumRecordListField,
    (_i4.ModuleClass,)? moduleClassRecordField,
    (_i2.Nullability,)? classRecordField,
    ({_i3.TestEnumStringified value})? enumNamedRecordField,
    List<({_i3.TestEnumStringified value})>? enumNamedRecordListField,
    ({_i4.ModuleClass value})? moduleClassNamedRecordField,
    ({_i2.Nullability value})? classNamedRecordField,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (classField != null) 'classField': classField?.toJson(),
      if (enumField != null) 'enumField': enumField?.toJson(),
      if (enumListField != null)
        'enumListField': enumListField?.toJson(valueToJson: (v) => v.toJson()),
      if (enumRecordField != null)
        'enumRecordField': _i5.mapRecordToJson(enumRecordField),
      if (enumRecordListField != null)
        'enumRecordListField':
            _i5.mapRecordContainingContainerToJson(enumRecordListField!),
      if (moduleClassRecordField != null)
        'moduleClassRecordField': _i5.mapRecordToJson(moduleClassRecordField),
      if (classRecordField != null)
        'classRecordField': _i5.mapRecordToJson(classRecordField),
      if (enumNamedRecordField != null)
        'enumNamedRecordField': _i5.mapRecordToJson(enumNamedRecordField),
      if (enumNamedRecordListField != null)
        'enumNamedRecordListField':
            _i5.mapRecordContainingContainerToJson(enumNamedRecordListField!),
      if (moduleClassNamedRecordField != null)
        'moduleClassNamedRecordField':
            _i5.mapRecordToJson(moduleClassNamedRecordField),
      if (classNamedRecordField != null)
        'classNamedRecordField': _i5.mapRecordToJson(classNamedRecordField),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (classField != null) 'classField': classField?.toJsonForProtocol(),
      if (enumField != null) 'enumField': enumField?.toJson(),
      if (enumListField != null)
        'enumListField': enumListField?.toJson(valueToJson: (v) => v.toJson()),
      if (enumRecordField != null)
        'enumRecordField': _i5.mapRecordToJson(enumRecordField),
      if (enumRecordListField != null)
        'enumRecordListField':
            _i5.mapRecordContainingContainerToJson(enumRecordListField!),
      if (moduleClassRecordField != null)
        'moduleClassRecordField': _i5.mapRecordToJson(moduleClassRecordField),
      if (classRecordField != null)
        'classRecordField': _i5.mapRecordToJson(classRecordField),
      if (enumNamedRecordField != null)
        'enumNamedRecordField': _i5.mapRecordToJson(enumNamedRecordField),
      if (enumNamedRecordListField != null)
        'enumNamedRecordListField':
            _i5.mapRecordContainingContainerToJson(enumNamedRecordListField!),
      if (moduleClassNamedRecordField != null)
        'moduleClassNamedRecordField':
            _i5.mapRecordToJson(moduleClassNamedRecordField),
      if (classNamedRecordField != null)
        'classNamedRecordField': _i5.mapRecordToJson(classNamedRecordField),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ModelInSubfolderImpl extends ModelInSubfolder {
  _ModelInSubfolderImpl({
    _i2.Nullability? classField,
    _i3.TestEnumStringified? enumField,
    List<_i3.TestEnumStringified>? enumListField,
    (_i3.TestEnumStringified,)? enumRecordField,
    List<(_i3.TestEnumStringified,)>? enumRecordListField,
    (_i4.ModuleClass,)? moduleClassRecordField,
    (_i2.Nullability,)? classRecordField,
    ({_i3.TestEnumStringified value})? enumNamedRecordField,
    List<({_i3.TestEnumStringified value})>? enumNamedRecordListField,
    ({_i4.ModuleClass value})? moduleClassNamedRecordField,
    ({_i2.Nullability value})? classNamedRecordField,
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
  @_i1.useResult
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
      classField: classField is _i2.Nullability?
          ? classField
          : this.classField?.copyWith(),
      enumField:
          enumField is _i3.TestEnumStringified? ? enumField : this.enumField,
      enumListField: enumListField is List<_i3.TestEnumStringified>?
          ? enumListField
          : this.enumListField?.map((e0) => e0).toList(),
      enumRecordField: enumRecordField is (_i3.TestEnumStringified,)?
          ? enumRecordField
          : this.enumRecordField == null
              ? null
              : (this.enumRecordField!.$1,),
      enumRecordListField:
          enumRecordListField is List<(_i3.TestEnumStringified,)>?
              ? enumRecordListField
              : this.enumRecordListField?.map((e0) => (e0.$1,)).toList(),
      moduleClassRecordField: moduleClassRecordField is (_i4.ModuleClass,)?
          ? moduleClassRecordField
          : this.moduleClassRecordField == null
              ? null
              : (this.moduleClassRecordField!.$1.copyWith(),),
      classRecordField: classRecordField is (_i2.Nullability,)?
          ? classRecordField
          : this.classRecordField == null
              ? null
              : (this.classRecordField!.$1.copyWith(),),
      enumNamedRecordField:
          enumNamedRecordField is ({_i3.TestEnumStringified value})?
              ? enumNamedRecordField
              : this.enumNamedRecordField == null
                  ? null
                  : (value: this.enumNamedRecordField!.value,),
      enumNamedRecordListField:
          enumNamedRecordListField is List<({_i3.TestEnumStringified value})>?
              ? enumNamedRecordListField
              : this
                  .enumNamedRecordListField
                  ?.map((e0) => (value: e0.value,))
                  .toList(),
      moduleClassNamedRecordField: moduleClassNamedRecordField is ({
        _i4.ModuleClass value
      })?
          ? moduleClassNamedRecordField
          : this.moduleClassNamedRecordField == null
              ? null
              : (value: this.moduleClassNamedRecordField!.value.copyWith(),),
      classNamedRecordField: classNamedRecordField is ({_i2.Nullability value})?
          ? classNamedRecordField
          : this.classNamedRecordField == null
              ? null
              : (value: this.classNamedRecordField!.value.copyWith(),),
    );
  }
}
