/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class ScopeNoneFields extends _i1.SerializableEntity {
  ScopeNoneFields._({this.id});

  factory ScopeNoneFields({int? id}) = _ScopeNoneFieldsImpl;

  factory ScopeNoneFields.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ScopeNoneFields(
        id: serializationManager.deserialize<int?>(jsonSerialization['id']));
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  ScopeNoneFields copyWith({int? id});
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
    };
  }
}

class _Undefined {}

class _ScopeNoneFieldsImpl extends ScopeNoneFields {
  _ScopeNoneFieldsImpl({int? id}) : super._(id: id);

  @override
  ScopeNoneFields copyWith({Object? id = _Undefined}) {
    return ScopeNoneFields(id: id is int? ? id : this.id);
  }
}
