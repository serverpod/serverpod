/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class ServerOnlyClass extends _i1.SerializableEntity {
  ServerOnlyClass._({required this.foo});

  factory ServerOnlyClass({required String foo}) = _ServerOnlyClassImpl;

  factory ServerOnlyClass.fromJson(Map<String, dynamic> jsonSerialization) {
    return ServerOnlyClass(foo: jsonSerialization['foo'] as String);
  }

  String foo;

  ServerOnlyClass copyWith({String? foo});
  @override
  Map<String, dynamic> toJson() {
    return {'foo': foo};
  }

  @override
  Map<String, dynamic> allToJson() {
    return {'foo': foo};
  }
}

class _ServerOnlyClassImpl extends ServerOnlyClass {
  _ServerOnlyClassImpl({required String foo}) : super._(foo: foo);

  @override
  ServerOnlyClass copyWith({String? foo}) {
    return ServerOnlyClass(foo: foo ?? this.foo);
  }
}
