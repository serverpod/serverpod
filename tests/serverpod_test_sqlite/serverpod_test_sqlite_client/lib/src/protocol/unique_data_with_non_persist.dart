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

abstract class UniqueDataWithNonPersist implements _i1.SerializableModel {
  UniqueDataWithNonPersist._({
    this.id,
    required this.number,
    required this.email,
    this.extra,
  });

  factory UniqueDataWithNonPersist({
    int? id,
    required int number,
    required String email,
    String? extra,
  }) = _UniqueDataWithNonPersistImpl;

  factory UniqueDataWithNonPersist.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return UniqueDataWithNonPersist(
      id: jsonSerialization['id'] as int?,
      number: jsonSerialization['number'] as int,
      email: jsonSerialization['email'] as String,
      extra: jsonSerialization['extra'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int number;

  String email;

  String? extra;

  /// Returns a shallow copy of this [UniqueDataWithNonPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UniqueDataWithNonPersist copyWith({
    int? id,
    int? number,
    String? email,
    String? extra,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UniqueDataWithNonPersist',
      if (id != null) 'id': id,
      'number': number,
      'email': email,
      if (extra != null) 'extra': extra,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UniqueDataWithNonPersistImpl extends UniqueDataWithNonPersist {
  _UniqueDataWithNonPersistImpl({
    int? id,
    required int number,
    required String email,
    String? extra,
  }) : super._(
         id: id,
         number: number,
         email: email,
         extra: extra,
       );

  /// Returns a shallow copy of this [UniqueDataWithNonPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UniqueDataWithNonPersist copyWith({
    Object? id = _Undefined,
    int? number,
    String? email,
    Object? extra = _Undefined,
  }) {
    return UniqueDataWithNonPersist(
      id: id is int? ? id : this.id,
      number: number ?? this.number,
      email: email ?? this.email,
      extra: extra is String? ? extra : this.extra,
    );
  }
}
