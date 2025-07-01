/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class MyFeatureModel implements _i1.SerializableModel {
  MyFeatureModel._({required this.name});

  factory MyFeatureModel({required String name}) = _MyFeatureModelImpl;

  factory MyFeatureModel.fromJson(Map<String, dynamic> jsonSerialization) {
    return MyFeatureModel(name: jsonSerialization['name'] as String);
  }

  String name;

  /// Returns a shallow copy of this [MyFeatureModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  MyFeatureModel copyWith({String? name});
  @override
  Map<String, dynamic> toJson() {
    return {'name': name};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _MyFeatureModelImpl extends MyFeatureModel {
  _MyFeatureModelImpl({required String name}) : super._(name: name);

  /// Returns a shallow copy of this [MyFeatureModel]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  MyFeatureModel copyWith({String? name}) {
    return MyFeatureModel(name: name ?? this.name);
  }
}
