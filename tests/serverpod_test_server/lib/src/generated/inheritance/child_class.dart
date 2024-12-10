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
    super.id,
    required super.grandParentField,
    required super.parentField,
    required this.childField,
  });

  factory ChildClass({
    int? id,
    required String grandParentField,
    required String parentField,
    required int childField,
  }) = _ChildClassImpl;

  factory ChildClass.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChildClass(
      id: jsonSerialization['id'] as int?,
      grandParentField: jsonSerialization['grandParentField'] as String,
      parentField: jsonSerialization['parentField'] as String,
      childField: jsonSerialization['childField'] as int,
    );
  }

  int childField;

  @override
  ChildClass copyWith({
    Object? id,
    String? grandParentField,
    String? parentField,
    int? childField,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'grandParentField': grandParentField,
      'parentField': parentField,
      'childField': childField,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'grandParentField': grandParentField,
      'parentField': parentField,
      'childField': childField,
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChildClassImpl extends ChildClass {
  _ChildClassImpl({
    int? id,
    required String grandParentField,
    required String parentField,
    required int childField,
  }) : super._(
          id: id,
          grandParentField: grandParentField,
          parentField: parentField,
          childField: childField,
        );

  @override
  ChildClass copyWith({
    Object? id = _Undefined,
    String? grandParentField,
    String? parentField,
    int? childField,
  }) {
    return ChildClass(
      id: id is int? ? id : this.id,
      grandParentField: grandParentField ?? this.grandParentField,
      parentField: parentField ?? this.parentField,
      childField: childField ?? this.childField,
    );
  }
}
