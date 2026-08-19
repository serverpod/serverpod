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

abstract class ModuleDatatype
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ModuleDatatype._({
    required this.model,
    required this.list,
    required this.map,
    this.record,
  });

  factory ModuleDatatype({
    required _i89s5423.ModuleClass model,
    required List<_i89s5423.ModuleClass> list,
    required Map<String, _i89s5423.ModuleClass> map,
    (_i89s5423.ModuleClass,)? record,
  }) = _ModuleDatatypeImpl;

  factory ModuleDatatype.fromJson(Map<String, dynamic> jsonSerialization) {
    return ModuleDatatype(
      model: _iza9lbb5.Protocol().deserialize<_i89s5423.ModuleClass>(
        jsonSerialization['model'],
      ),
      list: _iza9lbb5.Protocol().deserialize<List<_i89s5423.ModuleClass>>(
        jsonSerialization['list'],
      ),
      map: _iza9lbb5.Protocol().deserialize<Map<String, _i89s5423.ModuleClass>>(
        jsonSerialization['map'],
      ),
      record: jsonSerialization['record'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<(_i89s5423.ModuleClass,)?>(
              (jsonSerialization['record'] as Map<String, dynamic>),
            ),
    );
  }

  _i89s5423.ModuleClass model;

  List<_i89s5423.ModuleClass> list;

  Map<String, _i89s5423.ModuleClass> map;

  (_i89s5423.ModuleClass,)? record;

  /// Returns a shallow copy of this [ModuleDatatype]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ModuleDatatype copyWith({
    _i89s5423.ModuleClass? model,
    List<_i89s5423.ModuleClass>? list,
    Map<String, _i89s5423.ModuleClass>? map,
    (_i89s5423.ModuleClass,)? record,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ModuleDatatype',
      'model': model.toJson(),
      'list': list.toJson(valueToJson: (v) => v.toJson()),
      'map': map.toJson(valueToJson: (v) => v.toJson()),
      if (record != null)
        'record': _iza9lbb5.Protocol().mapRecordToJson(record),
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
        'record': _iza9lbb5.Protocol().mapRecordToJson(record),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ModuleDatatypeImpl extends ModuleDatatype {
  _ModuleDatatypeImpl({
    required _i89s5423.ModuleClass model,
    required List<_i89s5423.ModuleClass> list,
    required Map<String, _i89s5423.ModuleClass> map,
    (_i89s5423.ModuleClass,)? record,
  }) : super._(
         model: model,
         list: list,
         map: map,
         record: record,
       );

  /// Returns a shallow copy of this [ModuleDatatype]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ModuleDatatype copyWith({
    _i89s5423.ModuleClass? model,
    List<_i89s5423.ModuleClass>? list,
    Map<String, _i89s5423.ModuleClass>? map,
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
      record: record is (_i89s5423.ModuleClass,)?
          ? record
          : this.record == null
          ? null
          : (this.record!.$1.copyWith(),),
    );
  }
}
