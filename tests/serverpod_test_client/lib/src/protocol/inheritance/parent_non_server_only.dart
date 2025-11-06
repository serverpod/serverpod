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
import 'package:serverpod_client/serverpod_client.dart' as _i1;

class NonServerOnlyParentClass implements _i1.SerializableModel {
  NonServerOnlyParentClass({required this.parentField});

  factory NonServerOnlyParentClass.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NonServerOnlyParentClass(
      parentField: jsonSerialization['parentField'] as String,
    );
  }

  String parentField;

  /// Returns a shallow copy of this [NonServerOnlyParentClass]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  NonServerOnlyParentClass copyWith({String? parentField}) {
    return NonServerOnlyParentClass(
      parentField: parentField ?? this.parentField,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {'parentField': parentField};
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}
