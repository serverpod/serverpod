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

class ParentClass extends _iv35mfmj.GrandparentClass
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ParentClass({
    this.id,
    required super.grandParentField,
    required this.parentField,
  });

  factory ParentClass.fromJson(Map<String, dynamic> jsonSerialization) {
    return ParentClass(
      id: jsonSerialization['id'] as int?,
      grandParentField: jsonSerialization['grandParentField'] as String,
      parentField: jsonSerialization['parentField'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String parentField;

  /// Returns a shallow copy of this [ParentClass]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ParentClass copyWith({
    Object? id = _Undefined,
    String? grandParentField,
    String? parentField,
  }) {
    return ParentClass(
      id: id is int? ? id : this.id,
      grandParentField: grandParentField ?? this.grandParentField,
      parentField: parentField ?? this.parentField,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ParentClass',
      if (id != null) 'id': id,
      'grandParentField': grandParentField,
      'parentField': parentField,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ParentClass',
      if (id != null) 'id': id,
      'grandParentField': grandParentField,
      'parentField': parentField,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}
