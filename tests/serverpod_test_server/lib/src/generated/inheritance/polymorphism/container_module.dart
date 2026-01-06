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

/// A class that holds child objects defined in a module.
abstract class ModulePolymorphicChildContainer
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ModulePolymorphicChildContainer._({
    required this.moduleObject,
    required this.moduleObjectList,
    required this.moduleObjectMap,
  });

  factory ModulePolymorphicChildContainer({
    required _i2.ModulePolymorphicChild moduleObject,
    required List<_i2.ModulePolymorphicChild> moduleObjectList,
    required Map<String, _i2.ModulePolymorphicChild> moduleObjectMap,
  }) = _ModulePolymorphicChildContainerImpl;

  factory ModulePolymorphicChildContainer.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ModulePolymorphicChildContainer(
      moduleObject: _i3.Protocol().deserialize<_i2.ModulePolymorphicChild>(
        jsonSerialization['moduleObject'],
      ),
      moduleObjectList: _i3.Protocol()
          .deserialize<List<_i2.ModulePolymorphicChild>>(
            jsonSerialization['moduleObjectList'],
          ),
      moduleObjectMap: _i3.Protocol()
          .deserialize<Map<String, _i2.ModulePolymorphicChild>>(
            jsonSerialization['moduleObjectMap'],
          ),
    );
  }

  /// Object from a module.
  _i2.ModulePolymorphicChild moduleObject;

  /// List of objects from a module.
  List<_i2.ModulePolymorphicChild> moduleObjectList;

  /// Map of objects from a module.
  Map<String, _i2.ModulePolymorphicChild> moduleObjectMap;

  /// Returns a shallow copy of this [ModulePolymorphicChildContainer]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ModulePolymorphicChildContainer copyWith({
    _i2.ModulePolymorphicChild? moduleObject,
    List<_i2.ModulePolymorphicChild>? moduleObjectList,
    Map<String, _i2.ModulePolymorphicChild>? moduleObjectMap,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ModulePolymorphicChildContainer',
      'moduleObject': moduleObject.toJson(),
      'moduleObjectList': moduleObjectList.toJson(
        valueToJson: (v) => v.toJson(),
      ),
      'moduleObjectMap': moduleObjectMap.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ModulePolymorphicChildContainer',
      'moduleObject': moduleObject.toJsonForProtocol(),
      'moduleObjectList': moduleObjectList.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'moduleObjectMap': moduleObjectMap.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ModulePolymorphicChildContainerImpl
    extends ModulePolymorphicChildContainer {
  _ModulePolymorphicChildContainerImpl({
    required _i2.ModulePolymorphicChild moduleObject,
    required List<_i2.ModulePolymorphicChild> moduleObjectList,
    required Map<String, _i2.ModulePolymorphicChild> moduleObjectMap,
  }) : super._(
         moduleObject: moduleObject,
         moduleObjectList: moduleObjectList,
         moduleObjectMap: moduleObjectMap,
       );

  /// Returns a shallow copy of this [ModulePolymorphicChildContainer]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ModulePolymorphicChildContainer copyWith({
    _i2.ModulePolymorphicChild? moduleObject,
    List<_i2.ModulePolymorphicChild>? moduleObjectList,
    Map<String, _i2.ModulePolymorphicChild>? moduleObjectMap,
  }) {
    return ModulePolymorphicChildContainer(
      moduleObject: moduleObject ?? this.moduleObject.copyWith(),
      moduleObjectList:
          moduleObjectList ??
          this.moduleObjectList.map((e0) => e0.copyWith()).toList(),
      moduleObjectMap:
          moduleObjectMap ??
          this.moduleObjectMap.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0.copyWith(),
            ),
          ),
    );
  }
}
