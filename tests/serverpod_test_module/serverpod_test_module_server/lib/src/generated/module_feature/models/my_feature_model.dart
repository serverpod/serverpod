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

abstract class MyModuleFeatureModel
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  MyModuleFeatureModel._({required this.name});

  factory MyModuleFeatureModel({required String name}) =
      _MyModuleFeatureModelImpl;

  factory MyModuleFeatureModel.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return MyModuleFeatureModel(name: jsonSerialization['name'] as String);
  }

  String name;

  /// Returns a shallow copy of this [MyModuleFeatureModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MyModuleFeatureModel copyWith({String? name});
  @override
  Map<String, dynamic> toJson() {
    return {'name': name};
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {'name': name};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _MyModuleFeatureModelImpl extends MyModuleFeatureModel {
  _MyModuleFeatureModelImpl({required String name}) : super._(name: name);

  /// Returns a shallow copy of this [MyModuleFeatureModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MyModuleFeatureModel copyWith({String? name}) {
    return MyModuleFeatureModel(name: name ?? this.name);
  }
}
