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

abstract class NotServerOnlyClass implements _i1.SerializableModel {
  NotServerOnlyClass._({required this.foo});

  factory NotServerOnlyClass({required String foo}) = _NotServerOnlyClassImpl;

  factory NotServerOnlyClass.fromJson(Map<String, dynamic> jsonSerialization) {
    return NotServerOnlyClass(foo: jsonSerialization['foo'] as String);
  }

  String foo;

  /// Returns a shallow copy of this [NotServerOnlyClass]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  NotServerOnlyClass copyWith({String? foo});
  @override
  Map<String, dynamic> toJson() {
    return {'foo': foo};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _NotServerOnlyClassImpl extends NotServerOnlyClass {
  _NotServerOnlyClassImpl({required String foo}) : super._(foo: foo);

  /// Returns a shallow copy of this [NotServerOnlyClass]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  NotServerOnlyClass copyWith({String? foo}) {
    return NotServerOnlyClass(foo: foo ?? this.foo);
  }
}
