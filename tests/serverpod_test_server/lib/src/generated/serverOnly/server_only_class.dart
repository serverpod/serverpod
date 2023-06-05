/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class ServerOnlyClass extends _i1.SerializableEntity {
  const ServerOnlyClass._();

  const factory ServerOnlyClass({required String foo}) = _ServerOnlyClass;

  factory ServerOnlyClass.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ServerOnlyClass(
        foo:
            serializationManager.deserialize<String>(jsonSerialization['foo']));
  }

  ServerOnlyClass copyWith({String? foo});
  String get foo;
}

class _ServerOnlyClass extends ServerOnlyClass {
  const _ServerOnlyClass({required this.foo}) : super._();

  @override
  final String foo;

  @override
  Map<String, dynamic> toJson() {
    return {'foo': foo};
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is ServerOnlyClass &&
            (identical(
                  other.foo,
                  foo,
                ) ||
                other.foo == foo));
  }

  @override
  int get hashCode => foo.hashCode;

  @override
  ServerOnlyClass copyWith({String? foo}) {
    return ServerOnlyClass(foo: foo ?? this.foo);
  }
}
