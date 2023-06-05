/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

class _Undefined {}

class NotServerOnlyClass extends _i1.SerializableEntity {
  NotServerOnlyClass({required this.foo});

  factory NotServerOnlyClass.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return NotServerOnlyClass(
        foo:
            serializationManager.deserialize<String>(jsonSerialization['foo']));
  }

  final String foo;

  late Function({String? foo}) copyWith = _copyWith;

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

  NotServerOnlyClass _copyWith({String? foo}) {
    return NotServerOnlyClass(foo: foo ?? this.foo);
  }
}
