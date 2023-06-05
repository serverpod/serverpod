/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class DefaultServerOnlyClass extends _i1.SerializableEntity {
  const DefaultServerOnlyClass._();

  const factory DefaultServerOnlyClass({required String foo}) =
      _DefaultServerOnlyClass;

  factory DefaultServerOnlyClass.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return DefaultServerOnlyClass(
        foo:
            serializationManager.deserialize<String>(jsonSerialization['foo']));
  }

  DefaultServerOnlyClass copyWith({String? foo});
  String get foo;
}

class _DefaultServerOnlyClass extends DefaultServerOnlyClass {
  const _DefaultServerOnlyClass({required this.foo}) : super._();

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
        (other is DefaultServerOnlyClass &&
            (identical(
                  other.foo,
                  foo,
                ) ||
                other.foo == foo));
  }

  @override
  int get hashCode => foo.hashCode;

  @override
  DefaultServerOnlyClass copyWith({String? foo}) {
    return DefaultServerOnlyClass(foo: foo ?? this.foo);
  }
}
