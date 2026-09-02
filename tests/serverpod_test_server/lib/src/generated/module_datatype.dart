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
import 'package:serverpod_test_module_server/serverpod_test_module_server.dart'
    as _iom2gwyu;
import 'package:serverpod_test_server/src/generated/protocol.dart' as _igqrxdcj;

abstract class ModuleDatatype
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ModuleDatatype._({
    required this.model,
    required this.list,
    required this.map,
    this.record,
  });

  factory ModuleDatatype({
    required _iom2gwyu.ModuleClass model,
    required List<_iom2gwyu.ModuleClass> list,
    required Map<String, _iom2gwyu.ModuleClass> map,
    (_iom2gwyu.ModuleClass,)? record,
  }) = _ModuleDatatypeImpl;

  factory ModuleDatatype.fromJson(Map<String, dynamic> jsonSerialization) {
    return ModuleDatatype(
      model: _igqrxdcj.Protocol().deserialize<_iom2gwyu.ModuleClass>(
        jsonSerialization['model'],
      ),
      list: _igqrxdcj.Protocol().deserialize<List<_iom2gwyu.ModuleClass>>(
        jsonSerialization['list'],
      ),
      map: _igqrxdcj.Protocol().deserialize<Map<String, _iom2gwyu.ModuleClass>>(
        jsonSerialization['map'],
      ),
      record: jsonSerialization['record'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<(_iom2gwyu.ModuleClass,)?>(
              (jsonSerialization['record'] as Map<String, dynamic>),
            ),
    );
  }

  _iom2gwyu.ModuleClass model;

  List<_iom2gwyu.ModuleClass> list;

  Map<String, _iom2gwyu.ModuleClass> map;

  (_iom2gwyu.ModuleClass,)? record;

  /// Returns a shallow copy of this [ModuleDatatype]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ModuleDatatype copyWith({
    _iom2gwyu.ModuleClass? model,
    List<_iom2gwyu.ModuleClass>? list,
    Map<String, _iom2gwyu.ModuleClass>? map,
    (_iom2gwyu.ModuleClass,)? record,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ModuleDatatype',
      'model': model.toJson(),
      'list': list.toJson(valueToJson: (v) => v.toJson()),
      'map': map.toJson(valueToJson: (v) => v.toJson()),
      if (record != null)
        'record': _igqrxdcj.Protocol().mapRecordToJson(record),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ModuleDatatype',
      'model': model.toJson(),
      'list': list.toJson(valueToJson: (v) => v.toJson()),
      'map': map.toJson(valueToJson: (v) => v.toJson()),
      if (record != null)
        'record': _igqrxdcj.Protocol().mapRecordToJson(record),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ModuleDatatypeImpl extends ModuleDatatype {
  _ModuleDatatypeImpl({
    required _iom2gwyu.ModuleClass model,
    required List<_iom2gwyu.ModuleClass> list,
    required Map<String, _iom2gwyu.ModuleClass> map,
    (_iom2gwyu.ModuleClass,)? record,
  }) : super._(
         model: model,
         list: list,
         map: map,
         record: record,
       );

  /// Returns a shallow copy of this [ModuleDatatype]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ModuleDatatype copyWith({
    _iom2gwyu.ModuleClass? model,
    List<_iom2gwyu.ModuleClass>? list,
    Map<String, _iom2gwyu.ModuleClass>? map,
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
      record: record is (_iom2gwyu.ModuleClass,)?
          ? record
          : this.record == null
          ? null
          : (this.record!.$1.copyWith(),),
    );
  }
}
