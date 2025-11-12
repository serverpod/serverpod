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
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod_test_module_server/serverpod_test_module_server.dart'
    as _i2;
import 'package:serverpod_test_server/src/generated/protocol.dart' as _i3;

abstract class ModuleDatatype
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ModuleDatatype._({
    required this.model,
    required this.list,
    required this.map,
    this.record,
  });

  factory ModuleDatatype({
    required _i2.ModuleClass model,
    required List<_i2.ModuleClass> list,
    required Map<String, _i2.ModuleClass> map,
    (_i2.ModuleClass,)? record,
  }) = _ModuleDatatypeImpl;

  factory ModuleDatatype.fromJson(Map<String, dynamic> jsonSerialization) {
    return ModuleDatatype(
      model: _i2.ModuleClass.fromJson(
        (jsonSerialization['model'] as Map<String, dynamic>),
      ),
      list: (jsonSerialization['list'] as List)
          .map((e) => _i2.ModuleClass.fromJson((e as Map<String, dynamic>)))
          .toList(),
      map: (jsonSerialization['map'] as Map).map(
        (k, v) => MapEntry(
          k as String,
          _i2.ModuleClass.fromJson((v as Map<String, dynamic>)),
        ),
      ),
      record: jsonSerialization['record'] == null
          ? null
          : _i3.Protocol().deserialize<(_i2.ModuleClass,)?>(
              (jsonSerialization['record'] as Map<String, dynamic>),
            ),
    );
  }

  _i2.ModuleClass model;

  List<_i2.ModuleClass> list;

  Map<String, _i2.ModuleClass> map;

  (_i2.ModuleClass,)? record;

  /// Returns a shallow copy of this [ModuleDatatype]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ModuleDatatype copyWith({
    _i2.ModuleClass? model,
    List<_i2.ModuleClass>? list,
    Map<String, _i2.ModuleClass>? map,
    (_i2.ModuleClass,)? record,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'model': model.toJson(),
      'list': list.toJson(valueToJson: (v) => v.toJson()),
      'map': map.toJson(valueToJson: (v) => v.toJson()),
      if (record != null) 'record': _i3.mapRecordToJson(record),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'model': model.toJsonForProtocol(),
      'list': list.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'map': map.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (record != null) 'record': _i3.mapRecordToJson(record),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ModuleDatatypeImpl extends ModuleDatatype {
  _ModuleDatatypeImpl({
    required _i2.ModuleClass model,
    required List<_i2.ModuleClass> list,
    required Map<String, _i2.ModuleClass> map,
    (_i2.ModuleClass,)? record,
  }) : super._(
         model: model,
         list: list,
         map: map,
         record: record,
       );

  /// Returns a shallow copy of this [ModuleDatatype]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ModuleDatatype copyWith({
    _i2.ModuleClass? model,
    List<_i2.ModuleClass>? list,
    Map<String, _i2.ModuleClass>? map,
    Object? record = _Undefined,
  }) {
    return ModuleDatatype(
      model: model ?? this.model.copyWith(),
      list: list ?? this.list.map((e0) => e0.copyWith()).toList(),
      map:
          map ??
          this.map.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0.copyWith(),
            ),
          ),
      record: record is (_i2.ModuleClass,)?
          ? record
          : this.record == null
          ? null
          : (this.record!.$1.copyWith(),),
    );
  }
}
