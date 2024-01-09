/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class DefaultServerOnlyClass extends _i1.SerializableEntity {
  DefaultServerOnlyClass._({required this.foo});

  factory DefaultServerOnlyClass({required String foo}) =
      _DefaultServerOnlyClassImpl;

  factory DefaultServerOnlyClass.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return DefaultServerOnlyClass(
        foo:
            serializationManager.deserialize<String>(jsonSerialization['foo']));
  }

  String foo;

  DefaultServerOnlyClass copyWith({String? foo});
  @override
  Map<String, dynamic> toJson() {
    return {
      'foo': foo,
    };
  }
}

class _DefaultServerOnlyClassImpl extends DefaultServerOnlyClass {
  _DefaultServerOnlyClassImpl({required String foo}) : super._(foo: foo);

  @override
  DefaultServerOnlyClass copyWith({String? foo}) {
    return DefaultServerOnlyClass(foo: foo ?? this.foo);
  }
}
