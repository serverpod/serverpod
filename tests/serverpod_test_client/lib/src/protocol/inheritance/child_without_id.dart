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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../protocol.dart' as _iv35mfmj;

abstract class ChildClassWithoutId extends _iv35mfmj.ParentClassWithoutId
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ChildClassWithoutId._({
    this.id,
    required super.grandParentField,
    required super.parentField,
    required this.childField,
  });

  factory ChildClassWithoutId({
    _isc.UuidValue? id,
    required String grandParentField,
    required String parentField,
    required String childField,
  }) = _ChildClassWithoutIdImpl;

  factory ChildClassWithoutId.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChildClassWithoutId(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      grandParentField: jsonSerialization['grandParentField'] as String,
      parentField: jsonSerialization['parentField'] as String,
      childField: jsonSerialization['childField'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _isc.UuidValue? id;

  String childField;

  /// Returns a shallow copy of this [ChildClassWithoutId]
  /// with some or all fields replaced by the given arguments.
  @override
  @_isc.useResult
  ChildClassWithoutId copyWith({
    Object? id,
    String? grandParentField,
    String? parentField,
    String? childField,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChildClassWithoutId',
      if (id != null) 'id': id?.toJson(),
      'grandParentField': grandParentField,
      'parentField': parentField,
      'childField': childField,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ChildClassWithoutId',
      if (id != null) 'id': id?.toJson(),
      'grandParentField': grandParentField,
      'parentField': parentField,
      'childField': childField,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChildClassWithoutIdImpl extends ChildClassWithoutId {
  _ChildClassWithoutIdImpl({
    _isc.UuidValue? id,
    required String grandParentField,
    required String parentField,
    required String childField,
  }) : super._(
         id: id,
         grandParentField: grandParentField,
         parentField: parentField,
         childField: childField,
       );

  /// Returns a shallow copy of this [ChildClassWithoutId]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ChildClassWithoutId copyWith({
    Object? id = _Undefined,
    String? grandParentField,
    String? parentField,
    String? childField,
  }) {
    return ChildClassWithoutId(
      id: id is _isc.UuidValue? ? id : this.id,
      grandParentField: grandParentField ?? this.grandParentField,
      parentField: parentField ?? this.parentField,
      childField: childField ?? this.childField,
    );
  }
}
