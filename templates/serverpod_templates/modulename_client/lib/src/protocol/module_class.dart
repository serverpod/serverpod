/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class ModuleClass implements _i1.SerializableModel {
  ModuleClass._({
    required this.name,
    required this.data,
  });

  factory ModuleClass({
    required String name,
    required int data,
  }) = _ModuleClassImpl;

  factory ModuleClass.fromJson(Map<String, dynamic> jsonSerialization) {
    return ModuleClass(
      name: jsonSerialization['name'] as String,
      data: jsonSerialization['data'] as int,
    );
  }

  String name;

  int data;

  ModuleClass copyWith({
    String? name,
    int? data,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'data': data,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ModuleClassImpl extends ModuleClass {
  _ModuleClassImpl({
    required String name,
    required int data,
  }) : super._(
          name: name,
          data: data,
        );

  @override
  ModuleClass copyWith({
    String? name,
    int? data,
  }) {
    return ModuleClass(
      name: name ?? this.name,
      data: data ?? this.data,
    );
  }
}
