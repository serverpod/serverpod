/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import '../protocol.dart' as _i1;
import 'package:serverpod/serverpod.dart' as _i2;

abstract class ChildClass extends _i1.ParentClass
    implements _i2.SerializableModel, _i2.ProtocolSerialization {
  ChildClass._({
    required super.name,
    required this.age,
  });

  factory ChildClass({
    required String name,
    required int age,
  }) = _ChildClassImpl;

  factory ChildClass.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChildClass(
      name: jsonSerialization['name'] as String,
      age: jsonSerialization['age'] as int,
    );
  }

  int age;

  @override
  ChildClass copyWith({
    String? name,
    int? age,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'name': name,
      'age': age,
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _ChildClassImpl extends ChildClass {
  _ChildClassImpl({
    required String name,
    required int age,
  }) : super._(
          name: name,
          age: age,
        );

  @override
  ChildClass copyWith({
    String? name,
    int? age,
  }) {
    return ChildClass(
      name: name ?? this.name,
      age: age ?? this.age,
    );
  }
}
