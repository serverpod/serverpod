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

class ParentClass implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ParentClass({required this.name});

  factory ParentClass.fromJson(Map<String, dynamic> jsonSerialization) {
    return ParentClass(name: jsonSerialization['name'] as String);
  }

  String name;

  ParentClass copyWith({String? name}) {
    return ParentClass(name: name ?? this.name);
  }

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
