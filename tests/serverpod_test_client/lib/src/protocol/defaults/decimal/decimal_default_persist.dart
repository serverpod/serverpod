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

abstract class DecimalDefaultPersist implements _i1.SerializableModel {
  DecimalDefaultPersist._({
    this.id,
    this.decimalDefaultPersist,
  });

  factory DecimalDefaultPersist({
    int? id,
    _i1.Decimal? decimalDefaultPersist,
  }) = _DecimalDefaultPersistImpl;

  factory DecimalDefaultPersist.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return DecimalDefaultPersist(
      id: jsonSerialization['id'] as int?,
      decimalDefaultPersist: jsonSerialization['decimalDefaultPersist'] == null
          ? null
          : _i1.DecimalJsonExtension.fromJson(
              jsonSerialization['decimalDefaultPersist'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.Decimal? decimalDefaultPersist;

  /// Returns a shallow copy of this [DecimalDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  DecimalDefaultPersist copyWith({
    int? id,
    _i1.Decimal? decimalDefaultPersist,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DecimalDefaultPersist',
      if (id != null) 'id': id,
      if (decimalDefaultPersist != null)
        'decimalDefaultPersist': decimalDefaultPersist?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DecimalDefaultPersistImpl extends DecimalDefaultPersist {
  _DecimalDefaultPersistImpl({
    int? id,
    _i1.Decimal? decimalDefaultPersist,
  }) : super._(
         id: id,
         decimalDefaultPersist: decimalDefaultPersist,
       );

  /// Returns a shallow copy of this [DecimalDefaultPersist]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  DecimalDefaultPersist copyWith({
    Object? id = _Undefined,
    Object? decimalDefaultPersist = _Undefined,
  }) {
    return DecimalDefaultPersist(
      id: id is int? ? id : this.id,
      decimalDefaultPersist: decimalDefaultPersist is _i1.Decimal?
          ? decimalDefaultPersist
          : this.decimalDefaultPersist,
    );
  }
}
