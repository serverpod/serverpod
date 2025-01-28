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

abstract class IntDefaultPersist implements _i1.SerializableModel {
  IntDefaultPersist._({
    this.id,
    this.intDefaultPersist,
  });

  factory IntDefaultPersist({
    int? id,
    int? intDefaultPersist,
  }) = _IntDefaultPersistImpl;

  factory IntDefaultPersist.fromJson(Map<String, dynamic> jsonSerialization) {
    return IntDefaultPersist(
      id: jsonSerialization['id'] as int?,
      intDefaultPersist: jsonSerialization['intDefaultPersist'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int? intDefaultPersist;

  /// Returns a shallow copy of this [IntDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  IntDefaultPersist copyWith({
    int? id,
    int? intDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (intDefaultPersist != null) 'intDefaultPersist': intDefaultPersist,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IntDefaultPersistImpl extends IntDefaultPersist {
  _IntDefaultPersistImpl({
    int? id,
    int? intDefaultPersist,
  }) : super._(
          id: id,
          intDefaultPersist: intDefaultPersist,
        );

  /// Returns a shallow copy of this [IntDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  IntDefaultPersist copyWith({
    Object? id = _Undefined,
    Object? intDefaultPersist = _Undefined,
  }) {
    return IntDefaultPersist(
      id: id is int? ? id : this.id,
      intDefaultPersist: intDefaultPersist is int?
          ? intDefaultPersist
          : this.intDefaultPersist,
    );
  }
}
