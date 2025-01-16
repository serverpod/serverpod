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

abstract class ChildWithDefault extends _i1.ParentWithDefault
    implements _i2.SerializableModel, _i2.ProtocolSerialization {
  ChildWithDefault._({
    required super.name,
    super.parentDefault,
    required this.age,
    int? childDefault,
  }) : childDefault = childDefault ?? -1;

  factory ChildWithDefault({
    required String name,
    int? parentDefault,
    required int age,
    int? childDefault,
  }) = _ChildWithDefaultImpl;

  factory ChildWithDefault.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChildWithDefault(
      name: jsonSerialization['name'] as String,
      parentDefault: jsonSerialization['parentDefault'] as int,
      age: jsonSerialization['age'] as int,
      childDefault: jsonSerialization['childDefault'] as int,
    );
  }

  int age;

  int childDefault;

  @override
  ChildWithDefault copyWith({
    String? name,
    int? parentDefault,
    int? age,
    int? childDefault,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'parentDefault': parentDefault,
      'age': age,
      'childDefault': childDefault,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'name': name,
      'parentDefault': parentDefault,
      'age': age,
      'childDefault': childDefault,
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _ChildWithDefaultImpl extends ChildWithDefault {
  _ChildWithDefaultImpl({
    required String name,
    int? parentDefault,
    required int age,
    int? childDefault,
  }) : super._(
          name: name,
          parentDefault: parentDefault,
          age: age,
          childDefault: childDefault,
        );

  @override
  ChildWithDefault copyWith({
    String? name,
    int? parentDefault,
    int? age,
    int? childDefault,
  }) {
    return ChildWithDefault(
      name: name ?? this.name,
      parentDefault: parentDefault ?? this.parentDefault,
      age: age ?? this.age,
      childDefault: childDefault ?? this.childDefault,
    );
  }
}
