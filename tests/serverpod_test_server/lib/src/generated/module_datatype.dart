/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod_test_module_server/module.dart' as _i2;

abstract class ModuleDatatype extends _i1.SerializableEntity {
  ModuleDatatype._({
    required this.model,
    required this.list,
    required this.map,
  });

  factory ModuleDatatype({
    required _i2.ModuleClass model,
    required List<_i2.ModuleClass> list,
    required Map<String, _i2.ModuleClass> map,
  }) = _ModuleDatatypeImpl;

  factory ModuleDatatype.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ModuleDatatype(
      model: serializationManager
          .deserialize<_i2.ModuleClass>(jsonSerialization['model']),
      list: serializationManager
          .deserialize<List<_i2.ModuleClass>>(jsonSerialization['list']),
      map: serializationManager
          .deserialize<Map<String, _i2.ModuleClass>>(jsonSerialization['map']),
    );
  }

  _i2.ModuleClass model;

  List<_i2.ModuleClass> list;

  Map<String, _i2.ModuleClass> map;

  ModuleDatatype copyWith({
    _i2.ModuleClass? model,
    List<_i2.ModuleClass>? list,
    Map<String, _i2.ModuleClass>? map,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'model': model,
      'list': list,
      'map': map,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'model': model,
      'list': list,
      'map': map,
    };
  }
}

class _ModuleDatatypeImpl extends ModuleDatatype {
  _ModuleDatatypeImpl({
    required _i2.ModuleClass model,
    required List<_i2.ModuleClass> list,
    required Map<String, _i2.ModuleClass> map,
  }) : super._(
          model: model,
          list: list,
          map: map,
        );

  @override
  ModuleDatatype copyWith({
    _i2.ModuleClass? model,
    List<_i2.ModuleClass>? list,
    Map<String, _i2.ModuleClass>? map,
  }) {
    return ModuleDatatype(
      model: model ?? this.model.copyWith(),
      list: list ?? this.list.clone(),
      map: map ?? this.map.clone(),
    );
  }
}
