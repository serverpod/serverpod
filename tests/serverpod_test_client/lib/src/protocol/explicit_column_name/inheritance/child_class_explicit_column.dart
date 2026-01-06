/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import '../../protocol.dart' as _i1;
import 'package:serverpod_client/serverpod_client.dart' as _i2;

abstract class ChildClassExplicitColumn extends _i1.NonTableParentClass
    implements _i2.SerializableModel {
  ChildClassExplicitColumn._({
    this.id,
    required super.nonTableParentField,
    required this.childField,
  });

  factory ChildClassExplicitColumn({
    int? id,
    required String nonTableParentField,
    required String childField,
  }) = _ChildClassExplicitColumnImpl;

  factory ChildClassExplicitColumn.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ChildClassExplicitColumn(
      id: jsonSerialization['id'] as int?,
      nonTableParentField: jsonSerialization['nonTableParentField'] as String,
      childField: jsonSerialization['childField'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String childField;

  /// Returns a shallow copy of this [ChildClassExplicitColumn]
  /// with some or all fields replaced by the given arguments.
  @override
  @_i2.useResult
  ChildClassExplicitColumn copyWith({
    int? id,
    String? nonTableParentField,
    String? childField,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChildClassExplicitColumn',
      if (id != null) 'id': id,
      'nonTableParentField': nonTableParentField,
      'childField': childField,
    };
  }

  @override
  String toString() {
    return _i2.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChildClassExplicitColumnImpl extends ChildClassExplicitColumn {
  _ChildClassExplicitColumnImpl({
    int? id,
    required String nonTableParentField,
    required String childField,
  }) : super._(
         id: id,
         nonTableParentField: nonTableParentField,
         childField: childField,
       );

  /// Returns a shallow copy of this [ChildClassExplicitColumn]
  /// with some or all fields replaced by the given arguments.
  @_i2.useResult
  @override
  ChildClassExplicitColumn copyWith({
    Object? id = _Undefined,
    String? nonTableParentField,
    String? childField,
  }) {
    return ChildClassExplicitColumn(
      id: id is int? ? id : this.id,
      nonTableParentField: nonTableParentField ?? this.nonTableParentField,
      childField: childField ?? this.childField,
    );
  }
}
