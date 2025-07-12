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

abstract class UriDefaultPersist implements _i1.SerializableModel {
  UriDefaultPersist._({
    this.id,
    this.uriDefaultPersist,
  });

  factory UriDefaultPersist({
    int? id,
    Uri? uriDefaultPersist,
  }) = _UriDefaultPersistImpl;

  factory UriDefaultPersist.fromJson(Map<String, dynamic> jsonSerialization) {
    return UriDefaultPersist(
      id: jsonSerialization['id'] as int?,
      uriDefaultPersist: jsonSerialization['uriDefaultPersist'] == null
          ? null
          : _i1.UriJsonExtension.fromJson(
              jsonSerialization['uriDefaultPersist']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  Uri? uriDefaultPersist;

  /// Returns a shallow copy of this [UriDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UriDefaultPersist copyWith({
    int? id,
    Uri? uriDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (uriDefaultPersist != null)
        'uriDefaultPersist': uriDefaultPersist?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UriDefaultPersistImpl extends UriDefaultPersist {
  _UriDefaultPersistImpl({
    int? id,
    Uri? uriDefaultPersist,
  }) : super._(
          id: id,
          uriDefaultPersist: uriDefaultPersist,
        );

  /// Returns a shallow copy of this [UriDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UriDefaultPersist copyWith({
    Object? id = _Undefined,
    Object? uriDefaultPersist = _Undefined,
  }) {
    return UriDefaultPersist(
      id: id is int? ? id : this.id,
      uriDefaultPersist: uriDefaultPersist is Uri?
          ? uriDefaultPersist
          : this.uriDefaultPersist,
    );
  }
}
