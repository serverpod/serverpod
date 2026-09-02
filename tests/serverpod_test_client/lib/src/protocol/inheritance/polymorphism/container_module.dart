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

/// A class that holds child objects defined in a module.
abstract class ModulePolymorphicChildContainer
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ModulePolymorphicChildContainer._({
    required this.moduleObject,
    required this.moduleObjectList,
    required this.moduleObjectMap,
  });

  factory ModulePolymorphicChildContainer({
    required _i89s5423.ModulePolymorphicChild moduleObject,
    required List<_i89s5423.ModulePolymorphicChild> moduleObjectList,
    required Map<String, _i89s5423.ModulePolymorphicChild> moduleObjectMap,
  }) = _ModulePolymorphicChildContainerImpl;

  factory ModulePolymorphicChildContainer.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ModulePolymorphicChildContainer(
      moduleObject: _iza9lbb5.Protocol()
          .deserialize<_i89s5423.ModulePolymorphicChild>(
            jsonSerialization['moduleObject'],
          ),
      moduleObjectList: _iza9lbb5.Protocol()
          .deserialize<List<_i89s5423.ModulePolymorphicChild>>(
            jsonSerialization['moduleObjectList'],
          ),
      moduleObjectMap: _iza9lbb5.Protocol()
          .deserialize<Map<String, _i89s5423.ModulePolymorphicChild>>(
            jsonSerialization['moduleObjectMap'],
          ),
    );
  }

  /// Object from a module.
  _i89s5423.ModulePolymorphicChild moduleObject;

  /// List of objects from a module.
  List<_i89s5423.ModulePolymorphicChild> moduleObjectList;

  /// Map of objects from a module.
  Map<String, _i89s5423.ModulePolymorphicChild> moduleObjectMap;

  /// Returns a shallow copy of this [ModulePolymorphicChildContainer]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ModulePolymorphicChildContainer copyWith({
    _i89s5423.ModulePolymorphicChild? moduleObject,
    List<_i89s5423.ModulePolymorphicChild>? moduleObjectList,
    Map<String, _i89s5423.ModulePolymorphicChild>? moduleObjectMap,
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
    return _isc.SerializationManager.encode(this);
  }
}

class _ModulePolymorphicChildContainerImpl
    extends ModulePolymorphicChildContainer {
  _ModulePolymorphicChildContainerImpl({
    required _i89s5423.ModulePolymorphicChild moduleObject,
    required List<_i89s5423.ModulePolymorphicChild> moduleObjectList,
    required Map<String, _i89s5423.ModulePolymorphicChild> moduleObjectMap,
  }) : super._(
         moduleObject: moduleObject,
         moduleObjectList: moduleObjectList,
         moduleObjectMap: moduleObjectMap,
       );

  /// Returns a shallow copy of this [ModulePolymorphicChildContainer]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ModulePolymorphicChildContainer copyWith({
    _i89s5423.ModulePolymorphicChild? moduleObject,
    List<_i89s5423.ModulePolymorphicChild>? moduleObjectList,
    Map<String, _i89s5423.ModulePolymorphicChild>? moduleObjectMap,
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
