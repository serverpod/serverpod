/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class NotServerOnlyClass extends _i1.SerializableEntity {
  const NotServerOnlyClass._();

  const factory NotServerOnlyClass({required String foo}) = _NotServerOnlyClass;

  factory NotServerOnlyClass.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return NotServerOnlyClass(
        foo:
            serializationManager.deserialize<String>(jsonSerialization['foo']));
  }

  NotServerOnlyClass copyWith({String? foo});
  String get foo;
}

class _NotServerOnlyClass extends NotServerOnlyClass {
  const _NotServerOnlyClass({required this.foo}) : super._();

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
        (other is NotServerOnlyClass &&
            (identical(
                  other.foo,
                  foo,
                ) ||
                other.foo == foo));
  }

  @override
  int get hashCode => foo.hashCode;

  @override
  NotServerOnlyClass copyWith({String? foo}) {
    return NotServerOnlyClass(foo: foo ?? this.foo);
  }
}
