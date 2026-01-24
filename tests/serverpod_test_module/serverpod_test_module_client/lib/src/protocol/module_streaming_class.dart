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

abstract class ModuleStreamingClass implements _i1.SerializableModel {
  ModuleStreamingClass._({required this.name});

  factory ModuleStreamingClass({required String name}) =
      _ModuleStreamingClassImpl;

  factory ModuleStreamingClass.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ModuleStreamingClass(name: jsonSerialization['name'] as String);
  }

  String name;

  /// Returns a shallow copy of this [ModuleStreamingClass]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ModuleStreamingClass copyWith({String? name});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_test_module.ModuleStreamingClass',
      'name': name,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ModuleStreamingClassImpl extends ModuleStreamingClass {
  _ModuleStreamingClassImpl({required String name}) : super._(name: name);

  /// Returns a shallow copy of this [ModuleStreamingClass]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ModuleStreamingClass copyWith({String? name}) {
    return ModuleStreamingClass(name: name ?? this.name);
  }
}
