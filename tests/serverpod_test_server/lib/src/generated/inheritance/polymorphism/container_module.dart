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

/// A class that holds child objects defined in a module.
abstract class ModulePolymorphicChildContainer
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ModulePolymorphicChildContainer._({
    required this.moduleObject,
    required this.moduleObjectList,
    required this.moduleObjectMap,
  });

  factory ModulePolymorphicChildContainer({
    required _iom2gwyu.ModulePolymorphicChild moduleObject,
    required List<_iom2gwyu.ModulePolymorphicChild> moduleObjectList,
    required Map<String, _iom2gwyu.ModulePolymorphicChild> moduleObjectMap,
  }) = _ModulePolymorphicChildContainerImpl;

  factory ModulePolymorphicChildContainer.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ModulePolymorphicChildContainer(
      moduleObject: _igqrxdcj.Protocol()
          .deserialize<_iom2gwyu.ModulePolymorphicChild>(
            jsonSerialization['moduleObject'],
          ),
      moduleObjectList: _igqrxdcj.Protocol()
          .deserialize<List<_iom2gwyu.ModulePolymorphicChild>>(
            jsonSerialization['moduleObjectList'],
          ),
      moduleObjectMap: _igqrxdcj.Protocol()
          .deserialize<Map<String, _iom2gwyu.ModulePolymorphicChild>>(
            jsonSerialization['moduleObjectMap'],
          ),
    );
  }

  /// Object from a module.
  _iom2gwyu.ModulePolymorphicChild moduleObject;

  /// List of objects from a module.
  List<_iom2gwyu.ModulePolymorphicChild> moduleObjectList;

  /// Map of objects from a module.
  Map<String, _iom2gwyu.ModulePolymorphicChild> moduleObjectMap;

  /// Returns a shallow copy of this [ModulePolymorphicChildContainer]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ModulePolymorphicChildContainer copyWith({
    _iom2gwyu.ModulePolymorphicChild? moduleObject,
    List<_iom2gwyu.ModulePolymorphicChild>? moduleObjectList,
    Map<String, _iom2gwyu.ModulePolymorphicChild>? moduleObjectMap,
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
      'moduleObject': moduleObject.toJson(),
      'moduleObjectList': moduleObjectList.toJson(
        valueToJson: (v) => v.toJson(),
      ),
      'moduleObjectMap': moduleObjectMap.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ModulePolymorphicChildContainerImpl
    extends ModulePolymorphicChildContainer {
  _ModulePolymorphicChildContainerImpl({
    required _iom2gwyu.ModulePolymorphicChild moduleObject,
    required List<_iom2gwyu.ModulePolymorphicChild> moduleObjectList,
    required Map<String, _iom2gwyu.ModulePolymorphicChild> moduleObjectMap,
  }) : super._(
         moduleObject: moduleObject,
         moduleObjectList: moduleObjectList,
         moduleObjectMap: moduleObjectMap,
       );

  /// Returns a shallow copy of this [ModulePolymorphicChildContainer]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ModulePolymorphicChildContainer copyWith({
    _iom2gwyu.ModulePolymorphicChild? moduleObject,
    List<_iom2gwyu.ModulePolymorphicChild>? moduleObjectList,
    Map<String, _iom2gwyu.ModulePolymorphicChild>? moduleObjectMap,
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
