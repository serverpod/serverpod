/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod_test_module_server/module.dart' as _i2;

class ModuleDatatype extends _i1.SerializableEntity {
  ModuleDatatype({
    required this.entity,
    required this.list,
    required this.map,
  });

  factory ModuleDatatype.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ModuleDatatype(
      entity: serializationManager
          .deserialize<_i2.ModuleClass>(jsonSerialization['entity']),
      list: serializationManager
          .deserialize<List<_i2.ModuleClass>>(jsonSerialization['list']),
      map: serializationManager
          .deserialize<Map<String, _i2.ModuleClass>>(jsonSerialization['map']),
    );
  }

  _i2.ModuleClass entity;

  List<_i2.ModuleClass> list;

  Map<String, _i2.ModuleClass> map;

  @override
  Map<String, dynamic> toJson() {
    return {
      'entity': entity,
      'list': list,
      'map': map,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'entity': entity,
      'list': list,
      'map': map,
    };
  }
}
