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
import 'package:serverpod_test_module_client/src/protocol/protocol.dart' as _i2;

abstract class ModuleClass implements _i1.SerializableModel {
  ModuleClass._({
    required this.name,
    required this.data,
    this.record,
  });

  factory ModuleClass({
    required String name,
    required int data,
    (bool,)? record,
  }) = _ModuleClassImpl;

  factory ModuleClass.fromJson(Map<String, dynamic> jsonSerialization) {
    return ModuleClass(
      name: jsonSerialization['name'] as String,
      data: jsonSerialization['data'] as int,
      record: jsonSerialization['record'] == null
          ? null
          : _i2.Protocol().deserialize<(bool,)?>(
              (jsonSerialization['record'] as Map<String, dynamic>),
            ),
    );
  }

  String name;

  int data;

  (bool,)? record;

  /// Returns a shallow copy of this [ModuleClass]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ModuleClass copyWith({
    String? name,
    int? data,
    (bool,)? record,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'data': data,
      if (record != null) 'record': _i2.mapRecordToJson(record),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ModuleClassImpl extends ModuleClass {
  _ModuleClassImpl({
    required String name,
    required int data,
    (bool,)? record,
  }) : super._(
         name: name,
         data: data,
         record: record,
       );

  /// Returns a shallow copy of this [ModuleClass]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ModuleClass copyWith({
    String? name,
    int? data,
    Object? record = _Undefined,
  }) {
    return ModuleClass(
      name: name ?? this.name,
      data: data ?? this.data,
      record: record is (bool,)?
          ? record
          : this.record == null
          ? null
          : (this.record!.$1,),
    );
  }
}
